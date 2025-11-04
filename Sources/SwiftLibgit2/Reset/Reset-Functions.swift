//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Sets the HEAD of the given repository to the specified commit, and
/// optionally resets the index and worktree to match.
///
/// If the given committish object is a tag, it must be deferenceable to a
/// commit.
///
/// If `checkoutOpts` is provided for a hard reset, the
/// ``GitCheckoutOptions/checkoutStrategy`` property will be overriden by
/// `resetType`.
///
/// - Parameters:
///   - repo: The repository to reset. The underlying type must be
///   `git_repository`.
///   - target: The committish object to which HEAD should move. The underlying
///   type must be either `git_commit` or `git_tag`. This must belong to the
///   given repository.
///   - resetType: The type of reset to perform.
///   - checkoutOpts: The checkout options to use for a hard reset.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reset()`](https://libgit2.org/docs/reference/main/reset/git_reset.html)
public func gitReset(
    repo            : OpaquePointer,
    target          : OpaquePointer,
    resetType       : GitResetT,
    checkoutOpts    : GitCheckoutOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try checkoutOpts.withOptionalCValue
        {
            cCheckoutOpts in
            
            return git_reset(
                repo,
                target,
                resetType.cValue(),
                cCheckoutOpts
            )
        }
    }
}



/// Sets the HEAD of the given repository to the given annotated commit, and
/// optionally resets the index and worktree to match.
///
/// If `checkoutOpts` is provided for a hard reset, the
/// ``GitCheckoutOptions/checkoutStrategy`` property will be overriden by
/// `resetType`.
///
/// This function behaves like
/// ``gitReset(repo:target:resetType:checkoutOpts:)``, but takes an
/// annotated commit. This enables more exact reflog messages by being able to
/// specify the extended SHA syntax string which was specified by a user.
///
/// - Parameters:
///   - repo: The repository to reset. The underlying type must be
///   `git_repository`.
///   - target: The annotated commit to which HEAD should move. The underlying
///   type must be `git_annotated_commit`. This must belong to the given
///   repository.
///   - resetType: The type of reset to perform.
///   - checkoutOpts: The checkout options to use for a hard reset.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reset_from_annotated()`](https://libgit2.org/docs/reference/main/reset/git_reset_from_annotated.html)
public func gitResetFromAnnotated(
    repo            : OpaquePointer,
    target          : OpaquePointer,
    resetType       : GitResetT,
    checkoutOpts    : GitCheckoutOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try checkoutOpts.withOptionalCValue
        {
            cCheckoutOpts in
            
            return git_reset_from_annotated(
                repo,
                target,
                resetType.cValue(),
                cCheckoutOpts
            )
        }
    }
}



/// Updates some entries in the index of the given repository, from the
/// specified commit tree.
///
/// The scope of the updated entries will be determined by the given pathspecs.
/// If the given committish object is `nil`, entries in the index matching the
/// provided pathspecs will be removed.
///
/// - Parameters:
///   - repo: The repository to reset. The underlying type must be
///   `git_repository`.
///   - target: The committish object to use to reset the index. The underlying
///   type must be either `git_commit` or `git_tag`. This must belong to the
///   given repository.
///   - pathspecs: The pathspecs to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reset_default()`](https://libgit2.org/docs/reference/main/reset/git_reset_default.html)
public func gitResetDefault(
    repo        : OpaquePointer,
    target      : OpaquePointer?,
    pathspecs   : [String]
) -> GitErrorCode
{
    return withCConversion
    {
        return try pathspecs.withGitStrArray
        {
            cPathspecs in
            
            return git_reset_default(
                repo,
                target,
                cPathspecs
            )
        }
    }
}
