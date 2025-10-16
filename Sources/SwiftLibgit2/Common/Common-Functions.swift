//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import CLibgit2Opts
import Foundation



/// Gets the libgit2 version currently being used.
/// - Parameters:
///   - major: The pointer in which to store the major version number.
///   - minor: The pointer in which to store the minor version number
///   - rev: The pointer in which to store the revision (patch) number
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_libgit2_version()`](https://libgit2.org/docs/reference/main/common/git_libgit2_version.html)
public func gitLibgit2Version(
    major   : UnsafeMutablePointer<Int32>,
    minor   : UnsafeMutablePointer<Int32>,
    rev     : UnsafeMutablePointer<Int32>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_version(
            major,
            minor,
            rev
        )
    }
}



/// Gets the name of the libgit2 prerelease state.
/// - Returns: The name of the prerelease state.
///
/// ## Discussion
///
/// For nightly builds during active development, the prerelease state name
/// will be `alpha`. Releases may have a `beta` or release candidate (`rc1`,
/// `rc2`, etc.) prerelease. This function will return `nil` for a final
/// release.
///
/// ## C Equivalent
///
/// [`git_libgit2_prerelease()`](https://libgit2.org/docs/reference/main/common/git_libgit2_prerelease.html)
public func gitLibgit2Prerelease() -> String?
{
    let prerelease: UnsafePointer<CChar>? = git_libgit2_prerelease()
    
    return String(optionalCString: prerelease)
}



/// Gets the compile-time options of libgit2.
/// - Returns: The compile-time options of libgit2.
///
/// ## C Equivalent
///
/// [`git_libgit2_features()`](https://libgit2.org/docs/reference/main/common/git_libgit2_features.html)
public func gitLibgit2Features() -> GitFeatureT?
{
    let features: Int32 = git_libgit2_features()
    
    guard features >= 0
    else
    {
        return nil
    }
    
    return GitFeatureT(rawValue: UInt32(features))
}



/// Gets the backend details for the given compile-time feature in libgit2.
/// - Parameter feature: The feature for which to get backend details.
/// - Returns: The backend details for the given compile-time feature,
/// or `nil` if the feature is not supported.
///
/// ## Discussion
///
/// This function will return the "backend" for the feature, which is useful
/// for things like HTTPS or SSH support that can have multiple backends that
/// could be compiled in.
///
/// For example, when libgit2 is compiled with dynamic OpenSSL support, the
/// feature backend will be `openssl-dynamic`. The feature backend names
/// reflect the compilation options specified to the build system (though in
/// all lower case). The backend may be `builtin` for features that are
/// provided by libgit2 itself.
///
/// ## C Equivalent
///
/// [`git_libgit2_feature_backend()`](https://libgit2.org/docs/reference/main/common/git_libgit2_feature_backend.html)
public func gitLibgit2FeatureBackend(
    feature: GitFeatureT
) -> String?
{
    let featureBackend: UnsafePointer<CChar>?
        = git_libgit2_feature_backend(feature.cValue())
    
    return String(optionalCString: featureBackend)
}



/// Gets the maximum `mmap()` window size.
/// - Parameter size: The pointer in which to store the window size value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetMWindowSize(
    size: UnsafeMutablePointer<Int>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_mwindow_size(size)
    }
}



/// Sets the maximum `mmap()` window size.
/// - Parameter size: The maximum `mmap()` window size to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetMWindowSize(
    size: Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_mwindow_size(size)
    }
}



/// Gets the maximum memory that will be mapped in total by libgit2.
/// - Parameter limit: The pointer in which to store the maximum memory value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetMWindowMappedLimit(
    limit: UnsafeMutablePointer<Int>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_mwindow_mapped_limit(limit)
    }
}



/// Sets the maximum amount of memory that can be mapped in total by libgit2.
/// - Parameter limit: The maximum memory value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetMWindowMappedLimit(
    limit: Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_mwindow_mapped_limit(limit)
    }
}



/// Gets the search path for the given level of configuration data.
/// - Parameters:
///   - level: The priority level for which to get the search path.
///   - buf: The `Data` instance to update with the search path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// `level` must be one of the following values:
///
/// - ``GitConfigLevelT/gitConfigLevelProgramData``
/// - ``GitConfigLevelT/gitConfigLevelSystem``
/// - ``GitConfigLevelT/gitConfigLevelXDG``
/// - ``GitConfigLevelT/gitConfigLevelGlobal``
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetSearchPath(
    level   : GitConfigLevelT,
    buf     : inout Data
) -> GitErrorCode
{
    return withCConversion
    {
        return try buf.withMutatingGitBuf
        {
            cBuf in
            
            return git_libgit2_opt_get_search_path(
                level.rawValue,
                cBuf
            )
        }
    }
}



/// Sets the search path for the given level of configuration data.
/// - Parameters:
///   - level: The priority level for which to set the search path.
///   - path: The search path to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// `level` must be one of the following values:
/// - ``GitConfigLevelT/gitConfigLevelProgramData``
/// - ``GitConfigLevelT/gitConfigLevelSystem``
/// - ``GitConfigLevelT/gitConfigLevelXDG``
/// - ``GitConfigLevelT/gitConfigLevelGlobal``
///
/// `path` lists the directories specified by ``gitPathListSeparator``. Pass
/// `nil` to reset to the default, which is generally based on environment
/// variables. Pass magic path `$PATH` to include the old value of the path
/// (for example, for prepending or appending).
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetSearchPath(
    level   : GitConfigLevelT,
    path    : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_search_path(
            level.rawValue,
            path
        )
    }
}



/// Sets the maximum data size for the given type of object to be considered
/// eligible for caching in memory.
/// - Parameters:
///   - type: The type of object for which to set the maximum data size.
///   - size: The maximum data size to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Setting the limit to `0` means that the given type of object will not be
/// cached.
///
/// The default value is `0` for ``GitObjectT/gitObjectBlob`` and `4,000` for
/// ``GitObjectT/gitObjectCommit``, ``GitObjectT/gitObjectTree``, and
/// ``GitObjectT/gitObjectTag``.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetCacheObjectLimit(
    type    : GitObjectT,
    size    : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_cache_object_limit(
            type.cValue(),
            size
        )
    }
}



/// Sets the maximum total data size that will be cached in memory across all
/// repositories before libgit2 starts evicting objects from the cache.
/// - Parameter maxStorageBytes: The maximum total data size to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is 256 MB.
///
/// Since this is a soft limit, libgit2 may briefly exceed it, but will start
/// aggressively evicting objects from cache when that happens.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetCacheMaxSize(
    maxStorageBytes: Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_cache_max_size(maxStorageBytes)
    }
}



/// Enables or disable caching completely.
/// - Parameter enabled: Whether to enable caching.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Since caches are repository-specific, disabling the cache cannot
/// immediately clear all cached objects, but each cache will be cleared on
/// the next attempt to update anything in it.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableCaching(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_caching(enabled.int32Value)
    }
}



/// Gets the current number of bytes in the cache and the maximum number of
/// bytes that would be allowed in the cache.
/// - Parameters:
///   - current: The pointer in which to store the current number of bytes in
///   the cache.
///   - allowed: The pointer in which to store the maximum number of bytes
///   that would be allowed in the cache.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetCachedMemory(
    current : UnsafeMutablePointer<Int>,
    allowed : UnsafeMutablePointer<Int>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_cached_memory(
            current,
            allowed
        )
    }
}



/// Gets the default template path.
/// - Parameter out: The `Data` instance to update with the template path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetTemplatePath(
    out: inout Data
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_libgit2_opt_get_template_path(cOut)
        }
    }
}



/// Sets the default template path.
/// - Parameter path: The default template path to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetTemplatePath(
    path: String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_template_path(path)
    }
}



/// Sets the SSL certificate-authority locations.
/// - Parameters:
///   - file: The location of a file containing several certificates
///   concatenated together.
///   - path: The path to a directory holding several certificates, one
///   per file.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Either `file` or `path` may be `nil`, but both may not be `nil`.
///
/// Calling ``gitLibgit2OptAddSSLX509Cert(cert:)`` may override the data in
/// `path`.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetSSLCertLocations(
    file    : String?,
    path    : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_ssl_cert_locations(
            file,
            path
        )
    }
}



/// Sets the value of the comment section of the User-Agent header.
/// - Parameter userAgent: The comment section value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The value can represent information about the product and its version.
/// The default value is `libgit2` followed by the libgit2 version
///
/// This value will be appended to User-Agent product, which is typically set
/// to `git/2.0`.
///
/// Pass an empty string to not send any information in the comment section,
/// or pass `nil` to restore the default value.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetUserAgent(
    userAgent: String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_user_agent(userAgent)
    }
}



/// Enables strict input validation when creating new objects to ensure that
/// all inputs to the new objects are valid.
/// - Parameter enabled: Whether to enable strict object creation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `true`.
///
/// When this is enabled, the parent(s) and tree inputs will be validated when
/// creating a new commit.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableStrictObjectCreation(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_strict_object_creation(enabled.int32Value)
    }
}



/// Enables validation of the target of a symbolic reference during creation.
/// - Parameter enabled: Whether to enable strict symbolic reference creation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `true`.
///
/// For example, `foobar` is not a valid ref, therefore `foobar` is not a
/// valid target for a symbolic reference by default, whereas
/// `refs/heads/foobar` is a valid target. Disabling this will bypass
/// validation, so an arbitrary string such as `foobar` can be used for a
/// symbolic reference target.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableStrictSymbolicRefCreation(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_strict_symbolic_ref_creation(
            enabled.int32Value
        )
    }
}



/// Sets the SSL ciphers use for HTTPS connections.
/// - Parameter ciphers: The SSL ciphers to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetSSLCiphers(
    ciphers: String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_ssl_ciphers(ciphers)
    }
}



/// Gets the value of the comment section of the User-Agent header.
/// - Parameter out: The `Data` instance to update with the comment section
/// of the User-Agent header.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetUserAgent(
    out: inout Data
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_libgit2_opt_get_user_agent(cOut)
        }
    }
}



/// Enables or disables the use of offset deltas when creating packfiles,
/// and the negotiation of them when talking to a remote server.
/// - Parameter enabled: Whether to enable offset deltas.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `true`.
///
/// Offset deltas store a delta base location as an offset into the packfile
/// from the current location, which provides shorter encoding and smaller
/// packfiles. Packfiles containing offset deltas can still be read.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableOFSDelta(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_ofs_delta(enabled.int32Value)
    }
}



/// Enables synchronized writes of files in the Git directory using `fsync`
/// (or the platform equivalent) to ensure that new object data is written to
/// permanent storage, not simply cached.
/// - Parameter enabled: Whether to enable synchronized writes of files in the
/// Git directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `false`.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableFSyncGitDir(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_fsync_gitdir(enabled.int32Value)
    }
}



/// Gets the share mode used when opening files on Windows.
/// - Parameter value: The pointer in which to store the share mode value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetWindowsShareMode(
    value: UnsafeMutablePointer<UInt>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_windows_sharemode(value)
    }
}



/// Sets the share mode used when opening files on Windows.
/// - Parameter value: The share mode value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `FILE_SHARE_READ | FILE_SHARE_WRITE`.
///
/// - Note: This option is only available on Windows platforms.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetWindowsShareMode(
    value: UInt
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_windows_sharemode(value)
    }
}



/// Enables strict verification of object hash sums when reading objects from
/// disk.
/// - Parameter enabled: Whether to enable strict hash verification.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `true`.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableStrictHashVerification(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_strict_hash_verification(enabled.int32Value)
    }
}



/// Sets the memory allocator to a different memory allocator.
/// - Parameter allocator: The memory allocator to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The given allocator will then be used to make all memory allocations for
/// libgit2 operations. Pass `nil` to restore the system default allocator.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetAllocator(
    allocator: UnsafeMutablePointer<git_allocator>?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_allocator(allocator)
    }
}



/// Ensures that there are no unsaved changes in the index before beginning
/// any operation that reloads the index from disk (for example, the checkout
/// operation).
/// - Parameter enabled: Whether to enable unsaved index safety.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `true`.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableUnsavedIndexSafety(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_unsaved_index_safety(enabled.int32Value)
    }
}



/// Gets the maximum number of objects libgit2 will allow in a pack file when
/// downloading a packfile from a remote.
/// - Parameter out: The pointer in which to store the maximum number of
/// objects.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetPackMaxObjects(
    out: UnsafeMutablePointer<Int>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_pack_max_objects(out)
    }
}



/// Sets the maximum number of objects libgit2 will allow in a pack file when
/// downloading a packfile from a remote.
/// - Parameter objects: The maximum number of objects to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This option can be used to limit maximum memory usage when fetching from
/// an untrusted remote.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetPackMaxObjects(
    objects: Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_pack_max_objects(objects)
    }
}



/// Skips `.keep` file existence checks when accessing packfiles.
/// - Parameter skip: Whether to skip `.keep` file existence checks.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Skipping file existence checks can improve performance with remote file
/// systems.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptDisablePackKeepFileChecks(
    skip: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_disable_pack_keep_file_checks(skip.int32Value)
    }
}



/// Uses `expect`/`continue` when connecting to a server using NTLM or
/// Negotiate authentication.
/// - Parameter enabled: Whether to enable HTTP `expect`/`continue`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This option is not available on Windows.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptEnableHTTPExpectContinue(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_enable_http_expect_continue(enabled.int32Value)
    }
}



/// Gets the maximum number of files that will be mapped at any time by libgit2.
/// - Parameter limit: The pointer in which to store the maximum number of
/// files.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetMWindowFileLimit(
    limit: UnsafeMutablePointer<Int>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_mwindow_file_limit(limit)
    }
}



/// Sets the maximum number of files that will be mapped at any time by libgit2.
/// - Parameter limit: The maximum number of files.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value (`0`) is unlimited.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetMWindowFileLimit(
    limit: Int
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_mwindow_file_limit(limit)
    }
}



/// Overrides the default priority of the packed object database backend,
/// which is added when default backends are assigned to a repository.
/// - Parameter priority: The priority level to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetODBPackedPriority(
    priority: Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_odb_packed_priority(priority)
    }
}



/// Overrides the default priority of the loose object database backend, which
/// is added when default backends are assigned to a repository.
/// - Parameter priority: The priority level to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetODBLoosePriority(
    priority: Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_odb_loose_priority(priority)
    }
}



/// Gets the list of supported Git extensions.
/// - Parameter out: The pointer in which to store the list of supported Git
/// extensions.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is the list of built-in extensions supported by libgit2 and custom
/// extensions that have been added with
/// ``gitLibgit2OptSetExtensions(extensions:len:)``. This function will not
/// return extensions that have been negated.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetExtensions(
    out: UnsafeMutablePointer<[String]>
) -> GitErrorCode
{
    return withCConversion
    {
        var strArray = git_strarray()
        
        let getExtensionsResult: Int32
            = git_libgit2_opt_get_extensions(&strArray)
        
        out.pointee = Array(strArray)
        
        gitStrArrayDispose(array: &strArray)
        
        return getExtensionsResult
    }
}



/// Sets the list of supported Git extensions.
/// - Parameters:
///   - extensions: The Git extensions to set.
///   - len: The length of `extensions`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Extensions supported by libgit2 may be negated by prefixing them with an
/// exclamation mark (`!`).
///
/// For example, passing `["!noop", "newext"]` as `extensions` indicates that
/// the caller does not want to support repositories with the `noop` extension,
/// but does want to support repositories with the `newext` extension.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetExtensions(
    extensions  : [String],
    len         : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try extensions.withArrayOfImmutableCStrings
        {
            cExtensions in
            
            return git_libgit2_opt_set_extensions(
                cExtensions,
                len
            )
        }
    }
}



/// Gets the owner validation setting for repository directories.
/// - Parameter enabled: The pointer in which to store the owner validation
/// setting.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetOwnerValidation(
    enabled: UnsafeMutablePointer<Bool>
) -> GitErrorCode
{
    return withCConversion
    {
        var intEnabled: Int32 = 0
        
        let getOwnerValidationResult: Int32
            = git_libgit2_opt_get_owner_validation(&intEnabled)
        
        enabled.pointee = Bool(intEnabled)
        
        return getOwnerValidationResult
    }
}



/// Sets the owner validation setting for repository directories.
/// - Parameter enabled: Whether owner validation is enabled.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `true`.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetOwnerValidation(
    enabled: Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_owner_validation(enabled.int32Value)
    }
}



/// Gets the current user's home directory to be used for file lookups.
/// - Parameter out: The `Data` instance to update with the home directory path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetHomeDir(
    out: inout Data
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_libgit2_opt_get_homedir(cOut)
        }
    }
}



/// Sets the current user's home directory to be used for file lookups.
/// - Parameter path: The home directory path to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetHomeDir(
    path: String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_homedir(path)
    }
}



/// Sets the timeout (in milliseconds) to attempt connections to a remote
/// server.
/// - Parameter timeout: The timeout to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetServerConnectTimeout(
    timeout: Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_server_connect_timeout(timeout)
    }
}



/// Gets the timeout (in milliseconds) to attempt connections to a remote
/// server.
/// - Parameter timeout: The pointer in which to store the timeout value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetServerConnectTimeout(
    timeout: UnsafeMutablePointer<Int32>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_server_connect_timeout(timeout)
    }
}



/// Sets the timeout (in milliseconds) for reading from and writing to a
/// remote server.
/// - Parameter timeout: The timeout to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetServerTimeout(
    timeout: Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_server_timeout(timeout)
    }
}



/// Gets the timeout (in milliseconds) for reading from and writing to a
/// remote server.
/// - Parameter timeout: The pointer in which to store the timeout value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetServerTimeout(
    timeout: UnsafeMutablePointer<Int32>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_get_server_timeout(timeout)
    }
}



/// Sets the value of the product portion of the User-Agent header.
/// - Parameter userAgent: The product section value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default value is `git/2.0`, for compatibility with other Git clients.
///
/// It is recommended to keep this as `git/<version>` for compatibility with
/// servers that perform user-agent detection.
///
/// Pass an empty string to not send any information in the product section,
/// or pass `nil` to restore the default value.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptSetUserAgentProduct(
    userAgent: String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_set_user_agent_product(userAgent)
    }
}



/// Gets the value of the product section of the User-Agent header.
/// - Parameter out: The `Data` instance to update with the product section
/// of the User-Agent header.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptGetUserAgentProduct(
    out: inout Data
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_libgit2_opt_get_user_agent_product(cOut)
        }
    }
}



/// Adds a raw X.509 certificate into the SSL certifications store.
/// - Parameter cert: The raw X.509 certificate to add into the SSL
/// certifications store.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This certificate is only used by libgit2 invocations during the application
/// lifetime and is not persisted to the disk. This certificate cannot be
/// removed from the application once is has been added.
///
/// - Note: This function is a type-safe binding to the variadic function
/// `git_libgit2_opts()`. See ``GitLibgit2OptT`` for more information.
///
/// ## C Equivalent
///
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html)
public func gitLibgit2OptAddSSLX509Cert(
    cert: UnsafeRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_libgit2_opt_add_ssl_x509_cert(cert)
    }
}
