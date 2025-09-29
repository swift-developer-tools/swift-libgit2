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
/// conform to one of the following protocols.The exception is Swift structs that act as bindings for C
/// bitset enums. These Swift structs should conform to the ``GitOptionSet`` protocol instead.
///
/// The only structs that should conform directly to ``GitStruct`` are structs which are unused by other
/// bindings, but exist for documentation purposes. ``GitStructReadable`` does not define any
/// additional requirements other than those of ``GitStruct``, but exists for semantic purposes.
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
/// In addition to the requirements actually defined by this protocol, conforming structs should also follow the
/// rules described above. These protocols cannot be more specific due to limitations of what Swift protocols
/// can define, and also because the conforming structs have different requirements based on the C struct
/// they are translating.
///
/// For example, the three protocols described above require different property access levels, but this is
/// not definable through Swift protocols.
///
/// Similarly, structs that conform to ``GitStructReadable``, ``GitStructMutable``,
/// or ``GitStructInternalMutable`` should implement one of the following approaches to
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
/// Structs should implement these by conforming to one of the following protocols:
///
/// - ``CConvertible`` (non-throwing, without memory management)
/// - ``ThrowingCConvertible`` (throwing, without memory management)
/// - ``WithCConvertible`` (non-throwing, with memory management)
/// - ``WithThrowingCConvertible`` (throwing, with memory management)
///
/// ``GitStruct`` does not directly conform to the C convertible protocols due to the level of variation
/// required by conforming structs. A single protocol cannot define this level of variation, and multiple
/// protocols would be less effective from a semantic standpoint. Conforming structs should adopt one
/// of the convertible protocols, unless they conform directly to ``GitStruct`` (and are unused by
/// other bindings).
///
/// Some structs may also need to implement an additional mutating method:
///
/// ```swift
/// internal func withMutatingCValue<T>(
///     _ body: (UnsafeMutablePointer<C>) throws -> T
/// ) throws -> T
/// ```
///
/// The first mutating method should be used when working with C functions that expect a parameter
/// of the type `C *`, while the second mutating method should be used for `C **` parameters.
/// The structs which current implement these methods are:
///
/// - `UnsafeMutablePointer<C>`:
///     - ``GitBuf``
///     - ``GitOID``
///
/// - `UnsafeMutablePointer<UnsafeMutablePointer<C>?>`:
///     - ``GitConfigEntry``
///     - ``GitSignature``
///
/// These structs are commonly used as `inout` parameters with function bindings.
/// Currently, no protocol defines requirements for these mutating methods. If more binding structs
/// implement this method, a new protocol should be created to standardize its implementation.
internal protocol GitStruct
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// Creates an instance from a C value.
    /// - Parameter cValue: The C value to use.
    ///
    /// ## Discussion
    ///
    /// This should have an `internal` access level.
    init(
        cValue: C
    )
}



internal protocol GitStructReadable: GitStruct { }



internal protocol GitStructMutable: GitStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This should have a `public` access level and an empty body.
    init()
}



internal protocol GitStructInternalMutable: GitStruct
{
    /// Creates an instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// This should have a `public` access level and an empty body.
    init()
}
