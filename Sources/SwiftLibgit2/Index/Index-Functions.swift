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



// TODO: Replace `git_repository_index()` in documentation.
/// Creates a new bare index as an in-memory representation of the index at the given path.
/// - Parameters:
///   - indexOut: The pointer in which to store the index. The underlying type must be `git_index`.
///   - indexPath: The path to the on-disk index.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Since there is no object database or working directory behind the resulting index, any index APIs
/// which rely on these will fail with the ``GitErrorCode/gitError`` result code.
///
/// To access the index of an actual repository, use `git_repository_index()` instead.
///
/// - Note: This function supports only SHA-1 indices.
///
/// ## C Equivalent
///
/// [`git_index_open()`](https://libgit2.org/docs/reference/main/index/git_index_open.html)
public func gitIndexOpen(
    indexOut    : UnsafeMutablePointer<OpaquePointer?>,
    indexPath   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_open(
            indexOut,
            indexPath
        )
    }
}



/// Creates an in-memory index.
/// - Parameter indexOut: The pointer in which to store the index. The underlying type must be
/// `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting index cannot be read or written to the file system, but may be used to perform in-memory
/// index operations.
///
/// - Note: This function supports only SHA-1 indices.
///
/// ## C Equivalent
///
/// [`git_index_new()`](https://libgit2.org/docs/reference/main/index/git_index_new.html)
public func gitIndexNew(
    indexOut: UnsafeMutablePointer<OpaquePointer?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_new(indexOut)
    }
}



/// Frees the memory allocated for the given `git_index` instance.
/// - Parameter index: The index to free. The underlying type must be `git_index`.
///
/// ## C Equivalent
///
/// [`git_index_free()`](https://libgit2.org/docs/reference/main/index/git_index_free.html)
public func gitIndexFree(
    index: OpaquePointer?
)
{
    git_index_free(index)
}



/// Gets the repository that is related to the given index.
/// - Parameter index: The index. The underlying type must be `git_index`.
/// - Returns: A pointer to the repository that is related to the given index.
///
/// ## C Equivalent
///
/// [`git_index_owner()`](https://libgit2.org/docs/reference/main/index/git_index_owner.html)
public func gitIndexOwner(
    index: OpaquePointer
) -> OpaquePointer
{
    return git_index_owner(index)
}



/// Gets the system capabilities of the given index.
/// - Parameter index: The index to evaluate. The underlying type must be `git_index`.
/// - Returns: The system capabilities of the given index.
///
/// ## Discussion
///
/// This function will return `nil` if an unexpected value is encountered.
///
/// ## C Equivalent
///
/// [`git_index_caps()`](https://libgit2.org/docs/reference/main/index/git_index_caps.html)
public func gitIndexCaps(
    index: OpaquePointer
) -> GitIndexCapabilityT?
{
    return GitIndexCapabilityT(rawValue: git_index_caps(index))
}



/// Sets the system capabilities of the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - caps: The system capabilities to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If ``GitIndexCapabilityT/gitIndexCapabilityFromOwner`` is passed for the system
/// capabilities, then the capabilities will be read from the configuration of the owner, looking at
/// `core.ignorecase`, `core.filemode`, and `core.symlinks`.
///
/// ## C Equivalent
///
/// [`git_index_set_caps()`](https://libgit2.org/docs/reference/main/index/git_index_set_caps.html)
public func gitIndexSetCaps(
    index   : OpaquePointer,
    caps    : GitIndexCapabilityT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_set_caps(
            index,
            caps.rawValue
        )
    }
}



/// Gets the on-disk index version.
/// - Parameter index: The index to evaluate. The underlying type must be `git_index`.
/// - Returns: The on-disk index version.
///
/// ## Discussion
///
/// Valid return values are `2`, `3`, or `4`. If `3` is returned, an index with version `2` may be written
/// instead, if the extension data in version `3` is not necessary.
///
/// ## C Equivalent
///
/// [`git_index_version()`](https://libgit2.org/docs/reference/main/index/git_index_version.html)
public func gitIndexVersion(
    index: OpaquePointer
) -> UInt32
{
    return git_index_version(index)
}




