//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



// TODO: `git_diff_delta` Swift binding.

/// The callback that will be made per delta (file) when applying a patch.
/// - Parameters:
///   - delta: The delta to be applied.
///   - payload: The user-specified payload.
/// - Returns: A negative value if the apply process will be aborted, a positive value if the delta will not
/// be applied, or `0` if the delta will be applied.
///
/// ## Discussion
///
/// When the callback:
/// - Returns a negative value, the apply process will be aborted.
/// - Returns a positive value, the delta will not be applied, but the apply process will continue.
/// - Returns `0`, the delta will be applied, and the apply process will continue.
///
/// ## C Equivalent
///
/// [`git_apply_delta_cb()`](https://libgit2.org/docs/reference/main/apply/git_apply_delta_cb.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public typealias GitApplyDeltaCB = @convention(c) (
    UnsafePointer<git_diff_delta>?,
    UnsafeMutableRawPointer?
) -> Int32



// TODO: `git_diff_hunk` Swift binding.

/// The callback that will be made per hunk when applying a patch.
/// - Parameters:
///   - hunk: The hunk to be applied.
///   - payload: The user-specified payload.
/// - Returns: A negative value if the apply process will be aborted, a positive value if the hunk will not
/// be applied, or `0` if the hunk will be applied.
///
/// ## Discussion
///
/// When the callback:
/// - Returns a negative value, the apply process will be aborted.
/// - Returns a positive value, the hunk will not be applied, but the apply process will continue.
/// - Returns `0`, the hunk will be applied, and the apply process will continue.
///
/// ## C Equivalent
///
/// [`git_apply_hunk_cb()`](https://libgit2.org/docs/reference/main/apply/git_apply_hunk_cb.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public typealias GitApplyHunkCB = @convention(c) (
    UnsafePointer<git_diff_hunk>?,
    UnsafeMutableRawPointer?
) -> Int32
