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



/// Gets the repository containing the given patch.
/// - Parameter patch: The patch for which to get the repository. The
/// underlying type must be `git_patch`.
/// - Returns: The repository containing the given patch. The underlying
/// type will be `git_repository`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given patch and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_patch_owner()`](https://libgit2.org/docs/reference/main/patch/git_patch_owner.html)
public func gitPatchOwner(
    patch: OpaquePointer
) -> OpaquePointer
{
    return git_patch_owner(patch)
}



/// Gets the patch for the specified entry in the given diff.
/// - Parameters:
///   - out: The pointer in which to store the patch. The underlying type must
///   be `git_patch`.
///   - diff: The diff to search. The underlying type must be `git_diff`.
///   - idx: The index of the entry in the given diff.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The returned patch can be used to loop over all the hunks and lines in the
/// given diff.
///
/// For an unchanged file or binary file, no patch will be created, the patch
/// pointed to by `out` will be set to `nil`, and the `binary` flag will be
/// set to `true` in the diff delta.
///
/// Either the patch pointed to by `out` or `diff` may be `nil`. If the patch
/// is `nil`, then no text diff will be calculated.
///
/// ## C Equivalent
///
/// [`git_patch_from_diff()`](https://libgit2.org/docs/reference/main/patch/git_patch_from_diff.html)
public func gitPatchFromDiff(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    diff    : OpaquePointer?,
    idx     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_patch_from_diff(
            out,
            diff,
            idx
        )
    }
}



/// Creates a patch from the difference between the given blobs.
/// - Parameters:
///   - out: The pointer in which to store the patch. The underlying type must
///   be `git_patch`.
///   - oldBlob: The blob for the old side of the diff. The underlying type
///   must be `git_blob`.
///   - oldAsPath: The file name to use for `oldBlob`.
///   - newBlob: The blob for the new side of the diff. The underlying type
///   must be `git_blob`.
///   - newAsPath: The file name to use for `newBlob`.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is similar to
/// ``gitDiffBlobs(oldBlob:oldAsPath:newBlob:newAsPath:options:fileCB:binaryCB:hunkCB:lineCB:payload:)``,
/// except this function generates a patch for the diff instead of directly
/// invoking callbacks.
///
/// ## C Equivalent
///
/// [`git_patch_from_blobs()`](https://libgit2.org/docs/reference/main/patch/git_patch_from_blobs.html)
public func gitPatchFromBlobs(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    oldBlob     : OpaquePointer?,
    oldAsPath   : String?,
    newBlob     : OpaquePointer?,
    newAsPath   : String?,
    opts        : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_patch_from_blobs(
                out,
                oldBlob,
                oldAsPath,
                newBlob,
                newAsPath,
                cOpts
            )
        }
    }
}



/// Creates a patch from the difference between the given blob and buffer.
/// - Parameters:
///   - out: The pointer in which to store the patch. The underlying type must
///   be `git_patch`.
///   - oldBlob: The blob for the old side of the diff. The underlying type
///   must be `git_blob`.
///   - oldAsPath: The file name to use for `oldBlob`.
///   - buffer: The raw data for the new side of the diff.
///   - bufferLen: The length of `buffer`.
///   - bufferAsPath: The file name to use for `buffer`.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is similar to
/// ``gitDiffBlobToBuffer(oldBlob:oldAsPath:buffer:bufferLen:bufferAsPath:options:fileCB:binaryCB:hunkCB:lineCB:payload:)``,
/// except this function generates a patch for the diff instead of directly
/// invoking callbacks.
///
/// ## C Equivalent
///
/// [`git_patch_from_blob_and_buffer()`](https://libgit2.org/docs/reference/main/patch/git_patch_from_blob_and_buffer.html)
public func gitPatchFromBlobAndBuffer(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    oldBlob         : OpaquePointer?,
    oldAsPath       : String?,
    buffer          : Data?,
    bufferLen       : Int?,
    bufferAsPath    : String?,
    opts            : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try buffer.withOptionalCBuffer
        {
            cBuffer, cBufferCount in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_patch_from_blob_and_buffer(
                    out,
                    oldBlob,
                    oldAsPath,
                    cBuffer,
                    cBufferCount,
                    bufferAsPath,
                    cOpts
                )
            }
        }
    }
}



