//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Configurable features of libgit2.
///
/// ## C Equivalent
///
/// [`git_feature_t`](https://libgit2.org/docs/reference/main/common/git_feature_t.html)
public struct GitFeatureT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitFeatureT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// libgit2 is thread-aware and can be used from multiple threads (as described in the
    /// libgit2 documentation).
    public static let gitFeatureThreads         = GitFeatureT(rawValue: GIT_FEATURE_THREADS.rawValue)
    
    /// HTTPS remotes.
    public static let gitFeatureHTTPS           = GitFeatureT(rawValue: GIT_FEATURE_HTTPS.rawValue)
    
    /// SSH remotes.
    public static let gitFeatureSSH             = GitFeatureT(rawValue: GIT_FEATURE_SSH.rawValue)
    
    /// Sub-second resolution in index timestamps.
    public static let gitFeatureNSEC            = GitFeatureT(rawValue: GIT_FEATURE_NSEC.rawValue)
    
    /// HTTP parsing.
    ///
    /// ## Discussion
    ///
    /// This feature is always available.
    public static let gitFeatureHTTPParser      = GitFeatureT(rawValue: GIT_FEATURE_HTTP_PARSER.rawValue)
    
    /// Regular expression support.
    ///
    /// ## Discussion
    ///
    /// This feature is always available.
    public static let gitFeatureRegex           = GitFeatureT(rawValue: GIT_FEATURE_REGEX.rawValue)
    
    /// Internationalization support for filename translation.
    public static let gitFeatureI18N            = GitFeatureT(rawValue: GIT_FEATURE_I18N.rawValue)
    
    /// NTLM support over HTTPS.
    public static let gitFeatureAuthNTLM        = GitFeatureT(rawValue: GIT_FEATURE_AUTH_NTLM.rawValue)
    
    /// Kerberos (SPNEGO) authentication support over HTTPS.
    public static let gitFeatureAuthNegotiate   = GitFeatureT(rawValue: GIT_FEATURE_AUTH_NEGOTIATE.rawValue)
    
    /// Zlib support.
    ///
    /// ## Discussion
    ///
    /// This feature is always available.
    public static let gitFeatureCompression     = GitFeatureT(rawValue: GIT_FEATURE_COMPRESSION.rawValue)
    
    /// SHA-1 object support.
    ///
    /// ## Discussion
    ///
    /// This feature is always available.
    public static let gitFeatureSHA1            = GitFeatureT(rawValue: GIT_FEATURE_SHA1.rawValue)
    
    /// SHA-256 object support.
    public static let gitFeatureSHA256          = GitFeatureT(rawValue: GIT_FEATURE_SHA256.rawValue)
    
    
    
    /// Converts the ``GitFeatureT`` instance into a `git_feature_t` instance.
    /// - Returns: The `git_feature_t` instance.
    internal func cValue() -> git_feature_t
    {
        return git_feature_t(rawValue)
    }
}



/// Global libgit2 options.
///
/// ## Discussion
///
/// This enum is provided for documentation purposes, but is not used by other bindings.
///
/// In libgit2, these values are intended for use with the variadic function called
/// [`git_libgit2_opts()`](https://libgit2.org/docs/reference/main/common/git_libgit2_opts.html).
/// There is no binding for `git_libgit2_opts()`, since it uses C-style variadic arguments
/// (`...`), and Swift can only import C variadic functions that use `va_list` for their arguments.
///
/// Use the type-safe Common Functions bindings related to libgit2 options instead.
///
/// ## C Equivalent
///
/// [`git_libgit2_opt_t`](https://libgit2.org/docs/reference/main/common/git_libgit2_opt_t.html)
public enum GitLibgit2OptT: UInt32, GitEnum
{
    /// Gets the maximum `mmap()` window size.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetMWindowSize(size:)`` to interact with this option.
    case gitOptGetMWindowSize                   = 0
    
    /// Sets the maximum `mmap()` window size.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetMWindowSize(size:)`` to interact with this option.
    case gitOptSetMWindowSize                   = 1
    
