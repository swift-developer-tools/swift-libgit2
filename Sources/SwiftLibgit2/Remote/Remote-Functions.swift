//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Adds a remote with the default fetch refspec to the given repository.
/// - Parameters:
///   - out: The pointer in which to store the remote. The underlying type
///   must be `git_remote`.
///   - repo: The repository in which to create the remote. The underlying
///   type must be `git_repository`.
///   - name: The remote name to use.
///   - url: The remote URL to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_create()`](https://libgit2.org/docs/reference/main/remote/git_remote_create.html)
public func gitRemoteCreate(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_create(
            out,
            repo,
            name,
            url
        )
    }
}



/// Initializes the given `git_remote_create_options` instance.
/// - Parameters:
///   - opts: The `git_remote_create_options` instance to initialize.
///   - version: The version to use. Pass ``gitRemoteCreateOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_create_options_init()`](https://libgit2.org/docs/reference/main/remote/git_remote_create_options_init.html)
public func gitRemoteCreateOptionsInit(
    opts    : UnsafeMutablePointer<git_remote_create_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_create_options_init(
            opts,
            version
        )
    }
}



/// Adds a remote with the given options.
/// - Parameters:
///   - out: The pointer in which to store the remote. The underlying type
///   must be `git_remote`.
///   - url: The remote URL to use.
///   - opts: The remote creation options. Pass `nil` to create a detached
///   remote.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_create_with_opts()`](https://libgit2.org/docs/reference/main/remote/git_remote_create_with_opts.html)
public func gitRemoteCreateWithOpts(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    url     : String,
    opts    : GitRemoteCreateOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_remote_create_with_opts(
                out,
                url,
                cOpts
            )
        }
    }
}



/// Adds a remote with the given fetch refspec to the given repository.
/// - Parameters:
///   - out: The pointer in which to store the remote. The underlying type
///   must be `git_remote`.
///   - repo: The repository in which to create the remote. The underlying
///   type must be `git_repository`.
///   - name: The remote name to use.
///   - url: The remote URL to use.
///   - fetch: The fetchspec to use. Pass `nil` to use the default fetchspec.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_create_with_fetchspec()`](https://libgit2.org/docs/reference/main/remote/git_remote_create_with_fetchspec.html)
public func gitRemoteCreateWithFetchspec(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String,
    url     : String,
    fetch   : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_create_with_fetchspec(
            out,
            repo,
            name,
            url,
            fetch
        )
    }
}



/// Adds an anonymous remote to the given repository.
/// - Parameters:
///   - out: The pointer in which to store the remote. The underlying type
///   must be `git_remote`.
///   - repo: The repository in which to create the remote. The underlying
///   type must be `git_repository`.
///   - url: The remote URL to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_create_anonymous()`](https://libgit2.org/docs/reference/main/remote/git_remote_create_anonymous.html)
public func gitRemoteCreateAnonymous(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_create_anonymous(
            out,
            repo,
            url
        )
    }
}



/// Creates a detached remote without a connected repository.
/// - Parameters:
///   - out: The pointer in which to store the remote. The underlying type
///   must be `git_remote`.
///   - url: The remote URL to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A detached remote will not consider any repository configuration values.
///
/// ## C Equivalent
///
/// [`git_remote_create_detached()`](https://libgit2.org/docs/reference/main/remote/git_remote_create_detached.html)
public func gitRemoteCreateDetached(
    out : UnsafeMutablePointer<OpaquePointer?>,
    url : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_create_detached(
            out,
            url
        )
    }
}



/// Looks up the specified remote.
/// - Parameters:
///   - out: The pointer in which to store the remote. The underlying type
///   must be `git_remote`.
///   - repo: The repository containing the remote. The underlying type must
///   be `git_repository`.
///   - name: The name of the remote to look up. This will be checked for
///   validity.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_lookup()`](https://libgit2.org/docs/reference/main/remote/git_remote_lookup.html)
public func gitRemoteLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_lookup(
            out,
            repo,
            name
        )
    }
}



