//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// A type that can be converted to the equivalent C value.
///
/// ## Discussion
///
/// These protocols standardize the implementation of Swift binding structs that can be converted
/// to their C equivalents using an instance method.
///
/// ### Conforming Structs
///
/// All Swift binding structs that indirectly conform to ``GitStruct`` must also conform to
/// one of the following protocols:
///
/// - ``CConvertible`` (non-throwing, without memory management)
/// - ``ThrowingCConvertible`` (throwing, without memory management)
/// - ``WithCConvertible`` (throwing, with memory management)
///
/// Structs that directly conform to ``GitStruct`` (and are unused by other bindings) must not
/// conform to any of these protocols. See the ``GitStruct`` documentation for more information.
///
/// None of the C convertible protocols define requirements to convert from a given C value to the
/// equivalent Swift value (by using an `init(cValue:)` method) in order to maintain flexibility.
///
/// For example, other protocols like ``GitEnum`` and ``GitOptionSet`` conform to
/// ``CConvertible``, but these use `init?(cValue:)` and `init(rawValue:)`, respectively.
/// The `init(cValue:)` requirement is therefore defined by ``GitStruct``.
///
/// ### Protocol Choice
///
/// The protocol used by a struct depends on the conversion process and whether the conversion can fail.
///
/// Structs whose conversion involves only simple field assignment (creating a C struct and directly
/// returning it) must conform to ``CConvertible`` or ``ThrowingCConvertible``. Any structs
/// with an initialization method involve the possibility of failure during conversion, so these structs must
/// conform to ``ThrowingCConvertible``.
///
/// Structs whose conversion requires memory management (using closures to ensure proper lifetime of
/// C values and other nested conversions) must conform to ``WithCConvertible``.
///
/// Structs should use ``NSError/makeCConversionError()`` to create conversion errors.
///
/// ## Methods vs Properties
///
/// Structs whose conversion process involves only simple field assignment without memory management
/// would theoretically be able to use a computed property instead of an instance method.
///
/// However, computed properties are not used for C conversion, since they cannot throw an error.
/// The only recourse for a computed property whose conversion fails would be to return an optional value.
///
/// ### Optional Receivers
///
/// ``WithCConvertible`` includes default implementations of ``withOptionalCValue(_:)``,
/// which can be used to reduce overhead at call sites by eliminating the need to guard against optional
/// structs when converting them to their C equivalents.
///
/// ``CConvertible`` and ``ThrowingCConvertible`` do not provide equivalent optional handling
/// extensions. These protocols are generally used by structs whose C values are passed directly to C
/// functions (not as pointers), so the standard optional chaining syntax `object?.cValue()` is more
/// appropriate. For cases where a pointer is needed, a simple `guard` statement provides clear control
/// flow without adding protocol complexity for an uncommon use case.
///
/// ### Preventing Silent Failure
///
/// Protocols whose conversion may fail will throw instead of returning `nil`. If the methods returned a
/// `nil` pointer on failure, it would lead to ambiguity and additional overhead at call sites.
///
/// For example, consider the following outcomes of calling ``withOptionalCValue(_:)``:
///
/// - The method is called on a `nil` receiver, which returns a `nil` pointer. This is correct behavior.
/// - The method is called on a non-`nil` receiver, but the conversion fails and the conversion method
/// returns a `nil` pointer.
///
/// In the second scenario, the caller cannot immediately distinguish between these two cases without
/// additional logic. Callers would have to manually verify within each conversion closure that the returned
/// pointer is only `nil` when the receiver is also `nil`.
///
/// In order to reduce overhead and the chance of mistakes at call sites, an error is thrown only when
/// conversion of a non-`nil` receiver fails. Callers are responsible for catching the error and returning
/// `GIT_EUSER`. Callers should use ``withCConversion(_:)`` to do this automatically.



// MARK: - Protocols

/// A type that can be converted to the equivalent C value, without memory management and
/// without the possibility of failure.
internal protocol CConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    
    
    /// Converts the receiver instance to the equivalent C value.
    /// - Returns: The equivalent C value
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func cValue() -> C
}



/// A type that can be converted to the equivalent C value, without memory management and
/// with the possibility of failure.
internal protocol ThrowingCConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    
    
    /// Converts the receiver instance to the equivalent C value.
    /// - Returns: The equivalent C value
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func cValue() throws -> C
}



/// A type that can be converted to the equivalent C value, with memory management and
/// with the possibility of failure.
internal protocol WithCConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    
    
    /// Calls the given closure with a non-optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func withCValue<T>(
        _ body: (UnsafeMutablePointer<C>) throws -> T
    ) throws -> T
    
    
    
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<C>?) throws -> T
    ) throws -> T
}



// MARK: - Extensions

/// The default implementation of ``withOptionalCValue(_:)`` for structs that conform
/// to ``WithCConvertible``.
internal extension WithCConvertible
{
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
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



/// The default implementation of ``withOptionalCValue(_:)`` for optional structs that conform
/// to ``WithCConvertible``.
internal extension Optional where Wrapped: WithCConvertible
{
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
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



// MARK: - Utilities

/// Calls the given closure within a `do`/`catch` block and returns `GIT_EUSER` if an error is thrown.
/// - Parameter body: The closure to call.
/// - Returns: The return value of the given closure, or the `code` property of a thrown `NSError`,
/// or `GIT_EUSER` for any other thrown error.
internal func withCConversion(
    _ body: () throws -> Int32
) -> Int32
{
    do
    {
        return try body()
    }
    catch let error as NSError
    {
        return Int32(error.code)
    }
    catch
    {
        return GIT_EUSER.rawValue
    }
}
