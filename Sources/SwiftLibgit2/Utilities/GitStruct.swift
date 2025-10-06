//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

// MARK: - GitStruct

/// A type that can be initialized from the equivalent C value.
///
/// ## Discussion
///
/// These protocols standardize the implementation of Swift binding structs that can be initialized
/// from their C equivalents.
///
/// ### Conforming Structs
///
/// All Swift binding structs must conform to one of the following protocols:
///
/// - ``GitStructReadable`` (read-only)
/// - ``GitStructMutable`` (mutable)
/// - ``GitStructInternalMutable`` (public read-only, internal mutable)
///
/// The exception is Swift structs that act as bindings for C bitset enums. These Swift structs must conform
/// to the ``GitOptionSet`` protocol instead.
///
/// The only structs that may conform directly to ``GitStruct`` are structs which are unused by other
/// bindings, but exist for documentation purposes. ``GitStructReadable`` does not define any
/// additional requirements other than those of ``GitStruct``, but exists for semantic purposes.
///
/// ## Protocol Choice
///
/// The protocol used by a struct depends on how that struct will be used.
///
/// ``GitStructReadable``:
/// - Generally represents Git data.
/// - Uses `public let` properties.
/// - Provides no default property values.
/// - Provides no public initializer.
/// - Examples: ``GitBlameLine`` and ``GitDiffDelta``.
///
/// ``GitStructMutable``:
/// - Generally represents caller-configurable options.
/// - Uses `public var` properties.
/// - Provides default property values and publicly documents them.
/// - Provides a `public init()` method that accepts no parameters and has an empty body.
/// - Examples: ``GitCheckoutOptions`` and ``GitMergeOptions``.
///
/// ``GitStructInternalMutable``:
/// - Generally used as `inout` function parameters.
/// - Uses `public private(set) var` or `public internal(set) var` properties.
/// - Provides default property values, but does not publicly document them.
/// - Provides a `public init()` method that accepts no parameters and has an empty body.
/// - Examples: ``GitOID`` and ``GitSignature``.
///
/// ## Additional Requirements
///
/// In addition to the requirements actually defined by this protocol, conforming structs must also follow the
/// rules described above. These protocols cannot be more specific due to limitations of what Swift protocols
/// can define, and also because the conforming structs have different requirements based on the C struct
/// they are translating.
///
/// For example, the three protocols described above require different property access levels, but this is
/// not definable through Swift protocols.
///
/// Similarly, structs that conform to ``GitStructReadable``, ``GitStructMutable``,
/// or ``GitStructInternalMutable`` must implement one of the following approaches to
/// converting the Swift struct to its C equivalent:
///
/// ```swift
/// internal func cValue() -> C
///
/// internal func withCValue<T>(
///     _ body: (UnsafeMutablePointer<C>) -> T
/// ) -> T
/// ```
///
/// Structs must implement these by conforming to one of the following protocols:
///
/// - ``CConvertible`` (non-throwing, without memory management)
/// - ``ThrowingCConvertible`` (throwing, without memory management)
/// - ``WithCConvertible`` (throwing, with memory management)
///
/// ``GitStruct`` does not directly conform to the C convertible protocols due to the level of variation
/// required by conforming structs. A single protocol cannot define this level of variation, and multiple
/// protocols would be less effective from a semantic standpoint. Conforming structs must adopt one
/// of the convertible protocols, unless they conform directly to ``GitStruct`` (and are unused by
/// other bindings).
///
/// Some structs may also need to implement one of the following mutating methods:
///
/// ```swift
/// internal mutating func withMutatingCValue<T>(
///     _ body: (UnsafeMutablePointer<C>) throws -> T
/// ) rethrows -> T
///
/// internal mutating func withMutatingCValue<T>(
///     _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
/// ) rethrows -> T
///
/// internal mutating func withMutatingCValue<T>(
///     _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
/// ) throws -> T
/// ```
///
/// The methods are designed for use with C functions that expect parameters of the type `C *`,
/// `C **`, and `const C **`, respectively. The second and third methods use an optional pointer,
/// since libgit2 may set the pointer to `nil`.
///
/// The structs that use these mutating methods are commonly used as `inout` parameters.
/// ``GitStructInternalMutable`` provides default implementations of both methods.
internal protocol GitStruct
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// Creates an instance from a C value.
    /// - Parameter cValue: The C value to use.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    init(
        cValue: C
    )
}



// MARK: - Refining Protocols

/// A read-only type that can be initialized from the equivalent C value.
internal protocol GitStructReadable: GitStruct { }



/// A mutable type that can be initialized from the equivalent C value.
internal protocol GitStructMutable: GitStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This must have a `public` access level and an empty body.
    init()
}



/// A publicly-readable and internally-mutable type that can be initialized from the equivalent C value.
internal protocol GitStructInternalMutable: GitStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This must have a `public` access level and an empty body.
    init()
}



// MARK: - Extensions

/// The default implementations of ``withMutatingCValue(_:)`` for structs that conform
/// to ``GitStructInternalMutable`` and ``CConvertible``.
internal extension GitStructInternalMutable where Self: CConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance, and updates the receiver with
    /// any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) rethrows -> T
    {
        var cValue: C = cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            self = Self.init(cValue: cValuePointer.pointee)
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var cValue: C = cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if let finalCValuePointer: UnsafeMutablePointer<C> = optionalCValuePointer
            {
                self = Self.init(cValue: finalCValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer to a `C` instance, and
    /// updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer
        {
            self = Self.init(cValue: finalCValuePointer.pointee)
        }
        
        return result
    }
}



/// The default implementations of ``withMutatingCValue(_:)`` for structs that conform
/// to ``GitStructInternalMutable`` and ``ThrowingCConvertible``.
internal extension GitStructInternalMutable where Self: ThrowingCConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance, and updates the receiver with
    /// any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    {
        var cValue: C = try cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            self = Self.init(cValue: cValuePointer.pointee)
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T
    {
        var cValue: C = try cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if let finalCValuePointer: UnsafeMutablePointer<C> = optionalCValuePointer
            {
                self = Self.init(cValue: finalCValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer to a `C` instance, and
    /// updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer
        {
            self = Self.init(cValue: finalCValuePointer.pointee)
        }
        
        return result
    }
}



/// The default implementations of ``withMutatingCValue(_:)`` for structs that conform
/// to ``GitStructInternalMutable`` and ``WithCConvertible``.
internal extension GitStructInternalMutable where Self: WithCConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance, and updates the receiver with
    /// any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    {
        return try withCValue
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            self = Self.init(cValue: cValuePointer.pointee)
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T
    {
        return try withCValue
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if let finalCValuePointer: UnsafeMutablePointer<C> = optionalCValuePointer
            {
                self = Self.init(cValue: finalCValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer to a `C` instance, and
    /// updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer
        {
            self = Self.init(cValue: finalCValuePointer.pointee)
        }
        
        return result
    }
}
