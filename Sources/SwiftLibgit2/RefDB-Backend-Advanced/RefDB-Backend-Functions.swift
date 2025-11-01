//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_refdb_backend` instance.
/// - Parameters:
///   - opts: The `git_refdb_backend` instance to initialize.
///   - version: The version to use. Pass ``gitRefDBBackendVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_refdb_init_backend()`](https://libgit2.org/docs/reference/main/sys/refdb_backend/git_refdb_init_backend.html)
public func gitRefDBInitBackend(
    opts    : UnsafeMutablePointer<git_refdb_backend>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_refdb_init_backend(
            opts,
            version
        )
    }
}



/// Creates a default reference database backend, based on the file system.
/// - Parameters:
///   - backendOut: The pointer in which to store the reference database
///   backend.
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is normally called automatically when a repository is
/// created or opened. It may be called manually to explicitly create a file
/// system-based reference database backend for a repository.
///
/// ## C Equivalent
///
/// [`git_refdb_backend_fs()`](https://libgit2.org/docs/reference/main/sys/refdb_backend/git_refdb_backend_fs.html)
public func gitRefDBBackendFS(
    backendOut  : UnsafeMutablePointer<UnsafeMutablePointer<git_refdb_backend>?>,
    repo        : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_refdb_backend_fs(
            backendOut,
            repo
        )
    }
}



/// Sets the given reference database backend as the custom backend of the
/// given reference database.
/// - Parameters:
///   - refDB: The reference database to update. The underlying type must be
///   `git_refdb`.
///   - backend: The reference database backend to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: If the operation succeeds, ownership of the given reference
/// database backend will be transferred to the given reference database. The
/// caller must not free the reference database backend.
///
/// ## C Equivalent
///
/// [`git_refdb_set_backend()`](https://libgit2.org/docs/reference/main/sys/refdb_backend/git_refdb_set_backend.html)
public func gitRefDBSetBackend(
    refDB   : OpaquePointer,
    backend : UnsafeMutablePointer<git_refdb_backend>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_refdb_set_backend(
            refDB,
            backend
        )
    }
}
