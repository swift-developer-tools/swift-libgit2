//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to initialize the given merge driver.
///
/// This callback will be invoked at most once, immediately before the merge
/// driver is first used.
///
/// - Parameter self: The merge driver to initialize.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_merge_driver_init_fn()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_init_fn.html)
public typealias GitMergeDriverInitFN = @convention(c)
(
    UnsafeMutablePointer<git_merge_driver>?
) -> Int32




/// The callback invoked to shut down the given merge driver.
///
/// This callback will be invoked at most once, when the given merge driver is
/// unregistered or when libgit2 is shutting down. This may be called even
/// if ``GitMergeDriverInitFN`` was not invoked.
///
/// - Parameter self: The merge driver to initialize.
///
/// ## C Equivalent
///
/// [`git_merge_driver_shutdown_fn()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_shutdown_fn.html)
public typealias GitMergeDriverShutdownFN = @convention(c)
(
    UnsafeMutablePointer<git_merge_driver>?
) -> Void



/// The callback invoked to perform a merge.
/// - Parameters:
///   - self: The merge driver to use.
///   - pathOut: The pointer in which to store the resolved path.
///   - modeOut: The pointer in which to store the resolved mode.
///   - mergedOut: The pointer in which to store the merged output contents.
///   - filterName: The name of the invoked filter.
///   - src: The merge driver source to use. The underlying type must be
///   `git_merge_driver_source`.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_merge_driver_apply_fn()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_apply_fn.html)
public typealias GitMergeDriverApplyFN = @convention(c)
(
    UnsafeMutablePointer<git_merge_driver>?,
    UnsafeMutablePointer<UnsafePointer<CChar>?>?,
    UnsafeMutablePointer<UInt32>?,
    UnsafeMutablePointer<git_buf>?,
    UnsafePointer<CChar>?,
    OpaquePointer?
) -> Int32
