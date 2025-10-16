//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// Initializes the given `git_describe_options` instance.
/// - Parameters:
///   - opts: The `git_describe_options` instance to initialize.
///   - version: The version to use. Pass ``gitDescribeOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_describe_options_init()`](https://libgit2.org/docs/reference/main/describe/git_describe_options_init.html)
public func gitDescribeOptionsInit(
    opts    : UnsafeMutablePointer<git_describe_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_describe_options_init(
            opts,
            version
        )
    }
}



/// Initializes the given `git_describe_format_options` instance.
/// - Parameters:
///   - opts: The `git_describe_format_options` instance to initialize.
///   - version: The version to use. Pass ``gitDescribeFormatOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_describe_format_options_init()`](https://libgit2.org/docs/reference/main/describe/git_describe_format_options_init.html)
public func gitDescribeFormatOptionsInit(
    opts    : UnsafeMutablePointer<git_describe_format_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_describe_format_options_init(
            opts,
            version
        )
    }
}



/// Describes the given commit.
/// - Parameters:
///   - result: The pointer in which to store the description. The underlying
///   type must be `git_describe_result`.
///   - committish: The commit to describe. The underlying type must be
///   `git_object`.
///   - opts: The describe options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_describe_commit()`](https://libgit2.org/docs/reference/main/describe/git_describe_commit.html)
public func gitDescribeCommit(
    result      : UnsafeMutablePointer<OpaquePointer?>,
    committish  : OpaquePointer,
    opts        : GitDescribeOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_describe_commit(
                result,
                committish,
                cOpts
            )
        }
    }
}



/// Describes the current commit and worktree.
/// - Parameters:
///   - out: The pointer in which to store the description. The underlying
///   type must be `git_describe_result`.
///   - repo: The repository containing the commit. The underlying type must
///   be `git_repository`.
///   - opts: The describe options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A status check will be run after performing the describe operation on HEAD.
/// The description will be considered dirity if there are any entries.
///
/// ## C Equivalent
///
/// [`git_describe_workdir()`](https://libgit2.org/docs/reference/main/describe/git_describe_workdir.html)
public func gitDescribeWorkdir(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    opts    : GitDescribeOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_describe_workdir(
                out,
                repo,
                cOpts
            )
        }
    }
}



/// Updates the given `Data` instance with the given description.
/// - Parameters:
///   - out: The `Data` instance to update with the description.
///   - result: The description to use. The underlying type must be
///   `git_describe_result`.
///   - opts: The describe format options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_describe_format()`](https://libgit2.org/docs/reference/main/describe/git_describe_format.html)
public func gitDescribeFormat(
    out     : inout Data,
    result  : OpaquePointer,
    opts    : GitDescribeFormatOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_describe_format(
                    cOut,
                    result,
                    cOpts
                )
            }
        }
    }
}



/// Frees the memory allocated for the given `git_describe_result` instance.
/// - Parameter result: The description to free. The underlying type must be
/// `git_describe_result`.
///
/// ## C Equivalent
///
/// [`git_describe_result_free()`](https://libgit2.org/docs/reference/main/describe/git_describe_result_free.html)
public func gitDescribeResultFree(
    result: OpaquePointer?
)
{
    guard let result: OpaquePointer = result
    else
    {
        return
    }
    
    git_describe_result_free(result)
}
