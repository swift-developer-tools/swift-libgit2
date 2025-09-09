//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Looks up a blob from a repository.
/// - Parameters:
///   - blob: The pointer that will receive the blob.
///   - repo: The repository to use when locating the blob.
///   - id: The identity of the blob to locate.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_lookup()`](https://libgit2.org/docs/reference/main/blob/git_blob_lookup.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobLookup(
    blob    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : UnsafePointer<git_oid>
) -> Int32
{
    return git_blob_lookup(
        blob,
        repo,
        id
    )
}



/// Looks up a blob from a repository, given a prefix of its identifier (short ID).
/// - Parameters:
///   - blob: The pointer that will receive the blob.
///   - repo: The repository to use when locating the blob.
///   - id: The identity of the blob to locate.
///   - len: The length of the short ID.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_lookup_prefix()`](https://libgit2.org/docs/reference/main/blob/git_blob_lookup_prefix.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobLookupPrefix(
    blob    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : UnsafePointer<git_oid>,
    len     : Int
) -> Int32
{
    return git_blob_lookup_prefix(
        blob,
        repo,
        id,
        len
    )
}



/// Frees the memory allocated for a `git_blob` instance.
/// - Parameter blob: The blob to free.
///
/// ## Discussion
///
/// It is necessary to call this method when a blob is no longer needed, otherwise it will cause
/// a memory leak.
///
/// ## C Equivalent
///
/// [`git_blob_free()`](https://libgit2.org/docs/reference/main/blob/git_blob_free.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobFree(
    blob: OpaquePointer?
)
{
    return git_blob_free(blob)
}



/// Gets the ID of the given blob.
/// - Parameter blob: The blob.
/// - Returns: The ID of the blob.
///
/// ## C Equivalent
///
/// [`git_blob_id()`](https://libgit2.org/docs/reference/main/blob/git_blob_id.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobID(
    blob: OpaquePointer
) -> UnsafePointer<git_oid>?
{
    return git_blob_id(blob)
}



/// Gets the repository that contains the given blob.
/// - Parameter blob: The blob.
/// - Returns: The repository that contains the blob.
///
/// ## C Equivalent
///
/// [`git_blob_owner()`](https://libgit2.org/docs/reference/main/blob/git_blob_owner.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobOwner(
    blob: OpaquePointer
) -> OpaquePointer
{
    return git_blob_owner(blob)
}



/// Gets a read-only buffer containing the raw content of the given blob.
/// - Parameter blob: The blob.
/// - Returns: A read-only buffer containing the raw content of the blob.
///
/// ## C Equivalent
///
/// [`git_blob_rawcontent()`](https://libgit2.org/docs/reference/main/blob/git_blob_rawcontent.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobRawContent(
    blob: OpaquePointer
) -> UnsafeRawPointer
{
    return git_blob_rawcontent(blob)
}



/// Gets the size, in bytes, of the content of the given blob.
/// - Parameter blob: The blob.
/// - Returns: The size, in bytes, of the content of the given blob.
///
/// ## C Equivalent
///
/// [`git_blob_rawsize()`](https://libgit2.org/docs/reference/main/blob/git_blob_rawsize.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobRawSize(
    blob: OpaquePointer
) -> UInt64
{
    return git_blob_rawsize(blob)
}



// TODO: Replace `git_buf` and `git_buf_dispose()` in documenation.
/// Gets a buffer with the filtered content of the given blob.
/// - Parameters:
///   - out: The buffer to be filled in.
///   - blob: The blob.
///   - asPath: The path used for attribute lookups and other processes.
///   - opts: The options for the blob filtering process.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This applies filters as if the blob was being checked out to the working directory under the specified
/// file name. This may apply `CRLF` filtering or other types of changes depending on the file attributes
/// set for the blob and the content detected in it.
///
/// The output is written into a `git_buf` which the caller must dispose of when done
/// (using `git_buf_dispose()`).
///
/// If no filters need to be applied, then the `out` buffer will just be populated with a pointer to the raw
/// content of the blob. In that case, be careful to either copy the buffer into memory not owned by the
/// library, or to not free the blob until the buffer is no longer needed.
///
/// ## C Equivalent
///
/// [`git_blob_filter()`](https://libgit2.org/docs/reference/main/blob/git_blob_filter.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobFilter(
    out     : UnsafeMutablePointer<git_buf>,
    blob    : OpaquePointer,
    asPath  : String,
    opts    : GitBlobFilterOptions?
) -> Int32
{
    guard let opts: GitBlobFilterOptions = opts
    else
    {
        return git_blob_filter(
            out,
            blob,
            asPath,
            nil
        )
    }
    
    
    
    return opts.withCStruct
    {
        cOpts in
        
        return git_blob_filter(
            out,
            blob,
            asPath,
            cOpts
        )
    }
}



/// Reads a file from the working directory of the given repository and writes it to the object database.
/// - Parameters:
///   - id: The ID of the written blob.
///   - repo: The repository where the blob will be written. This repository cannot be bare.
///   - relativePath: The path to the file from which the blob will be created, relative to the
///   repository's working directory.
/// - Returns: `0` on success, or an error code.
///
///
/// ## C Equivalent
///
/// [`git_blob_create_from_workdir()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_workdir.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobCreateFromWorkdir(
    id              : UnsafeMutablePointer<git_oid>,
    repo            : OpaquePointer,
    relativePath    : String
) -> Int32
{
    return git_blob_create_from_workdir(
        id,
        repo,
        relativePath
    )
}



