//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_cherrypick_options` instance.
/// - Parameters:
///   - opts: The `git_cherrypick_options` instance to initialize.
///   - version: The version to use. Pass ``gitCherrypickOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is only needed when working directly with
/// `git_cherrypick_options` instances. ``GitCherrypickOptions`` instances do
/// not need to be initialized this way.
///
/// ## C Equivalent
///
/// [`git_cherrypick_options_init()`](https://libgit2.org/docs/reference/main/cherrypick/git_cherrypick_options_init.html)
public func gitCherrypickOptionsInit(
    opts    : UnsafeMutablePointer<git_cherrypick_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_cherrypick_options_init(
            opts,
            version
        )
    }
}



/// Cherry-picks the given commit against the given "our" commit, and produces
/// an index that reflects the result of the cherry-pick operation.
/// - Parameters:
///   - out: The pointer in which to store the index. The underlying type must
///   be `git_index`.
///   - repo: The repository containing the given commits. The underlying type
///   must be `git_repository`.
///   - cherrypickCommit: The commit to cherry-pick.
///   - ourCommit: The commit against which to cherry-pick (for example, HEAD).
///   - mainline: The parent of the commit to cherry-pick, if it is a merge.
///   - mergeOptions: The merge options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_cherrypick_commit()`](https://libgit2.org/docs/reference/main/cherrypick/git_cherrypick_commit.html)
public func gitCherrypickCommit(
    out                 : UnsafeMutablePointer<OpaquePointer?>,
    repo                : OpaquePointer,
    cherrypickCommit    : OpaquePointer,
    ourCommit           : OpaquePointer,
    mainline            : UInt32,
    mergeOptions        : GitMergeOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try mergeOptions.withOptionalCValue
        {
            cMergeOptions in
            
            return git_cherrypick_commit(
                out,
                repo,
                cherrypickCommit,
                ourCommit,
                mainline,
                cMergeOptions
            )
        }
    }
}



/// Cherry-picks the given commit, and produces changes in the index and
/// working directory.
/// - Parameters:
///   - repo: The repository containing the given commit. The underlying type
///   must be `git_repository`.
///   - commit: The commit to cherry-pick.
///   - cherrypickOptions: The cherry-pick options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_cherrypick()`](https://libgit2.org/docs/reference/main/cherrypick/git_cherrypick.html)
public func gitCherrypick(
    repo                : OpaquePointer,
    commit              : OpaquePointer,
    cherrypickOptions   : GitCherrypickOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try cherrypickOptions.withOptionalCValue
        {
            cCherrypickOptions in
            
            return git_cherrypick(
                repo,
                commit,
                cCherrypickOptions
            )
        }
    }
}