    /// Gets the maximum memory that will be mapped in total by libgit2.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetMWindowMappedLimit(limit:)`` to interact with this option.
    case gitOptGetMWindowMappedLimit            = 2
    
    /// Sets the maximum amount of memory that can be mapped in total by libgit2.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetMWindowMappedLimit(limit:)`` to interact with this option.
    case gitOptSetMWindowMappedLimit            = 3
    
    /// Gets the search path for the given level of configuration data.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetSearchPath(level:buf:)`` to interact with this option.
    case gitOptGetSearchPath                    = 4
    
    /// Sets the search path for the given level of configuration data.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetSearchPath(level:path:)`` to interact with this option.
    case gitOptSetSearchPath                    = 5
    
    /// Sets the maximum data size for the given type of object to be considered eligible for caching
    /// in memory.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetCacheObjectLimit(type:size:)`` to interact with this option.
    case gitOptSetCacheObjectLimit              = 6
    
    /// Sets the maximum total data size that will be cached in memory across all repositories before
    /// libgit2 starts evicting objects from the cache.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetCacheMaxSize(maxStorageBytes:)`` to interact with this
    /// option.
    case gitOptSetCacheMaxSize                  = 7
    
    /// Enables or disable caching completely.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableCaching(enabled:)`` to interact with this option.
    case gitOptEnableCaching                    = 8
    
    /// Gets the current number of bytes in the cache and the maximum number of bytes that would be
    /// allowed in the cache.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetCachedMemory(current:allowed:)`` to interact with this
    /// option.
    case gitOptGetCachedMemory                  = 9
    
    /// Gets the default template path.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetTemplatePath(out:)`` to interact with this option.
    case gitOptGetTemplatePath                  = 10
    
    /// Sets the default template path.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetTemplatePath(path:)`` to interact with this option.
    case gitOptSetTemplatePath                  = 11
    
    /// Sets the SSL certificate-authority locations.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetSSLCertLocations(file:path:)`` to interact with this
    /// option.
    case gitOptSetSSLCertLocations              = 12
    
    /// Sets the value of the comment section of the User-Agent header.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetUserAgent(userAgent:)`` to interact with this option.
    case gitOptSetUserAgent                     = 13
    
    /// Enables strict input validation when creating new objects to ensure that all inputs to the new
    /// objects are valid.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableStrictObjectCreation(enabled:)`` to interact with
    /// this option.
    case gitOptEnableStrictObjectCreation       = 14
    
    /// Enables validation of the target of a symbolic ref during creation.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableStrictSymbolicRefCreation(enabled:)`` to
    /// interact with this option.
    case gitOptEnableStrictSymbolicRefCreation  = 15
    
    /// Sets the SSL ciphers use for HTTPS connections.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetSSLCiphers(ciphers:)`` to interact with this option.
    case gitOptSetSSLCiphers                    = 16
    
    /// Gets the value of the User-Agent header.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetUserAgent(out:)`` to interact with this option.
    case gitOptGetUserAgent                     = 17
    
    /// Enables or disables the use of offset deltas when creating packfiles, and the negotiation of
    /// them when talking to a remote server.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableOFSDelta(enabled:)`` to interact with this option.
    case gitOptEnableOFSDelta                   = 18
    
    /// Enables synchronized writes of files in the Git directory using `fsync` (or the platform
    /// equivalent) to ensure that new object data is written to permanent storage, not simply cached.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableFSyncGitDir(enabled:)`` to interact with this option.
    case gitOptEnableFSyncGitDir                = 19
    
    /// Gets the share mode used when opening files on Windows.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetWindowsShareMode(value:)`` to interact with this option.
    case gitOptGetWindowsShareMode              = 20
    
    /// Sets the share mode used when opening files on Windows.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetWindowsShareMode(value:)`` to interact with this option.
    case gitOptSetWindowsShareMode              = 21
    
