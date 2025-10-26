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



/// Initializes the given `git_diff_options` instance.
/// - Parameters:
///   - opts: The `git_diff_options` instance to initialize.
///   - version: The version to use. Pass ``gitDiffOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_options_init()`](https://libgit2.org/docs/reference/main/diff/git_diff_options_init.html)
public func gitDiffOptionsInit(
    opts    : UnsafeMutablePointer<git_diff_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_diff_options_init(
            opts,
            version
        )
    }
}



/// Initializes the given `git_diff_find_options` instance.
/// - Parameters:
///   - opts: The `git_diff_find_options` instance to initialize.
///   - version: The version to use. Pass ``gitDiffFindOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_find_options_init()`](https://libgit2.org/docs/reference/main/diff/git_diff_find_options_init.html)
public func gitDiffFindOptionsInit(
    opts    : UnsafeMutablePointer<git_diff_find_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_diff_find_options_init(
            opts,
            version
        )
    }
}



/// Frees the memory allocated for the given `git_diff` instance.
/// - Parameter diff: The diff to free. The underlying type must be `git_diff`.
///
/// ## C Equivalent
///
/// [`git_diff_free()`](https://libgit2.org/docs/reference/main/diff/git_diff_free.html)
public func gitDiffFree(
    diff: OpaquePointer?
)
{
    guard let diff: OpaquePointer = diff
    else
    {
        return
    }
    
    git_diff_free(diff)
}



/// Creates a diff with the difference between the given trees.
/// - Parameters:
///   - diff: The pointer in which to store the diff. The underlying type must
///   be `git_diff`.
///   - repo: The repository containing the given trees. The underlying type
///   must be `git_repository`.
///   - oldTree: The old tree to use in the diff operation. The underlying type
///   must be `git_tree`.
///   - newTree: The new tree to use in the diff operation. The underlying type
///   must be `git_tree`.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is equivalent to `git diff <old-tree> <new-tree>`.
///
/// Either `oldTree` or `newTree` may be `nil`, but both may not be `nil`.
///
/// ## C Equivalent
///
/// [`git_diff_tree_to_tree()`](https://libgit2.org/docs/reference/main/diff/git_diff_tree_to_tree.html)
public func gitDiffTreeToTree(
    diff    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    oldTree : OpaquePointer?,
    newTree : OpaquePointer?,
    opts    : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_diff_tree_to_tree(
                diff,
                repo,
                oldTree,
                newTree,
                cOpts
            )
        }
    }
}



/// Creates a diff between the given tree and index.
/// - Parameters:
///   - diff: The pointer in which to store the diff. The underlying type must
///   be `git_diff`.
///   - repo: The repository containing the given tree and index. The
///   underlying type must be `git_repository`.
///   - oldTree: The old tree to use in the diff operation. The underlying type
///   must be `git_tree`.
///   - index: The index to use in the diff operation. The underlying type must
///   be `git_index`. Pass `nil` to use the repository index.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is equivalent to `git diff --cached <treeish>` or `git diff --cached`
/// if the HEAD tree is used.
///
/// If `index` is `nil`, the repository index will be used. If the index has
/// changed, it willl be refreshed from the disk before the diff is generated.
///
/// ## C Equivalent
///
/// [`git_diff_tree_to_index()`](https://libgit2.org/docs/reference/main/diff/git_diff_tree_to_index.html)
public func gitDiffTreeToIndex(
    diff    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    oldTree : OpaquePointer?,
    index   : OpaquePointer?,
    opts    : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_diff_tree_to_index(
                diff,
                repo,
                oldTree,
                index,
                cOpts
            )
        }
    }
}



