//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Looks up the specified tree in the given repository.
/// - Parameters:
///   - out: The pointer in which to store the tree. The underlying type must
///   be `git_tree`.
///   - repo: The repository containing the tree. The underlying type must be
///   `git_repository`.
///   - id: The ID of the tree to look up.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tree_lookup()`](https://libgit2.org/docs/reference/main/tree/git_tree_lookup.html)
public func gitTreeLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_tree_lookup(
                out,
                repo,
                cID
            )
        }
    }
}



/// Looks up the specified tree in the given repository, using a prefix of the
/// tree's ID.
/// - Parameters:
///   - out: The pointer in which to store the tree. The underlying
///   type must be `git_tree`.
///   - repo: The repository containing the tree. The underlying type must
///   be `git_repository`.
///   - id: The prefix of the ID of the tree to lookup.
///   - len: The length of the tree's ID prefix. This must be greater than or
///   equal to ``gitOIDMinPrefixLen``, and long enough to identify a unique
///   tree matching the prefix.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tree_lookup_prefix()`](https://libgit2.org/docs/reference/main/tree/git_tree_lookup_prefix.html)
public func gitTreeLookupPrefix(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_tree_lookup_prefix(
                out,
                repo,
                cID,
                len
            )
        }
    }
}



/// Frees the memory allocated for the given `git_tree` instance.
/// - Parameter tree: The tree to free. The underlying type must be `git_tree`.
///
/// ## C Equivalent
///
/// [`git_tree_free()`](https://libgit2.org/docs/reference/main/tree/git_tree_free.html)
public func gitTreeFree(
    tree: OpaquePointer?
)
{
    guard let tree
    else
    {
        return
    }
    
    git_tree_free(tree)
}



/// Gets the ID of the given tree.
/// - Parameter tree: The tree for which to get the ID. The underlying type
/// must be `git_tree`.
/// - Returns: The ID of the given tree.
///
/// ## C Equivalent
///
/// [`git_tree_id()`](https://libgit2.org/docs/reference/main/tree/git_tree_id.html)
public func gitTreeID(
    tree: OpaquePointer
) -> GitOID?
{
    guard let treeOID: UnsafePointer<git_oid> = git_tree_id(tree)
    else
    {
        return nil
    }
    
    return GitOID(cValue: treeOID.pointee)
}



/// Gets the repository containing the given tree.
/// - Parameter tree: The tree for which to get the repository. The underlying
/// type must be `git_tree`.
/// - Returns: The repository containing the given tree. The underlying type
/// will be `git_repository`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given tree and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_tree_owner()`](https://libgit2.org/docs/reference/main/tree/git_tree_owner.html)
public func gitTreeOwner(
    tree: OpaquePointer
) -> OpaquePointer
{
    return git_tree_owner(tree)
}



/// Gets the number of entries in the given tree.
/// - Parameter tree: The tree to check. The underlying type must be `git_tree`.
/// - Returns: The number of entries in the given tree.
///
/// ## C Equivalent
///
/// [`git_tree_entrycount()`](https://libgit2.org/docs/reference/main/tree/git_tree_entrycount.html)
public func gitTreeEntryCount(
    tree: OpaquePointer
) -> Int
{
    return git_tree_entrycount(tree)
}



/// Gets the specified entry in the given tree.
/// - Parameters:
///   - tree: The tree to check. The underlying type must be `git_tree`.
///   - fileName: The file name of the entry to retrieve.
/// - Returns: The specified entry in the given tree. The underlying type will
/// be `git_tree_entry`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given tree and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_tree_entry_byname()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_byname.html)
public func gitTreeEntryByName(
    tree        : OpaquePointer,
    fileName    : String
) -> OpaquePointer?
{
    return git_tree_entry_byname(
        tree,
        fileName
    )
}



/// Gets the entry at the specified index in the given tree.
/// - Parameters:
///   - tree: The tree to check. The underlying type must be `git_tree`.
///   - idx: The index of the entry to retrieve.
/// - Returns: The entry at the specified index in the given tree. The
/// underlying type will be `git_tree_entry`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given tree and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_tree_entry_byindex()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_byindex.html)
public func gitTreeEntryByIndex(
    tree    : OpaquePointer,
    idx     : Int
) -> OpaquePointer?
{
    return git_tree_entry_byindex(
        tree,
        idx
    )
}