/// Sets the on-disk index version.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - version: The version to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Valid versions are `2`, `3`, or `4`. If the version is `2`, ``gitIndexWrite(index:)`` may
/// write an index with version `3` instead, if necessary to accurately represent the index.
///
/// ## C Equivalent
///
/// [`git_index_set_version()`](https://libgit2.org/docs/reference/main/index/git_index_set_version.html)
public func gitIndexSetVersion(
    index   : OpaquePointer,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_set_version(
            index,
            version
        )
    }
}



/// Updates the contents of the given index in memory, by reading from the disk.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - force: Whether the index should always be reloaded.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If `force` is `true`, this function performs a "hard" read that discards in-memory changes and
/// always reloads the on-disk index data. If there is no on-disk version, the index will be cleared.
///
/// If `force` is `false`, this function performs a "soft" read that reloads the index data from disk only
/// if it has changed since the last time it was loaded. Purely in-memory index data will be untouched, unless
/// there are changes on the disk, in which case unwritten in-memory changes will be discarded.
///
/// ## C Equivalent
///
/// [`git_index_read()`](https://libgit2.org/docs/reference/main/index/git_index_read.html)
public func gitIndexRead(
    index   : OpaquePointer,
    force   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_read(
            index,
            force.intValue
        )
    }
}



/// Writes the given index from memory back to the disk, using an atomic file lock.
/// - Parameter index: The index to write. The underlying type must be `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_write()`](https://libgit2.org/docs/reference/main/index/git_index_write.html)
public func gitIndexWrite(
    index: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_write(index)
    }
}



/// Gets the full path to the on-disk index.
/// - Parameter index: The index to evaluate. The underlying type must be `git_index`.
/// - Returns: The full path to the on-disk index.
///
/// ## Discussion
///
/// This function will return `nil` if the given index is an in-memory index.
///
/// ## C Equivalent
///
/// [`git_index_path()`](https://libgit2.org/docs/reference/main/index/git_index_path.html)
public func gitIndexPath(
    index: OpaquePointer
) -> String?
{
    return String(optionalCString: git_index_path(index))
}



/// Gets the checksum of the given index.
/// - Parameter index: The index to evaluate. The underlying type must be `git_index`.
/// - Returns: The checksum of the given index.
///
/// ## Discussion
///
/// The returned checksum is the SHA-1 hash over the index file (except the last 20 bytes which are the
/// checksum itself). In cases where the index does not exist on-disk, it will be zeroed out.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next major release.
/// There is no replacement function.
///
/// ## C Equivalent
///
/// [`git_index_checksum()`](https://libgit2.org/docs/reference/main/index/git_index_checksum.html)
public func gitIndexChecksum(
    index: OpaquePointer
) -> GitOID
{
    return GitOID(cValue: git_index_checksum(index).pointee)
}



/// Reads the given tree into the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - tree: The tree to read.  The underlying type must be `git_tree`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The current index contents will be replaced by the given tree.
///
/// ## C Equivalent
///
/// [`git_index_read_tree()`](https://libgit2.org/docs/reference/main/index/git_index_read_tree.html)
public func gitIndexReadTree(
    index   : OpaquePointer,
    tree    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_read_tree(
            index,
            tree
        )
    }
}



/// Writes the given index as a tree.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the written tree.
///   - index: The index to write. The underlying type must be `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will scan the given index and write a representation of its current state back to the disk. It
/// recursively creates tree objects for each of the subtrees stored in the index, but only returns the OID of
/// the root tree. The resulting OID can be used for operations such as creating a commit.
///
/// The given index cannot be bare, must be associated with an existing repository, and must not contain
/// any conflicted files.
///
/// ## C Equivalent
///
/// [`git_index_write_tree()`](https://libgit2.org/docs/reference/main/index/git_index_write_tree.html)
public func gitIndexWriteTree(
    out     : inout GitOID,
    index   : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_index_write_tree(
                cOut,
                index
            )
        }
    }
}