/// Creates a patch from the difference between the given buffers.
/// - Parameters:
///   - out: The pointer in which to store the patch. The underlying type must
///   be `git_patch`.
///   - oldBuffer: The raw data for the old side of the diff.
///   - oldBufferLen: The length of `oldBuffer`.
///   - oldAsPath: The file name to use for `oldBuffer`.
///   - newBuffer: The raw data for the new side of the diff.
///   - newBufferLen: The length of `newBuffer`.
///   - newAsPath: The file name to use for `newBuffer`.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is similar to
/// ``gitDiffBuffers(oldBuffer:oldBufferLen:oldBufferAsPath:newBuffer:newBufferLen:newBufferAsPath:options:fileCB:binaryCB:hunkCB:lineCB:payload:)`,
/// except this function generates a patch for the diff instead of directly
/// invoking callbacks.
///
/// ## C Equivalent
///
/// [`git_patch_from_buffers()`](https://libgit2.org/docs/reference/main/patch/git_patch_from_buffers.html)
public func gitPatchFromBuffers(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    oldBuffer       : Data?,
    oldBufferLen    : Int?,
    oldAsPath       : String?,
    newBuffer       : Data?,
    newBufferLen    : Int?,
    newAsPath       : String?,
    opts            : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try oldBuffer.withOptionalCBuffer
        {
            cOldBuffer, cOldBufferCount in
            
            return try newBuffer.withOptionalCBuffer
            {
                cNewBuffer, cNewBufferCount in
                
                return try opts.withOptionalCValue
                {
                    cOpts in
                    
                    return git_patch_from_buffers(
                        out,
                        cOldBuffer,
                        cOldBufferCount,
                        oldAsPath,
                        cNewBuffer,
                        cNewBufferCount,
                        newAsPath,
                        cOpts
                    )
                }
            }
        }
    }
}



/// Frees the memory allocated for the given `git_patch` instance.
/// - Parameter patch: The patch to free. The underlying type must be
/// `git_patch`.
///
/// ## C Equivalent
///
/// [`git_patch_free()`](https://libgit2.org/docs/reference/main/patch/git_patch_free.html)
public func gitPatchFree(
    patch: OpaquePointer?
)
{
    guard let patch: OpaquePointer = patch
    else
    {
        return
    }
    
    git_patch_free(patch)
}



/// Gets the delta of the given patch.
/// - Parameter patch: The patch for which to get the delta. The underlying
/// type must be `git_patch`.
/// - Returns: The delta of the given patch.
///
/// ## C Equivalent
///
/// [`git_patch_get_delta()`](https://libgit2.org/docs/reference/main/patch/git_patch_get_delta.html)
public func gitPatchGetDelta(
    patch: OpaquePointer
) -> GitDiffDelta?
{
    guard let diffDelta: UnsafePointer<git_diff_delta>
            = git_patch_get_delta(patch)
    else
    {
        return nil
    }
    
    return GitDiffDelta(cValue: diffDelta.pointee)
}



/// Gets the number of hunks in the given patch.
/// - Parameter patch: The patch to use. The underlying type must be
/// `git_patch`.
/// - Returns: The number of hunks in the given patch.
///
/// ## C Equivalent
///
/// [`git_patch_num_hunks()`](https://libgit2.org/docs/reference/main/patch/git_patch_num_hunks.html)
public func gitPatchNumHunks(
    patch: OpaquePointer
) -> Int
{
    return git_patch_num_hunks(patch)
}



/// Gets the line counts of the given patch.
/// - Parameters:
///   - totalContext: The pointer in which to store the number of context lines.
///   - totalAdditions: The pointer in which to store the number of addition
///   lines.
///   - totalDeletions: The pointer in which to store the number of deletion
///   lines.
///   - patch: The patch to evaluate. The underlying type must be `git_patch`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is similar to `git diff --numstat`.
///
/// ## C Equivalent
///
/// [`git_patch_line_stats()`](https://libgit2.org/docs/reference/main/patch/git_patch_line_stats.html)
public func gitPatchLineStats(
    totalContext    : UnsafeMutablePointer<Int>?,
    totalAdditions  : UnsafeMutablePointer<Int>?,
    totalDeletions  : UnsafeMutablePointer<Int>?,
    patch           : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_patch_line_stats(
            totalContext,
            totalAdditions,
            totalDeletions,
            patch
        )
    }
}