/// Creates an in-memory copy of the given remote.
/// - Parameters:
///   - out: The pointer in which to store the copied remote. The underlying
///   type must be `git_remote`.
///   - source: The remote to copy. The underlying type must be `git_remote`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All internal strings will be duplicated. Callbacks will not be duplicated.
///
/// ## C Equivalent
///
/// [`git_remote_dup()`](https://libgit2.org/docs/reference/main/remote/git_remote_dup.html)
public func gitRemoteDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_dup(
            out,
            source
        )
    }
}



/// Gets the repository containing the given remote.
/// - Parameter remote: The remote for which to get the repository. The
/// underlying type must be `git_remote`.
/// - Returns: The repository containing the given remote. The underlying
/// type will be `git_repository`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given remote and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_remote_owner()`](https://libgit2.org/docs/reference/main/remote/git_remote_owner.html)
public func gitRemoteOwner(
    remote: OpaquePointer
) -> OpaquePointer
{
    return git_remote_owner(remote)
}



/// Gets the name of the given remote.
/// - Parameter remote: The remote for which to get the name. The underlying
/// type must be `git_remote`.
/// - Returns: The name of the given remote.
///
/// ## C Equivalent
///
/// [`git_remote_name()`](https://libgit2.org/docs/reference/main/remote/git_remote_name.html)
public func gitRemoteName(
    remote: OpaquePointer
) -> String?
{
    let remoteName: UnsafePointer<CChar>? = git_remote_name(remote)
    
    return String(optionalCString: remoteName)
}



/// Gets the URL of the given remote.
/// - Parameter remote: The remote for which to get the URL. The underlying
/// type must be `git_remote`.
/// - Returns: The URL of the given remote.
///
/// ## Discussion
///
/// If `url.*.insteadOf` has been configured for the remote URL, this function
/// will return the modified URL.
///
/// - Note: Use ``gitRemotePushURL(remote:)`` to get the push URL.
///
/// ## C Equivalent
///
/// [`git_remote_url()`](https://libgit2.org/docs/reference/main/remote/git_remote_url.html)
public func gitRemoteURL(
    remote: OpaquePointer
) -> String?
{
    let remoteURL: UnsafePointer<CChar>? = git_remote_url(remote)
    
    return String(optionalCString: remoteURL)
}



/// Gets the push URL of the given remote.
/// - Parameter remote: The remote for which to get the push URL. The
/// underlying type must be `git_remote`.
/// - Returns: The push URL of the given remote.
///
/// ## Discussion
///
/// If `url.*.insteadOf` has been configured for the remote URL, this function
/// will return the modified URL. Similarly, if
/// ``gitRemoteSetInstancePushURL(remote:url:)``has been called with the
/// given remote, this function will return the instance push URL.
///
/// ## C Equivalent
///
/// [`git_remote_pushurl()`](https://libgit2.org/docs/reference/main/remote/git_remote_pushurl.html)
public func gitRemotePushURL(
    remote: OpaquePointer
) -> String?
{
    let remotePushURL: UnsafePointer<CChar>? = git_remote_pushurl(remote)
    
    return String(optionalCString: remotePushURL)
}



/// Sets the URL of the specified remote.
/// - Parameters:
///   - repo: The repository containing the specified remote. The underlying
///   type must be `git_repository`.
///   - remote: The name of the remote to update.
///   - url: The URL to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// In-memory remotes will not be affected by this change.
///
/// - Note: This function supports only single-URL remotes.
///
/// ## C Equivalent
///
/// [`git_remote_set_url()`](https://libgit2.org/docs/reference/main/remote/git_remote_set_url.html)
public func gitRemoteSetURL(
    repo    : OpaquePointer,
    remote  : String,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_set_url(
            repo,
            remote,
            url
        )
    }
}