/// Writes the given index as a tree in the given repository.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the written tree.
///   - index: The index to write. The underlying type must be `git_index`.
///   - repo: The repository in which to write the tree. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function behaves the same as ``gitIndexWriteTree(out:index:)``, but allows the
/// caller to choose the repository in which the given tree should be written.
///
/// The given index instance cannot be bare, must be associated with an existing repository, and must not
/// contain any conflicted files.
///
/// ## C Equivalent
///
/// [`git_index_write_tree_to()`](https://libgit2.org/docs/reference/main/index/git_index_write_tree_to.html)
public func gitIndexWriteTreeTo(
    out     : inout GitOID,
    index   : OpaquePointer,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_index_write_tree_to(
                cOut,
                index,
                repo
            )
        }
    }
}



/// Gets the number of entries in the given index.
/// - Parameter index: The index to evaluate. The underlying type must be `git_index`.
/// - Returns: The number of entries in the given index.
///
/// ## C Equivalent
///
/// [`git_index_entrycount()`](https://libgit2.org/docs/reference/main/index/git_index_entrycount.html)
public func gitIndexEntryCount(
    index: OpaquePointer
) -> Int
{
    return git_index_entrycount(index)
}



/// Clears the entries of the given index.
/// - Parameter index: The index to clear. The underlying type must be `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function clears the in-memory index. Changes must be explicitly written to the disk to be persisted.
///
/// ## C Equivalent
///
/// [`git_index_clear()`](https://libgit2.org/docs/reference/main/index/git_index_clear.html)
public func gitIndexClear(
    index: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_clear(index)
    }
}



/// Gets the entry at the given position within the given index.
/// - Parameters:
///   - index: The index to search. The underlying type must be `git_index`.
///   - n: The position of the entry within the given index.
/// - Returns: A ``GitIndexEntry`` instance.
///
/// ## C Equivalent
///
/// [`git_index_get_byindex()`](https://libgit2.org/docs/reference/main/index/git_index_get_byindex.html)
public func gitIndexGetByIndex(
    index   : OpaquePointer,
    n       : Int
) -> GitIndexEntry?
{
    /// The entry is owned by libgit2 and does not need to be freed.
    guard let indexEntryPointer: UnsafePointer<git_index_entry>
            = git_index_get_byindex(
                index,
                n
            )
    else
    {
        return nil
    }
    
    return GitIndexEntry(cValue: indexEntryPointer.pointee)
}



/// Gets the entry at the given path and stage within the given index.
/// - Parameters:
///   - index: The index to search. The underlying type must be `git_index`.
///   - path: The path to the entry.
///   - stage: The stage to search.
/// - Returns: A ``GitIndexEntry`` instance.
///
/// ## C Equivalent
///
/// [`git_index_get_bypath()`](https://libgit2.org/docs/reference/main/index/git_index_get_bypath.html)
public func gitIndexGetByPath(
    index   : OpaquePointer,
    path    : String,
    stage   : GitIndexStageT
) -> GitIndexEntry?
{
    /// The entry is owned by libgit2 and does not need to be freed.
    guard let indexEntryPointer: UnsafePointer<git_index_entry>
            = git_index_get_bypath(
                index,
                path,
                stage.rawValue
            )
    else
    {
        return nil
    }
    
    return GitIndexEntry(cValue: indexEntryPointer.pointee)
}



/// Removes the entry at the given path and stage from the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - path: The path to the entry.
///   - stage: The stage to search.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_remove()`](https://libgit2.org/docs/reference/main/index/git_index_remove.html)
public func gitIndexRemove(
    index   : OpaquePointer,
    path    : String,
    stage   : GitIndexStageT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_remove(
            index,
            path,
            stage.rawValue
        )
    }
}



/// Removes all entries in the given directory and stage from the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - dir: The path to the directory.
///   - stage: The stage to search.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_remove_directory()`](https://libgit2.org/docs/reference/main/index/git_index_remove_directory.html)
public func gitIndexRemoveDirectory(
    index   : OpaquePointer,
    dir     : String,
    stage   : GitIndexStageT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_remove_directory(
            index,
            dir,
            stage.rawValue
        )
    }
}



