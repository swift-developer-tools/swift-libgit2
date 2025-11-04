//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a new reference database with no backends.
/// - Parameters:
///   - out: The pointer in which to store the reference database. The
///   underlying type must be `git_refdb`.
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Before the ODB can be used for reading or writing, a custom database
/// backend must be manually added by calling
/// ``gitRefDBSetBackend(refDB:backend:)``.
///
/// ## C Equivalent
///
/// [`git_refdb_new()`](https://libgit2.org/docs/reference/main/refdb/git_refdb_new.html)
public func gitRefDBNew(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_refdb_new(
            out,
            repo
        )
    }
}



/// Creates a new reference database, and automatically adds a default backend.
/// - Parameters:
///   - out: The pointer in which to store the reference database. The
///   underlying type must be `git_refdb`.
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default backend is a backend to read and write loose and packed
/// references from the disk, assuming the repository directory as the
/// directory.
///
/// ## C Equivalent
///
/// [`git_refdb_open()`](https://libgit2.org/docs/reference/main/refdb/git_refdb_open.html)
public func gitRefDBOpen(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_refdb_open(
            out,
            repo
        )
    }
}



/// Suggests that the given reference database compresses or optimizes its
/// references.
/// - Parameter out: The reference database to compress. The underlying type
/// must be `git_refdb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: The compression is implementation-specific. For example, for
/// on-disk reference databases, this may pack all loose references.
///
/// ## C Equivalent
///
/// [`git_refdb_compress()`](https://libgit2.org/docs/reference/main/refdb/git_refdb_compress.html)
public func gitRefDBCompress(
    out: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_refdb_compress(out)
    }
}



/// Frees the memory allocated for the given `git_refdb` instance.
/// - Parameter refDB: The reference database to free. The underlying type
/// must be `git_refdb`.
///
/// ## C Equivalent
///
/// [`git_refdb_free()`](https://libgit2.org/docs/reference/main/refdb/git_refdb_free.html)
public func gitRefDBFree(
    refDB: OpaquePointer?
)
{
    guard let refDB
    else
    {
        return
    }
    
    git_refdb_free(refDB)
}