/// Gets the specified entry in the given tree.
/// - Parameters:
///   - tree: The tree to check. The underlying type must be `git_tree`.
///   - id: The ID of the entry to retrieve.
/// - Returns: The specified entry in the given tree. The underlying type will
/// be `git_tree_entry`.
///
/// ## Discussion
///
/// This function must examine every entry in the given tree. If performance
/// is a priority, consider using another lookup function.
///
/// - Important: The returned pointer is owned by the given tree and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_tree_entry_byid()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_byid.html)
public func gitTreeEntryByID(
    tree    : OpaquePointer,
    id      : GitOID
) -> OpaquePointer?
{
    return id.withCValue
    {
        cID in
        
        return git_tree_entry_byid(
            tree,
            cID
        )
    }
}



/// Gets the specified entry in the given tree or any of its subtrees.
/// - Parameters:
///   - out: The pointer in which to store the entry. The underlying type must
///   be `git_tree_entry`.
///   - root: The root tree of the relative path. The underlying type must be
///   `git_tree`.
///   - path: The relative path to the entry to retrieve.
/// - Returns: The specified entry in the given tree.
///
/// ## C Equivalent
///
/// [`git_tree_entry_bypath()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_bypath.html)
public func gitTreeEntryByPath(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    root    : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tree_entry_bypath(
            out,
            root,
            path
        )
    }
}



/// Creates an in-memory copy of the given tree entry.
/// - Parameters:
///   - out: The pointer in which to store the copied tree entry. The
///   underlying type must be `git_tree_entry`.
///   - source: The tree entry to copy. The underlying type must be
///   `git_tree_entry`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tree_entry_dup()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_dup.html)
public func gitTreeEntryDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tree_entry_dup(
            out,
            source
        )
    }
}



/// Frees the memory allocated for the given `git_tree_entry` instance.
/// - Parameter entry: The tree entry to free. The underlying type must be
/// `git_tree_entry`.
///
/// ## C Equivalent
///
/// [`git_tree_entry_free()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_free.html)
public func gitTreeEntryFree(
    entry: OpaquePointer?
)
{
    guard let entry
    else
    {
        return
    }
    
    git_tree_entry_free(entry)
}



/// Gets the name of the given tree entry.
/// - Parameter entry: The tree entry for which to get the name. The
/// underlying type must be `git_tree_entry`.
/// - Returns: The name of the given tree entry.
///
/// ## C Equivalent
///
/// [`git_tree_entry_name()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_name.html)
public func gitTreeEntryName(
    entry: OpaquePointer
) -> String?
{
    let entryName: UnsafePointer<CChar>? = git_tree_entry_name(entry)
    
    return String(optionalCString: entryName)
}



/// Gets the ID of the given tree entry.
/// - Parameter entry: The tree entry for which to get the ID. The underlying
/// type must be `git_tree_entry`.
/// - Returns: The ID of the given tree entry.
///
/// ## C Equivalent
///
/// [`git_tree_entry_id()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_id.html)
public func gitTreeEntryID(
    entry: OpaquePointer
) -> GitOID?
{
    guard let entryOID: UnsafePointer<git_oid> = git_tree_entry_id(entry)
    else
    {
        return nil
    }
    
    return GitOID(cValue: entryOID.pointee)
}



/// Gets the object type of the given tree entry.
/// - Parameter entry: The tree entry for which to get the object type. The
/// underlying type must be `git_tree_entry`.
/// - Returns: The object type of the given tree entry.
///
/// ## C Equivalent
///
/// [`git_tree_entry_type()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_type.html)
public func gitTreeEntryType(
    entry: OpaquePointer
) -> GitObjectT?
{
    let objectType: git_object_t = git_tree_entry_type(entry)
    
    return GitObjectT(cValue: objectType)
}



/// Gets the file mode of the given tree entry.
/// - Parameter entry: The tree entry for which to get the file mode. The
/// underlying type must be `git_tree_entry`.
/// - Returns: The file mode of the given tree entry.
///
/// ## C Equivalent
///
/// [`git_tree_entry_filemode()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_filemode.html)
public func gitTreeEntryFileMode(
    entry: OpaquePointer
) -> GitFileModeT?
{
    let fileMode: git_filemode_t = git_tree_entry_filemode(entry)
    
    return GitFileModeT(cValue: fileMode)
}



/// Gets the raw file mode of the given tree entry.
/// - Parameter entry: The tree entry for which to get the raw file mode. The
/// underlying type must be `git_tree_entry`.
/// - Returns: The raw file mode of the given tree entry.
///
/// ## Discussion
///
/// This function does not perform any normalization.
///
/// ## C Equivalent
///
/// [`git_tree_entry_filemode_raw()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_filemode_raw.html)
public func gitTreeEntryFileModeRaw(
    entry: OpaquePointer
) -> GitFileModeT?
{
    let fileMode: git_filemode_t = git_tree_entry_filemode_raw(entry)
    
    return GitFileModeT(cValue: fileMode)
}



