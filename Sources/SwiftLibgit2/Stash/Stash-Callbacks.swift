//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to report stash application progress.
/// - Parameters:
///   - progress: The state of the stash application operation.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_stash_apply_progress_cb()`](https://libgit2.org/docs/reference/main/stash/git_stash_apply_progress_cb.html)
public typealias GitStashApplyProgressCB = @convention(c)
(
    git_stash_apply_progress_t,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for each stashed state.
/// - Parameters:
///   - index: The position of the entry within the stash list.
///   - message: The stash message.
///   - stashID: The commit ID of the stashed state.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_stash_cb()`](https://libgit2.org/docs/reference/main/stash/git_stash_cb.html)
public typealias GitStashCB = @convention(c)
(
    Int,
    UnsafePointer<CChar>?,
    UnsafePointer<git_oid>?,
    UnsafeMutableRawPointer?
) -> Int32
