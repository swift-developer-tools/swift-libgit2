//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked to create a new connection to the given host and port.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``GitStreamRegistration/Initialize`` instead.
///
/// - Parameters:
///   - out: The pointer in which to store the stream.
///   - host: The name of the host to which to connect the stream.
///   - port: The port to which to connect the stream.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_stream_cb()`](https://libgit2.org/docs/reference/main/sys/stream/git_stream_cb.html)
public typealias GitStreamCB = @convention(c)
(
    UnsafeMutablePointer<UnsafeMutablePointer<git_stream>?>?,
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?
) -> Int32
