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



/// Creates a new object database with no backends.
/// - Parameter odb: The pointer in which to store the object database. The
/// underlying type must be `git_odb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Before the ODB can be used for reading or writing, a custom database
/// backend must be manually added by calling
/// ``gitODBAddBackend(odb:backend:priority:)``.
///
/// - Note: This function supports only SHA-1 object databases.
///
/// ## C Equivalent
///
/// [`git_odb_new()`](https://libgit2.org/docs/reference/main/odb/git_odb_new.html)
public func gitODBNew(
    odb: UnsafeMutablePointer<OpaquePointer?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_new(odb)
    }
}



/// Creates a new obejct database, and automatically adds two default backends.
/// - Parameters:
///   - odbOut: The pointer in which to store the object database. The
/// underlying type must be `git_odb`.
///   - objectsDir: The path to the Objects directory of the backends.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The two default backends are:
///
/// - A backend for loose objects: Read and write loose object files from the
/// disk, assuming `objects_dir` is the Objects directory.
/// - A backend for packfiles: Read objects from packfiles, assuming
/// `objects_dir` is the Objects directory containing a `pack/` directory with
/// the corresponding data.
///
/// - Note: This function supports only SHA-1 object databases.
///
/// ## C Equivalent
///
/// [`git_odb_open()`](https://libgit2.org/docs/reference/main/odb/git_odb_open.html)
public func gitODBOpen(
    odbOut      : UnsafeMutablePointer<OpaquePointer?>,
    objectsDir  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_open(
            odbOut,
            objectsDir
        )
    }
}



/// Adds an on-disk alternate backend to the given object database.
/// - Parameters:
///   - odb: The object database to update. The underlying type must be
///   `git_odb`.
///   - path: The path to the Objects directory of the alternate backend.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Alternate backends are always checked for objects after all the main
/// backends have been checked. Writing is disabled on alternate backends.
///
/// ## C Equivalent
///
/// [`git_odb_add_disk_alternate()`](https://libgit2.org/docs/reference/main/odb/git_odb_add_disk_alternate.html)
public func gitODBAddDiskAlternate(
    odb     : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_add_disk_alternate(
            odb,
            path
        )
    }
}



/// Frees the memory allocated for the given `git_odb` instance.
/// - Parameter db: The object database to free. The underlying type must be
/// `git_odb`.
///
/// ## C Equivalent
///
/// [`git_odb_free()`](https://libgit2.org/docs/reference/main/odb/git_odb_free.html)
public func gitODBFree(
    db: OpaquePointer?
)
{
    guard let db: OpaquePointer = db
    else
    {
        return
    }
    
    git_odb_free(db)
}



/// Reads the specified object from the given object database.
/// - Parameters:
///   - obj: The pointer in which to store the read object. The underlying
///   type must be `git_odb_object`.
///   - db: The object database to search. The underlying type must be
///   `git_odb`.
///   - id: The ID of the object to read.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function will query all available object database backends.
///
/// ## C Equivalent
///
/// [`git_odb_read()`](https://libgit2.org/docs/reference/main/odb/git_odb_read.html)
public func gitODBRead(
    obj : UnsafeMutablePointer<OpaquePointer?>,
    db  : OpaquePointer,
    id  : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_odb_read(
            obj,
            db,
            &cID
        )
    }
}



// TODO: Replace `GIT_OID_MINPREFIXLEN` in documentation.
/// Reads the specified object from the given object database, using a prefix
/// of the object's ID.
/// - Parameters:
///   - obj: The pointer in which to store the read object. The underlying
///   type must be `git_odb_object`.
///   - db: The object database to search. The underlying type must be
///   `git_odb`.
///   - shortID: The prefix of the ID of the object to look up.
///   - len: The length of the object's ID prefix.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will try to match the first `len` hexadecimal characters of
/// the given ID. The remaining characters must be zeros.
///
/// `len` must be greater than or equal to `GIT_OID_MINPREFIXLEN`, and long
/// enough to identify a unique object matching the prefix.
///
/// - Note: This function will query all available object database backends.
///
/// ## C Equivalent
///
/// [`git_odb_read_prefix()`](https://libgit2.org/docs/reference/main/odb/git_odb_read_prefix.html)
public func gitODBReadPrefix(
    obj     : UnsafeMutablePointer<OpaquePointer?>,
    db      : OpaquePointer,
    shortID : GitOID,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        var cShortID: git_oid = shortID.cValue()
        
        return git_odb_read_prefix(
            obj,
            db,
            &cShortID,
            len
        )
    }
}



