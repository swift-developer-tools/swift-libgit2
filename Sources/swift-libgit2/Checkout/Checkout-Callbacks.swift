//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The callback for checkout notifications.
/// - Parameters:
///   - why: The notification reason.
///   - path: The path to the file being checked out.
///   - baseline: The baseline diff file information.
///   - target: The checkout target diff file information.
///   - workdir: The working directory diff file information.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_checkout_notify_cb()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_notify_cb.html)
public typealias GitCheckoutNotifyCB = @convention(c)
(
    git_checkout_notify_t,
    UnsafePointer<CChar>?,
    UnsafePointer<git_diff_file>?,
    UnsafePointer<git_diff_file>?,
    UnsafePointer<git_diff_file>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback for checkout progress.
/// - Parameters:
///   - path: The path to the file being checked out.
///   - completedSteps: The number of checkout steps completed.
///   - totalSteps: The total number of steps in the checkout process.
///   - payload: The payload provided by the caller.
///
/// ## C Equivalent
///
/// [`git_checkout_progress_cb()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_progress_cb.html)
public typealias GitCheckoutProgressCB = @convention(c)
(
    UnsafePointer<CChar>?,
    Int,
    Int,
    UnsafeMutableRawPointer?
) -> Void



/// The callback for reporting checkout performance data.
/// - Parameters:
///   - perfData: The checkout performance data.
///   - payload: The payload provided by the caller.
///
/// ## C Equivalent
///
/// [`git_checkout_perfdata_cb()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_perfdata_cb.html)
public typealias GitCheckoutPerfDataCB = @convention(c)
(
    UnsafePointer<git_checkout_perfdata>?,
    UnsafeMutableRawPointer?
) -> Void