/// Creates a diff between the given index and the working directory.
/// - Parameters:
///   - diff: The pointer in which to store the diff. The underlying type must
///   be `git_diff`.
///   - repo: The repository containing the given index and the working
///   directory. The underlying type must be `git_repository`.
///   - index: The index to use in the diff operation. The underlying type must
///   be `git_index`. Pass `nil` to use the repository index.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is equivalent to `git diff`.
///
/// If `index` is `nil`, the repository index will be used. If the index has
/// changed, it willl be refreshed from the disk before the diff is generated.
///
/// ## C Equivalent
///
/// [`git_diff_index_to_workdir()`](https://libgit2.org/docs/reference/main/diff/git_diff_index_to_workdir.html)
public func gitDiffIndexToWorkdir(
    diff    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    index   : OpaquePointer?,
    opts    : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_diff_index_to_workdir(
                diff,
                repo,
                index,
                cOpts
            )
        }
    }
}



/// Creates a diff between the given tree and the working directory.
/// - Parameters:
///   - diff: The pointer in which to store the diff. The underlying type must
///   be `git_diff`.
///   - repo: The repository containing the given tree. The underlying type
///   must be `git_repository`.
///   - oldTree: The old tree to use in the diff operation. The underlying type
///   must be `git_tree`.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is not equivalent to `git diff <treeish>` or
/// `git diff-index <treeish>`. Those commands use information from the index,
/// whereas this function strictly returns the differences between the tree and
/// the files in the working directory, regardless of the state of the index.
///
/// To understand the difference between this function and
/// ``gitDiffTreeToWorkdirWithIndex(diff:repo:oldTree:opts:)``, consider the
/// example of a staged file deletion where the file has then been put back
/// into the working directory and further modified. The
/// tree-to-working-directory diff for that file would show `modified`,
/// but `git diff` would show `deleted`, since there was a staged delete.
///
/// ## C Equivalent
///
/// [`git_diff_tree_to_workdir()`](https://libgit2.org/docs/reference/main/diff/git_diff_tree_to_workdir.html)
public func gitDiffTreeToWorkdir(
    diff    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    oldTree : OpaquePointer?,
    opts    : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_diff_tree_to_workdir(
                diff,
                repo,
                oldTree,
                cOpts
            )
        }
    }
}



/// Creates a diff between the given tree and the working directory, using
/// index data to account for staged deletes, tracked files, and other changes.
/// - Parameters:
///   - diff: The pointer in which to store the diff. The underlying type must
///   be `git_diff`.
///   - repo: The repository containing the given tree. The underlying type
///   must be `git_repository`.
///   - oldTree: The old tree to use in the diff operation. The underlying type
///   must be `git_tree`.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This emulates `git diff <tree>` by diffing the tree to the index and the
/// index to the working directory, and blending the results into a single
/// diff that includes staged deletes, tracked files, and other changes.
///
/// ## C Equivalent
///
/// [`git_diff_tree_to_workdir_with_index()`](https://libgit2.org/docs/reference/main/diff/git_diff_tree_to_workdir_with_index.html)
public func gitDiffTreeToWorkdirWithIndex(
    diff    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    oldTree : OpaquePointer?,
    opts    : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_diff_tree_to_workdir_with_index(
                diff,
                repo,
                oldTree,
                cOpts
            )
        }
    }
}



/// Creates a diff between the given indices.
/// - Parameters:
///   - diff: The pointer in which to store the diff. The underlying type must
///   be `git_diff`.
///   - repo: The repository containing the given indices. The underlying type
///   must be `git_repository`.
///   - oldIndex: The old index to use in the diff operation. The underlying
///   type must be `git_index`.
///   - newIndex: The new index to use in the diff operation. The underlying
///   type must be `git_index`.
///   - opts: The diff options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_index_to_index()`](https://libgit2.org/docs/reference/main/diff/git_diff_index_to_index.html)
public func gitDiffIndexToIndex(
    diff        : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    oldIndex    : OpaquePointer,
    newIndex    : OpaquePointer,
    opts        : GitDiffOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_diff_index_to_index(
                diff,
                repo,
                oldIndex,
                newIndex,
                cOpts
            )
        }
    }
}