/// Compares the given tree entries.
/// - Parameters:
///   - e1: The first tree entry to compare. The underlying type must be
///   `git_tree_entry`.
///   - e2: The second tree entry to compare. The underlying type must be
/// `git_tree_entry`.
/// - Returns: A negative number if `e1` is before `e2`, a positive number if
/// `e1` is after `e2`, or `0` if they are equal.
///
/// ## C Equivalent
///
/// [`git_tree_entry_cmp()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_cmp.html)
public func gitTreeEntryCmp(
    e1  : OpaquePointer,
    e2  : OpaquePointer
) -> Int32
{
    return git_tree_entry_cmp(
        e1,
        e2
    )
}



/// Converts the given tree entry into the object to which it points.
/// - Parameters:
///   - objectOut: The pointer in which to store the object. The underlying
///   type must be `git_object`.
///   - repo: The repository containing the object. The underlying type must
///   be `git_repository`.
///   - entry: The tree entry to convert. The underlying type must be
///   `git_tree_entry`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tree_entry_to_object()`](https://libgit2.org/docs/reference/main/tree/git_tree_entry_to_object.html)
public func gitTreeEntryToObject(
    objectOut   : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    entry       : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tree_entry_to_object(
            objectOut,
            repo,
            entry
        )
    }
}



/// Creates a new treebuilder from the given source.
/// - Parameters:
///   - out: The pointer in which to store the treebuilder. The underlying
///   type must be `git_treebuilder`.
///   - repo: The repository in which to create the treebuilder. The underlying
///   type must be `git_repository`.
///   - source: The source tree from which to initialize the treebuilder. Pass
///   `nil` to create an empty treebuilder.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_treebuilder_new()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_new.html)
public func gitTreebuilderNew(
    out:        UnsafeMutablePointer<OpaquePointer?>,
    repo:       OpaquePointer,
    source:     OpaquePointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_treebuilder_new(
            out,
            repo,
            source
        )
    }
}



/// Clears all the entries in the given treebuilder.
/// - Parameter bld: The treebuilder to clear. The underlying type must be
/// `git_treebuilder`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_treebuilder_clear()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_clear.html)
public func gitTreebuilderClear(
    bld: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_treebuilder_clear(bld)
    }
}



/// Gets the number of entries in the given treebuilder.
/// - Parameter bld: The treebuilder to check. The underlying type must be
/// `git_treebuilder`.
/// - Returns: The number of entries in the given treebuilder.
///
/// ## C Equivalent
///
/// [`git_treebuilder_entrycount()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_entrycount.html)
public func gitTreebuilderEntryCount(
    bld: OpaquePointer
) -> Int
{
    return git_treebuilder_entrycount(bld)
}



/// Frees the memory allocated for the given `git_treebuilder` instance.
/// - Parameter bld: The treebuilder to free. The underlying type must be
/// `git_treebuilder`.
///
/// ## C Equivalent
///
/// [`git_treebuilder_free()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_free.html)
public func gitTreebuilderFree(
    bld: OpaquePointer?
)
{
    guard let bld
    else
    {
        return
    }
    
    git_treebuilder_free(bld)
}



/// Gets the specified entry from the given treebuilder.
/// - Parameters:
///   - bld: The treebuilder to search. The underlying type must be
///   `git_treebuilder`.
///   - fileName: The file name of the entry to retrieve.
/// - Returns: The specified entry from the given treebuilder.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given treebuilder and
/// must not be freed.
///
/// ## C Equivalent
///
/// [`git_treebuilder_get()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_get.html)
public func gitTreebuilderGet(
    bld         : OpaquePointer,
    fileName    : String
) -> OpaquePointer?
{
    return git_treebuilder_get(
        bld,
        fileName
    )
}



