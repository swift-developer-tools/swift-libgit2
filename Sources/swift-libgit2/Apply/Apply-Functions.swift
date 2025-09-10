//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Applies a diff to a tree, and returns the resulting image as an index.
/// - Parameters:
///   - out: The postimage of the application.The underlying type should be `git_index`.
///   - repo: The repository to apply. The underlying type should be `git_repository`.
///   - preimage: The tree to which the diff should be applied. The underlying type should be
///   `git_tree`.
///   - diff: The diff to apply. The underlying type should be `git_diff`.
///   - options: The options for the apply.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_apply_to_tree()`](https://libgit2.org/docs/reference/main/apply/git_apply_to_tree.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitApplyToTree(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    preimage    : OpaquePointer,
    diff        : OpaquePointer,
    options     : GitApplyOptions?
) -> Int32
{
    guard let options: GitApplyOptions = options
    else
    {
        return git_apply_to_tree(
            out,
            repo,
            preimage,
            diff,
            nil
        )
    }
    
    
    
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



/// Applies a diff to the given repository, making changes directly in the working directory,
/// the index, or both.
/// - Parameters:
///   - repo: The repository to which the diff should be applied. The underlying type should be
///   `git_repository`.
///   - diff: The diff to apply. The underlying type should be `git_diff`.
///   - location: The location to apply (the working directory, the index, or both).
///   - options: The options for the apply.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_apply()`](https://libgit2.org/docs/reference/main/apply/git_apply.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitApply(
    repo        : OpaquePointer,
    diff        : OpaquePointer,
    location    : GitApplyLocationT,
    options     : GitApplyOptions?
) -> Int32
{
    guard let options: GitApplyOptions = options
    else
    {
        return git_apply(
            repo,
            diff,
            git_apply_location_t(rawValue: location.rawValue),
            nil
        )
    }
    
    
            
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
