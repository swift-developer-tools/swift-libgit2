//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Describes the given commit.
/// - Parameters:
///   - result: The pointer in which to store the resulting description. The underlying type
///   should be `git_describe_result`.
///   - committish: The commit to describe. The underlying type should be `git_object`.
///   - opts: The options for describing the commit.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will return `GIT_EUSER` if `opts` was provided, but it
/// could not be converted to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_describe_commit()`](https://libgit2.org/docs/reference/main/describe/git_describe_commit.html)
public func gitDescribeCommit(
    result      : UnsafeMutablePointer<OpaquePointer?>,
    committish  : OpaquePointer,
    opts        : GitDescribeOptions?
) -> Int32
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
///   - out: The pointer in which to store the resulting description. The underlying type
///   should be `git_describe_result`.
///   - repo: The repository in which the commit exists. The underlying type should be
///   `git_repository`.
///   - opts: The options for describing the commit.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// A status check will be run after performing the describe operation on HEAD. The description will be
/// considered dirity if there are any entries.
///
/// This function will return `GIT_EUSER` if `opts` was provided, but it
/// could not be converted to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_describe_workdir()`](https://libgit2.org/docs/reference/main/describe/git_describe_workdir.html)
public func gitDescribeWorkdir(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    opts    : GitDescribeOptions?
) -> Int32
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



/// Writes the given commit description to a buffer.
/// - Parameters:
///   - out: The buffer into which the description should be written.
///   - result: The commit description. The underlying type should be `git_describe_result`.
///   - opts: The options for formatting the commit description.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function will return `GIT_EUSER` if `opts` was provided, but it
/// could not be converted to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_describe_format()`](https://libgit2.org/docs/reference/main/describe/git_describe_format.html)
public func gitDescribeFormat(
    out     : inout GitBuf,
    result  : OpaquePointer,
    opts    : GitDescribeFormatOptions?
) -> Int32
{
    return withCConversion
    {
        return try out.withMutatingCValue
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



/// Frees the memory allocated for a `git_describe_result`.
/// - Parameter result: The description to free. The underlying type should be
/// `git_describe_result`.
///
/// ## C Equivalent
///
/// [`git_describe_result_free()`](https://libgit2.org/docs/reference/main/describe/git_describe_result_free.html)
public func gitDescribeResultFree(
    result: OpaquePointer?
)
{
    git_describe_result_free(result)
}
