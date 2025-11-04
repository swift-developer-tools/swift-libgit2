//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_odb_backend` instance.
/// - Parameters:
///   - backend: The `git_odb_backend` instance to initialize.
///   - version: The version to use. Pass ``gitODBBackendVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_odb_init_backend()`](https://libgit2.org/docs/reference/main/sys/odb_backend/git_odb_init_backend.html)
public func gitODBInitBackend(
    backend : UnsafeMutablePointer<git_odb_backend>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_init_backend(
            backend,
            version
        )
    }
}



/// Allocates memory for an object of the given object database.
///
/// Custom object database backends may use this function to provide data
/// to the object database from read functions.
///
/// - Important: The memory must not be freed once it is returned to libgit2.
/// If a custom object database uses this function, but encounters an error
/// and does not return the memory to libgit2, it must use
/// ``gitODBBackendDataFree(backend:data:)`` to free the buffer.
///
/// - Parameters:
///   - backend: The object database for which to allocate the memory.
///   - len: The number of bytes to allocate.
/// - Returns: The allocated buffer.
///
/// ## C Equivalent
///
/// [`git_odb_backend_data_alloc()`](https://libgit2.org/docs/reference/main/sys/odb_backend/git_odb_backend_data_alloc.html)
public func gitODBBackendDataAlloc(
    backend : UnsafeMutablePointer<git_odb_backend>,
    len     : Int
) -> UnsafeMutableRawPointer?
{
    return git_odb_backend_data_alloc(
        backend,
        len
    )
}



/// Frees the memory allocated for the given custom-allocated object database
/// buffer.
///
/// Custom object database backends may use this function to provide data
/// to the object database from read functions.
///
/// - Important: This function must be called only if a custom object database
/// used ``gitODBBackendDataAlloc(backend:len:)`` to allocate memory, but
/// encountered an error and did not return the memory to libgit2.
///
/// - Parameters:
///   - backend: The object database for which to free the memory.
///   - data: The buffer to free.
///
/// ## C Equivalent
///
/// [`git_odb_backend_data_free()`](https://libgit2.org/docs/reference/main/sys/odb_backend/git_odb_backend_data_free.html)
public func gitODBBackendDataFree(
    backend : UnsafeMutablePointer<git_odb_backend>?,
    data    : UnsafeMutableRawPointer?
)
{
    guard
        let backend,
        let data
    else
    {
        return
    }
    
    git_odb_backend_data_free(
        backend,
        data
    )
}



/// Allocates memory for an object of the given object database.
///
/// Custom object database backends may use this function to provide data
/// to the object database from read functions.
///
/// - Important: The memory must not be freed once it is returned to libgit2.
/// If a custom object database uses this function, but encounters an error
/// and does not return the memory to libgit2, it must use
/// ``gitODBBackendDataFree(backend:data:)`` to free the buffer.
///
/// - Warning: This is deprecated in libgit2 and will be removed in the next
/// major release. Use ``gitODBBackendDataAlloc(backend:len:)`` instead.
///
/// - Parameters:
///   - backend: The object database for which to allocate the memory.
///   - len: The number of bytes to allocate.
/// - Returns: The allocated buffer.
///
/// ## C Equivalent
///
/// [`git_odb_backend_malloc()`](https://libgit2.org/docs/reference/main/sys/odb_backend/git_odb_backend_malloc.html)
public func gitODBBackendDataMalloc(
    backend : UnsafeMutablePointer<git_odb_backend>,
    len     : Int
) -> UnsafeMutableRawPointer?
{
    return git_odb_backend_malloc(
        backend,
        len
    )
}
