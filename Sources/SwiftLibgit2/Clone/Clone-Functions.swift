//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Clones a remote repository.
/// - Parameters:
///   - out: The pointer in which to store the resulting repository. The underlying type should be
///   `git_repository`.
///   - url: The URL of the remote to clone.
///   - localPath: The path to the local directory in which to clone.
///   - options: The options for the clone operation.
/// - Returns: `0` on success, a non-zero value returned by ``GitRemoteCreateCB`` or
/// ``GitRepositoryCreateCB``, or an error code.
///
/// ## C Equivalent
///
/// [`git_clone()`](https://libgit2.org/docs/reference/main/clone/git_clone.html)
public func gitClone(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    url         : String,
    localPath   : String,
    options     : GitCloneOptions?
) -> Int32
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