/// Merges one diff into another.
/// - Parameters:
///   - onto: The diff to merge into. The underlying type must be `git_diff`.
///   - from: The diff to merge. The underlying type must be `git_diff`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting diff will contain all items that appear in either list.
/// If an item appears in both lists, then it will be "merged" to appear as
/// if the old version was from the `onto` list and the new version is from
/// the `from` list (with the exception that if the item has a pending delete
/// in the middle, then it will show as deleted).
///
/// ## C Equivalent
///
/// [`git_diff_merge()`](https://libgit2.org/docs/reference/main/diff/git_diff_merge.html)
public func gitDiffMerge(
    onto    : OpaquePointer,
    from    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_diff_merge(
            onto,
            from
        )
    }
}



/// Transforms a diff, marking file renames or copies, and breaking modified
/// files into add/remove pairs if requested.
/// - Parameters:
///   - diff: The diff to transform. The underlying type must be `git_diff`.
///   - options: The diff rename and copy detection options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_find_similar()`](https://libgit2.org/docs/reference/main/diff/git_diff_find_similar.html)
public func gitDiffFindSimilar(
    diff    : OpaquePointer,
    options : GitDiffFindOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        guard let options: GitDiffFindOptions = options
        else
        {
            return git_diff_find_similar(
                diff,
                nil
            )
        }
        
        var cOptions: git_diff_find_options = try options.cValue()
        
        return git_diff_find_similar(
            diff,
            &cOptions
        )
    }
}



/// Gets the number of diff records in the given diff.
/// - Parameter diff: The diff to query. The underlying type must be `git_diff`.
/// - Returns: The number of diff records in the given diff.
///
/// ## C Equivalent
///
/// [`git_diff_num_deltas()`](https://libgit2.org/docs/reference/main/diff/git_diff_num_deltas.html)
public func gitDiffNumDeltas(
    diff: OpaquePointer
) -> Int
{
    return git_diff_num_deltas(diff)
}



/// Gets the number of diff records of the given type in the given diff.
/// - Parameters:
///   - diff: The diff to query. The underlying type must be `git_diff`.
///   - type: The type of change for which to get the number of diff records.
/// - Returns: The number of diff records of the given type in the given diff.
///
/// ## C Equivalent
///
/// [`git_diff_num_deltas_of_type()`](https://libgit2.org/docs/reference/main/diff/git_diff_num_deltas_of_type.html)
public func gitDiffNumDeltasOfType(
    diff    : OpaquePointer,
    type    : GitDeltaT
) -> Int
{
    return git_diff_num_deltas_of_type(
        diff,
        type.cValue()
    )
}



/// Gets the diff delta for the specified entry in the given diff.
/// - Parameters:
///   - diff: The diff to query. The underlying type must be `git_diff`.
///   - idx: The index of the entry in the given diff.
/// - Returns: The diff delta for the specified entry in the given diff.
///
/// ## Discussion
///
/// The flags on the delta related to whether it has binary content may not
/// be set if there are no attributes set for the file, and there has been no
/// reason to load the file data up until this pointer.
///
/// If those flags need to be up to date, use either
/// ``gitDiffForEach(diff:fileCB:binaryCB:hunkCB:lineCB:payload:)``, or create
/// a `git_patch`.
///
/// ## C Equivalent
///
/// [`git_diff_get_delta()`](https://libgit2.org/docs/reference/main/diff/git_diff_get_delta.html)
public func gitDiffGetDelta(
    diff    : OpaquePointer,
    idx     : Int
) -> GitDiffDelta?
{
    guard let diffDelta: UnsafePointer<git_diff_delta>
            = git_diff_get_delta(diff, idx)
    else
    {
        return nil
    }
    
    return GitDiffDelta(cValue: diffDelta.pointee)
}



/// Checks whether the deltas of the given diff are sorted case-insensitively.
/// - Parameter diff: The diff to check. The underlying type must be `git_diff`.
/// - Returns: Whether the deltas of the given diff are sorted
/// case-insensitively.
///
/// ## C Equivalent
///
/// [`git_diff_is_sorted_icase()`](https://libgit2.org/docs/reference/main/diff/git_diff_is_sorted_icase.html)
public func gitDiffIsSortedICase(
    diff: OpaquePointer
) -> Bool
{
    let isSortedICase: Int32 = git_diff_is_sorted_icase(diff)
    
    return Bool(isSortedICase)
}