/// Adds the given index entry to the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - sourceEntry: The new index entry.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If a previous index entry exists that has the same path and stage as the given index entry, it will be
/// replaced. Otherwise, the index entry will be added.
///
/// A full copy of the index entry (including the path) will be inserted on the index.
///
/// ## C Equivalent
///
/// [`git_index_add()`](https://libgit2.org/docs/reference/main/index/git_index_add.html)
public func gitIndexAdd(
    index       : OpaquePointer,
    sourceEntry : GitIndexEntry
) -> GitErrorCode
{
    return withCConversion
    {
        return sourceEntry.withCValue
        {
            cSourceEntry in
            
            return git_index_add(
                index,
                cSourceEntry
            )
        }
    }
}



/// Gets the stage from the given index entry.
/// - Parameter entry: The index entry to evaluate.
/// - Returns: A ``GitIndexStageT`` instance.
///
/// ## C Equivalent
///
/// [`git_index_entry_stage()`](https://libgit2.org/docs/reference/main/index/git_index_entry_stage.html)
public func gitIndexEntryStage(
    entry: GitIndexEntry
) -> GitIndexStageT?
{
    return entry.withCValue
    {
        cEntry in
        
        return GitIndexStageT(rawValue: git_index_entry_stage(cEntry))
    }
}



/// Checks whether the given index entry is a conflict entry.
/// - Parameter entry: The entry to check.
/// - Returns: Whether the given index entry is a conflict entry.
///
/// ## C Equivalent
///
/// [`git_index_entry_is_conflict()`](https://libgit2.org/docs/reference/main/index/git_index_entry_is_conflict.html)
public func gitIndexEntryIsConflict(
    entry: GitIndexEntry
) -> Bool
{
    return entry.withCValue
    {
        cEntry in
        
        return Bool(git_index_entry_is_conflict(cEntry))
    }
}



/// Creates an iterator that will return every entry contained in the given index at the time of creation.
/// - Parameters:
///   - iteratorOut: The pointer in which to store the iterator. The underlying type must be
///   `git_index_iterator`.
///   - index: The index to iterate. The underlying type must be `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Entries are returned in order, sorted by path. The iterator is backed by a snapshot that allows callers
/// to modify the index while iterating, without affecting the iterator.
///
/// ## C Equivalent
///
/// [`git_index_iterator_new()`](https://libgit2.org/docs/reference/main/index/git_index_iterator_new.html)
public func gitIndexIteratorNew(
    iteratorOut : UnsafeMutablePointer<OpaquePointer?>,
    index       : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_iterator_new(
            iteratorOut,
            index
        )
    }
}



/// Gets the next index entry from the given index iterator.
/// - Parameters:
///   - out: The ``GitIndexEntry`` instance in which to store the next index entry.
///   - iterator: The index iterator to use. The underlying type must be `git_index_iterator`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_iterator_next()`](https://libgit2.org/docs/reference/main/index/git_index_iterator_next.html)
public func gitIndexIteratorNext(
    out         : inout GitIndexEntry,
    iterator    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_index_iterator_next(
                cOut,
                iterator
            )
        }
    }
}



/// Frees the memory allocated for the given `git_index_iterator` instance.
/// - Parameter iterator: The index iterator to free. The underlying type must be
/// `git_index_iterator`.
///
/// ## C Equivalent
///
/// [`git_index_iterator_free()`](https://libgit2.org/docs/reference/main/index/git_index_iterator_free.html)
public func gitIndexIteratorFree(
    iterator: OpaquePointer?
)
{
    git_index_iterator_free(iterator)
}



/// Adds an index entry from the specified on-disk file.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - path: The path to the file to add, relative to the working directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function forces the file to be added to the given index, regardless of ignore rules. If the file
/// is the result of a merge conflict, it will no longer be marked as conflicting. The data about the conflict
/// will be moved to the "resolve undo" (`REUC`) section.
///
/// - Note: This function does not support bare repositories.
///
/// ## C Equivalent
///
/// [`git_index_add_bypath()`](https://libgit2.org/docs/reference/main/index/git_index_add_bypath.html)
public func gitIndexAddByPath(
    index   : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_add_bypath(
            index,
            path
        )
    }
}



