//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked for each `FETCH_HEAD` entry.
/// - Parameters:
///   - refName: The reference name.
///   - remoteURL: The remote URL.
///   - oid: The reference target ID.
///   - isMerge: Whether the reference was the result of a merge operation.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_repository_fetchhead_foreach_cb()`](https://libgit2.org/docs/reference/main/repository/git_repository_fetchhead_foreach_cb.html)
public typealias GitRepositoryFETCHHEADForEachCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UnsafePointer<git_oid>?,
    UInt32,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for each `MERGE_HEAD` entry.
/// - Parameters:
///   - oid: The merge ID.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_repository_mergehead_foreach_cb()`](https://libgit2.org/docs/reference/main/repository/git_repository_mergehead_foreach_cb.html)
public typealias GitRepositoryMERGEHEADForEachCB = @convention(c)
(
    UnsafePointer<git_oid>?,
    UnsafeMutableRawPointer?
) -> Int32
