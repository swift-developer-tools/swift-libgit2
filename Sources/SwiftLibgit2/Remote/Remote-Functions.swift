//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_remote_callbacks` instance.
/// - Parameters:
///   - opts: The `git_remote_callbacks` instance to initialize.
///   - version: The version to use. Pass ``gitRemoteCallbacksVersion``.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function is only needed when working directly with `git_remote_callbacks` instances.
/// ``GitRemoteCallbacks`` instances do not need to be initialized this way.
///
/// ## C Equivalent
///
/// [`git_remote_init_callbacks()`](https://libgit2.org/docs/reference/main/remote/git_remote_init_callbacks.html)
public func gitRemoteInitCallbacks(
    opts    : UnsafeMutablePointer<git_remote_callbacks>,
    version : UInt32
) -> Int32
{
    return git_remote_init_callbacks(
        opts,
        version
    )
}