/// Reads the header of the specified object from the given object database,
/// without reading its full contents.
/// - Parameters:
///   - lenOut: The pointer in which to store the header length.
///   - typeOut: The ``GitObjectT`` instance in which to store the header type.
///   - db: The object database to search. The underlying type must be
///   `git_odb`.
///   - id: The ID of the object to read.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: Most backends do not support reading only the header of an object,
/// so the whole object will be read.
///
/// ## C Equivalent
///
/// [`git_odb_read_header()`](https://libgit2.org/docs/reference/main/odb/git_odb_read_header.html)
public func gitODBReadHeader(
    lenOut  : UnsafeMutablePointer<Int>,
    typeOut : inout GitObjectT,
    db      : OpaquePointer,
    id      : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return typeOut.withMutatingCValue
        {
            cTypeOut in
            
            var cID: git_oid = id.cValue()
            
            return git_odb_read_header(
                lenOut,
                cTypeOut,
                db,
                &cID
            )
        }
    }
}



/// Checks whether the specified object can be found in the object database.
/// - Parameters:
///   - db: The object for which to search. The underlying type must be
///   `git_odb`.
///   - id: The ID of the object for which to search.
/// - Returns: Whether the given object can be found in the object database.
///
/// ## C Equivalent
///
/// [`git_odb_exists()`](https://libgit2.org/docs/reference/main/odb/git_odb_exists.html)
public func gitODBExists(
    db  : OpaquePointer,
    id  : GitOID
) -> Bool
{
    var cID: git_oid = id.cValue()
    
    let odbExists: Int32 = git_odb_exists(
        db,
        &cID
    )
    
    return Bool(odbExists)
}



/// Checks whether the specified object can be found in the object database.
/// - Parameters:
///   - db: The object for which to search. The underlying type must be
///   `git_odb`.
///   - id: The ID of the object for which to search.
///   - flags: The flags controlling the behavior of the object database lookup.
/// - Returns: Whether the given object can be found in the object database.
///
/// ## C Equivalent
///
/// [`git_odb_exists_ext()`](https://libgit2.org/docs/reference/main/odb/git_odb_exists_ext.html)
public func gitODBExistsExt(
    db      : OpaquePointer,
    id      : GitOID,
    flags   : GitODBLookupFlagsT
) -> Bool
{
    var cID: git_oid = id.cValue()
    
    let odbExists: Int32 = git_odb_exists_ext(
        db,
        &cID,
        flags.rawValue
    )
    
    return Bool(odbExists)
}



// TODO: Replace `GIT_OID_MINPREFIXLEN` in documentation.
/// Checks whether the specified object can be found the given object database,
/// using a prefix of the object's ID.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the full ID of the found
///   object.
///   - db: The object database to search. The underlying type must be
///   `git_odb`.
///   - shortID: The prefix of the ID of the object to look up.
///   - len: The length of the object's ID prefix.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will try to match the first `len` hexadecimal characters of
/// the given ID. The remaining characters must be zeros.
///
/// `len` must be greater than or equal to `GIT_OID_MINPREFIXLEN`, and long
/// enough to identify a unique object matching the prefix.
///
/// - Note: This function will query all available object database backends.
///
/// ## C Equivalent
///
/// [`git_odb_exists_prefix()`](https://libgit2.org/docs/reference/main/odb/git_odb_exists_prefix.html)
public func gitODBExistsPrefix(
    out     : inout GitOID,
    db      : OpaquePointer,
    shortID : GitOID,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            var cShortID: git_oid = shortID.cValue()
            
            return git_odb_exists_prefix(
                cOut,
                db,
                &cShortID,
                len
            )
        }
    }
}



/// Checks whether one or more objects can be found in the given object
/// database by their abbreviated object IDs and types.
/// - Parameters:
///   - db: The object database to search. The underlying type must be
///   `git_odb`.
///   - ids: The array of ``GitODBExpandID`` instances for which to search.
///   - count: The length of `ids`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// For each abbreviated ID in the given array that is unique in the object
/// database, and of the specified type, the full object ID and type will be
/// written back to the array. If an ID is not found in the object database,
/// or it is ambiguous, the corresponding ``GitODBExpandID`` array element
/// will have its properties set to the default values.
///
/// - Note: Since this function operates on multiple objects, the underlying
/// object database will not be reloaded if an object is not found, unlike
/// other object database operations.
///
/// ## C Equivalent
///
/// [`git_odb_expand_ids()`](https://libgit2.org/docs/reference/main/odb/git_odb_expand_ids.html)
public func gitODBExpandIDs(
    db      : OpaquePointer,
    ids     : inout [GitODBExpandID],
    count   : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try ids.withMutatingArrayOfGitODBExpandIDs
        {
            cIDs, cIDsCount in
            
            return git_odb_expand_ids(
                db,
                cIDs,
                cIDsCount
            )
        }
    }
}



