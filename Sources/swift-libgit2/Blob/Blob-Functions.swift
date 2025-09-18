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
///   - blob: The pointer that should receive the blob. The underlying type should be `git_blob`.
///   - repo: The repository to use when locating the blob. The underlying type should be
///   `git_repository`.
///   - id: The identity of the blob to locate.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_lookup()`](https://libgit2.org/docs/reference/main/blob/git_blob_lookup.html)
public func gitBlobLookup(
    blob    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID
) -> Int32
{
    var cID: git_oid = id.cValue
    
    return git_blob_lookup(
        blob,
        repo,
        &cID
    )
}



/// Looks up a blob from a repository, given a prefix of its identifier (short ID).
/// - Parameters:
///   - blob: The pointer that should receive the blob. The underlying type should be `git_blob`.
///   - repo: The repository to use when locating the blob. The underlying type should be
///   `git_repository`.
///   - id: The identity of the blob to locate.
///   - len: The length of the short ID.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_lookup_prefix()`](https://libgit2.org/docs/reference/main/blob/git_blob_lookup_prefix.html)
public func gitBlobLookupPrefix(
    blob    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID,
    len     : Int
) -> Int32
{
    var cID: git_oid = id.cValue
    
    return git_blob_lookup_prefix(
        blob,
        repo,
        &cID,
        len
    )
}



/// Frees the memory allocated for a `git_blob` instance.
/// - Parameter blob: The blob to free. The underlying type should be `git_blob`.
///
/// ## Discussion
///
/// It is necessary to call this method when a blob is no longer needed, otherwise it will cause
/// a memory leak.
///
/// ## C Equivalent
///
/// [`git_blob_free()`](https://libgit2.org/docs/reference/main/blob/git_blob_free.html)
public func gitBlobFree(
    blob: OpaquePointer?
)
{
    return git_blob_free(blob)
}



/// Gets the ID of the given blob.
/// - Parameter blob: The blob. The underlying type should be `git_blob`.
/// - Returns: The ID of the blob.
///
/// ## C Equivalent
///
/// [`git_blob_id()`](https://libgit2.org/docs/reference/main/blob/git_blob_id.html)
public func gitBlobID(
    blob: OpaquePointer
) -> GitOID?
{
    guard let blobIDPointer: UnsafePointer<git_oid> = git_blob_id(blob)
    else
    {
        return nil
    }
    
    return GitOID(cValue: blobIDPointer.pointee)
}



/// Gets the repository that contains the given blob.
/// - Parameter blob: The blob. The underlying type should be `git_blob`.
/// - Returns: The repository that contains the blob.
///
/// ## C Equivalent
///
/// [`git_blob_owner()`](https://libgit2.org/docs/reference/main/blob/git_blob_owner.html)
public func gitBlobOwner(
    blob: OpaquePointer
) -> OpaquePointer
{
    return git_blob_owner(blob)
}



/// Gets a read-only buffer containing the raw content of the given blob.
/// - Parameter blob: The blob. The underlying type should be `git_blob`.
/// - Returns: A read-only buffer containing the raw content of the blob.
///
/// ## C Equivalent
///
/// [`git_blob_rawcontent()`](https://libgit2.org/docs/reference/main/blob/git_blob_rawcontent.html)
public func gitBlobRawContent(
    blob: OpaquePointer
) -> UnsafeRawPointer
{
    return git_blob_rawcontent(blob)
}



/// Gets the size, in bytes, of the content of the given blob.
/// - Parameter blob: The blob. The underlying type should be `git_blob`.
/// - Returns: The size, in bytes, of the content of the given blob.
///
/// ## C Equivalent
///
/// [`git_blob_rawsize()`](https://libgit2.org/docs/reference/main/blob/git_blob_rawsize.html)
public func gitBlobRawSize(
    blob: OpaquePointer
) -> UInt64
{
    return git_blob_rawsize(blob)
}



/// Gets a buffer with the filtered content of the given blob.
/// - Parameters:
///   - out: The buffer to be filled in.
///   - blob: The blob. The underlying type should be `git_blob`.
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
/// The output is written into a ``GitBuf`` instance which the caller must dispose of when done by
/// using ``gitBufDispose(buffer:)``.
///
/// If no filters need to be applied, then the `out` buffer will just be populated with a pointer to the raw
/// content of the blob. In that case, be careful to either copy the buffer into memory not owned by the
/// library, or to not free the blob until the buffer is no longer needed.
///
/// This function will return `GIT_EUSER` if `opts` was provided, but there as an error converting it
/// to the equivalent C value.
///
/// ## C Equivalent
///
/// [`git_blob_filter()`](https://libgit2.org/docs/reference/main/blob/git_blob_filter.html)
public func gitBlobFilter(
    out     : inout GitBuf,
    blob    : OpaquePointer,
    asPath  : String,
    opts    : GitBlobFilterOptions?
) -> Int32
{
    guard let opts: GitBlobFilterOptions = opts
    else
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_blob_filter(
                cOut,
                blob,
                asPath,
                nil
            )
        }
    }
    
    
    
    return opts.withCValue
    {
        cOpts in
        
        guard let cOpts: UnsafeMutablePointer<git_blob_filter_options> = cOpts
        else
        {
            return GIT_EUSER.rawValue
        }
        
        return out.withMutatingCValue
        {
            cOut in
            
            return git_blob_filter(
                cOut,
                blob,
                asPath,
                cOpts
            )
        }
    }
}



