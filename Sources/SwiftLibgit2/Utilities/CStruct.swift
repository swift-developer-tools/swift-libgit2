//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

// MARK: - CStruct

/// A type that can be initialized from the equivalent C value.
///
/// ## Discussion
///
/// These protocols standardize the implementation of Swift binding structs
/// that can be initialized from their C equivalents.
///
/// ### Conforming Structs
///
/// All Swift binding structs must conform to one of the following protocols:
///
/// - ``CStructReadable`` (read-only)
/// - ``CStructMutable`` (mutable)
/// - ``CStructInternalMutable`` (public read-only, internal mutable)
///
/// The exception is Swift structs that act as bindings for C bitset enums.
/// These Swift structs must conform to the ``COptionSet`` protocol instead.
///
/// The only structs that may conform directly to ``CStruct`` are structs
/// which are unused by other bindings, but exist for documentation purposes.
/// ``CStructReadable`` does not define any additional requirements other
/// than those of ``CStruct``, but exists for semantic purposes.
///
/// ## Protocol Choice
///
/// The protocol used by a struct depends on how that struct will be used.
///
/// ``CStructReadable``:
/// - Generally represents Git data.
/// - Uses `public let` properties.
/// - Provides no default property values.
/// - Provides no public initializer.
/// - Examples: ``GitBlameLine`` and ``GitDiffDelta``.
///
/// ``CStructMutable``:
/// - Generally represents caller-configurable options.
/// - Uses `public var` properties.
/// - Provides default property values.
/// - Provides a `public init()` method with an empty body.
/// - Examples: ``GitCheckoutOptions`` and ``GitMergeOptions``.
///
/// ``CStructInternalMutable``:
/// - Generally used as `inout` function parameters.
/// - Uses `public private(set) var` or `public internal(set) var` properties.
/// - Provides default property values,.
/// - Provides a `public init()` method with an empty body.
/// - Examples: ``GitOID`` and ``GitSignature``.
///
/// ## Additional Requirements
///
/// In addition to the requirements actually defined by this protocol,
/// conforming structs must also follow the rules described above. These
/// protocols cannot be more specific due to limitations of what Swift
/// protocols can define, and also because the conforming structs have
/// different requirements based on the C struct they are translating.
///
/// For example, the three protocols described above require different property
/// access levels, but this is not definable through Swift protocols.
///
/// Finally, structs that conform to ``CStructReadable``,
/// ``CStructMutable``, or ``CStructInternalMutable`` must implement a
/// method to convert the Swift struct to its C equivalent. Structs must
/// implement this method by conforming to one of the following protocols:
///
/// - ``CConvertible`` (non-throwing, without memory management)
/// - ``ThrowingCConvertible`` (throwing, without memory management)
/// - ``WithCConvertible`` (throwing, with memory management)
///
/// ``CStruct`` does not directly conform to the C convertible protocols due
/// to the level of variation required by conforming structs. A single protocol
/// cannot define this level of variation, and multiple protocols would be less
/// effective from a semantic standpoint. Conforming structs must adopt one of
/// the convertible protocols, unless they conform directly to ``CStruct``
/// (and are unused by other bindings).
///
/// Some structs may also need to implement a mutating Swift-to-C conversion
/// method. These structs are often used as `inout` parameters. ``CStruct``
/// provides default implementations of these mutating methods, which are
/// designed for use with C functions that expect parameters of the type
/// `C *`, `C **`, or`const C **`.
///
/// ## CFreeable Structs
///
/// A struct that conforms to ``CStructInternalMutable`` may also need to
/// conform to ``CFreeable`` if libgit2 provides a corresponding memory-freeing
/// function.
///
/// Conforming to ``CFreeable`` enables automatic memory management when using
/// ``withMutatingCValue(_:)`` with C functions that expect `C **` parameters
/// and follow the allocating pattern, where libgit2 allocates new memory that
/// the caller must free.
///
/// Structs that do not conform to ``CFreeable`` cannot use
/// ``withMutatingCValue(_:)`` with `C **` parameters. Instead, they must use
/// ``withBorrowingCValue(_:)``, which is appropriate for functions that follow
/// the borrowing pattern.
///
/// ### Memory Ownership Patterns
///
/// libgit2 uses two distinct patterns for functions with `C **` output
/// parameters: the allocating pattern and the borrowing pattern.
///
/// The allocating pattern involves the function allocating new memory on the
/// heap and transferring ownership to the caller. The caller must free this
/// memory. The libgit2 documentation for these functions usually states this
/// responsibility. The struct must conform to ``CFreeable``, and the caller
/// must use ``withMutatingCValue(_:)``.
///
/// The borrowing pattern involves the function returning a pointer to memory
/// managed by libgit2, usually through use of an iterator, container, or other
/// object. The caller does not own this memory and must not free it. The
/// libgit2 documentation for these functions usually mentions the
/// lifecycle/validity of the returned pointer (for example, a pointer being
/// valid until the next call to the iterator, or until the iterator is freed).
///
/// ## CFreeable Exceptions
///
/// ``GitBuf`` conforms to ``CStructInternalMutable`` and has an associated
/// memory-freeing function in libgit2, but does not conform to ``CFreeable``.
/// This is because ``GitBuf`` acts as a pointer container with a lifecycle
/// managed by the API user rather than by the binding API.
///
/// ``GitBuf`` uses the `C *` version of ``withMutatingCValue(_:)``, which
/// passes a pointer to a stack-allocated `git_buf` struct. libgit2 populates
/// `git_buf->ptr` with heap-allocated memory, which is copied into the Swift
/// struct. To free this memory, the API user must call
/// ``gitBufDispose(buffer:)`` when done with the buffer.
internal protocol CStruct
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
internal protocol CStructReadable: CStruct { }



