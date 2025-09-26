//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A type that represents the Swift translation of a C struct.
///
/// ## Discussion
///
/// This protocol standardizes the implementation of Swift binding structs. All Swift binding structs should
/// conform to one of the following protocols. The exception is Swift structs that act as bindings for C bit
/// set enums. These Swift structs should conform to the ``GitOptionSet`` protocol instead.
///
/// ``GitStructReadOnly``:
/// - Generally represents Git data.
/// - Uses `public let` properties.
/// - Provides no default property values.
/// - Provides no public initializer.
/// - Examples: ``GitBlameLine`` and ``GitDiffDelta``.
///
/// ``GitStructInternalReadWrite``:
/// - Generally used as `inout` function parameters.
/// - Uses `public private(set) var` or `public internal(set) var` properties.
/// - Provides default property values, but does not publicly document them.
/// - Provides a `public init()` method that accepts no parameters.
/// - Examples: ``GitOID`` and ``GitSignature``.
///
/// ``GitStructReadWrite``:
/// - Generally represents caller-configurable options.
/// - Uses `public var` properties.
/// - Provides default property values and publicly documents them.
/// - Provides a `public init()` method that accepts no parameters.
/// - Examples: ``GitCheckoutOptions`` and ``GitMergeOptions``.
///
/// The only structs that may should directly to ``GitStruct`` are structs which are unused by other
/// bindings, but exist for documentation purposes.
///
/// In addition to the requirements actually defined by this protocol, conforming structs should also follow the
/// rules described above. These protocols cannot be more specific due to limitations of what Swift protocols
/// can define, and also because the conforming structs have different requirements based on the C struct
/// they are translating.
///
/// For example, the three protocols described above require different property access levels, but this is
/// not definable through Swift protocols.
///
/// Similarly, structs that conform to ``GitStructReadOnly``, ``GitStructInternalReadWrite``,
/// or``GitStructReadWrite`` should implement one of the following:
///
/// ```swift
/// internal var cValue: T
///
/// internal func withCValue<R>(
///     _ body: (UnsafeMutablePointer<T>) -> R
/// ) -> R
///
/// internal func withMutatingCValue<R>(
///     _ body: (UnsafeMutablePointer<T>) -> R
/// ) -> R
/// ```
///
/// Structs that conform directly to ``GitStruct`` should not implement any of these.
///
/// Generally, structs that can be translated from Swift to C using only simple field assignment should
/// implement the computed property, while structs that require memory management during translation
/// should implement one or both of the functions.
///
/// Structs that implement the functions may use `UnsafeMutablePointer<T>?` as the parameter of
/// the `body` closure, if their translation involves the possibility of an error. Some structs like
/// ``GitSignature`` may use `UnsafeMutablePointer<UnsafeMutablePointer<T>?>` as
/// the parameter of the `body` closure in order to reduce caller overhead.
///
/// A single protocol cannot define this level of variation, and multiple protocols would be less effective
/// from a semantic standpoint.
internal protocol GitStruct
{
    /// The equivalent C value.
    associatedtype T
    
    /// Creates an instance from a C value.
    /// - Parameter cValue: The C value to use.
    ///
    /// ## Discussion
    ///
    /// This initializer should have an `internal` access level.
    init(
        cValue: T
    )
}



internal protocol GitStructReadOnly: GitStruct { }



internal protocol GitStructInternalReadWrite: GitStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This initializer should have a `public` access level and an empty body.
    init()
}



internal protocol GitStructReadWrite: GitStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This initializer should have a `public` access level and an empty body.
    init()
}
