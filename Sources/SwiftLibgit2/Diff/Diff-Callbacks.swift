//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked for notifications of new diff deltas being added.
/// - Parameters:
///   - diffSoFar: The current diff. The underlying type must be `git_diff`.
///   - deltaToAdd: The delta to add.
///   - matchedPathspec: The matched pathspec.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value if an error occurred, a positive value to skip
/// this delta, or `0` on success.
///
/// ## C Equivalent
///
/// [`git_diff_notify_cb()`](https://libgit2.org/docs/reference/main/diff/git_diff_notify_cb.html)
public typealias GitDiffNotifyCB = @convention(c)
(
    OpaquePointer?,
    UnsafePointer<git_diff_delta>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for notifications of which files are being examined.
/// - Parameters:
///   - diffSoFar: The current diff. The underlying type must be `git_diff`.
///   - oldPath: The path to the old file.
///   - newPath: The path to the new file.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_diff_progress_cb()`](https://libgit2.org/docs/reference/main/diff/git_diff_progress_cb.html)
public typealias GitDiffProgressCB = @convention(c)
(
    OpaquePointer?,
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for each file in a diff.
/// - Parameters:
///   - delta: The delta data of the file.
///   - progress: The diff progress, from `0` to `1`.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_diff_file_cb()`](https://libgit2.org/docs/reference/main/diff/git_diff_file_cb.html)
public typealias GitDiffFileCB = @convention(c)
(
    UnsafePointer<git_diff_delta>?,
    Float,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for binary content in a diff.
/// - Parameters:
///   - delta: The delta data of the file.
///   - binary: The binary content.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_diff_binary_cb()`](https://libgit2.org/docs/reference/main/diff/git_diff_binary_cb.html)
public typealias GitDiffBinaryCB = @convention(c)
(
    UnsafePointer<git_diff_delta>?,
    UnsafePointer<git_diff_binary>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for each hunk in a diff.
/// - Parameters:
///   - delta: The delta data of the file.
///   - hunk: The diff hunk.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_diff_hunk_cb()`](https://libgit2.org/docs/reference/main/diff/git_diff_hunk_cb.html)
public typealias GitDiffHunkCB = @convention(c)
(
    UnsafePointer<git_diff_delta>?,
    UnsafePointer<git_diff_hunk>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for each line in a diff.
/// - Parameters:
///   - delta: The delta to process.
///   - hunk: The diff hunk to process.
///   - line: The diff line to process.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// In this context, the provided range will be `nil`.
///
/// - Note: `git_diff_print_callback__to_buf()` may be used as a stock
/// implementation of this callback.
///
/// ## C Equivalent
///
/// [`git_diff_line_cb()`](https://libgit2.org/docs/reference/main/diff/git_diff_line_cb.html)
public typealias GitDiffLineCB = @convention(c)
(
    UnsafePointer<git_diff_delta>?,
    UnsafePointer<git_diff_hunk>?,
    UnsafePointer<git_diff_line>?,
    UnsafeMutableRawPointer?
) -> Int32
