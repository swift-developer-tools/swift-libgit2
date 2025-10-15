//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_checkout_options` instance.
/// - Parameters:
///   - opts: The `git_checkout_options` instance to initialize.
///   - version: The version to use. Pass ``gitCheckoutOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_checkout_options_init()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_options_init.html)
public func gitCheckoutOptionsInit(
    opts    : UnsafeMutablePointer<git_checkout_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_checkout_options_init(
            opts,
            version
        )
    }
}



// TODO: Replace `git_repository_set_head()` in documentation.
/// Updates files in the index and in the working tree to match the conent of
/// the commit pointed at by HEAD.
/// - Parameters:
///   - repo: The repository to check out. The underlying type must be
///   `git_repository`. This repository may not be bare.
///   - opts: The checkout options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is not the correct mechanism to switch between branches.
/// Changing HEAD and then calling this function, would cause checkout
/// conflicts since the working directory would then appear to be dirty.
///
/// Instead, checkout the target of the branch and then update HEAD using
/// `git_repository_set_head()` to point to the checked-out branch.
///
/// ## C Equivalent
///
/// [`git_checkout_head()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_head.html)
public func gitCheckoutHEAD(
    repo    : OpaquePointer,
    opts    : GitCheckoutOptions?
) -> GitErrorCode
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
///   - repo: The repository to check out. The underlying type must be
///   `git_repository`. This repository may not be bare.
///   - index: The index to check out. The underlying type must be `git_index`.
///   Pass `nil` to use the repository index.
///   - opts: The checkout options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_checkout_index()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_index.html)
public func gitCheckoutIndex(
    repo    : OpaquePointer,
    index   : OpaquePointer?,
    opts    : GitCheckoutOptions?
) -> GitErrorCode
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



/// Updates files in the index and working tree to match the content of the
/// tree pointed at by the given tree-ish object.
/// - Parameters:
///   - repo: The repository to check out. The underlying type must be
///   `git_repository`. This repository may not be bare.
///   - treeish: The commit, tag, or tree to use to update the working
///   directory. The underlying type must be `git_object`. Pass `nil` to use
///   HEAD.
///   - opts: The checkout options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_checkout_tree()`](https://libgit2.org/docs/reference/main/checkout/git_checkout_tree.html)
public func gitCheckoutTree(
    repo    : OpaquePointer,
    treeish : OpaquePointer?,
    opts    : GitCheckoutOptions?
) -> GitErrorCode
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
