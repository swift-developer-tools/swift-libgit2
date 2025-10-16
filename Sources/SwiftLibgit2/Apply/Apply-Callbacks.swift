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
///   - delta: The delta to apply.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value to abort the apply operation, a positive value
/// to not apply the delta but to continue the operation, or `0` to apply the
/// delta.
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
///   - hunk: The hunk to apply.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value to abort the apply operation, a positive value
/// to not apply the hunk but to continue the operation, or `0` to apply the
/// hunk.
///
/// ## C Equivalent
///
/// [`git_apply_hunk_cb()`](https://libgit2.org/docs/reference/main/apply/git_apply_hunk_cb.html)
public typealias GitApplyHunkCB = @convention(c)
(
    UnsafePointer<git_diff_hunk>?,
    UnsafeMutableRawPointer?
) -> Int32
