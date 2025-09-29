//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



// TODO: Replace `git_repository_set_head()` in documentation.
/// Updates files in the index and in the working tree to match the contenet of the commit
/// pointed at by HEAD.
/// - Parameters:
///   - repo: The repository to check out. The underlying type should be `git_repository`.
///   This repository may not be bare.
///   - opts: The options for the checkout operation.
/// - Returns: `0` on success, a non-zero value returned by ``GitCheckoutNotifyCB``,
/// or an error code.
///
/// ## Discussion
///
/// This function is not the correct mechanism to switch between branches. Changing HEAD and then
/// calling this function, would cause checkout conflicts since the working directory would then appear
/// to be dirty.
///
/// Instead, checkout the target of the branch and then update HEAD using
/// `git_repository_set_head()` to point to the checked-out branch.
///
/// This function will return `GIT_EUSER` if `opts` was provided, but it
/// could not be converted to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_checkout_head()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_head.html)
public func gitCheckoutHEAD(
    repo    : OpaquePointer,
    opts    : GitCheckoutOptions?
) -> Int32
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_checkout_head(
                repo,
                cOpts
            )
        }
    }
}



/// Updates files in the working tree to match the index.
/// - Parameters:
///   - repo: The repository to check out. The underlying type should be `git_repository`.
///   This repository may not be bare.
///   - index: The index to check out. The underlying type should be `git_index`.
///   Pass `nil` to use the repository index.
///   - opts: The options for the checkout operation.
/// - Returns: `0` on success, a non-zero value returned by ``GitCheckoutNotifyCB``,
/// or an error code.
///
/// ## Discussion
///
/// This function will return `GIT_EUSER` if `opts` was provided, but it
/// could not be converted to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_checkout_index()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_index.html)
public func gitCheckoutIndex(
    repo    : OpaquePointer,
    index   : OpaquePointer?,
    opts    : GitCheckoutOptions?
) -> Int32
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_checkout_index(
                repo,
                index,
                cOpts
            )
        }
    }
}



/// Updates files in the index and working tree to match the content of the tree pointed at by the
/// given tree-ish object.
/// - Parameters:
///   - repo: The repository to check out. The underlying type should be `git_repository`.
///   This repository may not be bare.
///   - treeish: The commit, tag, or tree whose content will be used to update the working
///   directory. The underlying type should be `git_object`. Pass `nil` to use HEAD.
///   - opts: The options for the checkout operation.
/// - Returns: `0` on success, a non-zero value returned by ``GitCheckoutNotifyCB``,
/// or an error code.
///
/// ## Discussion
///
/// This function will return `GIT_EUSER` if `opts` was provided, but it
/// could not be converted to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_checkout_tree()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_tree.html)
public func gitCheckoutTree(
    repo    : OpaquePointer,
    treeish : OpaquePointer?,
    opts    : GitCheckoutOptions?
) -> Int32
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_checkout_tree(
                repo,
                treeish,
                cOpts
            )
        }
    }
}
