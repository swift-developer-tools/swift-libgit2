//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Generates formatted diff text.
/// - Parameters:
///   - delta: The delta to process.
///   - hunk: The diff hunk to process.
///   - line: The diff line to process.
///   - payload: The payload provided by the diff generator.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is provided for documentation purposes, but is not
/// intended to be called directly. Use ``GitDiffLineCB`` instead.
///
/// ## C Equivalent
///
/// [`git_diff_print_callback__to_buf()`](https://libgit2.org/docs/reference/main/sys/diff/git_diff_print_callback__to_buf.html)
public func gitDiffPrintCallbackToBuf(
    delta   : GitDiffDelta,
    hunk    : GitDiffHunk,
    line    : GitDiffLine,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try delta.withCValue
        {
            cDelta in
            
            return try hunk.withCValue
            {
                cHunk in
                
                return try line.withCValue
                {
                    cLine in
                    
                    return git_diff_print_callback__to_buf(
                        cDelta,
                        cHunk,
                        cLine,
                        payload
                    )
                }
            }
        }
    }
}



/// Generates formatted diff text.
/// - Parameters:
///   - delta: The delta to process.
///   - hunk: The diff hunk to process.
///   - line: The diff line to process.
///   - payload: The payload provided by the diff generator.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is provided for documentation purposes, but is not
/// intended to be called directly. Use ``GitDiffLineCB`` instead.
///
/// ## C Equivalent
///
/// [`git_diff_print_callback__to_file_handle()`](https://libgit2.org/docs/reference/main/sys/diff/git_diff_print_callback__to_file_handle.html)
public func gitDiffPrintCallbackToFileHandle(
    delta   : GitDiffDelta,
    hunk    : GitDiffHunk,
    line    : GitDiffLine,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try delta.withCValue
        {
            cDelta in
            
            return try hunk.withCValue
            {
                cHunk in
                
                return try line.withCValue
                {
                    cLine in
                    
                    return git_diff_print_callback__to_file_handle(
                        cDelta,
                        cHunk,
                        cLine,
                        payload
                    )
                }
            }
        }
    }
}



/// Gets the performance data of the given diff.
/// - Parameters:
///   - out: The ``GitDiffPerfData`` in which to store the performance data.
///   - diff: The diff to evaluate. The underlying type must be `git_diff`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_get_perfdata()`](https://libgit2.org/docs/reference/main/sys/diff/git_diff_get_perfdata.html)
public func gitDiffGetPerfData(
    out     : inout GitDiffPerfData,
    diff    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_diff_get_perfdata(
                cOut,
                diff
            )
        }
    }
}



/// Gets the performance data of the diffs in the given status list.
/// - Parameters:
///   - out: The ``GitDiffPerfData`` in which to store the performance data.
///   - status: The status list to evaluate. The underlying type must be
///   `git_status_list`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_status_list_get_perfdata()`](https://libgit2.org/docs/reference/main/sys/diff/git_status_list_get_perfdata.html)
public func gitStatusListGetPerfData(
    out     : inout GitDiffPerfData,
    status  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_status_list_get_perfdata(
                cOut,
                status
            )
        }
    }
}
