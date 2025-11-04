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



/// Creates a diff for the specified commit in `mbox` format to send via email.
/// - Parameters:
///   - out: The `Data` instance in which to store the email patch.
///   - diff: The diff to include in the email. The underlying type must be
///   `git_diff`.
///   - patchIdx: The patch index to use.
///   - patchCount: The number of patches to include in the email.
///   - commitID: The commit ID to use.
///   - summary: The commit message to use.
///   - body: The text to include above the diff stats.
///   - author: The author signature to use.
///   - opts: The email creation options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_email_create_from_diff()`](https://libgit2.org/docs/reference/main/sys/email/git_email_create_from_diff.html)
public func gitEmailCreateFromDiff(
    out         : inout Data,
    diff        : OpaquePointer,
    patchIdx    : Int,
    patchCount  : Int,
    commitID    : GitOID,
    summary     : String,
    body        : String?,
    author      : GitSignature,
    opts        : GitEmailCreateOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return try commitID.withCValue
            {
                cCommitID in
                
                return try author.withCValue
                {
                    cAuthor in
                    
                    return try opts.withOptionalCValue
                    {
                        cOpts in
                        
                        return git_email_create_from_diff(
                            cOut,
                            diff,
                            patchIdx,
                            patchCount,
                            cCommitID,
                            summary,
                            body,
                            cAuthor,
                            cOpts
                        )
                    }
                }
            }
        }
    }
}
