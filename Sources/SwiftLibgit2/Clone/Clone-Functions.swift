//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_clone_options` instance.
/// - Parameters:
///   - opts: The `git_clone_options` instance to initialize.
///   - version: The version to use. Pass ``gitCloneOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is only needed when working directly with
/// `git_clone_options` instances. ``GitCloneOptions`` instances do not need
/// to be initialized this way.
///
/// ## C Equivalent
///
/// [`git_clone_options_init()`](https://libgit2.org/docs/reference/main/clone/git_clone_options_init.html)
public func gitCloneOptionsInit(
    opts    : UnsafeMutablePointer<git_clone_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_clone_options_init(
            opts,
            version
        )
    }
}



/// Clones a remote repository.
/// - Parameters:
///   - out: The pointer in which to store the repository. The underlying type
///   must be `git_repository`.
///   - url: The URL of the remote to clone.
///   - localPath: The path to the local directory in which to clone.
///   - options: The options for the clone operation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_clone()`](https://libgit2.org/docs/reference/main/clone/git_clone.html)
public func gitClone(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    url         : String,
    localPath   : String,
    options     : GitCloneOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            return git_clone(
                out,
                url,
                localPath,
                cOptions
            )
        }
    }
}
