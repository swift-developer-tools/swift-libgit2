//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback to invoke for each delta (file) when applying a patch.
/// - Parameters:
///   - delta: The delta to be applied.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value if the apply operation should be aborted, a
/// positive value if the delta should not be applied but the operation should
/// continue, or `0` if the delta should be applied.
///
/// ## C Equivalent
///
/// [`git_apply_delta_cb()`](https://libgit2.org/docs/reference/main/apply/git_apply_delta_cb.html)
public typealias GitApplyDeltaCB = @convention(c)
(
    UnsafePointer<git_diff_delta>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback that to invoke for each hunk when applying a patch.
/// - Parameters:
///   - hunk: The hunk to be applied.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value if the apply operation should be aborted, a
/// positive value if the hunk should not be applied but the operation should
/// continue, or `0` if the hunk should be applied.
///
/// ## C Equivalent
///
/// [`git_apply_hunk_cb()`](https://libgit2.org/docs/reference/main/apply/git_apply_hunk_cb.html)
public typealias GitApplyHunkCB = @convention(c)
(
    UnsafePointer<git_diff_hunk>?,
    UnsafeMutableRawPointer?
) -> Int32