/// Adds the given index entry to the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - entry: The index entry to add.
///   - buffer: The data to be written into the blob.
///   - len: The length of `buffer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will create a blob in the repository that owns the given index and then add the given index
/// entry to the index. The path of the entry represents the position of the blob relative to the repository's
/// root folder.
///
/// If a previous index entry exists that has the same path as the given index entry, it will be replaced.
///
/// This function forces the file to be added to the given index, regardless of ignore rules. If the file
/// is the result of a merge conflict, it will no longer be marked as conflicting. The data about the conflict
/// will be moved to the "resolve undo" (`REUC`) section.
///
/// ## C Equivalent
///
/// [`git_index_add_from_buffer()`](https://libgit2.org/docs/reference/main/index/git_index_add_from_buffer.html)
public func gitIndexAddFromBuffer(
    index   : OpaquePointer,
    entry   : GitIndexEntry,
    buffer  : Data,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try entry.withCValue
        {
            cEntry in
            
            return try buffer.withCBuffer
            {
                cBuffer, cBufferCount in
                
                return git_index_add_frombuffer(
                    index,
                    cEntry,
                    cBuffer,
                    cBufferCount
                )
            }
        }
    }
}



/// Removes the index entry corresponding to the specified on-disk file.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - path: The path to the file to remove, relative to the working directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If the specified file is the result of a merge conflict, it will no longer be marked as conflicting. The data
/// about the conflict will be moved to the "resolve undo" (`REUC`) section.
///
/// ## C Equivalent
///
/// [`git_index_remove_bypath()`](https://libgit2.org/docs/reference/main/index/git_index_remove_bypath.html)
public func gitIndexRemoveByPath(
    index   : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_remove_bypath(
            index,
            path
        )
    }
}



/// Adds the index entries matching the specified files in the working directory.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - pathspec: The path patterns.
///   - flags: The flags for adding files that match a pathspec.
///   - callback: The callback for adding or updating files matching a pathspec.
///   - payload: The caller-specified payload passed to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// `pathspec` must be a list of file names or shell glob patterns to match against files in the repository's
/// working directory. Each matching file will be added to the index (either updating an existing entry or
/// adding a new entry). Use the
/// ``GitIndexAddOptionT/gitIndexAddDisablePatchspecMatch`` flag to disable glob
/// expansion and force exact matching.
///
/// Unlike ``gitIndexAddByPath(index:path:)``, ignored files will be skipped. If a file is already
/// tracked in the index, then it will be updated even if it is ignored. Use the
/// ``GitIndexAddOptionT/gitIndexAddForce`` flag to skip the checking of ignore rules.
///
/// To emulate `git add -A` and generate an error if the pathspec contains the exact path of an ignored
/// file (when not force-adding), use the ``GitIndexAddOptionT/gitIndexAddCheckPathspec``
/// flag to check that each entry in the pathspec that is an exact match to a filename on the disk is either not
/// ignored or is already in the index. If the check fails, this function will return
/// ``GitErrorCode/gitEInvalidSpec``.
///
/// To emulate `git add -A` with the `dry-run` option, use a callback function that always returns
/// a positive value.
///
/// If any of the specified files are the result of a merge conflict, they will no longer be marked as conflicting.
/// The data about the conflicts will be moved to the "resolve undo" (`REUC`) section.
///
/// - Note: This function does not support bare repositories.
///
/// ## C Equivalent
///
/// [`git_index_add_all()`](https://libgit2.org/docs/reference/main/index/git_index_add_all.html)
public func gitIndexAddAll(
    index       : OpaquePointer,
    pathspec    : [String],
    flags       : GitIndexAddOptionT,
    callback    : GitIndexMatchedPathCB?,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return pathspec.withGitStrArray
        {
            cPathspec in
            
            return git_index_add_all(
                index,
                cPathspec,
                flags.rawValue,
                callback,
                payload
            )
        }
    }
}



/// Removes the index entries matching the specified files in the working directory.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - pathspec: The path patterns.
///   - callback: The callback for removing files matching a pathspec.
///   - payload: The caller-specified payload passed to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_remove_all()`](https://libgit2.org/docs/reference/main/index/git_index_remove_all.html)
public func gitIndexRemoveAll(
    index       : OpaquePointer,
    pathspec    : [String],
    callback    : GitIndexMatchedPathCB?,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return pathspec.withGitStrArray
        {
            cPathspec in
            
            return git_index_remove_all(
                index,
                cPathspec,
                callback,
                payload
            )
        }
    }
}



