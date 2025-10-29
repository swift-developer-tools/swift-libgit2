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



/// Initializes the given `git_indexer_options` instance.
/// - Parameters:
///   - opts: The `git_indexer_options` instance to initialize.
///   - version: The version to use. Pass ``gitIndexerOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_indexer_options_init()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_options_init.html)
public func gitIndexerOptionsInit(
    opts    : UnsafeMutablePointer<git_indexer_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_indexer_options_init(
            opts,
            version
        )
    }
}



/// Creates a new indexer.
/// - Parameters:
///   - out: The pointer in which to store the indexer. The underlying type
///   must be `git_indexer`.
///   - path: The path to the directory in which to store the packfile.
///   - mode: The permissions to use when creating the packfile. Pass `0` for
///   the default permissions.
///   - odb: The object database from which to read objects when fixing thin
///   packs. The underlying type must be `git_odb`. Pass `nil` if no thin packs
///   are expected.
///   - opts: The indexer options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If `odb` is `nil` and there are missing bases, this function will return
/// an error code.
///
/// ## C Equivalent
///
/// [`git_indexer_new()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_new.html)
public func gitIndexerNew(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    path    : String,
    mode    : UInt32,
    odb     : OpaquePointer?,
    opts    : GitIndexerOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_indexer_new(
                out,
                path,
                mode,
                odb,
                cOpts
            )
        }
    }
}



/// Adds the given data to the given indexer.
/// - Parameters:
///   - idx: The indexer to update. The underlying type must be `git_indexer`.
///   - data: The data to add.
///   - size: The length of `data`.
///   - stats: The information about the progress of indexing a packfile.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_indexer_append()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_append.html)
public func gitIndexerAppend(
    idx     : OpaquePointer,
    data    : Data,
    size    : Int,
    stats   : inout GitIndexerProgress
) -> GitErrorCode
{
    return withCConversion
    {
        return try data.withCString
        {
            cData, cDataCount in
            
            return try stats.withMutatingCValue
            {
                cStats in
                
                return git_indexer_append(
                    idx,
                    cData,
                    cDataCount,
                    cStats
                )
            }
        }
    }
}



/// Resolves any pending deltas and writes out the index file.
/// - Parameters:
///   - idx: The indexer to finalize. The underlying type must be `git_indexer`.
///   - stats: The information about the progress of indexing a packfile.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_indexer_commit()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_commit.html)
public func gitIndexerCommit(
    idx     : OpaquePointer,
    stats   : inout GitIndexerProgress
) -> GitErrorCode
{
    return withCConversion
    {
        return try stats.withMutatingCValue
        {
            cStats in
            
            return git_indexer_commit(
                idx,
                cStats
            )
        }
    }
}



/// Gets the hash of the given packfile.
/// - Parameter idx: The indexer to use. The underlying type must be
/// `git_indexer`.
/// - Returns: The hash of the given packfile.
///
/// ## Discussion
///
/// The hash of a packfile is derived from the sorted hashing of all object
/// names. This hash will be correct only after the index has been finalized.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``gitIndexerName(idx:)`` instead.
///
/// ## C Equivalent
///
/// [`git_indexer_hash()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_hash.html)
public func gitIndexerHash(
    idx: OpaquePointer
) -> GitOID?
{
    guard let indexerHashOID: UnsafePointer<git_oid> = git_indexer_hash(idx)
    else
    {
        return nil
    }
    
    return GitOID(cValue: indexerHashOID.pointee)
}



/// Gets the unique name of the given packfile.
/// - Parameter idx: The indexer to use. The underlying type must be
/// `git_indexer`.
/// - Returns: The unique name of the given packfile.
///
/// ## Discussion
///
/// The name of a packfile is derived from the packfile's content. This name
/// will be correct only after the index has been finalized.
///
/// ## C Equivalent
///
/// [`git_indexer_name()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_name.html)
public func gitIndexerName(
    idx: OpaquePointer
) -> String?
{
    let indexerName: UnsafePointer<CChar>? = git_indexer_name(idx)
    
    return String(optionalCString: indexerName)
}



/// Frees the memory allocated for the given `git_indexer` instance.
/// - Parameter idx: The indexer to free. The underlying type must be
/// `git_indexer`.
///
/// ## C Equivalent
///
/// [`git_indexer_free()`](https://libgit2.org/docs/reference/main/indexer/git_indexer_free.html)
public func gitIndexerFree(
    idx: OpaquePointer?
)
{
    guard let idx: OpaquePointer = idx
    else
    {
        return
    }
    
    git_indexer_free(idx)
}