/// Sets the push URL of the specified remote.
/// - Parameters:
///   - repo: The repository containing the specified remote. The underlying
///   type must be `git_repository`.
///   - remote: The name of the remote to update.
///   - url: The push URL to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// In-memory remotes will not be affected by this change.
///
/// - Note: This function supports only single-URL remotes.
///
/// ## C Equivalent
///
/// [`git_remote_set_pushurl()`](https://libgit2.org/docs/reference/main/remote/git_remote_set_pushurl.html)
public func gitRemoteSetPushURL(
    repo    : OpaquePointer,
    remote  : String,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_set_pushurl(
            repo,
            remote,
            url
        )
    }
}



/// Sets the URL of the given remote.
/// - Parameters:
///   - remote: The remote to update. The underlying type must be `git_remote`.
///   - url: The URL to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The URL in the configuration will not be affected by this change.
///
/// ## C Equivalent
///
/// [`git_remote_set_instance_url()`](https://libgit2.org/docs/reference/main/remote/git_remote_set_instance_url.html)
public func gitRemoteSetInstanceURL(
    remote  : OpaquePointer,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_set_instance_url(
            remote,
            url
        )
    }
}



/// Sets the push URL of the given remote.
/// - Parameters:
///   - remote: The remote to update. The underlying type must be `git_remote`.
///   - url: The push URL to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The URL in the configuration will not be affected by this change.
///
/// ## C Equivalent
///
/// [`git_remote_set_instance_pushurl()`](https://libgit2.org/docs/reference/main/remote/git_remote_set_instance_pushurl.html)
public func gitRemoteSetInstancePushURL(
    remote  : OpaquePointer,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_set_instance_pushurl(
            remote,
            url
        )
    }
}



/// Adds the given fetch refspec to the specified remote.
/// - Parameters:
///   - repo: The repository containing the specified remote. The underlying
///   type must be `git_repository`.
///   - remote: The name of the remote to update.
///   - refspec: The fetch refspec to add.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Loaded remotes will not be affected by this change.
///
/// ## C Equivalent
///
/// [`git_remote_add_fetch()`](https://libgit2.org/docs/reference/main/remote/git_remote_add_fetch.html)
public func gitRemoteAddFetch(
    repo    : OpaquePointer,
    remote  : String,
    refspec : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_add_fetch(
            repo,
            remote,
            refspec
        )
    }
}



/// Gets the fetch refspecs of the given remote.
/// - Parameters:
///   - array: The array of strings in which to store the fetch refspecs.
///   - remote: The remote to search. The underlying type must be `git_remote`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_get_fetch_refspecs()`](https://libgit2.org/docs/reference/main/remote/git_remote_get_fetch_refspecs.html)
public func gitRemoteGetFetchRefspecs(
    array   : inout [String],
    remote  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try array.withMutatingGitStrArray
        {
            cArray in
            
            return git_remote_get_fetch_refspecs(
                cArray,
                remote
            )
        }
    }
}



/// Adds the given push refspec to the specified remote.
/// - Parameters:
///   - repo: The repository containing the specified remote. The underlying
///   type must be `git_repository`.
///   - remote: The name of the remote to update.
///   - refspec: The push refspec to add.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Loaded remotes will not be affected by this change.
///
/// ## C Equivalent
///
/// [`git_remote_add_push()`](https://libgit2.org/docs/reference/main/remote/git_remote_add_push.html)
public func gitRemoteAddPush(
    repo    : OpaquePointer,
    remote  : String,
    refspec : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_add_push(
            repo,
            remote,
            refspec
        )
    }
}



/// Gets the push refspecs of the given remote.
/// - Parameters:
///   - array: The array of strings in which to store the push refspecs.
///   - remote: The remote to search. The underlying type must be `git_remote`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_get_push_refspecs()`](https://libgit2.org/docs/reference/main/remote/git_remote_get_push_refspecs.html)
public func gitRemoteGetPushRefspecs(
    array   : inout [String],
    remote  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try array.withMutatingGitStrArray
        {
            cArray in
            
            return git_remote_get_push_refspecs(
                cArray,
                remote
            )
        }
    }
}



