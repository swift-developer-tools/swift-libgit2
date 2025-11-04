//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Gets the number of file name conflict entries in the given index.
/// - Parameter index: The index to evaluate. The underlying type must be
/// `git_index`.
/// - Returns: The number of file name conflict entries in the given index.
///
/// ## C Equivalent
///
/// [`git_index_name_entrycount()`](https://libgit2.org/docs/reference/main/sys/index/git_index_name_entrycount.html)
public func gitIndexNameEntryCount(
    index: OpaquePointer
) -> Int
{
    return git_index_name_entrycount(index)
}



/// Gets the file name conflict entry at the given position within the given
/// index.
/// - Parameters:
///   - index: The index to search. The underlying type must be `git_index`.
///   - n: The position of the entry within the given index.
/// - Returns: The file name conflict entry at the given position within the
/// given index.
///
/// ## C Equivalent
///
/// [`git_index_name_get_byindex()`](https://libgit2.org/docs/reference/main/sys/index/git_index_name_get_byindex.html)
public func gitIndexNameGetByIndex(
    index   : OpaquePointer,
    n       : Int
) -> GitIndexNameEntry?
{
    guard let indexNameEntry: UnsafePointer<git_index_name_entry>
            = git_index_name_get_byindex(
                index,
                n
            )
    else
    {
        return nil
    }
    
    return GitIndexNameEntry(cValue: indexNameEntry.pointee)
}



/// Adds the specified file name conflict entry to the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - ancestor: The path to the file as it existed in the common ancestor.
///   - ours: The path to the file as it existed in "our" tree.
///   - theirs: The path to the file as it existed in "their" tree.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_name_add()`](https://libgit2.org/docs/reference/main/sys/index/git_index_name_add.html)
public func gitIndexNameAdd(
    index       : OpaquePointer,
    ancestor    : String,
    ours        : String,
    theirs      : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_name_add(
            index,
            ancestor,
            ours,
            theirs
        )
    }
}



/// Clears the file name conflict entries of the given index.
/// - Parameter index: The index to clear. The underlying type must be
/// `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_name_clear()`](https://libgit2.org/docs/reference/main/sys/index/git_index_name_clear.html)
public func gitIndexNameClear(
    index: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_name_clear(index)
    }
}



/// Gets the number of resolve-undo (REUC) entries in the given index.
/// - Parameter index: The index to evaluate. The underlying type must be
/// `git_index`.
/// - Returns: The number of resolve-undo (REUC) entries in the given index.
///
/// ## C Equivalent
///
/// [`git_index_reuc_entrycount()`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_entrycount.html)
public func gitIndexREUCEntryCount(
    index: OpaquePointer
) -> Int
{
    return git_index_reuc_entrycount(index)
}



/// Finds the first position of any resolve-undo (REUC) matching the given
/// path in the given index.
/// - Parameters:
///   - atPos: The pointer in which to store the position of the REUC entry.
///   - index: The index to search. The underlying type must be `git_index`.
///   - path: The path to the file to search.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_reuc_find()`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_find.html)
public func gitIndexREUCFind(
    atPos   : UnsafeMutablePointer<Int>?,
    index   : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_reuc_find(
            atPos,
            index,
            path
        )
    }
}



/// Gets the resolve-undo (REUC) entry at the given path within the given index.
/// - Parameters:
///   - index: The index to search. The underlying type must be `git_index`.
///   - path: The path to the entry to get.
/// - Returns: The REUC entry at the given path within the given index.
///
/// ## C Equivalent
///
/// [`git_index_reuc_get_bypath()`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_get_bypath.html)
public func gitIndexREUCGetByPath(
    index   : OpaquePointer,
    path    : String
) -> GitIndexREUCEntry?
{
    guard let indexREUCEntry: UnsafePointer<git_index_reuc_entry>
            = git_index_reuc_get_bypath(
                index,
                path
            )
    else
    {
        return nil
    }
    
    return GitIndexREUCEntry(cValue: indexREUCEntry.pointee)
}



/// Gets the resolve-undo (REUC) entry at the given position within the given
/// index.
/// - Parameters:
///   - index: The index to search. The underlying type must be `git_index`.
///   - n: The position of the entry within the given index.
/// - Returns: The REUC entry at the given position within the given index.
///
/// ## C Equivalent
///
/// [`git_index_reuc_get_byindex()`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_get_byindex.html)
public func gitIndexREUCGetByIndex(
    index   : OpaquePointer,
    n       : Int
) -> GitIndexREUCEntry?
{
    guard let indexREUCEntry: UnsafePointer<git_index_reuc_entry>
            = git_index_reuc_get_byindex(
                index,
                n
            )
    else
    {
        return nil
    }
    
    return GitIndexREUCEntry(cValue: indexREUCEntry.pointee)
}



/// Adds the specified resolve-undo (REUC) entry to the given index.
///
/// If a previous REUC entry exists that has the same path as the specififed
/// entry, it will be replaced.
///
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   This index must not be bare.
///   - path: The path to the file to add.
///   - ancestorMode: The mode of the ancestor file.
///   - ancestorID: The ID of the ancestor file.
///   - ourMode: The mode of "our" file.
///   - ourID: The ID of "our" file.
///   - theirMode: The mode of "their" file.
///   - theirID: The ID of "their" file.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_reuc_add()`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_add.html)
public func gitIndexREUCAdd(
    index           : OpaquePointer,
    path            : String,
    ancestorMode    : Int32,
    ancestorID      : GitOID,
    ourMode         : Int32,
    ourID           : GitOID,
    theirMode       : Int32,
    theirID         : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return ancestorID.withCValue
        {
            cAncestorID in
            
            return ourID.withCValue
            {
                cOurID in
                
                return theirID.withCValue
                {
                    cTheirID in
                    
                    return git_index_reuc_add(
                        index,
                        path,
                        ancestorMode,
                        cAncestorID,
                        ourMode,
                        cOurID,
                        theirMode,
                        cTheirID
                    )
                }
            }
        }
    }
}



/// Removes the entry at the given position within the given index.
/// - Parameters:
///   - index: The index to update. The underlying type must be `git_index`.
///   - n: The position of the entry within the given index.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_reuc_remove()`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_remove.html)
public func gitIndexREUCRemove(
    index   : OpaquePointer,
    n       : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_reuc_remove(
            index,
            n
        )
    }
}



/// Clears the resolve-undo (REUC) entries of the given index.
/// - Parameter index: The index to clear. The underlying type must be
/// `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_index_reuc_clear()`](https://libgit2.org/docs/reference/main/sys/index/git_index_reuc_clear.html)
public func gitIndexREUCClear(
    index: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_index_reuc_clear(index)
    }
}