/// Reads a file from the file system (not necessarily inside the working directory of the given repository)
/// and writes it to the object database.
/// - Parameters:
///   - id: The ID of the written blob.
///   - repo: The repository where the blob will be written. This repository may be bare.
///   - path: The path to the file from which the blob will be created.
/// - Returns: `0` on success, or an error code.
///
///
/// ## C Equivalent
///
/// [`git_blob_create_from_disk()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_disk.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobCreateFromDisk(
    id      : UnsafeMutablePointer<git_oid>,
    repo    : OpaquePointer,
    path    : String
) -> Int32
{
    return git_blob_create_from_disk(
        id,
        repo,
        path
    )
}



// TODO: Replace `git_odb_open_wstream()` in documentation.
/// Creates a stream to write a new blob into the object database.
/// - Parameters:
///   - out: The stream into which to write.
///   - repo: The repository where the blob will be written. This repository may be bare.
///   - hintPath: The path to use when selecting data filters to apply onto the content of the blob
///   to be created.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function may need to buffer the data on the disk and is generally not the correct choice if the size
/// of the data to write is known.
///
/// If the data is held in memory, use ``gitBlobCreateFromBuffer(id:repo:buffer:len:)``
/// instead.
///
/// Otherwise, if the size of the contents are known (and filtering isn't needed), use
/// `git_odb_open_wstream()` instead.
///
/// Do not manually close this stream. Instead, pass it to
/// ``gitBlobCreateFromStreamCommit(out:stream:)`` to commit the write to the object
/// database and get the object ID.
///
/// If the `hintPath` parameter is not `nil`, it will be used to determine which Git filters should be
/// applied to the object before it is written to the object database.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_stream()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_stream.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobCreateFromStream(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_writestream>?>,
    repo        : OpaquePointer,
    hintPath    : String?
) -> Int32
{
    return git_blob_create_fromstream(
        out,
        repo,
        hintPath
    )
}



/// Closes the given stream and finalizes writing the blob to the object database.
/// - Parameters:
///   - out: The ID of the new blob.
///   - stream: The stream to close.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_stream_commit()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_stream_commit.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobCreateFromStreamCommit(
    out     : UnsafeMutablePointer<git_oid>,
    stream  : UnsafeMutablePointer<git_writestream>
) -> Int32
{
    return git_blob_create_from_stream_commit(
        out,
        stream
    )
}



/// Writes an in-memory buffer to the object database as a blob.
/// - Parameters:
///   - id: The ID of the written blob.
///   - repo: The repository where the blob will be written
///   - buffer: The data to be written into the blob.
///   - len: The length of the data.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_buffer()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_buffer.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobCreateFromBuffer(
    id      : UnsafeMutablePointer<git_oid>,
    repo    : OpaquePointer,
    buffer  : UnsafeRawPointer,
    len     : Int
) -> Int32
{
    return git_blob_create_frombuffer(
        id,
        repo,
        buffer,
        len
    )
}



/// Checks whether the blob content is most likely binary.
/// - Parameter blob: The blob to analyze.
/// - Returns: Whether the blob content is most likely binary.
///
/// ## Discussion
///
/// The heuristic used to guess whether a file is binary is taken from core Git and involves searching for
/// `NULL` bytes and looking for a reasonable ratio of printable to non-printable characters among
/// the first 8,000 bytes.
///
/// ## C Equivalent
///
/// [`git_blob_is_binary()`](https://libgit2.org/docs/reference/main/blob/git_blob_is_binary.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobIsBinary(
    blob: OpaquePointer
) -> Bool
{
    return git_blob_is_binary(blob) == 1
}



/// Checks whether the given content is most likely binary.
/// - Parameters:
///   - data: The blob data to analyze.
///   - len: The length of the data.
/// - Returns: Whether the given content is most likely binary.
///
/// ## Discussion
///
/// The heuristic used to guess whether file content is binary is taken from core Git and is the same
/// mechanism used by ``gitBlobIsBinary(blob:)``, but only looks at raw data.
///
/// ## C Equivalent
///
/// [`git_blob_data_is_binary()`](https://libgit2.org/docs/reference/main/blob/git_blob_data_is_binary.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobDataIsBinary(
    data    : String,
    len     : Int
) -> Bool
{
    return git_blob_data_is_binary(
        data,
        len
    ) == 1
}



/// Creates an in-memory copy of the given blob.
/// - Parameters:
///   - out: The pointer that will receive the copy of the blob.
///   - source: The original blob to copy.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The copy of the blob must be freed by the caller, otherwise it will cause a memory leak.
///
/// ## C Equivalent
///
/// [`git_blob_dup()`](https://libgit2.org/docs/reference/main/blob/git_blob_dup.html)
@available(iOS 1.0.0, macOS 1.0.0, *)
public func gitBlobDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> Int32
{
    return git_blob_dup(
        out,
        source
    )
}