/// Gets the number of refspecs of the given remote.
/// - Parameter remote: The remote to evaluate. The underlying type must be
/// `git_remote`.
/// - Returns: The number of refspecs of the given remote.
///
/// ## C Equivalent
///
/// [`git_remote_refspec_count()`](https://libgit2.org/docs/reference/main/remote/git_remote_refspec_count.html)
public func gitRemoteRefspecCount(
    remote: OpaquePointer
) -> Int
{
    return git_remote_refspec_count(remote)
}



/// Gets the refspec at the specified index in the given remote.
/// - Parameters:
///   - remote: The remote to search. The underlying type must be `git_remote`.
///   - n: The index of the refspec to retrieve.
/// - Returns: The refspec at the specified index in the given remote. The
/// underlying type will be `git_refspec`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given remote and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_remote_get_refspec()`](https://libgit2.org/docs/reference/main/remote/git_remote_get_refspec.html)
public func gitRemoteGetRefspec(
    remote  : OpaquePointer,
    n       : Int
) -> OpaquePointer
{
    return git_remote_get_refspec(
        remote,
        n
    )
}



/// Gets the reference advertisment list of the given remote.
/// - Parameters:
///   - out: The array of ``GitRemoteHEAD`` instances in which to store the
///   reference advertisment list of the given remote.
///   - size: The length of `out`.
///   - remote: The remote to use. The underlying type must be `git_remote`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The transport of the given remote must have connected to the remote host.
/// The reference advertisment list will be available as soon as the connection
/// to the remote is initiated, and it remains available after disconnecting.
///
/// ## C Equivalent
///
/// [`git_remote_ls()`](https://libgit2.org/docs/reference/main/remote/git_remote_ls.html)
public func gitRemoteLS(
    out     : inout [GitRemoteHEAD],
    size    : Int,
    remote  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingArrayOfGitRemoteHEADs
        {
            cOut, cOutCount in
            
            return git_remote_ls(
                cOut,
                cOutCount,
                remote
            )
        }
    }
}



/// Checks whether the transport of the given remote is connected to the
/// remote host.
/// - Parameter remote: The remote to check. The underlying type must be
/// `git_remote`.
/// - Returns: Whether the transport of the given remote is connected to the
/// remote host.
///
/// ## C Equivalent
///
/// [`git_remote_connected()`](https://libgit2.org/docs/reference/main/remote/git_remote_connected.html)
public func gitRemoteConnected(
    remote: OpaquePointer
) -> Bool
{
    let isConnected: Int32 = git_remote_connected(remote)
    
    return Bool(isConnected)
}



/// Cancels any in-progress operation of the given remote.
/// - Parameter remote: The remote for which to cancel any in-progress
/// operation. The underlying type must be `git_remote`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// At certain points in the operation, the network code checks whether the
/// operation as been cancelled before proceeding.
///
/// ## C Equivalent
///
/// [`git_remote_stop()`](https://libgit2.org/docs/reference/main/remote/git_remote_stop.html)
public func gitRemoteStop(
    remote: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_stop(remote)
    }
}



/// Closes the connection to the given remote.
/// - Parameter remote: The remote from which to disconnect. The underlying
/// type must be `git_remote`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_disconnect()`](https://libgit2.org/docs/reference/main/remote/git_remote_disconnect.html)
public func gitRemoteDisconnect(
    remote: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_disconnect(remote)
    }
}



/// Frees the memory allocated for the given `git_remote` instance.
/// - Parameter remote: The remote to free. The underlying type must be
/// `git_remote`.
///
/// ## Discussion
///
/// If the connection has not yet been closed, this method will also
/// disconnect from the given remote.
///
/// ## C Equivalent
///
/// [`git_remote_free()`](https://libgit2.org/docs/reference/main/remote/git_remote_free.html)
public func gitRemoteFree(
    remote: OpaquePointer?
)
{
    guard let remote: OpaquePointer = remote
    else
    {
        return
    }
    
    git_remote_free(remote)
}



