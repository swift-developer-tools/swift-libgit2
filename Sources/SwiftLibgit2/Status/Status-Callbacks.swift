//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The callback invoked for each file.
/// - Parameters:
///   - path: The path to the file.
///   - statusFlags: The flags representing the status of the file.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_status_cb()`](https://libgit2.org/docs/reference/main/status/git_status_cb.html)
public typealias GitStatusCB = @convention(c)
(
    UnsafePointer<CChar>?,
    UInt32,
    UnsafeMutableRawPointer?
) -> Int32
