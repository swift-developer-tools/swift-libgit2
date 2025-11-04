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
///   - version: The version to use. Pass ``gitProxyOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_proxy_options_init()`](https://libgit2.org/docs/reference/main/proxy/git_proxy_options_init.html)
public func gitProxyOptionsInit(
    opts    : UnsafeMutablePointer<git_proxy_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_proxy_options_init(
            opts,
            version
        )
    }
}