/// Gets the names of the configured remotes for the given repository.
/// - Parameters:
///   - out: The array of strings in which to store the names of the
///   configured remotes.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_list()`](https://libgit2.org/docs/reference/main/remote/git_remote_list.html)
public func gitRemoteList(
    out     : inout [String],
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitStrArray
        {
            cOut in
            
            return git_remote_list(
                cOut,
                repo
            )
        }
    }
}



/// Initializes the given `git_remote_callbacks` instance.
/// - Parameters:
///   - opts: The `git_remote_callbacks` instance to initialize.
///   - version: The version to use. Pass ``gitRemoteCallbacksVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_init_callbacks()`](https://libgit2.org/docs/reference/main/remote/git_remote_init_callbacks.html)
public func gitRemoteInitCallbacks(
    opts    : UnsafeMutablePointer<git_remote_callbacks>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_init_callbacks(
            opts,
            version
        )
    }
}



/// Initializes the given `git_fetch_options` instance.
/// - Parameters:
///   - opts: The `git_fetch_options` instance to initialize.
///   - version: The version to use. Pass ``gitFetchOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_fetch_options_init()`](https://libgit2.org/docs/reference/main/remote/git_fetch_options_init.html)
public func gitFetchOptionsInit(
    opts    : UnsafeMutablePointer<git_fetch_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_fetch_options_init(
            opts,
            version
        )
    }
}



/// Initializes the given `git_push_options` instance.
/// - Parameters:
///   - opts: The `git_push_options` instance to initialize.
///   - version: The version to use. Pass ``gitPushOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_push_options_init()`](https://libgit2.org/docs/reference/main/remote/git_push_options_init.html)
public func gitPushOptionsInit(
    opts    : UnsafeMutablePointer<git_push_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_push_options_init(
            opts,
            version
        )
    }
}



/// Initializes the given `git_remote_connect_options` instance.
/// - Parameters:
///   - opts: The `git_remote_connect_options` instance to initialize.
///   - version: The version to use. Pass ``gitRemoteConnectOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_connect_options_init()`](https://libgit2.org/docs/reference/main/remote/git_remote_connect_options_init.html)
public func gitRemoteConnectOptionsInit(
    opts    : UnsafeMutablePointer<git_remote_connect_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_connect_options_init(
            opts,
            version
        )
    }
}



/// Opens a connection to the given remote.
/// - Parameters:
///   - remote: The remote to which to connect. The underlying type must be
///   `git_remote`.
///   - direction: The remote connection direction to use.
///   - callbacks: The remote callbacks to use.
///   - proxyOpts: The proxy connection options to use.
///   - customHeaders: The extra HTTP headers to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The transport will be selected based on the remote URL.
///
/// ## C Equivalent
///
/// [`git_remote_connect()`](https://libgit2.org/docs/reference/main/remote/git_remote_connect.html)
public func gitRemoteConnect(
    remote          : OpaquePointer,
    direction       : GitDirection,
    callbacks       : GitRemoteCallbacks,
    proxyOpts       : GitProxyOptions?,
    customHeaders   : [String]
) -> GitErrorCode
{
    return withCConversion
    {
        return try callbacks.withCValue
        {
            cCallbacks in
            
            return try proxyOpts.withOptionalCValue
            {
                cProxyOpts in
                
                return try customHeaders.withGitStrArray
                {
                    cCustomHeaders in
                    
                    return git_remote_connect(
                        remote,
                        direction.cValue(),
                        cCallbacks,
                        cProxyOpts,
                        cCustomHeaders
                    )
                }
            }
        }
    }
}



