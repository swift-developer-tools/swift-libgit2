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
/// - Returns: A ``GitErrorCode`` instance.
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
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_init_callbacks(
            opts,
            version
        )
    }
}



/// Initializes the given `git_fetch_options` instance.
/// - Parameters:
///   - opts: The `git_fetch_options` instance to initialize.
///   - version: The version to use. Pass ``gitFetchOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is only needed when working directly with `git_fetch_options` instances.
/// ``GitFetchOptions`` instances do not need to be initialized this way.
///
/// ## C Equivalent
///
/// [`git_fetch_options_init()`](https://libgit2.org/docs/reference/main/remote/git_fetch_options_init.html)
public func gitFetchOptionsInit(
    opts    : UnsafeMutablePointer<git_fetch_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_fetch_options_init(
            opts,
            version
        )
    }
}