/// Adds or updates an entry in the given treebuilder.
/// - Parameters:
///   - out: The pointer in which to store the added or updated entry. The
///   underlying type must be `git_tree_entry`.
///   - bld: The treebuilder to update. The underlying type must be
///   `git_treebuilder`.
///   - fileName: The file name of the entry to add or update.
///   - id: The ID of the entry to add or update.
///   - fileMode: The file mode of the entry to add or update.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If an entry with the given file name already exists, the entry will be
/// updated.
///
/// The entry to add or update will be checked for validity, meaning it
/// exists in the object database and has the correct type. Use
/// ``gitLibgit2OptEnableStrictObjectCreation(enabled:)`` to disable this check.
///
/// - Important: The `out` pointer is owned by libgit2 and must not be freed.
/// It may not be valid past the next operation in the given treebuilder.
/// Duplicate the entry if necessary.
///
/// ## C Equivalent
///
/// [`git_treebuilder_insert()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_insert.html)
public func gitTreebuilderInsert(
    out         : UnsafeMutablePointer<OpaquePointer?>?,
    bld         : OpaquePointer,
    fileName    : String,
    id          : GitOID,
    fileMode    : GitFileModeT
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_treebuilder_insert(
                out,
                bld,
                fileName,
                cID,
                fileMode.cValue()
            )
        }
    }
}



/// Removes the specified entry from the given treebuilder.
/// - Parameters:
///   - bld: The treebuilder to update. The underlying type must be
///   `git_treebuilder`.
///   - fileName: The file name of the entry to remove.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_treebuilder_remove()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_remove.html)
public func gitTreebuilderRemove(
    bld         : OpaquePointer,
    fileName    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_treebuilder_remove(
            bld,
            fileName
        )
    }
}



/// Selectively removes entries in the given treebuilder.
/// - Parameters:
///   - bld: The treebuilder to update. The underlying type must be
///   `git_treebuilder`.
///   - filter: The ``GitTreebuilderFilterCB`` callback to invoke for each
///   tree entry.
///   - payload: The payload to pass to `filter`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_treebuilder_filter()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_filter.html)
public func gitTreebuilderFilter(
    bld     : OpaquePointer,
    filter  : GitTreebuilderFilterCB,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_treebuilder_filter(
            bld,
            filter,
            payload
        )
    }
}



/// Writes the contents of the given treebuilder as a tree.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the
///   newly-written tree.
///   - bld: The treebuilder to write. The underlying type must be
///   `git_treebuilder`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_treebuilder_write()`](https://libgit2.org/docs/reference/main/tree/git_treebuilder_write.html)
public func gitTreebuilderWrite(
    id  : inout GitOID,
    bld : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return git_treebuilder_write(
                cID,
                bld
            )
        }
    }
}



/// Traverses the entries in the given tree and its subtrees.
/// - Parameters:
///   - tree: The tree to traverse. The underlying type must be `git_tree`.
///   - mode: The traversal mode to use.
///   - callback: The ``GitTreewalkCB`` callback to invoke for each tree entry.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tree_walk()`](https://libgit2.org/docs/reference/main/tree/git_tree_walk.html)
public func gitTreeWalk(
    tree        : OpaquePointer,
    mode        : GitTreewalkMode,
    callback    : GitTreewalkCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tree_walk(
            tree,
            mode.cValue(),
            callback,
            payload
        )
    }
}



/// Creates an in-memory copy of the given tree.
/// - Parameters:
///   - out: The pointer in which to store the copied tree. The underlying
///   type must be `git_tree`.
///   - source: The tree to copy. The underlying type must be `git_tree`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tree_dup()`](https://libgit2.org/docs/reference/main/tree/git_tree_dup.html)
public func gitTreeDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tree_dup(
            out,
            source
        )
    }
}



/// Creates a tree based on the given tree, with the given updates.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the
///   newly-created tree.
///   - repo: The repository in which to create the tree. The underlying type
///   must be `git_repository`.
///   - baseline: The tree on which to base creation of the new tree. The
///   underlying type must be `git_tree`. This must belong to the given
///   repository.
///   - nUpdates: The length of `updates`.
///   - updates: The updates to perform.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is optimized for common file and directory addition, removal,
/// and replacement in trees. It is much more efficient than reading the tree
/// into a `git_index` instance and then modifying that, but it is not as
/// flexible.
///
/// - Important: Deleting and adding the same entry is undefined behavior.
///
/// - Note: This function does not support changing a tree to a blob or
/// changing a blob to a tree.
///
/// ## C Equivalent
///
/// [`git_tree_create_updated()`](https://libgit2.org/docs/reference/main/tree/git_tree_create_updated.html)
public func gitTreeCreateUpdated(
    out         : inout GitOID,
    repo        : OpaquePointer,
    baseline    : OpaquePointer,
    nUpdates    : Int,
    updates     : [GitTreeUpdate]
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try updates.withArrayOfGitTreeUpdates
            {
                cUpdates, cUpdatesCount in
                
                return git_tree_create_updated(
                    cOut,
                    repo,
                    baseline,
                    cUpdatesCount,
                    cUpdates
                )
            }
        }
    }
}
