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



/// Initializes the given `git_blame_options` instance.
/// - Parameters:
///   - opts: The `git_blame_options` instance to initialize.
///   - version: The version to use. Pass ``gitBlameOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blame_options_init()`](https://libgit2.org/docs/reference/main/blame/git_blame_options_init.html)
public func gitBlameOptionsInit(
    opts    : UnsafeMutablePointer<git_blame_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_blame_options_init(
            opts,
            version
        )
    }
}



/// Gets the number of lines that exist in the given blame.
/// - Parameter blame: The blame to evaluate. The underlying type must be
/// `git_blame`.
/// - Returns: The number of lines that exist in the blame.
///
/// ## C Equivalent
///
/// [`git_blame_linecount()`](https://libgit2.org/docs/reference/main/blame/git_blame_linecount.html)
public func gitBlameLineCount(
    blame: OpaquePointer
) -> Int
{
    return git_blame_linecount(blame)
}



/// Gets the number of hunks that exist in the given blame.
/// - Parameter blame: The blame to evaluate. The underlying type must be
/// `git_blame`.
/// - Returns: The number of hunks that exist in the blame.
///
/// ## C Equivalent
///
/// [`git_blame_hunkcount()`](https://libgit2.org/docs/reference/main/blame/git_blame_hunkcount.html)
public func gitBlameHunkCount(
    blame: OpaquePointer
) -> Int
{
    return git_blame_hunkcount(blame)
}