/// Loops over all deltas in the given diff.
/// - Parameters:
///   - diff: The diff to iterate. The underlying type must be `git_diff`.
///   - fileCB: The callback to invoke for each file in a diff.
///   - binaryCB: The callback to invoke for binary content in a diff.
///   - hunkCB: The callback to invoke for each hunk in a diff.
///   - lineCB: The callback to invoke for each line in a diff.
///   - payload: The payload to pass to the `fileCB`, `binaryCB`, `hunkCB`,
///   and `lineCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The text of diff files will be calculated only if `hunkCB` and `lineCB`
/// are not `nil`. Neither of these callbacks will be invoked for binary files
/// or for files with only file mode changes.
///
/// ## C Equivalent
///
/// [`git_diff_foreach()`](https://libgit2.org/docs/reference/main/diff/git_diff_foreach.html)
public func gitDiffForEach(
    diff        : OpaquePointer,
    fileCB      : GitDiffFileCB?,
    binaryCB    : GitDiffBinaryCB?,
    hunkCB      : GitDiffHunkCB?,
    lineCB      : GitDiffLineCB?,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_diff_foreach(
            diff,
            fileCB,
            binaryCB,
            hunkCB,
            lineCB,
            payload
        )
    }
}



/// Gets the single character abbreviation for the given delta status.
/// - Parameter status: The type of change for which to get the single
/// character abbreviation.
/// - Returns: The single character abbreviation for the given delta status.
///
/// ## Discussion
///
/// This is similar to `git diff --name-status`, which uses a single letter
/// code such as `A` for added files, `D` for deleted files, and `M` for
/// modified files.
///
/// If the given delta status is ``GitDeltaT/gitDeltaUntracked``, the character
/// will be a space.
///
/// ## C Equivalent
///
/// [`git_diff_status_char()`](https://libgit2.org/docs/reference/main/diff/git_diff_status_char.html)
public func gitDiffStatusChar(
    status: GitDeltaT
) -> CChar
{
    return git_diff_status_char(status.cValue())
}



/// Loops over the given diff and generates formatted text.
/// - Parameters:
///   - diff: The diff to iterate. The underlying type must be `git_diff`.
///   - format: The diff data output format to use.
///   - printCB: The callback to invoke for each line in a diff.
///   - payload: The payload to pass to `printCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_print()`](https://libgit2.org/docs/reference/main/diff/git_diff_print.html)
public func gitDiffPrint(
    diff    : OpaquePointer,
    format  : GitDiffFormatT,
    printCB : GitDiffLineCB,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_diff_print(
            diff,
            format.cValue(),
            printCB,
            payload
        )
    }
}



/// Gets the complete formatted text from the given diff.
/// - Parameters:
///   - out: The `Data` instance in which to store the formatted text.
///   - diff: The diff to use. The underlying type must be `git_diff`.
///   - format: The diff data output format to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_to_buf()`](https://libgit2.org/docs/reference/main/diff/git_diff_to_buf.html)
public func gitDiffToBuf(
    out     : inout Data,
    diff    : OpaquePointer,
    format  : GitDiffFormatT
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_diff_to_buf(
                cOut,
                diff,
                format.cValue()
            )
        }
    }
}



