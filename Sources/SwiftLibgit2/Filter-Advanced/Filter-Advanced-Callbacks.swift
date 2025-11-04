//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to initialize the given filter.
///
/// This callback will be invoked at most once, immediately before the filter
/// is first used.
///
/// - Parameter self: The filter to initialize.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_filter_init_fn()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_init_fn.html)
public typealias GitFilterInitFN = @convention(c)
(
    UnsafeMutablePointer<git_filter>?
) -> Int32



/// The callback invoked to shut down the given filter.
///
/// This callback will be invoked at most once, when the given filter is
/// unregistered or when libgit2 is shutting down. This may be called even
/// if ``GitFilterInitFN`` was not invoked.
///
/// - Parameter self: The filter to initialize.
///
/// ## C Equivalent
///
/// [`git_filter_shutdown_fn()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_shutdown_fn.html)
public typealias GitFilterShutdownFN = @convention(c)
(
    UnsafeMutablePointer<git_filter>?
) -> Void



/// The callback invoked to determine whether the given source needs the
/// given filter.
///
/// If the filter allocates and assigns a value to the given `payload`,
/// ``GitFilterCleanupFN`` must be used to free the payload.
///
/// - Parameters:
///   - self: The filter to check.
///   - payload: The payload provided by the caller. This must be allocated on
///   the heap, so it is valid until the ``GitFilterStreamFN`` callback can
///   use it.
///   - src: The filter source to check. The underlying type must be
///   `git_filter_source`.
///   - attrValues: The pointer in which to store the values of any attributes
///   given in the filter definition.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_filter_check_fn()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_check_fn.html)
public typealias GitFilterCheckFN = @convention(c)
(
    UnsafeMutablePointer<git_filter>?,
    UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
    OpaquePointer?,
    UnsafeMutablePointer<UnsafePointer<CChar>?>?
) -> Int32



/// The callback invoked to perform data filtering.
///
/// If the filter allocates and assigns a value to the given `payload`,
/// ``GitFilterCleanupFN`` must be used to free the payload.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``GitFilterStreamFN`` instead.
///
/// - Parameters:
///   - self: The filter to check.
///   - payload: The payload provided by the caller. This must be allocated on
///   the heap.
///   - to: The input buffer to use.
///   - from: The output buffer to use.
///   - src: The filter source to use. The underlying type must be
///   `git_filter_source`.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_filter_apply_fn()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_apply_fn.html)
public typealias GitFilterApplyFN = @convention(c)
(
    UnsafeMutablePointer<git_filter>?,
    UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
    UnsafeMutablePointer<git_buf>?,
    UnsafePointer<git_buf>?,
    OpaquePointer?
) -> Int32



/// The callback invoked to perform data filtering.
///
/// If the filter allocates and assigns a value to the given `payload`,
/// ``GitFilterCleanupFN`` must be used to free the payload.
///
/// - Parameters:
///   - out: The stream in which to write the original data.
///   - self: The filter to check.
///   - payload: The payload provided by the caller. This must be allocated on
///   the heap.
///   - src: The filter source to use. The underlying type must be
///   `git_filter_source`.
///   - next: The stream in which to write the filtered data.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_filter_stream_fn()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_stream_fn.html)
public typealias GitFilterStreamFN = @convention(c)
(
    UnsafeMutablePointer<UnsafeMutablePointer<git_writestream>?>?,
    UnsafeMutablePointer<git_filter>?,
    UnsafeMutablePointer<UnsafeMutableRawPointer?>?,
    OpaquePointer?,
    UnsafeMutablePointer<git_writestream>?
) -> Int32



/// The callback invoked to clean up after the given filter has been applied.
/// - Parameters:
///   - self: The filter to clean up.
///   - payload: The payload to free.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_filter_cleanup_fn()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_cleanup_fn.html)
public typealias GitFilterCleanupFN = @convention(c)
(
    UnsafeMutablePointer<git_filter>?,
    UnsafeMutableRawPointer?
) -> Void
