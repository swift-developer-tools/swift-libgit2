//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_apply_options` instance.
/// - Parameters:
///   - opts: The `git_apply_options` instance to initialize.
///   - version: The version to use. Pass ``gitApplyOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is only needed when working directly with `git_apply_options` instances.
/// ``GitApplyOptions`` instances do not need to be initialized this way.
///
/// ## C Equivalent
///
/// [`git_apply_options_init()`](https://libgit2.org/docs/reference/main/apply/git_apply_options_init.html)
public func gitApplyOptionsInit(
    opts    : UnsafeMutablePointer<git_apply_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_apply_options_init(
            opts,
            version
        )
    }
}



/// Applies a diff to a tree, and returns the resulting image as an index.
/// - Parameters:
///   - out: The pointer in which to store the postimage of the application. The underlying
///   type must be `git_index`.
///   - repo: The repository to apply. The underlying type must be `git_repository`.
///   - preimage: The tree to which the diff should be applied. The underlying type must be
///   `git_tree`.
///   - diff: The diff to apply. The underlying type must be `git_diff`.
///   - options: The options for the apply operation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_apply_to_tree()`](https://libgit2.org/docs/reference/main/apply/git_apply_to_tree.html)
public func gitApplyToTree(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    preimage    : OpaquePointer,
    diff        : OpaquePointer,
    options     : GitApplyOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_apply_to_tree(
                out,
                repo,
                preimage,
                diff,
                cOptions
            )
        }
    }
}



/// Applies a diff to the given repository, making changes directly in the working directory,
/// the index, or both.
/// - Parameters:
///   - repo: The repository to which the diff should be applied. The underlying type must be
///   `git_repository`.
///   - diff: The diff to apply. The underlying type must be `git_diff`.
///   - location: The location to apply (the working directory, the index, or both).
///   - options: The options for the apply operation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_apply()`](https://libgit2.org/docs/reference/main/apply/git_apply.html)
public func gitApply(
    repo        : OpaquePointer,
    diff        : OpaquePointer,
    location    : GitApplyLocationT,
    options     : GitApplyOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_apply(
                repo,
                diff,
                location.cValue(),
                cOptions
            )
        }
    }
}