/// Opens a connection to the given remote.
/// - Parameters:
///   - remote: The remote to which to connect. The underlying type must be
///   `git_remote`.
///   - direction: The remote connection direction to use.
///   - opts: The remote connection options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The transport will be selected based on the remote URL.
///
/// The given remote connection options will form the defaults for connection
/// options and callback setup. Use ``GitFetchOptions`` or ``GitPushOptions``
/// in subsequent connections to override these defaults.
///
/// ## C Equivalent
///
/// [`git_remote_connect_ext()`](https://libgit2.org/docs/reference/main/remote/git_remote_connect_ext.html)
public func gitRemoteConnectExt(
    remote      : OpaquePointer,
    direction   : GitDirection,
    opts        : GitRemoteConnectOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_remote_connect_ext(
                remote,
                direction.cValue(),
                cOpts
            )
        }
    }
}



/// Downloads and indexes the packfile of the given remote.
/// - Parameters:
///   - remote: The remote to use. The underlying type must be `git_remote`.
///   - refspecs: The refspecs to use. Pass an empty array to use the default
///   refspecs.
///   - opts: The fetch options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will connect to the given remote if a connection has not yet
/// been opened. If fetch options are provided, and the remote is already
/// connected, then the existing remote connection options will be discarded
/// and the remote will use the given options.
///
/// The `.idx` file will be created, and both it and the packfile will be
/// renamed to their final names.
///
/// ## C Equivalent
///
/// [`git_remote_download()`](https://libgit2.org/docs/reference/main/remote/git_remote_download.html)
public func gitRemoteDownload(
    remote      : OpaquePointer,
    refspecs    : [String],
    opts        : GitFetchOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try refspecs.withGitStrArray
        {
            cRefspecs in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_remote_download(
                    remote,
                    cRefspecs,
                    cOpts
                )
            }
        }
    }
}



/// Creates a packfile and sends it to the given remote.
/// - Parameters:
///   - remote: The remote to use. The underlying type must be `git_remote`.
///   - refspecs: The refspecs to use. Pass an empty array to use the default
///   refspecs.
///   - opts: The push options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will connect to the given remote if a connection has not yet
/// been opened. If push options are provided, and the remote is already
/// connected, then the existing remote connection options will be discarded
/// and the remote will use the given options.
///
/// ## C Equivalent
///
/// [`git_remote_upload()`](https://libgit2.org/docs/reference/main/remote/git_remote_upload.html)
public func gitRemoteUpload(
    remote      : OpaquePointer,
    refspecs    : [String],
    opts        : GitPushOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try refspecs.withGitStrArray
        {
            cRefspecs in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_remote_upload(
                    remote,
                    cRefspecs,
                    cOpts
                )
            }
        }
    }
}



/// Updates the tips of the given remote.
/// - Parameters:
///   - remote: The remote to update. The underlying type must be `git_remote`.
///   - callbacks: The remote callbacks to use.
///   - updateFlags: The remote update flags to use.
///   - downloadTags: The automatic tag-following option to use.
///   - reflogMessage: The reflog message to use when fetching. Pass `nil` to
///   use `fetch <name>`, where `name` is the remote name, or the URL for
///   in-memory remotes.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will connect to the given remote if a connection has not yet
/// been opened. If push options are provided, and the remote is already
/// connected, then the existing remote connection options will be discarded
/// and the remote will use the given options.
///
/// ## C Equivalent
///
/// [`git_remote_update_tips()`](https://libgit2.org/docs/reference/main/remote/git_remote_update_tips.html)
public func gitRemoteUpdateTips(
    remote          : OpaquePointer,
    callbacks       : GitRemoteCallbacks,
    updateFlags     : GitRemoteUpdateFlags,
    downloadTags    : GitRemoteAutoTagOptionT,
    reflogMessage   : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try callbacks.withCValue
        {
            cCallbacks in
            
            return git_remote_update_tips(
                remote,
                cCallbacks,
                updateFlags.rawValue,
                downloadTags.cValue(),
                reflogMessage
            )
        }
    }
}



