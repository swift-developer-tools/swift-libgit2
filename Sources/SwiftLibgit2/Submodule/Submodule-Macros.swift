//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The submodule source bit mask.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_STATUS__IN_FLAGS`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_STATUS__IN_FLAGS.html)
public let gitSubmoduleStatusInFlags: UInt32 = 0x000F



/// The submodule index status.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_STATUS__INDEX_FLAGS`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_STATUS__INDEX_FLAGS.html)
public let gitSubmoduleStatusIndexFlags: UInt32 = 0x0070



/// The submodule working directory status.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_STATUS__WD_FLAGS`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_STATUS__WD_FLAGS.html)
public let gitSubmoduleStatusWDFlags: UInt32 = 0x3F80



/// Checks whether the submodule is unmodified, based on the given status.
/// - Parameter status: The submodule status to evaluate.
/// - Returns: Whether the submodule is unmodified.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_STATUS_IS_UNMODIFIED`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_STATUS_IS_UNMODIFIED.html)
public func gitSubmoduleStatusIsUnmodified(
    status: GitSubmoduleStatusT
) -> Bool
{
    let modifiedBits: UInt32 = status.rawValue & ~gitSubmoduleStatusInFlags
    
    /// The `Bool` initializer treats `0` as `false`. The bitwise
    /// operation returns `0` if the submodule is unmodified.
    return !Bool(modifiedBits)
}



/// Checks whether the submodule index is unmodified, based on the given status.
/// - Parameter status: The submodule status to evaluate.
/// - Returns: Whether the submodule index is unmodified.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_STATUS_IS_INDEX_UNMODIFIED`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_STATUS_IS_INDEX_UNMODIFIED.html)
public func gitSubmoduleStatusIsIndexUnmodified(
    status: GitSubmoduleStatusT
) -> Bool
{
    let modifiedBits: UInt32 = status.rawValue & gitSubmoduleStatusIndexFlags
    
    /// The `Bool` initializer treats `0` as `false`. The bitwise
    /// operation returns `0` if the submodule index is unmodified.
    return !Bool(modifiedBits)
}



/// Checks whether the submodule working directory is unmodified, based on the
/// given status.
/// - Parameter status: The submodule status to evaluate.
/// - Returns: Whether the submodule working directory is unmodified.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_STATUS_IS_WD_UNMODIFIED`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_STATUS_IS_WD_UNMODIFIED.html)
public func gitSubmoduleStatusIsWDUnmodified(
    status: GitSubmoduleStatusT
) -> Bool
{
    let modifiedBits: UInt32 = status.rawValue & (
        gitSubmoduleStatusWDFlags
        & ~GitSubmoduleStatusT.gitSubmoduleStatusWDUninitialized.rawValue
    )
    
    /// The `Bool` initializer treats `0` as `false`. The bitwise operation
    /// returns `0` if the submodule working directory is unmodified.
    return !Bool(modifiedBits)
}



/// Checks whether the submodule working directory is dirty, based on the
/// given status.
/// - Parameter status: The submodule status to evaluate.
/// - Returns: Whether the submodule working directory is dirty.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_STATUS_IS_WD_DIRTY`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_STATUS_IS_WD_DIRTY.html)
public func gitSubmoduleStatusIsWDDirty(
    status: GitSubmoduleStatusT
) -> Bool
{
    let flags: GitSubmoduleStatusT =
    [
        .gitSubmoduleStatusWDIndexModified,
        .gitSubmoduleStatusWDWDModified,
        .gitSubmoduleStatusWDUntracked
    ]
    
    let modifiedBits: UInt32 = status.rawValue & flags.rawValue
    
    /// The `Bool` initializer treats `0` as `false`. The bitwise operation
    /// returns a non-zero value if the submodule working directory is dirty.
    return Bool(modifiedBits)
}



/// The current version for ``GitSubmoduleUpdateOptions``.
///
/// ## C Equivalent
///
/// [`GIT_SUBMODULE_UPDATE_OPTIONS_VERSION`](https://libgit2.org/docs/reference/main/submodule/GIT_SUBMODULE_UPDATE_OPTIONS_VERSION.html)
public let gitSubmoduleUpdateOptionsVersion: UInt32 = 1
