//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



// TODO: Replace `git_transport_remote_connect_options()` in documentation.
/// Frees the memory allocated for the given `git_remote_connect_options`
/// instance.
/// - Parameter opts: The remote connect options to free.
///
/// ## Discussion
///
/// This function does not free the `git_remote_connect_options` instance
/// itself. It disposes the libgit2-initialized fields of the given options.
///
/// - Important: This function must be called only with a
/// `git_remote_connect_options` instance that was returned by
/// `git_transport_remote_connect_options()`.
///
/// ## C Equivalent
///
/// [`git_remote_connect_options_dispose()`](https://libgit2.org/docs/reference/main/sys/remote/git_remote_connect_options_dispose.html)
public func gitRemoteConnectOptionsDispose(
    opts: UnsafeMutablePointer<git_remote_connect_options>?
)
{
    guard let opts: UnsafeMutablePointer<git_remote_connect_options> = opts
    else
    {
        return
    }
    
    git_remote_connect_options_dispose(opts)
}