/// Reads a file from the working directory of the given repository and writes it to the object database.
/// - Parameters:
///   - id: The ID of the written blob.
///   - repo: The repository where the blob should be written. The underlying type should be
///   `git_repository`. This repository may not be bare.
///   - relativePath: The path to the file from which the blob should be created, relative to the
///   repository's working directory.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_workdir()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_workdir.html)
public func gitBlobCreateFromWorkdir(
    id              : inout GitOID,
    repo            : OpaquePointer,
    relativePath    : String
) -> Int32
{
    var cID: git_oid = id.cValue
    
    let blobCreateFromWorkdirResult: Int32 = git_blob_create_from_workdir(
        &cID,
        repo,
        relativePath
    )
    
    id = GitOID(cValue: cID)
    
    return blobCreateFromWorkdirResult
}



/// Reads a file from the file system (not necessarily inside the working directory of the given repository)
/// and writes it to the object database.
/// - Parameters:
///   - id: The ID of the written blob.
///   - repo: The repository where the blob should be written. The underlying type should be
///   `git_repository`. This repository may be bare.
///   - path: The path to the file from which the blob should be created.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_disk()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_disk.html)
public func gitBlobCreateFromDisk(
    id      : inout GitOID,
    repo    : OpaquePointer,
    path    : String
) -> Int32
{
    var cID: git_oid = id.cValue
    
    let blobCreateFromDiskResult: Int32 = git_blob_create_from_disk(
        &cID,
        repo,
        path
    )
    
    id = GitOID(cValue: cID)
    
    return blobCreateFromDiskResult
}



// TODO: Replace `git_odb_open_wstream()` in documentation.
/// Creates a stream to write a new blob into the object database.
/// - Parameters:
///   - out: The stream into which to write.
///   - repo: The repository where the blob should be written. The underlying type should be
///   `git_repository`. This repository may be bare.
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
public func gitBlobCreateFromStream(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_writestream>?>,
    repo        : OpaquePointer,
    hintPath    : String?
) -> Int32
{
    return git_blob_create_from_stream(
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
public func gitBlobCreateFromStreamCommit(
    out     : inout GitOID,
    stream  : UnsafeMutablePointer<git_writestream>
) -> Int32
{
    var cOut: git_oid = out.cValue
    
    let blobCreateFromStreamCommitResult: Int32 = git_blob_create_from_stream_commit(
        &cOut,
        stream
    )
    
    out = GitOID(cValue: cOut)
    
    return blobCreateFromStreamCommitResult
}



/// Writes an in-memory buffer to the object database as a blob.
/// - Parameters:
///   - id: The ID of the written blob.
///   - repo: The repository where the blob should be written. The underlying type should be
///   `git_repository`.
///   - buffer: The data to be written into the blob.
///   - len: The length of the data.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_buffer()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_buffer.html)
public func gitBlobCreateFromBuffer(
    id      : inout GitOID,
    repo    : OpaquePointer,
    buffer  : UnsafeRawPointer,
    len     : Int
) -> Int32
{
    var cID: git_oid = id.cValue
    
    let blobCreateFromBufferResult: Int32 = git_blob_create_from_buffer(
        &cID,
        repo,
        buffer,
        len
    )
    
    id = GitOID(cValue: cID)
    
    return blobCreateFromBufferResult
}



/// Checks whether the blob content is most likely binary.
/// - Parameter blob: The blob to analyze. The underlying type should be `git_blob`.
/// - Returns: Whether the blob content is most likely binary.
///
/// ## Discussion
///
/// The heuristic used to guess whether a file is binary is taken from core Git and involves searching for
/// `NUL` bytes and looking for a reasonable ratio of printable to non-printable characters among
/// the first 8,000 bytes.
///
/// ## C Equivalent
///
/// [`git_blob_is_binary()`](https://libgit2.org/docs/reference/main/blob/git_blob_is_binary.html)
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
///   - out: The pointer that should receive the copy of the blob. The underlying type should be
///   `git_blob`.
///   - source: The original blob to copy. The underlying type should be `git_blob`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The copy of the blob must be freed by the caller, otherwise it will cause a memory leak.
///
/// ## C Equivalent
///
/// [`git_blob_dup()`](https://libgit2.org/docs/reference/main/blob/git_blob_dup.html)
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
