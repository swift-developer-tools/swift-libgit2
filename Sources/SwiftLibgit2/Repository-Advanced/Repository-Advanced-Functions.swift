//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a blank repository with no backend or configuration.
///
/// A blank repository is useful if it needs to be associated with an object
/// database and configuration store that are not backed by a file system.
///
/// Since a blank repository has no physical location, some systems may fail
/// to function properly. Locations under `$GIT_DIR`, `$GIT_COMMON_DIR`, and
/// `$GIT_INFO_DIR` are impacted.
///
/// - Note: This function supports only SHA-1 repositories.
///
/// - Parameter out: The pointer in which to store the repository. The
/// underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_new()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_new.html)
public func gitRepositoryNew(
    out: UnsafeMutablePointer<OpaquePointer?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_new(out)
    }
}



/// Resets the internal state of the given repository.
///
/// - Note: ``gitRepositoryFree(repo:)`` performs this operation before
/// deallocating the given repository. It is generally unnecessary to call
/// this function.
///
/// - Parameter repo: The repository to reset. The underlying type must be
/// `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository__cleanup()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository__cleanup.html)
public func gitRepositoryCleanup(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository__cleanup(repo)
    }
}



/// Updates the file system configuration for the given open repository.
///
/// When a repository is initialized, configuration values such as
/// `core.ignorecase`, `core.filemode`, and `core.symlinks` are set based on
/// the properties of the file system. If the repository is moved to a new file
/// system, these properties may no longer be correct, and the repository may
/// not behave as expected. This function reruns the phase of repository
/// initialization that sets those configuration properties.
///
/// - Parameters:
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
///   - recurseSubmodules: Whether to recursively update submodules.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_reinit_filesystem()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_reinit_filesystem.html)
public func gitRepositoryReinitFileSystem(
    repo                : OpaquePointer,
    recurseSubmodules   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_reinit_filesystem(
            repo,
            recurseSubmodules.int32Value
        )
    }
}



/// Sets the configuration file of the given repository.
///
/// - Important: Ownership of the given configuration will not transfer to the
/// repository. The caller must still free it.
///
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - config: The configuration to use. The underlying type must be
///   `git_config`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_set_config()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_set_config.html)
public func gitRepositorySetConfig(
    repo    : OpaquePointer,
    config  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_config(
            repo,
            config
        )
    }
}



/// Sets the object database of the given repository.
///
/// - Important: Ownership of the given object database will not transfer to
/// the repository. The caller must still free it.
///
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - odb: The object database to use. The underlying type must be
///   `git_odb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_set_odb()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_set_odb.html)
public func gitRepositorySetODB(
    repo    : OpaquePointer,
    odb     : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_odb(
            repo,
            odb
        )
    }
}



/// Sets the reference database of the given repository.
///
/// - Important: Ownership of the given reference database will not transfer to
/// the repository. The caller must still free it.
///
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - refDB: The reference database to use. The underlying type must be
///   `git_refdb`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_set_refdb()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_set_refdb.html)
public func gitRepositorySetRefDB(
    repo    : OpaquePointer,
    refDB   : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_refdb(
            repo,
            refDB
        )
    }
}



/// Sets the index of the given repository.
///
/// - Important: Ownership of the given index will not transfer to the
/// repository. The caller must still free it.
///
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - index: The index to use. The underlying type must be `git_index`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_set_index()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_set_index.html)
public func gitRepositorySetIndex(
    repo    : OpaquePointer,
    index   : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_index(
            repo,
            index
        )
    }
}



/// Converts the given repository to a bare repository.
///
/// This function will clear the working directory of the given repository,
/// and set `core.bare` to `true`.
///
/// - Note: This function will not update the index. Consider calling
/// ``gitRepositorySetIndex(repo:index:)`` to set the index to `nil`,
/// since a bare repository generally does not have an index.
///
/// - Parameter repo: The repository to update. The underlying type must be
/// `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_set_bare()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_set_bare.html)
public func gitRepositorySetBare(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_set_bare(repo)
    }
}



/// Loads and caches all submodules of the given repository.
///
/// Since the `.gitmodules` file is unstructured, loading submodules is an
/// `O(n)` operation. Any operation that requires accessing all submodules is
/// `O(n²)`. This function loads and caches all submodules, so that
/// subsequent calls to ``gitSubmoduleLookup(out:repo:name:)`` are `O(1)`.
///
/// - Parameter repo: The repository containing the submodules to cache. The
/// underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_submodule_cache_all()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_submodule_cache_all.html)
public func gitRepositorySubmoduleCacheAll(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_submodule_cache_all(repo)
    }
}



/// Clears the submodule cache of the given repository.
///
/// The submodule cache incorporates data from the repository's configuration
/// and the state of the working tree, the index, and HEAD. Any time one of
/// these has changed, the submodule cache may become invalid.
///
/// - Parameter repo: The repository containing the submodule cache to clear.
/// The underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_repository_submodule_cache_clear()`](https://libgit2.org/docs/reference/main/sys/repository/git_repository_submodule_cache_clear.html)
public func gitRepositorySubmoduleCacheClear(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_repository_submodule_cache_clear(repo)
    }
}