/// Performs a diff on the given blobs.
/// - Parameters:
///   - oldBlob: The old blob to use in the diff operation. The underlying type
///   must be `git_blob`.
///   - oldAsPath: The file name to use for `oldBlob`.
///   - newBlob: The new blob to use in the diff operation. The underlying type
///   must be `git_blob`.
///   - newAsPath: The file name to use for `newBlob`.
///   - options: The diff options to use.
///   - fileCB: The callback to invoke for each file in a diff.
///   - binaryCB: The callback to invoke for binary content in a diff.
///   - hunkCB: The callback to invoke for each hunk in a diff.
///   - lineCB: The callback to invoke for each line in a diff.
///   - payload: The payload to pass to the `fileCB`, `binaryCB`, `hunkCB`,
///   and `lineCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Since a blob lacks some contextual information compared to a file,
/// the `git_diff_file` given to the callback will include some placeholder
/// data. For example, `mode` will be `0` and `path` will be `NULL`.
///
/// Either `oldBlob` or `newBlob` may be `nil`. If both are `nil`, this
/// function will do nothing.
///
/// A binary content check will be performed on the blob content. If either
/// blob looks like binary data, the `git_diff_delta` `binary` attribute will
/// be set to `1`, and neither `hunkCB` nor `lineCB` will be invoked
/// (unless ``GitDiffOptions/flags`` includes
/// ``GitDiffOptionT/gitDiffForceText``).
///
/// ## C Equivalent
///
/// [`git_diff_blobs()`](https://libgit2.org/docs/reference/main/diff/git_diff_blobs.html)
public func gitDiffBlobs(
    oldBlob     : OpaquePointer?,
    oldAsPath   : String?,
    newBlob     : OpaquePointer?,
    newAsPath   : String?,
    options     : GitDiffOptions?,
    fileCB      : GitDiffFileCB?,
    binaryCB    : GitDiffBinaryCB?,
    hunkCB      : GitDiffHunkCB?,
    lineCB      : GitDiffLineCB?,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_diff_blobs(
                oldBlob,
                oldAsPath,
                newBlob,
                newAsPath,
                cOptions,
                fileCB,
                binaryCB,
                hunkCB,
                lineCB,
                payload
            )
        }
    }
}



/// Performs a diff on the given blobs.
/// - Parameters:
///   - oldBlob: The old blob to use in the diff operation. The underlying type
///   must be `git_blob`.
///   - oldAsPath: The file name to use for `oldBlob`.
///   - buffer: The raw data for the new side of the diff.
///   - bufferLen: The length of `buffer`.
///   - bufferAsPath: The file name to use for `buffer`.
///   - options: The diff options to use.
///   - fileCB: The callback to invoke for each file in a diff.
///   - binaryCB: The callback to invoke for binary content in a diff.
///   - hunkCB: The callback to invoke for each hunk in a diff.
///   - lineCB: The callback to invoke for each line in a diff.
///   - payload: The payload to pass to the `fileCB`, `binaryCB`, `hunkCB`,
///   and `lineCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Since a blob lacks some contextual information compared to a file,
/// the `git_diff_file` given to the callback will include some placeholder
/// data. For example, `mode` will be `0` and `path` will be `NULL`.
///
/// ## C Equivalent
///
/// [`git_diff_blob_to_buffer()`](https://libgit2.org/docs/reference/main/diff/git_diff_blob_to_buffer.html)
public func gitDiffBlobToBuffer(
    oldBlob         : OpaquePointer?,
    oldAsPath       : String?,
    buffer          : Data?,
    bufferLen       : Int?,
    bufferAsPath    : String?,
    options         : GitDiffOptions?,
    fileCB          : GitDiffFileCB?,
    binaryCB        : GitDiffBinaryCB?,
    hunkCB          : GitDiffHunkCB?,
    lineCB          : GitDiffLineCB?,
    payload         : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return try buffer.withOptionalCBuffer
            {
                cBuffer, cBufferLength in
                
                return git_diff_blob_to_buffer(
                    oldBlob,
                    oldAsPath,
                    cBuffer,
                    cBufferLength,
                    bufferAsPath,
                    cOptions,
                    fileCB,
                    binaryCB,
                    hunkCB,
                    lineCB,
                    payload
                )
            }
        }
    }
}



