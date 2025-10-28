//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a commit in the given repository, from the given IDs.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the
///   newly-created commit.
///   - repo: The repository in which to create the commit. The underlying type
///   must be `git_repository`.
///   - updateRef: The name of the reference to update to point to the commit.
///   - author: The author signature to use.
///   - committer: The committer signature to use.
///   - messageEncoding: The commit message encoding to use. Pass `nil` to
///   use the original message encoding.
///   - message: The commit message to use.
///   - tree: The ID of the commit tree to use.
///   - parentCount: The length of `parents`.
///   - parents: The IDs of the commits to use as parents of the commit. Pass
///   an empty array to create a commit with no parents.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The commit message will not be cleaned up automatically. Use
/// ``gitMessagePrettify(out:message:stripComments:commentChar:)`` to clean
/// up the commit message.
///
/// If `updateRef` is not direct, it will be resolved to a direct reference.
/// Pass `HEAD` to update the HEAD of the current branch and make it point to
/// this commit. If the reference does not exist yet, it will be created.
/// If it does exist, the first parent must be the tip of this branch.
///
/// - Important: This function does not validate the given tree ID or any of
/// the parent IDs.
///
/// ## C Equivalent
///
/// [`git_commit_create_from_ids()`](https://libgit2.org/docs/reference/main/sys/commit/git_commit_create_from_ids.html)
public func gitCommitCreateFromIDs(
    id              : inout GitOID,
    repo            : OpaquePointer,
    updateRef       : String?,
    author          : GitSignature,
    committer       : GitSignature,
    messageEncoding : String?,
    message         : String,
    tree            : GitOID,
    parentCount     : Int,
    parents         : [GitOID]
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return try author.withCValue
            {
                cAuthor in
                
                return try committer.withCValue
                {
                    cCommitter in
                    
                    return tree.withCValue
                    {
                        cTree in
                        
                        return parents.withArrayOfGitOIDs
                        {
                            cParents, cParentsCount in
                            
                            return git_commit_create_from_ids(
                                cID,
                                repo,
                                updateRef,
                                cAuthor,
                                cCommitter,
                                messageEncoding,
                                message,
                                cTree,
                                cParentsCount,
                                cParents
                            )
                        }
                    }
                }
            }
        }
    }
}



/// Creates a commit in the given repository, from the given IDs.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the
///   newly-created commit.
///   - repo: The repository in which to create the commit. The underlying type
///   must be `git_repository`.
///   - updateRef: The name of the reference to update to point to the commit.
///   - author: The author signature to use.
///   - committer: The committer signature to use.
///   - messageEncoding: The commit message encoding to use. Pass `nil` to
///   use the original message encoding.
///   - message: The commit message to use.
///   - tree: The ID of the commit tree to use.
///   - parentCB: The ``GitCommitParentCB`` callback to invoke to get the
///   parents of the commit.
///   - parentPayload: The payload to pass to `parentCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The commit message will not be cleaned up automatically. Use
/// ``gitMessagePrettify(out:message:stripComments:commentChar:)`` to clean
/// up the commit message.
///
/// If `updateRef` is not direct, it will be resolved to a direct reference.
/// Pass `HEAD` to update the HEAD of the current branch and make it point to
/// this commit. If the reference does not exist yet, it will be created.
/// If it does exist, the first parent must be the tip of this branch.
///
/// - Important: This function does not validate the given tree ID.
///
/// ## C Equivalent
///
/// [`git_commit_create_from_callback()`](https://libgit2.org/docs/reference/main/sys/commit/git_commit_create_from_callback.html)
public func gitCommitCreateFromCallback(
    id              : inout GitOID,
    repo            : OpaquePointer,
    updateRef       : String?,
    author          : GitSignature,
    committer       : GitSignature,
    messageEncoding : String?,
    message         : String,
    tree            : GitOID,
    parentCB        : GitCommitParentCB,
    parentPayload   : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return try author.withCValue
            {
                cAuthor in
                
                return try committer.withCValue
                {
                    cCommitter in
                    
                    return tree.withCValue
                    {
                        cTree in
                        
                        return git_commit_create_from_callback(
                            cID,
                            repo,
                            updateRef,
                            cAuthor,
                            cCommitter,
                            messageEncoding,
                            message,
                            cTree,
                            parentCB,
                            parentPayload
                        )
                    }
                }
            }
        }
    }
}
