//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_revert_options` instance.
/// - Parameters:
///   - opts: The `git_revert_options` instance to initialize.
///   - version: The version to use. Pass ``gitRevertOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revert_options_init()`](https://libgit2.org/docs/reference/main/revert/git_revert_options_init.html)
public func gitRevertOptionsInit(
    opts    : UnsafeMutablePointer<git_revert_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revert_options_init(
            opts,
            version
        )
    }
}



/// Reverts the given commit against the given "our" commit, and produces an
/// index reflecting the result of the revert operation.
/// - Parameters:
///   - out: The pointer in which to store the index. The underlying type must
///   be `git_index`.
///   - repo: The repository containing the given commits. The underlying type
///   must be `git_repository`.
///   - revertCommit: The commit to revert. The underlying type must be
///   `git_commit`.
///   - ourCommit: The commit against which to revert. The underlying type must
///   be `git_commit`.
///   - mainline: The parent of the commit to revert, if it is a merge commit.
///   - mergeOptions: The merge options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revert_commit()`](https://libgit2.org/docs/reference/main/revert/git_revert_commit.html)
public func gitRevertCommit(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    repo            : OpaquePointer,
    revertCommit    : OpaquePointer,
    ourCommit       : OpaquePointer,
    mainline        : UInt32,
    mergeOptions    : GitMergeOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try mergeOptions.withOptionalCValue
        {
            cMergeOptions in
            
            return git_revert_commit(
                out,
                repo,
                revertCommit,
                ourCommit,
                mainline,
                cMergeOptions
            )
        }
    }
}



/// Reverts the given commit, and produces changes in the index and working
/// directory of the given repository.
/// - Parameters:
///   - repo: The repository containing the given commit. The underlying type
///   must be `git_repository`.
///   - commit: The commit to revert. The underlying type must be `git_commit`.
///   - givenOpts: The revert options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revert()`](https://libgit2.org/docs/reference/main/revert/git_revert.html)
public func gitRevert(
    repo        : OpaquePointer,
    commit      : OpaquePointer,
    givenOpts   : GitRevertOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try givenOpts.withOptionalCValue
        {
            cGivenOpts in
            
            return git_revert(
                repo,
                commit,
                cGivenOpts
            )
        }
    }
}