/// Updates the index entries matching the specified files in the working directory.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - pathspec: The path patterns.
///   - callback: The callback for updating files matching a pathspec.
///   - payload: The caller-specified payload passed to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function scans the existing index entries and synchronizes them with the working directory,
/// deleting them if the corresponding working directory file no longer exists, or otherwise updating the
/// information (including adding the latest version of file to the object database if necessary).
///
/// - Note: This function does not support bare repositories.
///
/// ## C Equivalent
///
/// [`git_index_add_all()`](https://libgit2.org/docs/reference/main/index/git_index_add_all.html)
public func gitIndexUpdateAll(
    index       : OpaquePointer,
    pathspec    : [String],
    callback    : GitIndexMatchedPathCB?,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return pathspec.withGitStrArray
        {
            cPathspec in
            
            return git_index_update_all(
                index,
                cPathspec,
                callback,
                payload
            )
        }
    }
}



/// Finds the first position of any entries matching the given path in the given index.
/// - Parameters:
///   - atPos: The pointer in which to store the position of the index entry.
///   - index: The index to search. The underlying type must be `git_index`.
///   - path: The path the file to search.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_find()`](https://libgit2.org/docs/reference/main/index/git_index_find.html)
public func gitIndexFind(
    atPos   : UnsafeMutablePointer<Int>?,
    index   : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_find(
            atPos,
            index,
            path
        )
    }
}



/// Finds the first position of any entries matching the given prefix in the given index.
/// - Parameters:
///   - atPos: The pointer in which to store the position of the index entry.
///   - index: The index to search. The underlying type must be `git_index`.
///   - prefix: The prefix for which to search.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// To find the first position of a path inside a given folder, suffix the prefix with a forward slash ("/").
///
/// ## C Equivalent
///
/// [`git_index_find_prefix()`](https://libgit2.org/docs/reference/main/index/git_index_find_prefix.html)
public func gitIndexFindPrefix(
    atPos   : UnsafeMutablePointer<Int>?,
    index   : OpaquePointer,
    prefix  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_find_prefix(
            atPos,
            index,
            prefix
        )
    }
}



/// Adds the given index entries representing a conflict to the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - ancestoryEntry: The ancestor of the conflict.
///   - ourEntry: "Our" side of the conflict.
///   - theirEntry: "Their" side of the conflict.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The given entries must be the entries from the tree included in the merge. Any entry may be `nil`
/// to indicate that that file was not present in the trees during the merge.
///
/// ## C Equivalent
///
/// [`git_index_conflict_add()`](https://libgit2.org/docs/reference/main/index/git_index_conflict_add.html)
public func gitIndexConflictAdd(
    index           : OpaquePointer,
    ancestoryEntry  : GitIndexEntry?,
    ourEntry        : GitIndexEntry?,
    theirEntry      : GitIndexEntry?
) -> GitErrorCode
{
    return withCConversion
    {
        return try ancestoryEntry.withOptionalCValue
        {
            cAncestoryEntry in
            
            return try ourEntry.withOptionalCValue
            {
                cOurEntry in
                
                return try theirEntry.withOptionalCValue
                {
                    cTheirEntry in
                    
                    return git_index_conflict_add(
                        index,
                        cAncestoryEntry,
                        cOurEntry,
                        cTheirEntry
                    )
                }
            }
        }
    }
}



