//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

// MARK: - CConvertible Protocol

/// A type that can be converted to the equivalent C value.
///
/// ## Discussion
///
/// This protocol standardizes the implementation of Swift binding structs. Swift binding structs can be
/// converted to their C equivalents using either a computed property or an instance method.
///
/// All Swift binding structs that indirectly conform to ``GitStruct`` should also conform to one of
/// the following protocols:
///
/// - Computed property conversion:
///     - ``NonOptionalCConvertible``
///     - ``OptionalCConvertible``
///
/// - Instance method conversion:
///     - ``NonOptionalWithCConvertible``
///     - ``OptionalWithCConvertible``
///
/// Structs that directly conform to ``GitStruct`` (and are unused by other bindings) should not
/// conform to any of these protocols. See the ``GitStruct`` documentation for more information.
///
/// Structs should not directly conform to ``CConvertible``.
///
/// The protocol used by a struct depends on whether the conversion can occur using only simple field
/// assignment, in which case a computed property should be used, or whether the conversion requires
/// memory management, in which case an instance method should be used.
///
/// Both computed properties and instance methods may return an optional value if the conversion involves
/// the possibility of an error. Generally, C structs with an initialization method involve the possibility of failure,
/// and these structs should conform to one of the "Optional" protocols.
///
/// All convertible protocols include default implementations of ``withOptionalCValue(_:)``,
/// which can be used to reduce overhead at call sites by eliminating the need to guard against optional
/// structs when converting them to their C equivalents.
///
/// ``CConvertible`` does not define requirements to convert from a given C value to the
/// equivalent Swift value (by using an `init(cValue:)` method) in order to maintain flexibility.
/// For example, other protocols like ``GitEnum`` and ``GitOptionSet`` conform to
/// ``NonOptionalCConvertible``, but these use `init?(cValue:)` and `init(rawValue:)`,
/// respectively. The `init(cValue:)` requirement is therefore defined by ``GitStruct``, which
/// conforms directly to ``CConvertible``.
internal protocol CConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
}



// MARK: - Property Protocols

/// A type that can be converted to the non-optional equivalent C value using a computed property.
internal protocol NonOptionalCConvertible: CConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// The non-optional equivalent C value.
    ///
    /// ## Discussion
    ///
    /// This should have an `internal` access level.
    var cValue: C { get }
}



/// A type that can be converted to the optional equivalent C value using a computed property.
internal protocol OptionalCConvertible: CConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// The optional equivalent C value.
    ///
    /// ## Discussion
    ///
    /// This should have an `internal` access level.
    var cValue: C? { get }
}



// MARK: - Method Protocols

/// A type that can be converted to the equivalent C value using an instance method.
internal protocol WithCConvertible: CConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This should have an `internal` access level.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<C>?) -> T
    ) -> T
}



/// A type that can be converted to the equivalent non-optional C value using an instance method.
internal protocol NonOptionalWithCConvertible: WithCConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// Calls the given closure with a non-optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This should have an `internal` access level.
    func withCValue<T>(
        _ body: (UnsafeMutablePointer<C>) -> T
    ) -> T
}



/// A type that can be converted to the equivalent optional C value using an instance method.
internal protocol OptionalWithCConvertible: WithCConvertible
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This should have an `internal` access level.
    func withCValue<T>(
        _ body: (UnsafeMutablePointer<C>?) -> T
    ) -> T
}



// MARK: - Extensions

internal extension NonOptionalWithCConvertible
{
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<C>?) -> T
    ) -> T
    {
        return withCValue
        {
            cValuePointer in
            
            body(cValuePointer)
        }
    }
}



internal extension OptionalWithCConvertible
{
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<C>?) -> T
    ) -> T
    {
        return withCValue
        {
            cValuePointer in
            
            body(cValuePointer)
        }
    }
}



internal extension Optional where Wrapped: WithCConvertible
{
    /// Calls the given closure with an optional pointer to the equivalent C value.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    func withOptionalCValue<T>(
        _ body: (UnsafeMutablePointer<Wrapped.C>?) -> T
    ) -> T
    {
        switch self
        {
            case .none:
                
                return body(nil)
                
            case .some(let wrapped):
                
                return wrapped.withOptionalCValue(body)
        }
    }
}
