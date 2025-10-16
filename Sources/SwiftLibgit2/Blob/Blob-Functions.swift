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



/// Looks up a blob in the given repository.
/// - Parameters:
///   - blob: The pointer in which to store the blob. The underlying type must
///   be `git_blob`.
///   - repo: The repository to use when locating the blob. The underlying type
///   must be `git_repository`.
///   - id: The ID of the blob to look up.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blob_lookup()`](https://libgit2.org/docs/reference/main/blob/git_blob_lookup.html)
public func gitBlobLookup(
    blob    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_blob_lookup(
            blob,
            repo,
            &cID
        )
    }
}



/// Looks up a blob in the given repository, using a prefix of the blob's ID.
/// - Parameters:
///   - blob: The pointer in which to store the blob. The underlying type must
///   be `git_blob`.
///   - repo: The repository to use when locating the blob. The underlying type
///   must be `git_repository`.
///   - id: The prefix of the ID of the blob to look up.
///   - len: The length of the blob's ID prefix.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will try to match the first `len` hexadecimal characters of
/// the given ID. The remaining characters must be zeros.
///
/// `len` must be greater than or equal to ``gitOIDMinPrefixLen``, and long
/// enough to identify a unique blob matching the prefix.
///
/// ## C Equivalent
///
/// [`git_blob_lookup_prefix()`](https://libgit2.org/docs/reference/main/blob/git_blob_lookup_prefix.html)
public func gitBlobLookupPrefix(
    blob    : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_blob_lookup_prefix(
            blob,
            repo,
            &cID,
            len
        )
    }
}



/// Frees the memory allocated for the given `git_blob` instance.
/// - Parameter blob: The blob to free. The underlying type must be `git_blob`.
///
/// ## C Equivalent
///
/// [`git_blob_free()`](https://libgit2.org/docs/reference/main/blob/git_blob_free.html)
public func gitBlobFree(
    blob: OpaquePointer?
)
{
    guard let blob: OpaquePointer = blob
    else
    {
        return
    }
    
    git_blob_free(blob)
}



/// Gets the ID of the given blob.
/// - Parameter blob: The blob for which to get the ID. The underlying type
/// must be `git_blob`.
/// - Returns: The ID of the blob.
///
/// ## C Equivalent
///
/// [`git_blob_id()`](https://libgit2.org/docs/reference/main/blob/git_blob_id.html)
public func gitBlobID(
    blob: OpaquePointer
) -> GitOID
{
    let blobOID: UnsafePointer<git_oid> = git_blob_id(blob)
    
    return GitOID(cValue: blobOID.pointee)
}



/// Gets the repository containing the given blob.
/// - Parameter blob: The blob for which to get the repository. The underlying
/// type must be `git_blob`.
/// - Returns: The repository containing the given blob. The underlying
/// type will be `git_repository`.
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



/// Gets the raw content of the given blob.
/// - Parameter blob: The blob for which to get the raw content. The underlying
/// type must be `git_blob`.
/// - Returns: The raw content of the given blob.
///
/// ## C Equivalent
///
/// [`git_blob_rawcontent()`](https://libgit2.org/docs/reference/main/blob/git_blob_rawcontent.html)
public func gitBlobRawContent(
    blob: OpaquePointer
) -> Data?
{
    guard let blobRawContent: UnsafeRawPointer = git_blob_rawcontent(blob)
    else
    {
        return nil
    }
    
    let blobRawContentSize: UInt64 = gitBlobRawSize(blob: blob)
    
    guard blobRawContentSize <= Int.max
    else
    {
        return nil
    }
    
    return Data(
        bytes:  blobRawContent,
        count:  Int(blobRawContentSize)
    )
}



/// Gets the size, in bytes, of the content of the given blob.
/// - Parameter blob: The blob for which to get the size. The underlying type
/// must be `git_blob`.
/// - Returns: The size of the content of the given blob.
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



/// Initializes the given `git_blob_filter_options` instance.
/// - Parameters:
///   - opts: The `git_blob_filter_options` instance to initialize.
///   - version: The version to use. Pass ``gitBlobFilterOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blob_filter_options_init()`](https://libgit2.org/docs/reference/main/blob/git_blob_filter_options_init.html)
public func gitBlobFilterOptionsInit(
    opts    : UnsafeMutablePointer<git_blob_filter_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_blob_filter_options_init(
            opts,
            version
        )
    }
}



/// Gets the filtered content of the given blob.
/// - Parameters:
///   - out: The `Data` instance to update with the filtered content.
///   - blob: The blob for which to get the filtered content. The underlying
///   type must be `git_blob`.
///   - asPath: The path used for attribute lookups and other operations.
///   - opts: The blob filter options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This applies filters as if the blob was being checked out to the working
/// directory under the specified file name. This may apply `CRLF` filtering or
/// other types of changes depending on the file attributes set for the blob
/// and the content detected in it.
///
/// If no filters need to be applied, then the `out` parameter will be updated
/// with the raw content of the blob.
///
/// ## C Equivalent
///
/// [`git_blob_filter()`](https://libgit2.org/docs/reference/main/blob/git_blob_filter.html)
public func gitBlobFilter(
    out     : inout Data,
    blob    : OpaquePointer,
    asPath  : String,
    opts    : GitBlobFilterOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return try out.withMutatingGitBuf
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
}