    /// Enables strict verification of object hash sums when reading objects from disk.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableStrictHashVerification(enabled:)`` to interact
    /// with this option.
    case gitOptEnableStrictHashVerification     = 22
    
    /// Sets the memory allocator to a different memory allocator.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetAllocator(allocator:)`` to interact with this option.
    case gitOptSetAllocator                     = 23
    
    /// Ensures that there are no unsaved changes in the index before beginning any operation that
    /// reloads the index from disk (for example, the checkout operation).
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableUnsavedIndexSafety(enabled:)`` to interact with
    /// this option.
    case gitOptEnableUnsavedIndexSafety         = 24
    
    /// Gets the maximum number of objects libgit2 will allow in a pack file when downloading a
    /// packfile from a remote.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetPackMaxObjects(out:)`` to interact with this option.
    case gitOptGetPackMaxObjects                = 25
    
    /// Sets the maximum number of objects libgit2 will allow in a pack file when downloading a
    /// packfile from a remote.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetPackMaxObjects(objects:)`` to interact with this option.
    case gitOptSetPackMaxObjects                = 26
    
    /// Skips `.keep` file existence checks when accessing packfiles.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptDisablePackKeepFileChecks(enabled:)`` to interact with
    /// this option.
    case gitOptDisablePackKeepFileChecks        = 27
    
    /// Uses `expect`/`continue` when connecting to a server using NTLM or Negotiate
    /// authentication.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptEnableHTTPExpectContinue(enabled:)`` to interact with this
    /// option.
    case gitOptEnableHTTPExpectContinue         = 28
    
    /// Gets the maximum number of files that will be mapped at any time by libgit2.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetMWindowFileLimit(limit:)`` to interact with this option.
    case gitOptGetMWindowFileLimit              = 29
    
    /// Sets the maximum number of files that can be mapped at any time by libgit2.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetMWindowFileLimit(limit:)`` to interact with this option.
    case gitOptSetMWindowFileLimit              = 30
    
    /// Overrides the default priority of the packed object database backend, which is added when
    /// default backends are assigned to a repository.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetODBPackedPriority(priority:)`` to interact with this
    /// option.
    case gitOptSetODBPackedPriority             = 31
    
    /// Overrides the default priority of the loose object database backend, which is added when
    /// default backends are assigned to a repository.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetODBLoosePriority(priority:)`` to interact with this
    /// option.
    case gitOptSetODBLoosePriority              = 32
    
    /// Gets the list of supported Git extensions.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetExtensions(out:)`` to interact with this option.
    case gitOptGetExtensions                    = 33
    
    /// Sets the list of supported Git extensions.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetExtensions(extensions:len:)`` to interact with this
    /// option.
    case gitOptSetExtensions                    = 34
    
    /// Gets the owner validation setting for repository directories.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetOwnerValidation(enabled:)`` to interact with this option.
    case gitOptGetOwnerValidation               = 35
    
    /// Specifies that repository directories should be owned by the current user.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetOwnerValidation(enabled:)`` to interact with this option.
    case gitOptSetOwnerValidation               = 36
    
    /// Gets the current user's home directory to be used for file lookups.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetHomeDir(out:)`` to interact with this option.
    case gitOptGetHomeDir                       = 37
    
    /// Sets the current user's home directory to be used for file lookups.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetHomeDir(path:)`` to interact with this option.
    case gitOptSetHomeDir                       = 38
    
    /// Sets the timeout (in milliseconds) to attempt connections to a remote server.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetServerConnectTimeout(timeout:)`` to interact with this
    /// option.
    case gitOptSetServerConnectTimeout          = 39
    
    /// Gets the timeout (in milliseconds) to attempt connections to a remote server.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetServerConnectTimeout(timeout:)`` to interact with this
    /// option.
    case gitOptGetServerConnectTimeout          = 40
    
    /// Sets the timeout (in milliseconds) for reading from and writing to a remote server.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetServerTimeout(timeout:)`` to interact with this option.
    case gitOptSetServerTimeout                 = 41
    