/// Refreshes the given object database to load newly added files.
/// - Parameter db: The object database to refresh. The underlying type must
/// be `git_odb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will force a reload of the underlying indices if the on-disk
/// object databases have changed while libgit2.
///
/// - Note: It is generally unnecessary to call this function. libgit2 will
/// automatically attempt to refresh the object database when a lookup fails,
/// to check whether the object exists on-disk but has not been loaded yet.
///
/// ## C Equivalent
///
/// [`git_odb_refresh()`](https://libgit2.org/docs/reference/main/odb/git_odb_refresh.html)
public func gitODBRefresh(
    db: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_refresh(db)
    }
}



/// Loops over all objects available in the given object database.
/// - Parameters:
///   - db: The object database to search. The underlying type must be
///   `git_odb`.
///   - cb: The callback to invoke for each object.
///   - payload: The payload to pass to `cb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The objects in the given object database will most likely be iterated in
/// the index order. Accessing objects in that order is generally inefficient.
///
/// ## C Equivalent
///
/// [`git_note_foreach()`](https://libgit2.org/docs/reference/main/notes/git_note_foreach.html)
public func gitODBForEach(
    db:         OpaquePointer,
    cb:         GitODBForEachCB?,
    payload:    UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_foreach(
            db,
            cb,
            payload
        )
    }
}



/// Writes the specified object into the given object database.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the write
///   operation.
///   - odb: The object database to update. The underlying type must be
///   `git_odb`.
///   - data: The object data to store.
///   - len: The length of `data`.
///   - type: The type of object to store.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// In most cases, it is preferrable to write objects to an object database
/// using a write stream, which is both faster and less memory intensive,
/// especially for larger objects.
///
/// This function is best used with custom backends which are not able to
/// support write streams.
///
/// ## C Equivalent
///
/// [`git_odb_write()`](https://libgit2.org/docs/reference/main/odb/git_odb_write.html)
public func gitODBWrite(
    out     : inout GitOID,
    odb     : OpaquePointer,
    data    : Data,
    len     : Int,
    type    : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try data.withCBuffer
            {
                cData, cDataCount in
                
                return git_odb_write(
                    cOut,
                    odb,
                    cData,
                    cDataCount,
                    type.cValue()
                )
            }
        }
    }
}



// TODO: Replace `GIT_STREAM_WRONLY` in documentation.
/// Opens a stream to write an object into the given object database.
/// - Parameters:
///   - out: The pointer in which to store the stream.
///   - db: The object database to update. The underlying type must be
///   `git_odb`.
///   - size: The final size of the object to write.
///   - type: The type of the object to write.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The type of the resulting stream will be `GIT_STREAM_WRONLY`, and it
/// will not be effective until ``gitODBStreamFinalizeWrite(out:stream:)``
/// is successfully called.
///
/// ## C Equivalent
///
/// [`git_odb_open_wstream()`](https://libgit2.org/docs/reference/main/odb/git_odb_open_wstream.html)
public func gitODBOpenWStream(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_odb_stream>?>,
    db      : OpaquePointer,
    size    : GitObjectSizeT,
    type    : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_open_wstream(
            out,
            db,
            size,
            type.cValue()
        )
    }
}



/// Writes to the given object database stream.
/// - Parameters:
///   - stream: The stream in which to write.
///   - buffer: The data to write.
///   - len: The length of `buffer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: The write operation will fail if if total number of received bytes
/// exceeds the size declared with ``gitODBOpenWStream(out:db:size:type:)``.
///
/// ## C Equivalent
///
/// [`git_odb_stream_write()`](https://libgit2.org/docs/reference/main/odb/git_odb_stream_write.html)
public func gitODBStreamWrite(
    stream  : UnsafeMutablePointer<git_odb_stream>,
    buffer  : Data,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try buffer.withCBuffer
        {
            cBuffer, cBufferCount in
            
            return git_odb_stream_write(
                stream,
                cBuffer,
                cBufferCount
            )
        }
    }
}