/// Connects to the given remote, downloads the data, disconnects, and then
/// updates the remote-tracking branches.
/// - Parameters:
///   - remote: The remote from which to fetch. The underlying type must be
///   `git_remote`.
///   - refspecs: The refspecs to use. Pass an empty array to use the default
///   refspecs.
///   - opts: The fetch options to use.
///   - reflogMessage: The reflog message to use. Pass `nil` to use `fetch`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If fetch options are provided, and the remote is already connected, then
/// the existing remote connection options will be discarded and the remote
/// will use the given options.
///
/// ## C Equivalent
///
/// [`git_remote_fetch()`](https://libgit2.org/docs/reference/main/remote/git_remote_fetch.html)
public func gitRemoteFetch(
    remote          : OpaquePointer,
    refspecs        : [String],
    opts            : GitFetchOptions?,
    reflogMessage   : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try refspecs.withGitStrArray
        {
            cRefspecs in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_remote_fetch(
                    remote,
                    cRefspecs,
                    cOpts,
                    reflogMessage
                )
            }
        }
    }
}



/// Prunes tracking references that are no longer present on the given remote.
/// - Parameters:
///   - remote: The remote to prune. The underlying type must be `git_remote`.
///   - callbacks: The remote callbacks to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_prune()`](https://libgit2.org/docs/reference/main/remote/git_remote_prune.html)
public func gitRemotePrune(
    remote      : OpaquePointer,
    callbacks   : GitRemoteCallbacks
) -> GitErrorCode
{
    return withCConversion
    {
        return try callbacks.withCValue
        {
            cCallbacks in
            
            return git_remote_prune(
                remote,
                cCallbacks
            )
        }
    }
}



/// Pushes to the given remote.
/// - Parameters:
///   - remote: The remote to which to push. The underlying type must be
///   `git_remote`.
///   - refspecs: The refspecs to use. Pass an empty array to use the default
///   refspecs.
///   - opts: The push options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If push options are provided, and the remote is already connected, then
/// the existing remote connection options will be discarded and the remote
/// will use the given options.
///
/// ## C Equivalent
///
/// [`git_remote_push()`](https://libgit2.org/docs/reference/main/remote/git_remote_push.html)
public func gitRemotePush(
    remote      : OpaquePointer,
    refspecs    : [String],
    opts        : GitPushOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try refspecs.withGitStrArray
        {
            cRefspecs in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_remote_push(
                    remote,
                    cRefspecs,
                    cOpts
                )
            }
        }
    }
}



/// Gets statistics for the given remote.
/// - Parameter remote: The remote to evaluate. The underlying type must be
/// `git_remote`.
/// - Returns: The statistics for the given remote.
///
/// ## C Equivalent
///
/// [`git_remote_stats()`](https://libgit2.org/docs/reference/main/remote/git_remote_stats.html)
public func gitRemoteStats(
    remote: OpaquePointer
) -> GitIndexerProgress?
{
    guard let indexerProgress: UnsafePointer<git_indexer_progress>
            = git_remote_stats(remote)
    else
    {
        return nil
    }
    
    return GitIndexerProgress(cValue: indexerProgress.pointee)
}



/// Gets the automatic tag-following option of the given remote.
/// - Parameter remote: The remote to search. The underlying type must be
/// `git_remote`.
/// - Returns: The automatic tag-following option of the given remote.
///
/// ## C Equivalent
///
/// [`git_remote_autotag()`](https://libgit2.org/docs/reference/main/remote/git_remote_autotag.html)
public func gitRemoteAutoTag(
    remote: OpaquePointer
) -> GitRemoteAutoTagOptionT?
{
    let remoteAutoTagOption: git_remote_autotag_option_t
        = git_remote_autotag(remote)
    
    return GitRemoteAutoTagOptionT(cValue: remoteAutoTagOption)
}



