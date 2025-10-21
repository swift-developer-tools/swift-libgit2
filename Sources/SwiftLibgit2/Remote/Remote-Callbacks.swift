//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to report push network progress.
/// - Parameters:
///   - current: The number of objects pushed so far.
///   - total: The total number of objects to push.
///   - bytes: The number of bytes pushed.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_push_transfer_progress_cb()`](https://libgit2.org/docs/reference/main/remote/git_push_transfer_progress_cb.html)
public typealias GitPushTransferProgressCB = @convention(c)
(
    UInt32,
    UInt32,
    Int,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for upcoming update notifications.
/// - Parameters:
///   - updates: An array containing the updates to send as commands to the
///   destination.
///   - len: The length of `updates`.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_push_negotiation()`](https://libgit2.org/docs/reference/main/remote/git_push_negotiation.html)
public typealias GitPushNegotiationCB = @convention(c)
(
    UnsafeMutablePointer<UnsafePointer<git_push_update>?>?,
    Int,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for remote status update notifications.
/// - Parameters:
///   - refname: The reference name specifying the remote reference that was
///   updated.
///   - status: The status message sent from the remote.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will be called for each updated reference on push.
/// If `status` is not `nil`, then update was rejected by the remote server
/// and `status` contains the rejection reason given by the server.
///
/// ## C Equivalent
///
/// [`git_push_update_reference_cb()`](https://libgit2.org/docs/reference/main/remote/git_push_update_reference_cb.html)
public typealias GitPushUpdateReferenceCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked to resolve URLs.
/// - Parameters:
///   - urlResolved: The buffer to which to write the resolved URL.
///   - url: The URL to resolve.
///   - direction: The direction of the connection. See ``GitDirection``.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``gitRemoteSetInstanceURL(remote:url:)`` instead.
///
/// ## C Equivalent
///
/// [`git_url_resolve_cb()`](https://libgit2.org/docs/reference/main/remote/git_url_resolve_cb.html)
public typealias GitURLResolveCB = @convention(c)
(
    UnsafeMutablePointer<git_buf>?,
    UnsafePointer<CChar>?,
    Int32,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked immediately before attempting a remote connection.
/// - Parameters:
///   - remote: The remote to be connected. The underlying type must be
///   `git_remote`.
///   - direction: The direction of the connection. See ``GitDirection``.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The URL may be changed before the connection by calling
/// ``gitRemoteSetInstanceURL(remote:url:)``.
///
/// ## C Equivalent
///
/// [`git_remote_ready_cb()`](https://libgit2.org/docs/reference/main/remote/git_remote_ready_cb.html)
public typealias GitRemoteReadyCB = @convention(c)
(
    OpaquePointer?,
    Int32,
    UnsafeMutableRawPointer?
) -> Int32
