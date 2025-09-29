//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback to push network progress notifications.
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



/// The callback to inform of upcoming updates.
/// - Parameters:
///   - updates: An array containing the updates to send as commands to the destination.
///   - len: The number of elements in `updates`.
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



/// The callback to inform of the update status from the remote.
/// - Parameters:
///   - refname: The reference name specifying the remote reference that was updated.
///   - status: The status message sent from the remote.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will be called for each updated reference on push. If `status` is not `nil`, then update
/// was rejected by the remote server and `status` contains the rejection reason given by the server.
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



// TODO: Replace `git_direction` and `git_remote_set_instance_url()` in documentation.
/// The callback to resolve URLs before connecting to the remote.
/// - Parameters:
///   - urlResolved: The buffer to which the resolved URL should be written.
///   - url: The URL to resolve.
///   - direction: The direction of the connection. See `git_direction`.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This is deprecated in libgit2 and will be removed in the next major release.
/// Use `git_remote_set_instance_url()` instead.
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



// TODO: Replace `git_direction` and `git_remote_set_instance_url()` in documentation.
/// The callback invoked immediately before attempting to connect to the given URL.
/// - Parameters:
///   - remote: The remote to be connected. The underlying type should be `git_remote`.
///   - direction: The direction of the connection. See `git_direction`.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The URL may be changed before the connection by calling `git_remote_set_instance_url()`.
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



/// The callback invoked when different parts of the download process are completed.
/// - Parameters:
///   - type: The type of remote operation that was completed.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This callback is currently unused.
///
/// ## C Equivalent
///
/// This callback does not have a named equivalent in libgit2, but exists as the
/// ``GitRemoteCallbacks/completion`` property on ``GitRemoteCallbacks``.
public typealias GitRemoteCompletionCB = @convention(c)
(
    git_remote_completion_t,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for local reference updates.
/// - Parameters:
///   - refname: The reference name specifying the remote reference that was updated.
///   - old_id: The old ID.
///   - id: The new ID.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This is deprecated in libgit2 and will be removed in the next major release.
/// Use ``GitRemoteUpdateRefsCB`` instead.
///
/// If this function and ``GitRemoteUpdateRefsCB`` are both provided to
/// ``GitRemoteCallbacks``, then only ``GitRemoteUpdateRefsCB`` will be invoked.
///
/// ## C Equivalent
///
/// This callback does not have a named equivalent in libgit2, but exists as the
/// ``GitRemoteCallbacks/updateTips`` property on ``GitRemoteCallbacks``.
public typealias GitRemoteUpdateTipsCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafePointer<git_oid>?,
    UnsafePointer<git_oid>?,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback invoked for local reference updates.
/// - Parameters:
///   - refname: The reference name specifying the remote reference that was updated.
///   - old_id: The old ID.
///   - id: The new ID.
///   - refspec: The refspec to use. The underlying type should be `git_refspec`.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If this function and ``GitRemoteUpdateTipsCB`` are both provided to
/// ``GitRemoteCallbacks``, then only this function will be invoked.
///
/// ## C Equivalent
///
/// This callback does not have a named equivalent in libgit2, but exists as the
/// ``GitRemoteCallbacks/updateRefs`` property on ``GitRemoteCallbacks``.
public typealias GitRemoteUpdateRefsCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UnsafePointer<git_oid>?,
    UnsafePointer<git_oid>?,
    OpaquePointer?,
    UnsafeMutableRawPointer?
) -> Int32
