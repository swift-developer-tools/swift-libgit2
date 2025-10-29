//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// Creates a diff for the given commit in `mbox` format to send via email.
/// - Parameters:
///   - out: The `Data` instance in which to store the email patch.
///   - commit: The commit for which to create a patch. The underlying type
///   must be `git_commit`. This must not be a merge commit.
///   - opts: The email creation options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_email_create_from_commit()`](https://libgit2.org/docs/reference/main/email/git_email_create_from_commit.html)
public func gitEmailCreateFromCommit(
    out     : inout Data,
    commit  : OpaquePointer,
    opts    : GitEmailCreateOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_email_create_from_commit(
                    cOut,
                    commit,
                    cOpts
                )
            }
        }
    }
}
