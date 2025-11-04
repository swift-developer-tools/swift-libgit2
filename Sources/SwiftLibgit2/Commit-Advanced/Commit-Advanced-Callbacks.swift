//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to get the parents of a commit.
/// - Parameters:
///   - idx: The index of the parent to retrieve.
///   - payload: The payload provided by the caller.
/// - Returns: The ID of the parent commit, or `nil` if there are no further
/// parents.
///
/// ## C Equivalent
///
/// [`git_commit_parent_callback()`](https://libgit2.org/docs/reference/main/sys/commit/git_commit_parent_callback.html)
public typealias GitCommitParentCB = @convention(c)
(
    Int,
    UnsafeMutableRawPointer?
) -> UnsafePointer<git_oid>?
