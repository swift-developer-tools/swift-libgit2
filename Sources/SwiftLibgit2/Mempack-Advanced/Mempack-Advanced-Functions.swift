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



/// Creates a new mempack backend.
/// - Parameter out: The pointer in which to store the mempack backend.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The mempack backend must be added to an existing object database with the
/// highest priority.
///
/// Once the mempack backend has been loaded, all writes to the object database
/// will instead be queued in memory, and can be finalized with
/// ``gitMempackDump(pack:repo:backend:)``. Subsequent reads will also be
/// served from the in-memory backend to ensure consistency, until the mempack
/// backend is dumped.
///
/// ## C Equivalent
///
/// [`git_mempack_new()`](https://libgit2.org/docs/reference/main/sys/mempack/git_mempack_new.html)
public func gitMempackNew(
    out: UnsafeMutablePointer<UnsafeMutablePointer<git_odb_backend>?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_mempack_new(out)
    }
}



/// Writes a thin packfile with the objects in the given mempack backend.
/// - Parameters:
///   - backend: The mempack backend to use.
///   - pb: The packbuilder to use. The underlying type must be
///   `git_packbuilder`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A thin packfile is a packfile that does not contain its transitive closure
/// of references. This is useful for efficiently distributing additions to a
/// repository over the network, but is also useful for the efficient bulk
/// addition of objects to a local repository.
///
/// This function performs the shallow insert operations into the given
/// packbuilder, but does not write the packfile to the disk. See
/// ``gitPackbuilderWriteBuf(buf:pb:)`` for more information.
///
/// - Note: This function does not reset the in-memory object database. Use
/// ``gitMempackReset(backend:)`` instead.
///
/// ## C Equivalent
///
/// [`git_mempack_write_thin_pack()`](https://libgit2.org/docs/reference/main/sys/mempack/git_mempack_write_thin_pack.html)
public func gitMempackWriteThinPack(
    backend : UnsafeMutablePointer<git_odb_backend>,
    pb      : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_mempack_write_thin_pack(
            backend,
            pb
        )
    }
}



/// Stores all the queued in-memory writes of the given mempack backend in a
/// raw packfile.
/// - Parameters:
///   - pack: The `Data` instance in which to store the raw packfile.
///   - repo: The repository in which the mempack backend is loaded.
///   - backend: The mempack backend to dump.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function does not make the written packfile available to the given
/// repository. It must be made available manually, for example, by writing it
/// to the disk.
///
/// Once the packfile is available to the repository, use
/// ``gitMempackReset(backend:)`` to clean up the memory store. Cleaning up the
/// memory store before the packfile has been written to the disk will result
/// in an inconsistent repository, since the objects in the memory store will
/// not be accessible.
///
/// ## C Equivalent
///
/// [`git_mempack_dump()`](https://libgit2.org/docs/reference/main/sys/mempack/git_mempack_dump.html)
public func gitMempackDump(
    pack    : inout Data,
    repo    : OpaquePointer,
    backend : UnsafeMutablePointer<git_odb_backend>
) -> GitErrorCode
{
    return withCConversion
    {
        return try pack.withMutatingGitBuf
        {
            cPack in
            
            return git_mempack_dump(
                cPack,
                repo,
                backend
            )
        }
    }
}



/// Clears all queued objects of the given mempack backend.
/// - Parameter backend: The mempack backend to reset.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function assumes that ``gitMempackDump(pack:repo:backend:)`` has been
/// called with the given mempack backend to store all the queued objects in
/// a single packfile.
///
/// Alternatively, call this function without a previous dump to undo all the
/// recently written objects.
///
/// ## C Equivalent
///
/// [`git_mempack_reset()`](https://libgit2.org/docs/reference/main/sys/mempack/git_mempack_reset.html)
public func gitMempackReset(
    backend: UnsafeMutablePointer<git_odb_backend>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_mempack_reset(backend)
    }
}



/// Gets the number of objects in the given mempack backend.
/// - Parameters:
///   - count: The `Int` instance in which to store the number of objects in
///   the given mempack backend.
///   - backend: The mempack backend to evaluate.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_mempack_object_count()`](https://libgit2.org/docs/reference/main/sys/mempack/git_mempack_object_count.html)
public func gitMempackObjectCount(
    count   : inout Int,
    backend : UnsafeMutablePointer<git_odb_backend>
) -> GitErrorCode
{
    return withCConversion
    {
        return count.withMutatingInt
        {
            cCount in
            
            return git_mempack_object_count(
                cCount,
                backend
            )
        }
    }
}