/// Finishes writing to an object database stream.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the write
///   operation.
///   - stream: The stream to finalize.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// After the finalization operation successfully completes, the object will
/// take its final name and will be available to the object database.
///
/// - Note: The finalization operation will fail if if total number of received
/// bytes exceeds the size declared with
/// ``gitODBOpenWStream(out:db:size:type:)``.
///
/// ## C Equivalent
///
/// [`git_odb_stream_finalize_write()`](https://libgit2.org/docs/reference/main/odb/git_odb_stream_finalize_write.html)
public func gitODBStreamFinalizeWrite(
    out     : inout GitOID,
    stream  : UnsafeMutablePointer<git_odb_stream>
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_odb_stream_finalize_write(
                cOut,
                stream
            )
        }
    }
}



/// Reads from the given object database stream.
/// - Parameters:
///   - stream: The stream to read.
///   - buffer: The buffer in which to store the read data.
///   - len: The length of `buffer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: Most backends do not implement streaming reads.
///
/// ## C Equivalent
///
/// [`git_odb_stream_read()`](https://libgit2.org/docs/reference/main/odb/git_odb_stream_read.html)
public func gitODBStreamRead(
    stream  : UnsafeMutablePointer<git_odb_stream>,
    buffer  : UnsafeMutablePointer<CChar>,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_stream_read(
            stream,
            buffer,
            len
        )
    }
}



// TODO: Replace second `git_odb_stream` with ``GitODBStream`` in documentation note.
/// Frees the memory allocated for the given `git_odb_stream` instance.
/// - Parameter stream: The stream to free.
///
/// ## Discussion
///
/// - Note: This function is only needed when working directly with
/// `git_odb_stream` instances allocated by libgit2. `git_odb_stream`
/// instances do not need to be freed.
///
/// ## C Equivalent
///
/// [`git_odb_stream_free()`](https://libgit2.org/docs/reference/main/odb/git_odb_stream_free.html)
public func gitODBStreamFree(
    stream: UnsafeMutablePointer<git_odb_stream>?
)
{
    guard let stream: UnsafeMutablePointer<git_odb_stream> = stream
    else
    {
        return
    }
    
    git_odb_stream_free(stream)
}



// TODO: Replace `GIT_STREAM_WRONLY` in documentation.
/// Opens a stream to read the specified object from the given object database.
/// - Parameters:
///   - out: The pointer in which to store the stream.
///   - len: The pointer in which to store the length of the object.
///   - type: The ``GitObjectT`` instance in which to store the object type.
///   - db: The object database to read. The underlying type must be
///   `git_odb`.
///   - oid: The ID of the object to read.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The type of the resulting stream will be `GIT_STREAM_RONLY`, and will
/// have `read()` and `free()` methods.
///
/// - Note: Most backends do not support streaming reads, since the objects are
/// stored as compressed/delta blobs. Use ``gitODBRead(obj:db:id:)`` instead.
///
/// ## C Equivalent
///
/// [`git_odb_open_rstream()`](https://libgit2.org/docs/reference/main/odb/git_odb_open_rstream.html)
public func gitODBOpenRStream(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_odb_stream>?>,
    len     : UnsafeMutablePointer<Int>,
    type    : inout GitObjectT,
    db      : OpaquePointer,
    oid     : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return type.withMutatingCValue
        {
            cType in
            
            var cOID: git_oid = oid.cValue()
            
            return git_odb_open_rstream(
                out,
                len,
                cType,
                db,
                &cOID
            )
        }
    }
}



/// Opens a stream for writing the given packfile to the given object
/// database.
/// - Parameters:
///   - out: The writepack functions.
///   - db: The object database to read. The underlying type must be `git_odb`.
///   - progressCB: The callback to invoke with progress information.
///   - progressPayload: The payload to pass to `progressCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the object database layer understands pack files, then the given
/// packfile will most likely be streamed directly to the disk, and a
/// corresponding index will be created. Otherwise, the objects will be
/// stored in the format used by the object database layer.
///
/// - Note: The callback will be invoked inline with network operations and
/// indexing operations, and may affect performance.
///
/// ## C Equivalent
///
/// [`git_odb_write_pack()`](https://libgit2.org/docs/reference/main/odb/git_odb_write_pack.html)
public func gitODBWritePack(
    out             : UnsafeMutablePointer<UnsafeMutablePointer<git_odb_writepack>?>,
    db              : OpaquePointer,
    progressCB      : GitIndexerProgressCB?,
    progressPayload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_write_pack(
            out,
            db,
            progressCB,
            progressPayload
        )
    }
}



