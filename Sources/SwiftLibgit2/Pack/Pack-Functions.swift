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



/// Creates a new packbuilder.
/// - Parameters:
///   - out: The pointer in which to store the packbuilder. The underlying
///   type must be `git_packbuilder`.
///   - repo: The repository in which to create the packbuilder. The underlying
///   type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_packbuilder_new()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_new.html)
public func gitPackbuilderNew(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_packbuilder_new(
            out,
            repo
        )
    }
}



/// Sets the number of threads to spawn.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - n: The number of threads to spawn.
/// - Returns: The actual number of threads used.
///
/// ## C Equivalent
///
/// [`git_packbuilder_set_threads()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_set_threads.html)
public func gitPackbuilderSetThreads(
    pb  : OpaquePointer,
    n   : UInt32
) -> UInt32
{
    return git_packbuilder_set_threads(
        pb,
        n
    )
}



/// Inserts the specified object into the specified packfile.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - id: The ID of the object to insert.
///   - name: The object reference name to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// For optimal packfiles, objects must be inserted in recency order: commits,
/// trees, then blobs.
///
/// ## C Equivalent
///
/// [`git_packbuilder_insert()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_insert.html)
public func gitPackbuilderInsert(
    pb      : OpaquePointer,
    id      : GitOID,
    name    : String?
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_packbuilder_insert(
            pb,
            &cID,
            name
        )
    }
}



/// Inserts the specified root tree into the specified packfile.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - id: The ID of the root tree to insert.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The tree and all referenced trees and blobs will be added to the specified
/// packfile.
///
/// ## C Equivalent
///
/// [`git_packbuilder_insert_tree()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_insert_tree.html)
public func gitPackbuilderInsertTree(
    pb  : OpaquePointer,
    id  : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_packbuilder_insert_tree(
            pb,
            &cID
        )
    }
}



/// Inserts the specified commit into the specified packfile.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - id: The ID of the commit to insert.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The commit and the completed referenced tree will be added to the
/// specified packfile.
///
/// ## C Equivalent
///
/// [`git_packbuilder_insert_commit()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_insert_commit.html)
public func gitPackbuilderInsertCommit(
    pb  : OpaquePointer,
    id  : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_packbuilder_insert_commit(
            pb,
            &cID
        )
    }
}



/// Inserts the objects of the given revwalk into the specified packfile.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - walk: The revwalk to use to fill the given packbuilder. The underlying
///   type must be `git_revwalk`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The commits and all referenced objects will be added to the specified
/// packfile.
///
/// ## C Equivalent
///
/// [`git_packbuilder_insert_walk()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_insert_walk.html)
public func gitPackbuilderInsertWalk(
    pb      : OpaquePointer,
    walk    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_packbuilder_insert_walk(
            pb,
            walk
        )
    }
}



/// Recursively inserts the given root object and its referenced objects into
/// the specified packfile.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - id: The ID of the root object to insert.
///   - name: The object reference name to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_packbuilder_insert_recur()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_insert_recur.html)
public func gitPackbuilderInsertRecur(
    pb      : OpaquePointer,
    id      : GitOID,
    name    : String?
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_packbuilder_insert_recur(
            pb,
            &cID,
            name
        )
    }
}



/// Writes the contents of the specified packfile to the given `Data` instance.
/// - Parameters:
///   - buf: The `Data` instance to update with the contents of the specified
///   packfile.
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The contents of `buf` will become a valid packfile,even though there will
/// be no attached index.
///
/// ## C Equivalent
///
/// [`git_packbuilder_write_buf()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_write_buf.html)
public func gitPackbuilderWriteBuf(
    buf : inout Data,
    pb  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try buf.withMutatingGitBuf
        {
            cBuf in
            
            return git_packbuilder_write_buf(
                cBuf,
                pb
            )
        }
    }
}