/// Performs a diff between the given buffers.
/// - Parameters:
///   - oldBuffer: The raw data for the old side of the diff.
///   - oldBufferLen: The length of `oldBuffer`.
///   - oldBufferAsPath: The file name to use for `oldBuffer`.
///   - newBuffer: The raw data for the new side of the diff.
///   - newBufferLen: The length of `newBuffer`.
///   - newBufferAsPath: The file name to use for `newBuffer`.
///   - options: The diff options to use.
///   - fileCB: The callback to invoke for each file in a diff.
///   - binaryCB: The callback to invoke for binary content in a diff.
///   - hunkCB: The callback to invoke for each hunk in a diff.
///   - lineCB: The callback to invoke for each line in a diff.
///   - payload: The payload to pass to the `fileCB`, `binaryCB`, `hunkCB`,
///   and `lineCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Since a blob lacks some contextual information compared to a file,
/// the `git_diff_file` given to the callback will include some placeholder
/// data. For example, `mode` will be `0` and `path` will be `NULL`.
///
/// ## C Equivalent
///
/// [`git_diff_buffers()`](https://libgit2.org/docs/reference/main/diff/git_diff_buffers.html)
public func gitDiffBuffers(
    oldBuffer       : Data?,
    oldBufferLen    : Int?,
    oldBufferAsPath : String?,
    newBuffer       : Data?,
    newBufferLen    : Int?,
    newBufferAsPath : String?,
    options         : GitDiffOptions?,
    fileCB          : GitDiffFileCB?,
    binaryCB        : GitDiffBinaryCB?,
    hunkCB          : GitDiffHunkCB?,
    lineCB          : GitDiffLineCB?,
    payload         : UnsafeMutableRawPointer?
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
                
                return try options.withOptionalCValue
                {
                    cOptions in
                    
                    return git_diff_buffers(
                        cOldBuffer,
                        cOldBufferCount,
                        oldBufferAsPath,
                        cNewBuffer,
                        cNewBufferCount,
                        newBufferAsPath,
                        cOptions,
                        fileCB,
                        binaryCB,
                        hunkCB,
                        lineCB,
                        payload
                    )
                }
            }
        }
    }
}



/// Writes the given patch file contents into a diff.
/// - Parameters:
///   - out: The pointer in which to store the diff. The underlying type must
///   be `git_diff`.
///   - content: The patch file contents to write.
///   - contentLen: The length of `content`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting diff will be similar to the one that would be produced by
/// comparing two trees, but with subtle differences. For example, a patch
/// file likely contains abbreviated IDs, so the IDs in a diff delta
/// produced by this function will also be abbreviated.
///
/// - Note: This function supports only SHA-1 patch files, and will read only
/// patch files created by a Git implementation. It will not read unified
/// diffs produced by the diff program or any other type of patch file.
///
/// ## C Equivalent
///
/// [`git_diff_from_buffer()`](https://libgit2.org/docs/reference/main/diff/git_diff_from_buffer.html)
public func gitDiffFromBuffer(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    content     : Data,
    contentLen  : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try content.withCBuffer
        {
            cContent, cContentCount in
            
            return git_diff_from_buffer(
                out,
                cContent,
                cContentCount
            )
        }
    }
}



/// Accumulates diff statistics for all patches.
/// - Parameters:
///   - out: The pointer in which to store the diff statistics. The underlying
///   type must be `git_diff_stats`.
///   - diff: The diff to evaluate. The underlying type must be `git_diff`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_get_stats()`](https://libgit2.org/docs/reference/main/diff/git_diff_get_stats.html)
public func gitDiffGetStats(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    diff    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_diff_get_stats(
            out,
            diff
        )
    }
}



/// Gets the total number of files changed in a diff.
/// - Parameter stats: The diff statistics from which to get the total number
/// of changed files. The underlying type must be `git_diff_stats`.
/// - Returns: The total number of files changed in a diff.
///
/// ## C Equivalent
///
/// [`git_diff_stats_files_changed()`](https://libgit2.org/docs/reference/main/diff/git_diff_stats_files_changed.html)
public func gitDiffStatsFilesChanged(
    stats: OpaquePointer
) -> Int
{
    return git_diff_stats_files_changed(stats)
}