/// A mutable type that can be initialized from the equivalent C value.
internal protocol CStructMutable: CStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This must have a `public` access level and an empty body.
    init()
}



/// A publicly-readable and internally-mutable type that can be initialized
/// from the equivalent C value.
internal protocol CStructInternalMutable: CStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This must have a `public` access level and an empty body.
    init()
}



// MARK: - Extensions

internal extension CStruct where Self: CConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) rethrows -> T
    {
        var cValue: C = cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            if isSuccess(result)
            {
                self = Self.init(cValue: cValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var cValue: C = cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>?
                = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if
                isSuccess(result),
                let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer
            {
                self = Self.init(cValue: finalCValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer
    /// to a `C` instance, and updates the receiver with any changes made by
    /// the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if
            isSuccess(result),
            let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer
        {
            self = Self.init(cValue: finalCValuePointer.pointee)
        }
        
        return result
    }
}



internal extension CStruct where Self: ThrowingCConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    {
        var cValue: C = try cValue()
        
        return try withUnsafeMutablePointer(to: &cValue)
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            if isSuccess(result)
            {
                self = Self.init(cValue: cValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
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
            
            if
                isSuccess(result),
                let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer
            {
                self = Self.init(cValue: finalCValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer
    /// to a `C` instance, and updates the receiver with any changes made by
    /// the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if
            isSuccess(result),
            let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer
        {
            self = Self.init(cValue: finalCValuePointer.pointee)
        }
        
        return result
    }
}



internal extension CStruct where Self: WithCConvertible
{
    /// Calls the given closure with a mutable pointer to a `C` instance,
    /// and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C *`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    {
        return try withCValue
        {
            cValuePointer in
            
            let result: T = try body(cValuePointer)
            
            if isSuccess(result)
            {
                self = Self.init(cValue: cValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    mutating func withBorrowingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T
    {
        return try withCValue
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            if
                isSuccess(result),
                let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer
            {
                self = Self.init(cValue: finalCValuePointer.pointee)
            }
            
            return result
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional pointer
    /// to a `C` instance, and updates the receiver with any changes made by
    /// the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `const C **`.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<C>?>) throws -> T
    ) rethrows -> T
    {
        var optionalCValuePointer: UnsafePointer<C>? = nil
        
        let result: T = try body(&optionalCValuePointer)
        
        if
            isSuccess(result),
            let finalCValuePointer: UnsafePointer<C> = optionalCValuePointer
        {
            self = Self.init(cValue: finalCValuePointer.pointee)
        }
        
        return result
    }
}



internal extension CStruct where Self: WithCConvertible & CFreeable
{
    /// Calls the given closure with a mutable pointer to an optional mutable
    /// pointer to a `C` instance, and updates the receiver with any changes
    /// made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Use this method with C functions that expect a parameter of the type
    /// `C **`.
    ///
    /// - Important: If libgit2 allocates new memory, this method will
    /// automatically free that memory by calling the receiver's
    /// ``freeCValue(_:)`` method after copying the data.
    mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<C>?>) throws -> T
    ) throws -> T where P == UnsafeMutablePointer<C>?
    {
        return try withCValue
        {
            cValuePointer in
            
            var optionalCValuePointer: UnsafeMutablePointer<C>? = cValuePointer
            
            let result: T = try body(&optionalCValuePointer)
            
            guard let finalCValuePointer: UnsafeMutablePointer<C>
                    = optionalCValuePointer
            else
            {
                return result
            }
            
            
            
            if isSuccess(result)
            {
                self = Self.init(cValue: finalCValuePointer.pointee)
            }
            
            if finalCValuePointer != cValuePointer
            {
                Self.freeCValue(finalCValuePointer)
            }
            
            return result
        }
    }
}