/// Gets information about the specified hunk in the given patch.
/// - Parameters:
///   - out: The ``GitDiffHunk`` instance in which to store the hunk.
///   - linesInHunk: The pointer in which to store the number of lines in the
///   specified hunk.
///   - patch: The patch to use. The underlying type must be `git_patch`.
///   - hunkIdx: The index of the hunk to retrieve.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_patch_get_hunk()`](https://libgit2.org/docs/reference/main/patch/git_patch_get_hunk.html)
public func gitPatchGetHunk(
    out         : inout GitDiffHunk,
    linesInHunk : UnsafeMutablePointer<Int>?,
    patch       : OpaquePointer,
    hunkIdx     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_patch_get_hunk(
                cOut,
                linesInHunk,
                patch,
                hunkIdx
            )
        }
    }
}



/// Gets the number of lines in the specified hunk.
/// - Parameters:
///   - patch: The patch to use. The underlying type must be `git_patch`.
///   - hunkIdx: The index of the hunk to retrieve.
/// - Returns: The number of lines in the specified hunk, or an error code.
///
/// ## C Equivalent
///
/// [`git_patch_num_lines_in_hunk()`](https://libgit2.org/docs/reference/main/patch/git_patch_num_lines_in_hunk.html)
public func gitPatchNumLinesInHunk(
    patch   : OpaquePointer,
    hunkIdx : Int
) -> Int32
{
    return git_patch_num_lines_in_hunk(
        patch,
        hunkIdx
    )
}



/// Gets information about the specified line in the given patch.
/// - Parameters:
///   - out: The ``GitDiffLine`` instance in which to store the line.
///   - patch: The patch to use. The underlying type must be `git_patch`.
///   - hunkIdx: The index of the hunk to retrieve.
///   - lineOfHunk: The index of the line to retrieve.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_patch_get_line_in_hunk()`](https://libgit2.org/docs/reference/main/patch/git_patch_get_line_in_hunk.html)
public func gitPatchGetLineInHunk(
    out         : inout GitDiffLine,
    patch       : OpaquePointer,
    hunkIdx     : Int,
    lineOfHunk  : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_patch_get_line_in_hunk(
                cOut,
                patch,
                hunkIdx,
                lineOfHunk
            )
        }
    }
}



/// Gets the size, in bytes, of the given patch.
/// - Parameters:
///   - patch: The patch to evaluate. The underlying type must be `git_patch`.
///   - includeContext: Whether to include context lines in the size.
///   - includeHunkHeaders: Whether to include hunk header lines in the size.
///   - includeFileHeaders: Whether to include file header lines in the size.
/// - Returns: The size of the given patch.
///
/// ## C Equivalent
///
/// [`git_patch_size()`](https://libgit2.org/docs/reference/main/patch/git_patch_size.html)
public func gitPatchSize(
    patch               : OpaquePointer,
    includeContext      : Bool,
    includeHunkHeaders  : Bool,
    includeFileHeaders  : Bool
) -> Int
{
    return git_patch_size(
        patch,
        includeContext.int32Value,
        includeHunkHeaders.int32Value,
        includeFileHeaders.int32Value
    )
}



/// Serializes the given patch to text.
/// - Parameters:
///   - patch: The patch to serialize. The underlying type must be `git_patch`.
///   - printCB: The ``GitDiffLineCB`` callback to invoke for each line in
///   the diff.
///   - payload: The payload to pass to `printCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_patch_print()`](https://libgit2.org/docs/reference/main/patch/git_patch_print.html)
public func gitPatchPrint(
    patch   : OpaquePointer,
    printCB : GitDiffLineCB,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_patch_print(
            patch,
            printCB,
            payload
        )
    }
}



/// Gets the diff text content of the given patch.
/// - Parameters:
///   - out: The `Data` instance in which to store the diff text content.
///   - patch: The patch to use. The underlying type must be `git_patch`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_patch_to_buf()`](https://libgit2.org/docs/reference/main/patch/git_patch_to_buf.html)
public func gitPatchToBuf(
    out     : inout Data,
    patch   : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_patch_to_buf(
                cOut,
                patch
            )
        }
    }
}