/// Writes the specified packfile and its corresponding index file to the
/// given path.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - path: The path to the directory in which to store the packfile and its
///   corresponding index file. Pass `nil` to use the default location.
///   - mode: The permissions to use when writing. Pass `0` for the default
///   permissions.
///   - progressCB: The callback to invoke with progress information.
///   - progressCBPayload: The payload to pass to `progressCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_packbuilder_write()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_write.html)
public func gitPackbuilderWrite(
    pb                  : OpaquePointer,
    path                : String?,
    mode                : UInt32,
    progressCB          : GitIndexerProgressCB?,
    progressCBPayload   : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_packbuilder_write(
            pb,
            path,
            mode,
            progressCB,
            progressCBPayload
        )
    }
}



/// Gets the ID of the specified packfile.
/// - Parameter pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
/// - Returns: The ID of the specified packfile.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``gitPackbuilderName(pb:)`` instead.
///
/// ## C Equivalent
///
/// [`git_packbuilder_hash()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_hash.html)
public func gitPackbuilderHash(
    pb: OpaquePointer
) -> GitOID?
{
    guard let packfileOID: UnsafePointer<git_oid> = git_packbuilder_hash(pb)
    else
    {
        return nil
    }
    
    return GitOID(cValue: packfileOID.pointee)
}



/// Gets the name of the specified packfile.
/// - Parameter pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
/// - Returns: The name of the specified packfile.
///
/// - Note: A packfile's name is derived from the its content. The name is
/// correct only after the packfile has been written.
///
/// ## C Equivalent
///
/// [`git_packbuilder_name()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_name.html)
public func gitPackbuilderName(
    pb: OpaquePointer
) -> String?
{
    let packfileName: UnsafePointer<CChar>? = git_packbuilder_name(pb)
    
    return String(optionalCString: packfileName)
}



/// Creates a new packfile and loops over each object in the packfile.
/// - Parameters:
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
///   - cb: The callback to invoke for each packed object.
///   - payload: The payload to pass to `cb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_packbuilder_foreach()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_foreach.html)
public func gitPackbuilderForEach(
    pb      : OpaquePointer,
    cb      : GitPackbuilderForEachCB,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_packbuilder_foreach(
            pb,
            cb,
            payload
        )
    }
}



/// Gets the number of objects that the specified packbuilder will write out.
/// - Parameter pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
/// - Returns: The number of objects that the specified packbuilder will
/// write out.
///
/// ## C Equivalent
///
/// [`git_packbuilder_object_count()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_object_count.html)
public func gitPackbuilderObjectCount(
    pb: OpaquePointer
) -> Int
{
    return git_packbuilder_object_count(pb)
}



/// Gets the number of objects that the specified packbuilder has already
/// written out.
/// - Parameter pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
/// - Returns: The number of objects that the specified packbuilder has already
/// written out.
///
/// ## C Equivalent
///
/// [`git_packbuilder_written()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_written.html)
public func gitPackbuilderWritten(
    pb: OpaquePointer
) -> Int
{
    return git_packbuilder_written(pb)
}



/// Sets the callbacks for the given packbuilder.
/// - Parameters:
///   - pb: The packbuilder to update. The underlying type must be
///   `git_packbuilder`.
///   - progressCB: The callback to invoke with progress notifications.
///   - progressCBPayload: The payload to pass to `progressCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_packbuilder_set_callbacks()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_set_callbacks.html)
public func gitPackbuilderSetCallbacks(
    pb                  : OpaquePointer,
    progressCB          : GitPackbuilderProgressCB,
    progressCBPayload   : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_packbuilder_set_callbacks(
            pb,
            progressCB,
            progressCBPayload
        )
    }
}



/// Frees the memory allocated for the given `git_packbuilder` instance.
/// - Parameter pb: The packbuilder to free. The underlying type must be
/// `git_packbuilder`.
///
/// ## C Equivalent
///
/// [`git_packbuilder_free()`](https://libgit2.org/docs/reference/main/pack/git_packbuilder_free.html)
public func gitPackbuilderFree(
    pb: OpaquePointer?
)
{
    guard let pb: OpaquePointer = pb
    else
    {
        return
    }
    
    git_packbuilder_free(pb)
}
