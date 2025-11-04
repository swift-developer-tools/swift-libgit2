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
///
/// ## Protocol Choice
///
/// The protocol used by a struct depends on how that struct will be used.
///
/// ``CStructReadable``:
/// - Generally represents Git data.
/// - Uses `public let` properties.
/// - Provides no public initializer and no default property values.
/// - Examples: ``GitBlameLine`` and ``GitDiffDelta``.
///
/// ``CStructMutable``:
/// - Generally represents caller-configurable options.
/// - Uses `public var` properties.
/// - Provides a public memberwise initializer with default values.
/// - Examples: ``GitCheckoutOptions`` and ``GitMergeOptions``.
///
/// ``CStructInternalMutable``:
/// - Generally used as `inout` function parameters.
/// - Uses `public private(set) var` or `public internal(set) var` properties.
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
/// While the refining protocols do not define additional requirements due to
/// these limitations, they provide semantic meaning to conforming structs.
///
/// Additionally, structs must conform to `Sendable` if possible. Structs that
/// contain shared mutable state such as pointers cannot be `Sendable`.
/// ``CStruct`` and its refining protocols do not require `Sendable`
/// conformance due to the level of variation among conforming structs.
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
/// provides default implementations of these mutating methods by conforming to
/// ``CMutable``. The mutating methods are designed for use with C functions
/// that expect parameters of the type `C *`, `C **`, or`const C **`.
///
/// ## CFreeable Structs
///
/// Any struct that conforms to ``CStructInternalMutable`` must also conform to
/// ``CFreeable``, if libgit2 provides a corresponding memory-freeing function.
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
internal protocol CStruct: CMutable
{
    /// The type of the equivalent C value.
    associatedtype C
    
    /// Creates an instance from a C value.
    ///
    /// This must have an `internal` access level.
    ///
    /// - Parameter cValue: The C value to use.
    init(
        cValue: C
    )
}



// MARK: - Refining Protocols

/// A read-only type that can be initialized from the equivalent C value.
internal protocol CStructReadable           : CStruct { }

/// A mutable type that can be initialized from the equivalent C value.
internal protocol CStructMutable            : CStruct { }

/// A publicly-readable and internally-mutable type that can be initialized
/// from the equivalent C value.
internal protocol CStructInternalMutable    : CStruct { }



// MARK: - Extensions

internal extension CStruct
{
    /// Creates an instance from a C value.
    /// - Parameter cValue: The C value to use.
    init?(
        cValue: C
    )
    {
        self.init(cValue: cValue)
    }
}