/// Gets the index entries that represent a conflict of the specified file in the given index.
/// - Parameters:
///   - ancestorOut: The ``GitIndexEntry`` instance in which to store the ancestory entry.
///   - ourOut: The ``GitIndexEntry`` instance in which to store "our" entry.
///   - theirOut: The ``GitIndexEntry`` instance in which to store "their" entry.
///   - index: The index to search. The underlying type must be `git_index`.
///   - path: The path to the file search.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_conflict_get()`](https://libgit2.org/docs/reference/main/index/git_index_conflict_get.html)
public func gitIndexConflictGet(
    ancestorOut : inout GitIndexEntry,
    ourOut      : inout GitIndexEntry,
    theirOut    : inout GitIndexEntry,
    index       : OpaquePointer,
    path        : String
) -> GitErrorCode
{
    return withCConversion
    {
        return ancestorOut.withMutatingCValue
        {
            cAncestorOut in
            
            return ourOut.withMutatingCValue
            {
                cOurOut in
                
                return theirOut.withMutatingCValue
                {
                    cTheirOut in
                    
                    return git_index_conflict_get(
                        cAncestorOut,
                        cOurOut,
                        cTheirOut,
                        index,
                        path
                    )
                }
            }
        }
    }
}



/// Removes the index entries that represent a conflict of the specified file in the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - path: The path to the file for which to remove conflicts.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_conflict_remove()`](https://libgit2.org/docs/reference/main/index/git_index_conflict_remove.html)
public func gitIndexConflictRemove(
    index   : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_conflict_remove(
            index,
            path
        )
    }
}



/// Removes all conflicts in the given index.
/// - Parameter index: The index to update. The underlying type must be `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_conflict_cleanup()`](https://libgit2.org/docs/reference/main/index/git_index_conflict_cleanup.html)
public func gitIndexConflictCleanup(
    index: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_conflict_cleanup(index)
    }
}



/// Checks whether the given index contains entries representing file conflicts.
/// - Parameter index: The index to check. The underlying type must be `git_index`.
/// - Returns: Whether the given index contains entries representing file conflicts.
///
/// ## C Equivalent
///
/// [`git_index_has_conflicts()`](https://libgit2.org/docs/reference/main/index/git_index_has_conflicts.html)
public func gitIndexHasConflicts(
    index: OpaquePointer
) -> Bool
{
    return Bool(git_index_has_conflicts(index))
}



/// Creates an iterator for the conflicts in the given index.
/// - Parameters:
///   - iteratorOut: The pointer in which to store the index conflict iterator. The underlying type
///   must be `git_index_conflict_iterator`.
///   - index: The index to scan. The underlying type must be `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_conflict_iterator_new()`](https://libgit2.org/docs/reference/main/index/git_index_conflict_iterator_new.html)
public func gitIndexConflictIteratorNew(
    iteratorOut : UnsafeMutablePointer<OpaquePointer?>,
    index       : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_conflict_iterator_new(
            iteratorOut,
            index
        )
    }
}



/// Gets the next conflict from the given index conflict iterator.
/// - Parameters:
///   - ancestorOut: The ``GitIndexEntry`` instance in which to store the ancestory entry.
///   - ourOut: The ``GitIndexEntry`` instance in which to store "our" entry.
///   - theirOut: The ``GitIndexEntry`` instance in which to store "their" entry.
///   - iterator: The index conflict iterator to use. The underlying type must be
///   `git_index_conflict_iterator`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_conflict_next()`](https://libgit2.org/docs/reference/main/index/git_index_conflict_next.html)
public func gitIndexConflictNext(
    ancestorOut : inout GitIndexEntry,
    ourOut      : inout GitIndexEntry,
    theirOut    : inout GitIndexEntry,
    iterator    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return ancestorOut.withMutatingCValue
        {
            cAncestorOut in
            
            return ourOut.withMutatingCValue
            {
                cOurOut in
                
                return theirOut.withMutatingCValue
                {
                    cTheirOut in
                    
                    return git_index_conflict_next(
                        cAncestorOut,
                        cOurOut,
                        cTheirOut,
                        iterator
                    )
                }
            }
        }
    }
}



/// Frees the memory allocated for the given `git_index_conflict_iterator` instance.
/// - Parameter iterator: The index conflict iterator to free. The underlying type must be
/// `git_index_conflict_iterator`.
///
/// ## C Equivalent
///
/// [`git_index_conflict_iterator_free()`](https://libgit2.org/docs/reference/main/index/git_index_conflict_iterator_free.html)
public func gitIndexConflictIteratorFree(
    iterator: OpaquePointer?
)
{
    git_index_conflict_iterator_free(iterator)
}