/// Sets the automatic tag-following option of the specified remote.
/// - Parameters:
///   - repo: The repository containing the specified remote. The underlying
///   type must be `git_repository`.
///   - remote: The name of the remote to update.
///   - value: The automatic tag-following option to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Loaded remotes will not be affected by this change.
///
/// ## C Equivalent
///
/// [`git_remote_set_autotag()`](https://libgit2.org/docs/reference/main/remote/git_remote_set_autotag.html)
public func gitRemoteSetAutoTag(
    repo    : OpaquePointer,
    remote  : String,
    value   : GitRemoteAutoTagOptionT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_set_autotag(
            repo,
            remote,
            value.cValue()
        )
    }
}



/// Checks whether reference pruning is enabled for the given remote.
/// - Parameter remote: The remote to check. The underlying type must be
/// `git_remote`.
/// - Returns: Whether reference pruning is enabled for the given remote.
///
/// ## C Equivalent
///
/// [`git_remote_prune_refs()`](https://libgit2.org/docs/reference/main/remote/git_remote_prune_refs.html)
public func gitRemotePruneRefs(
    remote: OpaquePointer
) -> Bool
{
    let pruneRefs: Int32 = git_remote_prune_refs(remote)
    
    return Bool(pruneRefs)
}




/// Renames the specified remote.
/// - Parameters:
///   - problems: The array of strings in which to store the non-default
///   refspecs that cannot be renamed.
///   - repo: The repository containing the specified remote. The underlying
///   type must be `git_repository`.
///   - name: The name of the remote to rename. This will be checked for
///   validity.
///   - newName: The new remote name to use. This will be checked for validity.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All remote-tracking branches and configuration settings for the specified
/// remote will be updated. Loaded remotes will not be affected by this change.
///
/// ## C Equivalent
///
/// [`git_remote_rename()`](https://libgit2.org/docs/reference/main/remote/git_remote_rename.html)
public func gitRemoteRename(
    problems    : inout [String],
    repo        : OpaquePointer,
    name        : String,
    newName     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try problems.withMutatingGitStrArray
        {
            cProblems in
            
            return git_remote_rename(
                cProblems,
                repo,
                name,
                newName
            )
        }
    }
}



/// Checks whether the given remote name is valid.
/// - Parameters:
///   - valid: The `Bool` instance in which to store whether the given remote
///   name is valid.
///   - name: The remote name to check.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_remote_name_is_valid()`](https://libgit2.org/docs/reference/main/remote/git_remote_name_is_valid.html)
public func gitRemoteNameIsValid(
    valid   : inout Bool,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return valid.withMutatingBool
        {
            cValid in
            
            return git_remote_name_is_valid(
                cValid,
                name
            )
        }
    }
}



/// Deletes the specified remote.
/// - Parameters:
///   - repo: The repository containing the specified remote. The underlying
///   type must be `git_repository`.
///   - name: The name of the remote to delete.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All remote-tracking branches and configuration settings for the specified
/// remote will be deleted.
///
/// ## C Equivalent
///
/// [`git_remote_delete()`](https://libgit2.org/docs/reference/main/remote/git_remote_delete.html)
public func gitRemoteDelete(
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_remote_delete(
            repo,
            name
        )
    }
}



/// Gets the default branch name of the given remote.
/// - Parameters:
///   - out: The `String` instance in which to store the default branch name.
///   - remote: The remote to check. The underlying type must be `git_remote`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default branch of a repository is the branch to which HEAD points. If
/// the given remote does not support reporting this information directly, this
/// function will guess, similar to Git. Specifically, if there are multiple
/// branches that point to the same commit, the first branch will be chosen.
/// If the main branch is a candidate, that branch will be chosen.
///
/// - Note: This function must only be called after connecting to the remote.
///
/// ## C Equivalent
///
/// [`git_remote_default_branch()`](https://libgit2.org/docs/reference/main/remote/git_remote_default_branch.html)
public func gitRemoteDefaultBranch(
    out     : inout String?,
    remote  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_remote_default_branch(
                cOut,
                remote
            )
        }
    }
}