/// Writes a `multi-pack-index` file from all the `.pack` files in the given
/// object database.
/// - Parameter db: The object database to update. The underlying type must be
/// `git_odb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the object database layer understands pack files, then a file called
/// `multi-pack-index` will be created next to the `.pack` and `.idx` files.
/// The created file will contain an index of all the objects stored in `.pack`
/// files. This enables `O(log(n))` lookups, regardless of the number of
/// packfiles.
///
/// ## C Equivalent
///
/// [`git_odb_write_multi_pack_index()`](https://libgit2.org/docs/reference/main/odb/git_odb_write_multi_pack_index.html)
public func gitODBWriteMultiPackIndex(
    db: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_write_multi_pack_index(db)
    }
}



/// Gets the object ID of the given data buffer.
/// - Parameters:
///   - oid: The ``GitOID`` instance in which to store the object ID.
///   - data: The data to hash.
///   - len: The length of `data`.
///   - objectType: The type of object to hash.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting ID will be the identifier of the given data buffer as if
/// the data buffer were written to the object database.
///
/// ## C Equivalent
///
/// [`git_odb_hash()`](https://libgit2.org/docs/reference/main/odb/git_odb_hash.html)
public func gitODBHash(
    oid         : inout GitOID,
    data        : Data,
    len         : Int,
    objectType  : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return try oid.withMutatingCValue
        {
            cOID in
            
            return try data.withCBuffer
            {
                cData, cDataCount in
                
                return git_odb_hash(
                    cOID,
                    cData,
                    cDataCount,
                    objectType.cValue()
                )
            }
        }
    }
}



// TODO: Replace `git_repository_hashfile()` in documentation.
/// Reads the specified file from the disk and gets the ID that the file would
/// have, if it were written to the object database as an object of the given
/// type, without applying filters.
/// - Parameters:
///   - oid: The ``GitOID`` instance in which to store the object ID.
///   - path: The path to the file to read.
///   - objectType: The type of object to hash.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is similar to `git hash-object --no-filters`.
///
/// - Note: To apply filters, use `git_repository_hashfile()` instead.
///
/// ## C Equivalent
///
/// [`git_odb_hashfile()`](https://libgit2.org/docs/reference/main/odb/git_odb_hashfile.html)
public func gitODBHashFile(
    oid         : inout GitOID,
    path        : String,
    objectType  : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return oid.withMutatingCValue
        {
            cOID in
            
            return git_odb_hashfile(
                cOID,
                path,
                objectType.cValue()
            )
        }
    }
}



/// Creates an in-memory copy of the given database object.
/// - Parameters:
///   - dest: The pointer in which to store the copied database object. The
///   underlying type must be `git_odb_object`.
///   - source: The database object to copy. The underlying type must be
///   `git_odb_object`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_object_dup()`](https://libgit2.org/docs/reference/main/object/git_object_dup.html)
public func gitODBObjectDup(
    dest    : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_object_dup(
            dest,
            source
        )
    }
}



/// Frees the memory allocated for the given `git_odb_object` instance.
/// - Parameter object: The database object to free. The underlying type must
/// be `git_odb_object`.
///
/// ## C Equivalent
///
/// [`git_odb_object_free()`](https://libgit2.org/docs/reference/main/odb/git_odb_object_free.html)
public func gitODBObjectFree(
    object: OpaquePointer?
)
{
    guard let object: OpaquePointer = object
    else
    {
        return
    }
    
    git_odb_object_free(object)
}



/// Gets the ID of the given database object.
/// - Parameter object: The database object for which to get the ID. The
/// underlying type must be `git_odb_object`.
/// - Returns: The ID of the given database object.
///
/// ## C Equivalent
///
/// [`git_odb_object_id()`](https://libgit2.org/docs/reference/main/odb/git_odb_object_id.html)
public func gitODBObjectID(
    object: OpaquePointer
) -> GitOID
{
    let databaseObjectOID: UnsafePointer<git_oid> = git_odb_object_id(object)
    
    return GitOID(cValue: databaseObjectOID.pointee)
}



/// Gets the raw content of the given database object.
/// - Parameter object: The database object for which to get the raw content.
/// The underlying type must be `git_odb_object`.
/// - Returns: The raw content of the given database object.
///
/// ## Discussion
///
/// The raw content of a database object is the uncompressed, raw data as read
/// from the object database, without the leading header.
///
/// ## C Equivalent
///
/// [`git_odb_object_data()`](https://libgit2.org/docs/reference/main/odb/git_odb_object_data.html)
public func gitODBObjectData(
    object: OpaquePointer
) -> Data?
{
    guard let objectData: UnsafeRawPointer = git_odb_object_data(object)
    else
    {
        return nil
    }
    
    let objectSize: Int = gitODBObjectSize(object: object)
    
    return Data(
        bytes:  objectData,
        count:  objectSize
    )
}



