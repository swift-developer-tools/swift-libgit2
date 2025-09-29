//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



// TODO: Replace `git_index_free()` in documentation.
/// Cherry-picks the given commit against the given "our" commit, and produces an index that reflects
/// the result of the cherry-pick operation.
/// - Parameters:
///   - out: The pointer in which to store the resulting index. The underlying type should be
///   `git_index`.
///   - repo: The repository containing the given commits. The underlying type should be
///   `git_repository`.
///   - cherrypickCommit: The commit to cherry-pick.
///   - ourCommit: The commit against which to cherry-pick (for example, HEAD).
///   - mainline: The parent of the commit to cherry-pick, if it is a merge.
///   - mergeOptions: The options to use for the merge operation.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The returned index should be freed with `git_index_free()`.
///
/// This function will return `GIT_EUSER` if `mergeOptions` was provided, but it
/// could not be converted to the equivalent C value.
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
) -> Int32
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



/// Cherry-picks the given commit, and produces changes in the index and working directory.
/// - Parameters:
///   - repo: The repository containing the given commit. The underlying type should be
///   `git_repository`.
///   - commit: The commit to cherry-pick.
///   - cherrypickOptions: The options to use for the cherry-pick operation.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will return `GIT_EUSER` if `cherrypickOptions` was provided, but it
/// could not be converted to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_cherrypick()`](https://libgit2.org/docs/reference/main/cherrypick/git_cherrypick.html)
public func gitCherrypick(
    repo                : OpaquePointer,
    commit              : OpaquePointer,
    cherrypickOptions   : GitCherrypickOptions?
) -> Int32
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
