//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Gets the number of lines that exist in the blame.
/// - Parameter blame: The blame to query. The underlying type should be `git_blame`.
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



/// Gets the number of hunks that exist in the blame.
/// - Parameter blame: The blame to query. The underlying type should be `git_blame`.
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
///   - blame: The blame to query. The underlying type should be `git_blame`.
///   - index: The index of the hunk to retrieve.
/// - Returns: The hunk at the given index, or `nil` on error.
///
/// ## C Equivalent
///
/// [`git_blame_hunk_byindex()`](https://libgit2.org/docs/reference/main/blame/git_blame_hunk_byindex.html)
public func gitBlameHunkByIndex(
    blame   : OpaquePointer,
    index   : Int
) -> GitBlameHunk?
{
    guard let blameHunkPointer: UnsafePointer<git_blame_hunk>
            = git_blame_hunk_byindex(
                blame,
                index
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(blameHunkPointer.pointee)
}



/// Gets the hunk that relates to the given line number in the newest commit.
/// - Parameters:
///   - blame: The blame to query. The underlying type should be `git_blame`.
///   - lineNo: The 1-indexed line number for which to find a hunk.
/// - Returns: The hunk that contains the given line, or `nil` on error.
///
/// ## C Equivalent
///
/// [`git_blame_hunk_byline()`](https://libgit2.org/docs/reference/main/blame/git_blame_hunk_byline.html)
public func gitBlameHunkByLine(
    blame   : OpaquePointer,
    lineNo  : Int
) -> GitBlameHunk?
{
    guard let blameHunkPointer: UnsafePointer<git_blame_hunk>
            = git_blame_hunk_byline(
                blame,
                lineNo
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(blameHunkPointer.pointee)
}



/// Gets the information about the line in the blame.
/// - Parameters:
///   - blame: The blame to query. The underlying type should be `git_blame`.
///   - idx: The 1-indexed line number.
/// - Returns: The blamed line, or `nil` on error.
///
/// ## C Equivalent
///
/// [`git_blame_line_byindex()`](https://libgit2.org/docs/reference/main/blame/git_blame_line_byindex.html)
public func gitBlameLineByIndex(
    blame   : OpaquePointer,
    idx     : Int
) -> GitBlameLine?
{
    guard let blameLinkPointer: UnsafePointer<git_blame_line>
            = git_blame_line_byindex(
                blame,
                idx
            )
    else
    {
        return nil
    }
    
    return GitBlameLine(blameLinkPointer.pointee)
}



/// Gets the number of hunks that exist in the blame.
/// - Parameter blame: The blame to query. The underlying type should be `git_blame`.
/// - Returns: The number of hunks that exist in the blame.
///
/// ## Discussion
///
/// This function is deprecated in libgit2.
/// Use ``gitBlameHunkCount(blame:)`` instead.
///
/// ## C Equivalent
///
/// [`git_blame_get_hunk_count()`](https://libgit2.org/docs/reference/main/blame/git_blame_get_hunk_count.html)
public func gitBlameGetHunkCount(
    blame: OpaquePointer
) -> Int
{
    return Int(git_blame_get_hunk_count(blame))
}



/// Gets the blame hunk at the given index.
/// - Parameters:
///   - blame: The blame to query. The underlying type should be `git_blame`.
///   - index: The index of the hunk to retrieve.
/// - Returns: The hunk at the given index, or `nil` on error.
///
/// ## Discussion
///
/// This function is deprecated in libgit2.
/// Use ``gitBlameHunkByIndex(blame:index:)`` instead.
///
/// ## C Equivalent
///
/// [`git_blame_get_hunk_byindex()`](https://libgit2.org/docs/reference/main/blame/git_blame_get_hunk_byindex.html)
public func gitBlameGetHunkByIndex(
    blame   : OpaquePointer,
    index   : UInt32
) -> GitBlameHunk?
{
    guard let blameHunkPointer: UnsafePointer<git_blame_hunk>
            = git_blame_get_hunk_byindex(
                blame,
                index
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(blameHunkPointer.pointee)
}



/// Gets the hunk that relates to the given line number in the newest commit.
/// - Parameters:
///   - blame: The blame to query. The underlying type should be `git_blame`.
///   - lineNo: The 1-indexed line number for which to find a hunk.
/// - Returns: The hunk that contains the given line, or `nil` on error.
///
/// ## Discussion
///
/// This function is deprecated in libgit2.
/// Use ``gitBlameHunkByLine(blame:lineNo:)`` instead.
///
/// ## C Equivalent
///
/// [`git_blame_get_hunk_byline()`](https://libgit2.org/docs/reference/main/blame/git_blame_get_hunk_byline.html)
public func gitBlameGetHunkByLine(
    blame   : OpaquePointer,
    lineNo  : Int
) -> GitBlameHunk?
{
    guard let blameHunkPointer: UnsafePointer<git_blame_hunk>
            = git_blame_get_hunk_byline(
                blame,
                lineNo
            )
    else
    {
        return nil
    }
    
    return GitBlameHunk(blameHunkPointer.pointee)
}



/// Gets the blame for a single file in the repository.
/// - Parameters:
///   - out: The pointer that should receive the blame object. The underlying type should be
///   `git_blame`.
///   - repo: The repository whose history should be walked. The underlying type should be
///   `git_repository`.
///   - path: The path to the file to consider.
///   - options: The options for the blame process.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blame_file()`](https://libgit2.org/docs/reference/main/blame/git_blame_file.html)
public func gitBlameFile(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    path    : String,
    options : GitBlameOptions?
) -> Int32
{
    guard let options: GitBlameOptions = options
    else
    {
        return git_blame_file(
            out,
            repo,
            path,
            nil
        )
    }
    
    
    
    do
    {
        return try options.withCStruct
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
    catch
    {
        return Int32(error.code)
    }
}



/// Gets the blame for a single file in the repository, using the given buffer contents as the uncommitted
/// changes of the file (the working directory content).
/// - Parameters:
///   - out: The pointer that should receive the blame object. The underlying type should be
///   `git_blame`.
///   - repo: The repository whose history should be walked. The underlying type should be
///   `git_repository`.
///   - path: The path to the file to consider.
///   - contents: The uncommitted changes.
///   - contentsLen: The length of the changes buffer.
///   - options: The options for the blame process.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blame_file_from_buffer()`](https://libgit2.org/docs/reference/main/blame/git_blame_file_from_buffer.html)
/*public func gitBlameFileFromBuffer(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    path        : String,
    contents    : String,
    contentsLen : Int,
    options     : GitBlameOptions?
) -> Int32
{
    guard let options: GitBlameOptions = options
    else
    {
        return git_blame_file_from_buffer(
            out,
            repo,
            path,
            contents,
            contentsLen,
            nil
        )
    }
    
    
    
    return options.withCStruct
    {
        cOptions in
        
        return git_blame_file_from_buffer(
            out,
            repo,
            path,
            contents,
            contentsLen,
            cOptions
        )
    }
}*/



/// Gets the blame data for a file that has been modified in memory.
/// - Parameters:
///   - out: The pointer that should receive the blame object. The underlying type should be
///   `git_blame`.
///   - base: The cached blame from the history of the file.  The underlying type should be
///   `git_blame`. This is usually the output from
///   ``gitBlameFile(out:repo:path:options:)``.
///   - buffer: The possibly-modified content of the file.
///   - bufferLen: The number of valid bytes in the buffer.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The blame parameter is a pre-calculated blame for the in-`odb` (object database) history of the file.
/// This means that once a file blame is completed (which can be expensive), updating the buffer blame
/// is very fast.
///
/// Lines that differ between the buffer and the committed version are marked as having a zero OID for
/// their ``GitBlameHunk/finalCommitID``.
///
/// ## C Equivalent
///
/// [`git_blame_buffer()`](https://libgit2.org/docs/reference/main/blame/git_blame_buffer.html)
public func gitBlameBuffer(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    base        : OpaquePointer,
    buffer      : String,
    bufferLen   : Int
) -> Int32
{
    return git_blame_buffer(
        out,
        base,
        buffer,
        bufferLen
    )
}



/// Frees the memory allocated for a `git_blame` instance.
/// - Parameter blame: The blame to free. The underlying type should be `git_blame`.
///
/// ## C Equivalent
///
/// [`git_blame_free()`](https://libgit2.org/docs/reference/main/blame/git_blame_free.html)
public func gitBlameFree(
    blame: OpaquePointer?
)
{
    return git_blame_free(blame)
}