/// Gets the size of the `data` buffer of the given database object.
/// - Parameter object: The database object for which to get the size. The
/// underlying type must be `git_odb_object`.
/// - Returns: The size of the `data` buffer of the given database object.
///
/// ## C Equivalent
///
/// [`git_odb_object_size()`](https://libgit2.org/docs/reference/main/odb/git_odb_object_size.html)
public func gitODBObjectSize(
    object: OpaquePointer
) -> Int
{
    return git_odb_object_size(object)
}



/// Gets the type of the given database object.
/// - Parameter object: The database object for which to get the type. The
/// underlying type must be `git_odb_object`.
/// - Returns: The type of the given database object.
///
/// ## C Equivalent
///
/// [`git_odb_object_type()`](https://libgit2.org/docs/reference/main/odb/git_odb_object_type.html)
public func gitODBObjectType(
    object: OpaquePointer
) -> GitObjectT?
{
    let objectType: git_object_t = git_odb_object_type(object)
    
    return GitObjectT(cValue: objectType)
}



/// Adds the given backend to the given object database.
/// - Parameters:
///   - odb: The object database to update. The underlying type must be
///   `git_odb`.
///   - backend: The backend to add.
///   - priority: The priority for ordering the backends queue.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_odb_add_backend()`](https://libgit2.org/docs/reference/main/odb/git_odb_add_backend.html)
public func gitODBAddBackend(
    odb         : OpaquePointer,
    backend     : UnsafeMutablePointer<git_odb_backend>,
    priority    : Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_add_backend(
            odb,
            backend,
            priority
        )
    }
}



/// Adds the given alternate backend to the given object database.
/// - Parameters:
///   - odb: The object database to update. The underlying type must be
///   `git_odb`.
///   - backend: The alternate backend to add.
///   - priority: The priority for ordering the backends queue.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Alternate backends are always checked for objects after all the main
/// backends have been checked. Writing is disabled on alternate backends.
///
/// ## C Equivalent
///
/// [`git_odb_add_alternate()`](https://libgit2.org/docs/reference/main/odb/git_odb_add_alternate.html)
public func gitODBAddAlternate(
    odb         : OpaquePointer,
    backend     : UnsafeMutablePointer<git_odb_backend>,
    priority    : Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_add_alternate(
            odb,
            backend,
            priority
        )
    }
}



/// Gets the number of backend objects in the given object database.
/// - Parameter odb: The object database to check. The underlying type must be
/// `git_odb`.
/// - Returns: The number of backend objects in the given object database.
///
/// ## C Equivalent
///
/// [`git_odb_num_backends()`](https://libgit2.org/docs/reference/main/odb/git_odb_num_backends.html)
public func gitODBNumBackends(
    odb: OpaquePointer
) -> Int
{
    return git_odb_num_backends(odb)
}



/// Looks up the specified backend object in the given object database.
/// - Parameters:
///   - out: The pointer in which to store the backend object.
///   - odb: The object database to search. The underlying type must be
/// `git_odb`.
///   - pos: The index of the backend object in the backend list.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_odb_get_backend()`](https://libgit2.org/docs/reference/main/odb/git_odb_get_backend.html)
public func gitODBGetBackend(
    out : UnsafeMutablePointer<UnsafeMutablePointer<git_odb_backend>?>,
    odb : OpaquePointer,
    pos : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_get_backend(
            out,
            odb,
            pos
        )
    }
}



/// Sets the given commit graph for the given object database.
/// - Parameters:
///   - odb: The object database to update. The underlying type must be
///   `git_odb`.
///   - cGraph: The commit graph to set. The underlying type must be
///   `git_commit_graph`. Pass `nil` to unset the commit graph.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: If the operation succeeds, ownership of the given commit graph
/// will be transferred to libgit2. The caller must not free it.
///
/// ## C Equivalent
///
/// [`git_odb_set_commit_graph()`](https://libgit2.org/docs/reference/main/odb/git_odb_set_commit_graph.html)
public func gitODBSetCommitGraph(
    odb     : OpaquePointer,
    cGraph  : OpaquePointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_set_commit_graph(
            odb,
            cGraph
        )
    }
}
