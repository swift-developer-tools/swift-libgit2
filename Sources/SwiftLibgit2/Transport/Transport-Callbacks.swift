//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback for messages received by the transport.
/// - Parameters:
///   - str: The message from the transport.
///   - len: The length of the message from the transport.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_transport_message_cb()`](https://libgit2.org/docs/reference/main/transport/git_transport_message_cb.html)
public typealias GitTransportMessageCB = @convention(c)
(
    UnsafePointer<CChar>?,
    Int32,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback to create a transport.
/// - Parameters:
///   - out: The pointer in which to store the resulting transport.
///   - owner: The owner of the transport. The underlying type must be `git_remote`.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_transport_cb()`](https://libgit2.org/docs/reference/main/transport/git_transport_cb.html)
public typealias GitTransportCB = @convention(c)
(
    UnsafeMutablePointer<UnsafeMutablePointer<git_transport>?>?,
    OpaquePointer?,
    UnsafeMutableRawPointer?
) -> Int32
