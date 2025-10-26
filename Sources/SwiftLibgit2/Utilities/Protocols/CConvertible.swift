//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A type that can be converted to the equivalent C value.
///
/// ## Discussion
///
/// These protocols standardize the implementation of Swift binding types
/// that can be converted to their C equivalents using an instance method.
///
/// ### Conforming Types
///
/// All Swift binding types that indirectly conform to ``CStruct`` must
/// also conform to one of the following protocols:
///
/// - ``CConvertible`` (non-throwing, without memory management)
/// - ``ThrowingCConvertible`` (throwing, without memory management)
/// - ``WithCConvertible`` (throwing, with memory management)
///
/// Types that directly conform to ``CStruct`` (and are unused by other
/// bindings) must not conform to any of these protocols. See the ``CStruct``
/// documentation for more information.
///
/// None of the C convertible protocols define requirements to convert from a
/// given C value to the equivalent Swift value (by using an `init(cValue:)`
/// method) in order to maintain flexibility. The `init(cValue:)` requirement
/// is defined by ``CStruct``.
///
/// ### Protocol Choice
///
/// The protocol used by a type depends on the conversion process and whether
/// the conversion can fail.
///
/// Types that can be converted using only simple field assignment (creating
/// a C type and directly returning it) must conform to ``CConvertible`` or
/// ``ThrowingCConvertible``. Any types with an initialization method involve
/// the possibility of failure during conversion, so these types must conform
/// to ``ThrowingCConvertible``.
///
/// Types that must be converted with memory management (using closures to
/// ensure proper lifetime of C values and other nested conversions) must
/// conform to ``WithCConvertible``.
///
/// Types must use ``NSError/makeCConversionError()`` to create conversion
/// errors.
///
/// ## Methods vs Properties
///
/// Types that can be converted using only simple field assignment without
/// memory management would theoretically be able to use a computed property
/// instead of an instance method.
///
/// However, computed properties are not used for C conversion since they
/// cannot throw an error. The only recourse for conversion failure in a
/// computed property is to return an optional value, which could lead to
/// silent failures. ``CConvertible`` does not throw an error but still uses
/// a method for consistency with the other protocols.
///
/// ### Optional Receivers
///
/// ``WithCConvertible`` includes default implementations of
/// ``withOptionalCValue(_:)``, which can be used to reduce overhead at call
/// sites by eliminating the need to guard against optional types when
/// converting them to their C equivalents.
///
/// ``CConvertible`` and ``ThrowingCConvertible`` both conform to
/// ``WithCConvertible`` and provide default implementations of
/// ``withCValue(_:)``. Conforming types must not override this method.
/// This allows all convertible types to use ``withCValue(_:)`` and
/// ``withOptionalCValue(_:)`` to reduce overhead at call sites, especially
/// for optional values that otherwise would require `guard` statements.
///
/// ### Preventing Silent Failure
///
/// Protocols with failable conversion methods must throw instead of returning
/// `nil`. If the methods returned a `nil` pointer on failure, it would cause
/// ambiguity and additional overhead at call sites.
///
/// For example, consider the following outcomes of calling
/// ``withOptionalCValue(_:)``:
///
/// - The method is called on a `nil` receiver, which returns a `nil` pointer.
/// This is correct behavior.
/// - The method is called on a non-`nil` receiver, but the conversion fails
/// and the conversion method returns a `nil` pointer.
///
/// In the second scenario, the caller cannot immediately distinguish between
/// these two cases without additional logic. Callers would have to manually
/// verify within each conversion closure that the returned pointer is only
/// `nil` when the receiver is also `nil`.
///
/// In order to reduce overhead and the chance of mistakes at call sites, an
/// error is thrown only when conversion of a non-`nil` receiver fails. Callers
/// are responsible for catching the error and returning
/// ``GitErrorCode/gitEUser``. Callers must use ``withCConversion(_:)`` to
/// do this.



// MARK: - Protocols

/// A type that can be converted to the equivalent C value, without memory
/// management and without the possibility of failure.
internal protocol CConvertible: WithCConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    
    
    /// Converts the receiver to the equivalent C value.
    /// - Returns: The equivalent C value
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func cValue() -> C
}



/// A type that can be converted to the equivalent C value, without
/// memory management and with the possibility of failure.
internal protocol ThrowingCConvertible: WithCConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    
    
    /// Converts the receiver to the equivalent C value.
    /// - Returns: The equivalent C value
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func cValue() throws -> C
}



/// A type that can be converted to the equivalent C value, with memory
/// management and with the possibility of failure.
internal protocol WithCConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    
    
    /// Calls the given closure with a mutable pointer to the equivalent C
    /// value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func withCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    
    
    
    /// Calls the given closure with an optional mutable pointer to the
    /// equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<C>?) throws -> T
    ) throws -> T
}



// MARK: - Extensions

internal extension CConvertible
{
    /// Calls the given closure with a mutable pointer to the equivalent C
    /// value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    func withCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) rethrows -> T
    {
        var cValue: C = cValue()
        
        return try body(&cValue)
    }
}



internal extension ThrowingCConvertible
{
    /// Calls the given closure with a mutable pointer to the equivalent C
    /// value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    {
        var cValue: C = try cValue()
        
        return try body(&cValue)
    }
}



internal extension WithCConvertible
{
    /// Calls the given closure with an optional mutable pointer to the
    /// equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<C>?) throws -> T
    ) throws -> T
    {
        return try withCValue
        {
            cValuePointer in
            
            try body(cValuePointer)
        }
    }
}



internal extension Optional where Wrapped: WithCConvertible
{
    /// Calls the given closure with an optional mutable pointer to the
    /// equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<Wrapped.C>?) throws -> T
    ) throws -> T
    {
        switch self
        {
            case .none:
                
                return try body(nil)
                
            case .some(let wrapped):
                
                return try wrapped.withCValue(body)
        }
    }
}