    /// Gets the timeout (in milliseconds) for reading from and writing to a remote server.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetServerTimeout(timeout:)`` to interact with this option.
    case gitOptGetServerTimeout                 = 42
    
    /// Sets the value of the product portion of the User-Agent header.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptSetUserAgentProduct(userAgent:)`` to interact with this
    /// option.
    case gitOptSetUserAgentProduct              = 43
    
    /// Gets the value of the User-Agent product header.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptGetUserAgentProduct(out:)`` to interact with this option.
    case gitOptGetUserAgentProduct              = 44
    
    /// Adds a raw X.509 certificate into the SSL certifications store.
    ///
    /// ## Discussion
    ///
    /// Use ``gitLibgit2OptAddSSLX509Cert(cert:)`` to interact with this option.
    case gitOptAddSSLX509Cert                   = 45
    
    
    
    /// Creates a ``GitLibgit2OptT`` instance from a `git_libgit2_opt_t` instance.
    /// - Parameter libgit2Opt: The `git_libgit2_opt_t` instance to use.
    internal init?(
        cValue libgit2Opt: git_libgit2_opt_t
    )
    {
        switch libgit2Opt
        {
            case GIT_OPT_GET_MWINDOW_SIZE                       : self = .gitOptGetMWindowSize
            case GIT_OPT_SET_MWINDOW_SIZE                       : self = .gitOptSetMWindowSize
            case GIT_OPT_GET_MWINDOW_MAPPED_LIMIT               : self = .gitOptGetMWindowMappedLimit
            case GIT_OPT_SET_MWINDOW_MAPPED_LIMIT               : self = .gitOptSetMWindowMappedLimit
            case GIT_OPT_GET_SEARCH_PATH                        : self = .gitOptGetSearchPath
            case GIT_OPT_SET_SEARCH_PATH                        : self = .gitOptSetSearchPath
            case GIT_OPT_SET_CACHE_OBJECT_LIMIT                 : self = .gitOptSetCacheObjectLimit
            case GIT_OPT_SET_CACHE_MAX_SIZE                     : self = .gitOptSetCacheMaxSize
            case GIT_OPT_ENABLE_CACHING                         : self = .gitOptEnableCaching
            case GIT_OPT_GET_CACHED_MEMORY                      : self = .gitOptGetCachedMemory
            case GIT_OPT_GET_TEMPLATE_PATH                      : self = .gitOptGetTemplatePath
            case GIT_OPT_SET_TEMPLATE_PATH                      : self = .gitOptSetTemplatePath
            case GIT_OPT_SET_SSL_CERT_LOCATIONS                 : self = .gitOptSetSSLCertLocations
            case GIT_OPT_SET_USER_AGENT                         : self = .gitOptSetUserAgent
            case GIT_OPT_ENABLE_STRICT_OBJECT_CREATION          : self = .gitOptEnableStrictObjectCreation
            case GIT_OPT_ENABLE_STRICT_SYMBOLIC_REF_CREATION    : self = .gitOptEnableStrictSymbolicRefCreation
            case GIT_OPT_SET_SSL_CIPHERS                        : self = .gitOptSetSSLCiphers
            case GIT_OPT_GET_USER_AGENT                         : self = .gitOptGetUserAgent
            case GIT_OPT_ENABLE_OFS_DELTA                       : self = .gitOptEnableOFSDelta
            case GIT_OPT_ENABLE_FSYNC_GITDIR                    : self = .gitOptEnableFSyncGitDir
            case GIT_OPT_GET_WINDOWS_SHAREMODE                  : self = .gitOptGetWindowsShareMode
            case GIT_OPT_SET_WINDOWS_SHAREMODE                  : self = .gitOptSetWindowsShareMode
            case GIT_OPT_ENABLE_STRICT_HASH_VERIFICATION        : self = .gitOptEnableStrictHashVerification
            case GIT_OPT_SET_ALLOCATOR                          : self = .gitOptSetAllocator
            case GIT_OPT_ENABLE_UNSAVED_INDEX_SAFETY            : self = .gitOptEnableUnsavedIndexSafety
            case GIT_OPT_GET_PACK_MAX_OBJECTS                   : self = .gitOptGetPackMaxObjects
            case GIT_OPT_SET_PACK_MAX_OBJECTS                   : self = .gitOptSetPackMaxObjects
            case GIT_OPT_DISABLE_PACK_KEEP_FILE_CHECKS          : self = .gitOptDisablePackKeepFileChecks
            case GIT_OPT_ENABLE_HTTP_EXPECT_CONTINUE            : self = .gitOptEnableHTTPExpectContinue
            case GIT_OPT_GET_MWINDOW_FILE_LIMIT                 : self = .gitOptGetMWindowFileLimit
            case GIT_OPT_SET_MWINDOW_FILE_LIMIT                 : self = .gitOptSetMWindowFileLimit
            case GIT_OPT_SET_ODB_PACKED_PRIORITY                : self = .gitOptSetODBPackedPriority
            case GIT_OPT_SET_ODB_LOOSE_PRIORITY                 : self = .gitOptSetODBLoosePriority
            case GIT_OPT_GET_EXTENSIONS                         : self = .gitOptGetExtensions
            case GIT_OPT_SET_EXTENSIONS                         : self = .gitOptSetExtensions
            case GIT_OPT_GET_OWNER_VALIDATION                   : self = .gitOptGetOwnerValidation
            case GIT_OPT_SET_OWNER_VALIDATION                   : self = .gitOptSetOwnerValidation
            case GIT_OPT_GET_HOMEDIR                            : self = .gitOptGetHomeDir
            case GIT_OPT_SET_HOMEDIR                            : self = .gitOptSetHomeDir
            case GIT_OPT_SET_SERVER_CONNECT_TIMEOUT             : self = .gitOptSetServerConnectTimeout
            case GIT_OPT_GET_SERVER_CONNECT_TIMEOUT             : self = .gitOptGetServerConnectTimeout
            case GIT_OPT_SET_SERVER_TIMEOUT                     : self = .gitOptSetServerTimeout
            case GIT_OPT_GET_SERVER_TIMEOUT                     : self = .gitOptGetServerTimeout
            case GIT_OPT_SET_USER_AGENT_PRODUCT                 : self = .gitOptSetUserAgentProduct
            case GIT_OPT_GET_USER_AGENT_PRODUCT                 : self = .gitOptGetUserAgentProduct
            case GIT_OPT_ADD_SSL_X509_CERT                      : self = .gitOptAddSSLX509Cert
            default                                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitLibgit2OptT`` instance into a `git_libgit2_opt_t` instance.
    /// - Returns: The `git_libgit2_opt_t` instance.
    internal func cValue() -> git_libgit2_opt_t
    {
        switch self
        {
            case .gitOptGetMWindowSize                  : return GIT_OPT_GET_MWINDOW_SIZE
            case .gitOptSetMWindowSize                  : return GIT_OPT_SET_MWINDOW_SIZE
            case .gitOptGetMWindowMappedLimit           : return GIT_OPT_GET_MWINDOW_MAPPED_LIMIT
            case .gitOptSetMWindowMappedLimit           : return GIT_OPT_SET_MWINDOW_MAPPED_LIMIT
            case .gitOptGetSearchPath                   : return GIT_OPT_GET_SEARCH_PATH
            case .gitOptSetSearchPath                   : return GIT_OPT_SET_SEARCH_PATH
            case .gitOptSetCacheObjectLimit             : return GIT_OPT_SET_CACHE_OBJECT_LIMIT
            case .gitOptSetCacheMaxSize                 : return GIT_OPT_SET_CACHE_MAX_SIZE
            case .gitOptEnableCaching                   : return GIT_OPT_ENABLE_CACHING
            case .gitOptGetCachedMemory                 : return GIT_OPT_GET_CACHED_MEMORY
            case .gitOptGetTemplatePath                 : return GIT_OPT_GET_TEMPLATE_PATH
            case .gitOptSetTemplatePath                 : return GIT_OPT_SET_TEMPLATE_PATH
            case .gitOptSetSSLCertLocations             : return GIT_OPT_SET_SSL_CERT_LOCATIONS
            case .gitOptSetUserAgent                    : return GIT_OPT_SET_USER_AGENT
            case .gitOptEnableStrictObjectCreation      : return GIT_OPT_ENABLE_STRICT_OBJECT_CREATION
            case .gitOptEnableStrictSymbolicRefCreation : return GIT_OPT_ENABLE_STRICT_SYMBOLIC_REF_CREATION
            case .gitOptSetSSLCiphers                   : return GIT_OPT_SET_SSL_CIPHERS
            case .gitOptGetUserAgent                    : return GIT_OPT_GET_USER_AGENT
            case .gitOptEnableOFSDelta                  : return GIT_OPT_ENABLE_OFS_DELTA
            case .gitOptEnableFSyncGitDir               : return GIT_OPT_ENABLE_FSYNC_GITDIR
            case .gitOptGetWindowsShareMode             : return GIT_OPT_GET_WINDOWS_SHAREMODE
            case .gitOptSetWindowsShareMode             : return GIT_OPT_SET_WINDOWS_SHAREMODE
            case .gitOptEnableStrictHashVerification    : return GIT_OPT_ENABLE_STRICT_HASH_VERIFICATION
            case .gitOptSetAllocator                    : return GIT_OPT_SET_ALLOCATOR
            case .gitOptEnableUnsavedIndexSafety        : return GIT_OPT_ENABLE_UNSAVED_INDEX_SAFETY
            case .gitOptGetPackMaxObjects               : return GIT_OPT_GET_PACK_MAX_OBJECTS
            case .gitOptSetPackMaxObjects               : return GIT_OPT_SET_PACK_MAX_OBJECTS
            case .gitOptDisablePackKeepFileChecks       : return GIT_OPT_DISABLE_PACK_KEEP_FILE_CHECKS
            case .gitOptEnableHTTPExpectContinue        : return GIT_OPT_ENABLE_HTTP_EXPECT_CONTINUE
            case .gitOptGetMWindowFileLimit             : return GIT_OPT_GET_MWINDOW_FILE_LIMIT
            case .gitOptSetMWindowFileLimit             : return GIT_OPT_SET_MWINDOW_FILE_LIMIT
            case .gitOptSetODBPackedPriority            : return GIT_OPT_SET_ODB_PACKED_PRIORITY
            case .gitOptSetODBLoosePriority             : return GIT_OPT_SET_ODB_LOOSE_PRIORITY
            case .gitOptGetExtensions                   : return GIT_OPT_GET_EXTENSIONS
            case .gitOptSetExtensions                   : return GIT_OPT_SET_EXTENSIONS
            case .gitOptGetOwnerValidation              : return GIT_OPT_GET_OWNER_VALIDATION
            case .gitOptSetOwnerValidation              : return GIT_OPT_SET_OWNER_VALIDATION
            case .gitOptGetHomeDir                      : return GIT_OPT_GET_HOMEDIR
            case .gitOptSetHomeDir                      : return GIT_OPT_SET_HOMEDIR
            case .gitOptSetServerConnectTimeout         : return GIT_OPT_SET_SERVER_CONNECT_TIMEOUT
            case .gitOptGetServerConnectTimeout         : return GIT_OPT_GET_SERVER_CONNECT_TIMEOUT
            case .gitOptSetServerTimeout                : return GIT_OPT_SET_SERVER_TIMEOUT
            case .gitOptGetServerTimeout                : return GIT_OPT_GET_SERVER_TIMEOUT
            case .gitOptSetUserAgentProduct             : return GIT_OPT_SET_USER_AGENT_PRODUCT
            case .gitOptGetUserAgentProduct             : return GIT_OPT_GET_USER_AGENT_PRODUCT
            case .gitOptAddSSLX509Cert                  : return GIT_OPT_ADD_SSL_X509_CERT
        }
    }
}
