//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_proxy_options` instance.
/// - Parameters:
///   - opts: The `git_proxy_options` instance to initialize.
///   - version: The version to use. Pass ``gitProxtOptionsVersion``.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function is only needed when working directly with `git_proxy_options` instances.
/// ``GitProxyOptions`` instances do not need to be initialized this way.
///
/// ## C Equivalent
///
/// [`git_proxy_options_init()`](https://libgit2.org/docs/reference/main/proxy/git_proxy_options_init.html)
public func gitProxyOptionsInit(
    opts    : UnsafeMutablePointer<git_proxy_options>,
    version : UInt32
) -> Int32
{
    return git_proxy_options_init(
        opts,
        version
    )
}
