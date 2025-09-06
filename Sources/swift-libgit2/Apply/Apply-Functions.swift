//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Apply a `git_diff` to a `git_tree`, and return the resulting image as an index.
/// - Parameters:
///   - out: The postimage of the application.
///   - repo: The repository to apply.
///   - preimage: The tree to apply the diff to.
///   - diff: The diff to apply.
///   - options: The options for the apply.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_apply_to_tree()`](https://libgit2.org/docs/reference/main/apply/git_apply_to_tree.html)
public func gitApplyToTree(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    preimage    : OpaquePointer,
    diff        : OpaquePointer,
    options     : GitApplyOptions
) -> Int32
{
    return options.withCStruct
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



/// Apply a `git_diff` to the given repository, making changes directly in the working directory, the index,
/// or both.
/// - Parameters:
///   - repo: The repository to apply to.
///   - diff: The diff to apply.
///   - location: The location to apply (the working directory, the index, or both).
///   - options: The options for the apply.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_apply()`](https://libgit2.org/docs/reference/main/apply/git_apply.html)
public func gitApply(
    repo        : OpaquePointer,
    diff        : OpaquePointer,
    location    : GitApplyLocationT,
    options     : GitApplyOptions
) -> Int32
{
    return options.withCStruct
    {
        cOptions in
        
        return git_apply(
            repo,
            diff,
            git_apply_location_t(rawValue: location.rawValue),
            cOptions
        )
    }
}