/// Reads a file from the working directory of the given repository and writes
/// it to the object database.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the written
///   blob.
///   - repo: The repository in which to write the blob. The underlying type
///   must be `git_repository`. This repository may not be bare.
///   - relativePath: The path to the file from which to create the blob. The
///   path must be relative to the repository's working directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_workdir()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_workdir.html)
public func gitBlobCreateFromWorkdir(
    id              : inout GitOID,
    repo            : OpaquePointer,
    relativePath    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withMutatingCValue
        {
            cID in
            
            return git_blob_create_from_workdir(
                cID,
                repo,
                relativePath
            )
        }
    }
}



/// Reads a file from the file system (not necessarily inside the working
/// directory of the given repository) and writes it to the object database.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the written
///   blob.
///   - repo: The repository in which to write the blob. The underlying type
///   must be `git_repository`. This repository may be bare.
///   - path: The path to the file from which to create the blob.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_disk()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_disk.html)
public func gitBlobCreateFromDisk(
    id      : inout GitOID,
    repo    : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withMutatingCValue
        {
            cID in
            
            return git_blob_create_from_disk(
                cID,
                repo,
                path
            )
        }
    }
}



/// Creates a stream to write a new blob into the object database.
/// - Parameters:
///   - out: The pointer in which to store the write stream.
///   - repo: The repository in which to write the blob. The underlying type
///   must be `git_repository`. This repository may be bare.
///   - hintPath: The path to use when selecting data filters to apply onto the
///   content of the blob to be created.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function may need to buffer the data on the disk and is generally not
/// the correct choice if the size of the data to write is known.
///
/// If the data is held in memory, use
/// ``gitBlobCreateFromBuffer(id:repo:buffer:len:)`` instead.
///
/// Otherwise, if the size of the contents are known (and filtering is not
/// needed), use ``gitODBOpenWStream(out:db:size:type:)`` instead.
///
/// - Important: Do not manually close this stream. Instead, pass it to
/// ``gitBlobCreateFromStreamCommit(out:stream:)`` to commit the write to the
/// object database and get the ID.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_stream()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_stream.html)
public func gitBlobCreateFromStream(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_writestream>?>,
    repo        : OpaquePointer,
    hintPath    : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_blob_create_from_stream(
            out,
            repo,
            hintPath
        )
    }
}



/// Closes the given stream and finalizes writing the blob to the object
/// database.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the new blob.
///   - stream: The stream to close.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_stream_commit()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_stream_commit.html)
public func gitBlobCreateFromStreamCommit(
    out     : inout GitOID,
    stream  : UnsafeMutablePointer<git_writestream>
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_blob_create_from_stream_commit(
                cOut,
                stream
            )
        }
    }
}



/// Writes in-memory data to the object database as a blob.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the written
///   blob.
///   - repo: The repository in which to write the blob. The underlying type
///   must be `git_repository`.
///   - buffer: The data to to write into the blob.
///   - len: The length of `buffer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blob_create_from_buffer()`](https://libgit2.org/docs/reference/main/blob/git_blob_create_from_buffer.html)
public func gitBlobCreateFromBuffer(
    id      : inout GitOID,
    repo    : OpaquePointer,
    buffer  : Data,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return try buffer.withCBuffer
            {
                cBuffer, cBufferCount in
                
                return git_blob_create_from_buffer(
                    cID,
                    repo,
                    cBuffer,
                    cBufferCount
                )
            }
        }
    }
}



/// Checks whether the blob content is most likely binary.
/// - Parameter blob: The blob to check. The underlying type must be `git_blob`.
/// - Returns: Whether the blob content is most likely binary.
///
/// ## Discussion
///
/// The heuristic used to guess whether a file is binary is taken from core Git
/// and involves searching for `NUL` bytes and looking for a reasonable ratio
/// of printable to non-printable characters among the first 8,000 bytes.
///
/// ## C Equivalent
///
/// [`git_blob_is_binary()`](https://libgit2.org/docs/reference/main/blob/git_blob_is_binary.html)
public func gitBlobIsBinary(
    blob: OpaquePointer
) -> Bool
{
    let blobIsBinary: Int32 = git_blob_is_binary(blob)
    
    return Bool(blobIsBinary)
}



/// Checks whether the given content is most likely binary.
/// - Parameters:
///   - data: The blob data to check.
///   - len: The length `data`.
/// - Returns: Whether the given content is most likely binary, or `nil` if
/// there was an error.
///
/// ## Discussion
///
/// The heuristic used to guess whether file content is binary is taken from
/// core Git and is the same mechanism used by ``gitBlobIsBinary(blob:)``, but
/// only looks at raw data.
///
/// ## C Equivalent
///
/// [`git_blob_data_is_binary()`](https://libgit2.org/docs/reference/main/blob/git_blob_data_is_binary.html)
public func gitBlobDataIsBinary(
    data    : Data,
    len     : Int
) -> Bool?
{
    guard !data.isEmpty
    else
    {
        /// Empty data is not binary.
        return false
    }
    
    return try? data.withCBuffer
    {
        cData, cDataCount in
        
        let blobDataIsBinary: Int32 = git_blob_data_is_binary(
            cData,
            cDataCount
        )
        
        return Bool(blobDataIsBinary)
    }
}



/// Creates an in-memory copy of the given blob.
/// - Parameters:
///   - out: The pointer in which to store the copied blob. The underlying
///   type must be `git_blob`.
///   - source: The blob to copy. The underlying type must be `git_blob`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_blob_dup()`](https://libgit2.org/docs/reference/main/blob/git_blob_dup.html)
public func gitBlobDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_blob_dup(
            out,
            source
        )
    }
}