/// Gets the blame hunk at the given index.
/// - Parameters:
///   - blame: The blame to search. The underlying type must be `git_blame`.
///   - index: The index of the blame hunk to retrieve.
/// - Returns: The blame hunk at the given index.
///
/// ## C Equivalent
///
/// [`git_blame_hunk_byindex()`](https://libgit2.org/docs/reference/main/blame/git_blame_hunk_byindex.html)
public func gitBlameHunkByIndex(
    blame   : OpaquePointer,
    index   : Int
) -> GitBlameHunk?
{
    guard let blameHunk: UnsafePointer<git_blame_hunk>
            = git_blame_hunk_byindex(
                blame,
                index
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(cValue: blameHunk.pointee)
}



/// Gets the blame hunk at the given line number in the newest commit.
/// - Parameters:
///   - blame: The blame to search. The underlying type must be `git_blame`.
///   - lineNo: The 1-indexed line number of the blame hunk to retrieve.
/// - Returns: The blame hunk at the given line number in the newest commit.
///
/// ## C Equivalent
///
/// [`git_blame_hunk_byline()`](https://libgit2.org/docs/reference/main/blame/git_blame_hunk_byline.html)
public func gitBlameHunkByLine(
    blame   : OpaquePointer,
    lineNo  : Int
) -> GitBlameHunk?
{
    guard let blameHunk: UnsafePointer<git_blame_hunk>
            = git_blame_hunk_byline(
                blame,
                lineNo
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(cValue: blameHunk.pointee)
}



/// Gets the blame line at the given index.
/// - Parameters:
///   - blame: The blame to search. The underlying type must be `git_blame`.
///   - idx: The 1-indexed line number of the blame line to retrieve.
/// - Returns: The blame line at the given index.
///
/// ## C Equivalent
///
/// [`git_blame_line_byindex()`](https://libgit2.org/docs/reference/main/blame/git_blame_line_byindex.html)
public func gitBlameLineByIndex(
    blame   : OpaquePointer,
    idx     : Int
) -> GitBlameLine?
{
    guard let blameLine: UnsafePointer<git_blame_line>
            = git_blame_line_byindex(
                blame,
                idx
            )
    else
    {
        return nil
    }
    
    return GitBlameLine(cValue: blameLine.pointee)
}



/// Gets the number of hunks that exist in the given blame.
/// - Parameter blame: The blame to search. The underlying type must be
/// `git_blame`.
/// - Returns: The number of hunks that exist in the blame.
///
/// ## Discussion
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``gitBlameHunkCount(blame:)`` instead.
///
/// ## C Equivalent
///
/// [`git_blame_get_hunk_count()`](https://libgit2.org/docs/reference/main/blame/git_blame_get_hunk_count.html)
public func gitBlameGetHunkCount(
    blame: OpaquePointer
) -> UInt32
{
    return git_blame_get_hunk_count(blame)
}



/// Gets the blame hunk at the given index.
/// - Parameters:
///   - blame: The blame to search. The underlying type must be `git_blame`.
///   - index: The index of the blame hunk to retrieve.
/// - Returns: The blame hunk at the given index.
///
/// ## Discussion
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``gitBlameHunkByIndex(blame:index:)`` instead.
///
/// ## C Equivalent
///
/// [`git_blame_get_hunk_byindex()`](https://libgit2.org/docs/reference/main/blame/git_blame_get_hunk_byindex.html)
public func gitBlameGetHunkByIndex(
    blame   : OpaquePointer,
    index   : UInt32
) -> GitBlameHunk?
{
    guard let blameHunk: UnsafePointer<git_blame_hunk>
            = git_blame_get_hunk_byindex(
                blame,
                index
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(cValue: blameHunk.pointee)
}



/// Gets the blame hunk at the given line number in the newest commit.
/// - Parameters:
///   - blame: The blame to search. The underlying type must be `git_blame`.
///   - lineNo: The 1-indexed line number of the blame hunk to retrieve.
/// - Returns: The blame hunk at the given line number in the newest commit.
///
/// ## Discussion
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``gitBlameHunkByLine(blame:lineNo:)`` instead.
///
/// ## C Equivalent
///
/// [`git_blame_get_hunk_byline()`](https://libgit2.org/docs/reference/main/blame/git_blame_get_hunk_byline.html)
public func gitBlameGetHunkByLine(
    blame   : OpaquePointer,
    lineNo  : Int
) -> GitBlameHunk?
{
    guard let blameHunk: UnsafePointer<git_blame_hunk>
            = git_blame_get_hunk_byline(
                blame,
                lineNo
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(cValue: blameHunk.pointee)
}



/// Gets the blame for the specified file in the given repository.
/// - Parameters:
///   - out: The pointer in which to store the blame. The underlying type must
///   be `git_blame`.
///   - repo: The repository containing the file. The underlying type must be
///   `git_repository`.
///   - path: The path to the file to consider.
///   - options: The blame options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blame_file()`](https://libgit2.org/docs/reference/main/blame/git_blame_file.html)
public func gitBlameFile(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    path    : String,
    options : GitBlameOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_blame_file(
                out,
                repo,
                path,
                cOptions
            )
        }
    }
}



/// Gets the blame data for a file that has been modified in memory.
/// - Parameters:
///   - out: The pointer in which to store the blame. The underlying type must
///   be `git_blame`.
///   - base: The cached blame from the history of the file. The underlying
///   type must be `git_blame`.
///   - buffer: The possibly-modified content of the file.
///   - bufferLen: The length of `buffer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The `base` parameter is a pre-calculated blame for the in-ODB (object
/// database) history of the file. This means that once a file blame is
/// completed (which can be expensive), updating the buffer blame is very fast.
///
/// Lines that differ between `buffer` and the committed version are marked
/// as having a zero ID for their ``GitBlameHunk/finalCommitID``.
///
/// - Note: The cached blame from the history of the file is usually the output
/// from ``gitBlameFile(out:repo:path:options:)``.
///
/// ## C Equivalent
///
/// [`git_blame_buffer()`](https://libgit2.org/docs/reference/main/blame/git_blame_buffer.html)
public func gitBlameBuffer(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    base        : OpaquePointer,
    buffer      : Data,
    bufferLen   : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try buffer.withCString
        {
            cBuffer, cBufferCount in
            
            return git_blame_buffer(
                out,
                base,
                cBuffer,
                cBufferCount
            )
        }
    }
}



/// Frees the memory allocated for the given `git_blame` instance.
/// - Parameter blame: The blame to free. The underlying type must be
/// `git_blame`.
///
/// ## C Equivalent
///
/// [`git_blame_free()`](https://libgit2.org/docs/reference/main/blame/git_blame_free.html)
public func gitBlameFree(
    blame: OpaquePointer?
)
{
    guard let blame: OpaquePointer = blame
    else
    {
        return
    }
    
    git_blame_free(blame)
}
