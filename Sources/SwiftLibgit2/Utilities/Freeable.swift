//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A type that can be converted to and from the equivalent C value, which
/// must be freed.
///
/// ## Discussion
///
/// A struct that conforms to ``GitStructInternalMutable`` may also need to
/// conform to ``Freeable`` if libgit2 provides a corresponding memory-freeing
/// function. See the ``GitStruct`` documenation for more information.
internal protocol Freeable: GitStruct
{
    /// The type of the pointer passed to ``freeCValue(_:)`` to free the memory
    /// allocated for the C value.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    ///
    /// The default type is `UnsafeMutablePointer<C>?`, which is appropriate
    /// for most conforming structs. Conforming structs may override this if
    /// a different type of pointer is required.
    associatedtype P = UnsafeMutablePointer<C>?
    
    
    
    /// Frees the memory allocated for the C value.
    /// - Parameter pointer: The pointer to the memory to free.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    ///
    /// This function will be called automatically when
    /// ``withMutatingCValue(_:)`` is used with C  functions that expect `C **`
    /// parameters, and libgit2 allocates new memory. Implementations should
    /// call the appropriate memory-freeing function.
    static func freeCValue(
        _ pointer: P
    )
}
