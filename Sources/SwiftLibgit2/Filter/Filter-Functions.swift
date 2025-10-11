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



/// Loads the filter list for the given path.
/// - Parameters:
///   - filters: The pointer in which to store the filter list. The underlying
///   type must be `git_filter_list`.
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - blob: The blob to which the filter should be applied. The underlying
///   type must be `git_blob`.
///   - path: The relative path to the file to filter.
///   - mode: The filtering direction.
///   - flags: The flags controlling the filtering process.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The operation will succeed if no filters are requested for the specified
/// file, but `filters` will be set to `nil`.
///
/// ## C Equivalent
///
/// [`git_filter_list_load()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_load.html)
public func gitFilterListLoad(
    filters : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    blob    : OpaquePointer?,
    path    : String,
    mode    : GitFilterModeT,
    flags   : GitFilterFlagT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_list_load(
            filters,
            repo,
            blob,
            path,
            mode.cValue(),
            flags.rawValue
        )
    }
}



/// Loads the filter list for the given path.
/// - Parameters:
///   - filters: The pointer in which to store the filter list. The underlying
///   type must be `git_filter_list`.
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - blob: The blob to which the filter should be applied. The underlying
///   type must be `git_blob`.
///   - path: The relative path to the file to filter.
///   - mode: The filtering direction.
///   - opts: The filtering options.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The operation will succeed if no filters are requested for the specified
/// file, but `filters` will be set to `nil`.
///
/// ## C Equivalent
///
/// [`git_filter_list_load_ext()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_load_ext.html)
public func gitFilterListLoadExt(
    filters : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    blob    : OpaquePointer?,
    path    : String,
    mode    : GitFilterModeT,
    opts    : GitFilterOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_filter_list_load_ext(
                filters,
                repo,
                blob,
                path,
                mode.cValue(),
                cOpts
            )
        }
    }
}



/// Checks whether the named filter will be applied.
/// - Parameters:
///   - filters: The filter list to check. The underlying type must be
///   `git_filter_list`.
///   - name: The name of the filter to check.
/// - Returns: Whether the named filter will be applied.
///
/// ## Discussion
///
/// The built-in filters `crlf` and `indent` can be queried.
///
/// ## C Equivalent
///
/// [`git_filter_list_contains()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_contains.html)
public func gitFilterListContains(
    filters : OpaquePointer?,
    name    : String
) -> Bool
{
    return Bool(git_filter_list_contains(
        filters,
        name
    ))
}



/// Applies the given filter list to the given data buffer.
/// - Parameters:
///   - out: The ``GitBuf`` instance into which the filtered content should
///   be written.
///   - filters: The filter list to apply. The underlying type must be
///   `git_filter_list`.
///   - input: The buffer containing the data to filter.
///   - inputLen: The length of `input`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_filter_list_apply_to_buffer()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_apply_to_buffer.html)
public func gitFilterListApplyToBuffer(
    out                     : inout GitBuf,
    filters                 : OpaquePointer?,
    in          input       : Data,
    inLen       inputLen    : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try input.withCBuffer
            {
                cInput, cInputCount in
                
                return git_filter_list_apply_to_buffer(
                    cOut,
                    filters,
                    cInput,
                    cInputCount
                )
            }
        }
    }
}



/// Applies the given filter list to the contents of the specified on-disk file.
/// - Parameters:
///   - out: The ``GitBuf`` instance into which the filtered content should
///   be written.
///   - filters: The filter list to apply. The underlying type must be
///   `git_filter_list`.
///   - repo: The repository containing the specified file. The underlying
///   type must be `git_repository`.
///   - path: The path of the file to filter.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If `path` is a relative path, it will be interpreted as being relative to
/// the working directory.
///
/// ## C Equivalent
///
/// [`git_filter_list_apply_to_file()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_apply_to_file.html)
public func gitFilterListApplyToFile(
    out     : inout GitBuf,
    filters : OpaquePointer?,
    repo    : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_filter_list_apply_to_file(
                cOut,
                filters,
                repo,
                path
            )
        }
    }
}



/// Applies the given filter list to the contents of the given blob.
/// - Parameters:
///   - out: The ``GitBuf`` instance into which the filtered content should
///   be written.
///   - filters: The filter list to apply. The underlying type must be
///   `git_filter_list`.
///   - blob: The blob to filter. The underlying type must be `git_blob`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_filter_list_apply_to_blob()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_apply_to_blob.html)
public func gitFilterListApplyToBlob(
    out     : inout GitBuf,
    filters : OpaquePointer?,
    blob    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_filter_list_apply_to_blob(
                cOut,
                filters,
                blob
            )
        }
    }
}



/// Applies the given filter list to the given buffer as a stream.
/// - Parameters:
///   - filters: The filter list to apply. The underlying type must be
///   `git_filter_list`.
///   - buffer: The buffer containing the data to filter.
///   - len: The length of `buffer`.
///   - target: The stream into which the data should be written.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_filter_list_stream_buffer()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_stream_buffer.html)
public func gitFilterListStreamBuffer(
    filters : OpaquePointer?,
    buffer  : Data,
    len     : Int,
    target  : UnsafeMutablePointer<git_writestream>
) -> GitErrorCode
{
    return withCConversion
    {
        return try buffer.withCBuffer
        {
            cBuffer, cBufferCount in
            
            return git_filter_list_stream_buffer(
                filters,
                cBuffer,
                cBufferCount,
                target
            )
        }
    }
}



/// Applies the given filter list to the specified file as a stream.
/// - Parameters:
///   - filters: The filter list to apply. The underlying type must be
///   `git_filter_list`.
///   - repo: The repository containing the specified file. The underlying
///   type must be `git_repository`.
///   - path: The path of the file to filter.
///   - target: The stream into which the data should be written.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If `path` is a relative path, it will be interpreted as being relative to
/// the working directory.
///
/// ## C Equivalent
///
/// [`git_filter_list_stream_file()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_stream_file.html)
public func gitFilterListStreamFile(
    filters : OpaquePointer?,
    repo    : OpaquePointer,
    path    : String,
    target  : UnsafeMutablePointer<git_writestream>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_list_stream_file(
            filters,
            repo,
            path,
            target
        )
    }
}



/// Applies the given filter list to the given blob as a stream.
/// - Parameters:
///   - filters: The filter list to apply. The underlying type must be
///   `git_filter_list`.
///   - blob: The blob to filter. The underlying type must be `git_blob`.
///   - target: The stream into which the data should be written.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_filter_list_stream_blob()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_stream_blob.html)
public func gitFilterListStreamBlob(
    filters : OpaquePointer?,
    blob    : OpaquePointer,
    target  : UnsafeMutablePointer<git_writestream>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_list_stream_blob(
            filters,
            blob,
            target
        )
    }
}



/// Frees the memory allocated for the given `git_filter_list` instance.
/// - Parameter filters: The filter list to free. The underlying type must
/// be `git_filter_list`.
///
/// ## C Equivalent
///
/// [`git_filter_list_free()`](https://libgit2.org/docs/reference/main/filter/git_filter_list_free.html)
public func gitFilterListFree(
    filters: OpaquePointer?
)
{
    guard let filters: OpaquePointer = filters
    else
    {
        return
    }
    
    git_filter_list_free(filters)
}
