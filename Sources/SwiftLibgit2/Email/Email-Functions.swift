//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a diff from the given commit in `mbox` format to send via email.
/// - Parameters:
///   - out: The buffer into which the email patch should be written
///   - commit: The commit for which to create a patch. The underlying type must be `git_commit`. 
///   - opts: The options for formatting generated emails.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: The given commit must not be a merge commit.
///
/// ## C Equivalent
///
/// [`git_email_create_from_commit()`](https://libgit2.org/docs/reference/main/email/git_email_create_from_commit.html)
public func gitEmailCreateFromCommit(
    out     : inout GitBuf,
    commit  : OpaquePointer,
    opts    : GitEmailCreateOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
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