/// Gets the total number of insertions in a diff.
/// - Parameter stats: The diff statistics from which to get the total number
/// of insertions. The underlying type must be `git_diff_stats`.
/// - Returns: The total number of insertions in a diff.
///
/// ## C Equivalent
///
/// [`git_diff_stats_insertions()`](https://libgit2.org/docs/reference/main/diff/git_diff_stats_insertions.html)
public func gitDiffStatsInsertions(
    stats: OpaquePointer
) -> Int
{
    return git_diff_stats_insertions(stats)
}



/// Gets the total number of deletions in a diff.
/// - Parameter stats: The diff statistics from which to get the total number
/// of deletions. The underlying type must be `git_diff_stats`.
/// - Returns: The total number of deletions in a diff.
///
/// ## C Equivalent
///
/// [`git_diff_stats_deletions()`](https://libgit2.org/docs/reference/main/diff/git_diff_stats_deletions.html)
public func gitDiffStatsDeletions(
    stats: OpaquePointer
) -> Int
{
    return git_diff_stats_deletions(stats)
}



/// Stores the given diff statistics in the given `Data` instance.
/// - Parameters:
///   - out: The `Data` instance in which to store the given diff statistics.
///   - stats: The diff statistics to write. The underlying type must be
///   `git_diff_stats`.
///   - format: The diff stats format to use.
///   - width: The target output width to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The given `width` only affects the output if `format` includes
/// ``GitDiffStatsFormatT/gitDiffStatsFull``.
///
/// ## C Equivalent
///
/// [`git_diff_stats_to_buf()`](https://libgit2.org/docs/reference/main/diff/git_diff_stats_to_buf.html)
public func gitDiffStatsToBuf(
    out     : inout Data,
    stats   : OpaquePointer,
    format  : GitDiffStatsFormatT,
    width   : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_diff_stats_to_buf(
                cOut,
                stats,
                format.cValue(),
                width
            )
        }
    }
}



/// Frees the memory allocated for the given `git_diff_stats` instance.
/// - Parameter stats: The diff statistics to free. The underlying type must
/// be `git_diff_stats`.
///
/// ## C Equivalent
///
/// [`git_diff_stats_free()`](https://libgit2.org/docs/reference/main/diff/git_diff_stats_free.html)
public func gitDiffStatsFree(
    stats: OpaquePointer?
)
{
    guard let stats: OpaquePointer = stats
    else
    {
        return
    }
    
    git_diff_stats_free(stats)
}



/// Initializes the given `git_diff_patchid_options` instance.
/// - Parameters:
///   - opts: The `git_diff_patchid_options` instance to initialize.
///   - version: The version to use. Pass ``gitDiffPatchIDOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_diff_patchid_options_init()`](https://libgit2.org/docs/reference/main/diff/git_diff_patchid_options_init.html)
public func gitDiffPatchIDOptionsInit(
    opts    : UnsafeMutablePointer<git_diff_patchid_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_diff_patchid_options_init(
            opts,
            version
        )
    }
}



/// Calculates the patch ID for the given patch, by summing the hash of the
/// file diffs, and ignoring whitespace and line numbers.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the patch ID.
///   - diff: The diff to evaluate. The underlying type must be `git_diff`.
///   - opts: The patch ID calculation options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting patch ID can be used to derive whether two diffs are the
/// same with a high probability.
///
/// - Note: Currently, this function calculates only stable patch IDs as
/// defined in `git-patch-id(1)`, and should generate the same IDs as the ones
/// generated by the upstream Git project.
///
/// ## C Equivalent
///
/// [`git_diff_patchid()`](https://libgit2.org/docs/reference/main/diff/git_diff_patchid.html)
public func gitDiffPatchID(
    out     : inout GitOID,
    diff    : OpaquePointer,
    opts    : GitDiffPatchIDOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        guard let opts: GitDiffPatchIDOptions = opts
        else
        {
            return out.withMutatingCValue
            {
                cOut in
                
                return git_diff_patchid(
                    cOut,
                    diff,
                    nil
                )
            }
        }
        
        var cOpts: git_diff_patchid_options = try opts.cValue()
        
        return out.withMutatingCValue
        {
            cOut in
            
            return git_diff_patchid(
                cOut,
                diff,
                &cOpts
            )
        }
    }
}
