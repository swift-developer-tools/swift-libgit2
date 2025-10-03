//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback for creating commits.
/// - Parameters:
///   - out: The pointer in which to store the resulting commit.
///   - author: The author's signature.
///   - committer: The committer's signature.
///   - messageEncoding: The encoding for the commit message. The default value is UTF-8.
///   - message: The commit message.
///   - tree: The tree to be committed.
///   - parentCount: The number of parents of the commit.
///   - parents: The parents of the commit.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_commit_create_cb()`](https://libgit2.org/docs/reference/main/commit/git_commit_create_cb.html)
public typealias GitCommitCreateCB = @convention(c)
(
    UnsafeMutablePointer<git_oid>?,
    UnsafePointer<git_signature>?,
    UnsafePointer<git_signature>?,
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    OpaquePointer?,
    Int,
    UnsafeMutablePointer<OpaquePointer?>?,
    UnsafeMutableRawPointer?
) -> Int32
