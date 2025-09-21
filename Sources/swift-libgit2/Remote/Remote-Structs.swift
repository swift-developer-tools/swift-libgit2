//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The callbacks invoked by the remote to inform the user about the progress of network operations.
///
/// ## C Equivalent
///
/// [`git_remote_callbacks`](https://libgit2.org/docs/reference/main/remote/git_remote_callbacks.html)
public struct GitRemoteCallbacks
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRemoteCallbacksVersion``.
    public var version              : UInt32
    
    /// Textual progress from the remote.
    ///
    /// ## Discussion
    ///
    /// Text sent over the progress side-band will be passed to this function. This is the "counting objects"
    /// output.
    public var sidebandProgress     : GitTransportMessageCB?
    
    /// The callback invoked when different parts of the download process are completed.
    ///
    /// ## Discussion
    ///
    /// This callback is currently unused.
    public var completion           : GitRemoteCompletionCB?
    
    /// The callback for credential acquisition.
    public var credentials          : GitCredentialAcquireCB?
    
    /// The callback for the user's custom certificate checks.
    public var certificateCheck     : GitTransportCertificateCheckCB?
    
    /// The callback to report progress during the indexing process.
    public var transferProgress     : GitIndexerProgressCB?
    
    /// The callback invoked for local reference updates.
    ///
    /// ## Discussion
    ///
    /// This is deprecated in libgit2 and will be removed in the next major release.
    /// Use ``updateRefs`` instead.
    public var updateTips           : GitRemoteUpdateTipsCB?
    
    /// The callback for progress notifications.
    public var packProgress         : GitPackbuilderProgressCB?
    
    /// The callback to push network progress notifications.
    public var pushTransferProgress : GitPushTransferProgressCB?
    
    /// The callback to inform of the update status from the remote.
    public var pushUpdateReference  : GitPushUpdateReferenceCB?
    
    /// The callback to inform of upcoming updates.
    public var pushNegotation       : GitPushNegotiationCB?
    
    /// The callback to create a transport.
    public var transport            : GitTransportCB?
    
    /// The callback invoked immediately before attempting to connect to the given URL.
    public var remoteReady          : GitRemoteReadyCB?
    
    /// The caller-specified payload passed to each callback in ``GitRemoteCallbacks``.
    public var payload              : UnsafeMutableRawPointer?
    
    /// The callback to resolve URLs before connecting to the remote.
    ///
    /// ## Discussion
    ///
    /// This is deprecated in libgit2 and will be removed in the next major release.
    /// Use ``remoteReady`` instead.
    public var resolveURL           : GitURLResolveCB?
    
    /// The callback invoked for local reference updates.
    public var updateRefs           : GitRemoteUpdateRefsCB?
    
    
    
    /// Creates a ``GitRemoteCallbacks`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to
    /// ``gitRemoteCallbacksVersion``.
    public init?(
        version: UInt32 = gitRemoteCallbacksVersion
    )
    {
        var remoteCallbacks = git_remote_callbacks()
        
        let remoteInitCallbacksResult: Int32 = git_remote_init_callbacks(
            &remoteCallbacks,
            version
        )
        
        if remoteInitCallbacksResult != GIT_OK.rawValue
        {
            return nil
        }
        
        self.init(cValue: remoteCallbacks)
    }
    
    
    
    /// Creates a ``GitRemoteCallbacks`` instance from a `git_remote_callbacks` instance.
    /// - Parameter remoteCallbacks: The `git_remote_callbacks` instance to use.
    internal init(
        cValue remoteCallbacks: git_remote_callbacks
    )
    {
        self.version                = remoteCallbacks.version
        self.sidebandProgress       = remoteCallbacks.sideband_progress
        self.completion             = remoteCallbacks.completion
        self.credentials            = remoteCallbacks.credentials
        self.certificateCheck       = remoteCallbacks.certificate_check
        self.transferProgress       = remoteCallbacks.transfer_progress
        self.updateTips             = remoteCallbacks.update_tips
        self.packProgress           = remoteCallbacks.pack_progress
        self.pushTransferProgress   = remoteCallbacks.push_transfer_progress
        self.pushUpdateReference    = remoteCallbacks.push_update_reference
        self.pushNegotation         = remoteCallbacks.push_negotiation
        self.transport              = remoteCallbacks.transport
        self.remoteReady            = remoteCallbacks.remote_ready
        self.payload                = remoteCallbacks.payload
        self.resolveURL             = remoteCallbacks.resolve_url
        self.updateRefs             = remoteCallbacks.update_refs
    }
    
    
    
    /// The equivalent C value.
    ///
    /// ## Discussion
    ///
    /// This value will be `nil` if the initialization failed.
    internal var cValue: git_remote_callbacks?
    {
        var remoteCallbacks = git_remote_callbacks()
        
        let remoteInitCallbacksResult: Int32 = git_remote_init_callbacks(
            &remoteCallbacks,
            version
        )
        
        if remoteInitCallbacksResult != GIT_OK.rawValue
        {
            return nil
        }
        
        remoteCallbacks.version                 = version
        remoteCallbacks.sideband_progress       = sidebandProgress
        remoteCallbacks.completion              = completion
        remoteCallbacks.credentials             = credentials
        remoteCallbacks.certificate_check       = certificateCheck
        remoteCallbacks.transfer_progress       = transferProgress
        remoteCallbacks.update_tips             = updateTips
        remoteCallbacks.pack_progress           = packProgress
        remoteCallbacks.push_transfer_progress  = pushTransferProgress
        remoteCallbacks.push_update_reference   = pushUpdateReference
        remoteCallbacks.push_negotiation        = pushNegotation
        remoteCallbacks.transport               = transport
        remoteCallbacks.remote_ready            = remoteReady
        remoteCallbacks.payload                 = payload
        remoteCallbacks.resolve_url             = resolveURL
        remoteCallbacks.update_refs             = updateRefs
        
        return remoteCallbacks
    }
}



/// The options for the fetch operation.
///
/// ## C Equivalent
///
/// [`git_fetch_options`](https://libgit2.org/docs/reference/main/remote/git_fetch_options.html)
public struct GitFetchOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitFetchOptionsVersion``.
    public var version          : UInt32
    
    /// The callbacks invoked by the remote to inform the user about the progress of network operations.
    public var callbacks        : GitRemoteCallbacks?
    
    /// The acceptable prune settings when performing a fetch operation.
    public var prune            : GitFetchPruneT
    
    /// The flags controlling remote updates.
    public var updateFetchHEAD  : GitRemoteUpdateFlags
    
    /// The automatic tag-following option used to determine which `--tags` option to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRemoteAutoTagOptionT/gitRemoteDownloadTagsAuto``.
    public var downloadTags     : GitRemoteAutoTagOptionT
    
    /// The options for connecting through a proxy.
    public var proxyOpts        : GitProxyOptions?
    
    /// The shallowness of the fetch operation.
    public var depth            : GitFetchDepthT
    
    /// Remote redirection settings.
    public var followRedirects  : GitRemoteRedirectT
    
    /// Extra headers for the fetch operation.
    public var customHeaders    : [String]
    
    
    
    /// Creates a ``GitFetchOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to ``gitFetchOptionsVersion``.
    public init?(
        version: UInt32 = gitFetchOptionsVersion
    )
    {
        var fetchOptions = git_fetch_options()
        
        let fetchOptionsInitResult: Int32 = git_fetch_options_init(
            &fetchOptions,
            version
        )
        
        if fetchOptionsInitResult != GIT_OK.rawValue
        {
            return nil
        }
        
        self.init(cValue: fetchOptions)
    }
    
    
    
    /// Creates a ``GitFetchOptions`` instance from a `git_fetch_options` instance.
    /// - Parameter fetchOptions: The `git_fetch_options` instance to use.
    ///
    /// ## Discussion
    ///
    /// If unexpected values are encountered, the following defaults are used:
    /// - ``prune``: ``GitFetchPruneT/gitFetchPruneUnspecified``,
    /// - ``downloadTags``: ``GitRemoteAutoTagOptionT/gitRemoteDownloadTagsUnspecified``
    /// - ``depth``: ``GitFetchDepthT/gitFetchDepthFull``
    /// - ``followRedirects``: ``GitRemoteRedirectT/gitRemoteRedirectInitial``
    ///
    /// This should never occur.
    internal init(
        cValue fetchOptions: git_fetch_options
    )
    {
        self.version            = UInt32(fetchOptions.version)
        self.callbacks          = GitRemoteCallbacks(cValue: fetchOptions.callbacks)
        self.prune              = GitFetchPruneT(cValue: fetchOptions.prune)                            ?? .gitFetchPruneUnspecified
        self.updateFetchHEAD    = GitRemoteUpdateFlags(rawValue: fetchOptions.update_fetchhead)
        self.downloadTags       = GitRemoteAutoTagOptionT(cValue: fetchOptions.download_tags)           ?? .gitRemoteDownloadTagsUnspecified
        self.proxyOpts          = GitProxyOptions(cValue: fetchOptions.proxy_opts)
        self.depth              = GitFetchDepthT(rawValue: UInt32(fetchOptions.depth))                  ?? .gitFetchDepthFull
        self.followRedirects    = GitRemoteRedirectT(rawValue: fetchOptions.follow_redirects.rawValue)  ?? .gitRemoteRedirectInitial
        self.customHeaders      = Array(fetchOptions.custom_headers)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_fetch_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the initialization failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_fetch_options>?) -> T
    ) -> T
    {
        var fetchOptions = git_fetch_options()
        
        let fetchOptionsInitResult: Int32 = git_fetch_options_init(
            &fetchOptions,
            version
        )
        
        if fetchOptionsInitResult != GIT_OK.rawValue
        {
            return body(nil)
        }
        
        if let cCallbacks: git_remote_callbacks = callbacks?.cValue
        {
            fetchOptions.callbacks = cCallbacks
        }
        
        fetchOptions.prune              = prune.cValue
        fetchOptions.update_fetchhead   = updateFetchHEAD.rawValue
        fetchOptions.download_tags      = downloadTags.cValue
        fetchOptions.depth              = Int32(depth.rawValue)
        fetchOptions.follow_redirects   = followRedirects.cValue
        
        return withComposedProperties(
            &fetchOptions,
            body
        )
    }
    
    
    
    /// Composes the optional properties of ``GitFetchOptions``, then calls the given closure
    /// with a pointer to the updated `git_fetch_options` instance.
    /// - Parameters:
    ///   - fetchOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This function composes the following optional properties:
    /// - ``proxyOpts``
    /// - ``customHeaders``
    ///
    /// The composition begins by calling ``withProxyOptions(_:_:)``.
    private func withComposedProperties<T>(
        _   fetchOptions    : UnsafeMutablePointer<git_fetch_options>,
        _   body            : (UnsafeMutablePointer<git_fetch_options>?) -> T
    ) -> T
    {
        return withProxyOptions(
            fetchOptions,
            body
        )
    }
    
    
    
    /// Updates the given `git_fetch_options` instance with the value of ``proxyOpts``,
    /// then continues the composition by calling ``withCustomHeaders(_:_:)``.
    /// - Parameters:
    ///   - fetchOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``proxyOpts`` is `nil`, this function will proceed directly to the next step in the composition.
    ///
    /// If ``GitProxyOptions.withCValue(_:)`` fails, this function will call the given closure
    /// with `nil`.
    private func withProxyOptions<T>(
        _   fetchOptions    : UnsafeMutablePointer<git_fetch_options>,
        _   body            : (UnsafeMutablePointer<git_fetch_options>?) -> T
    ) -> T
    {
        guard let proxyOpts: GitProxyOptions = proxyOpts
        else
        {
            return withCustomHeaders(
                fetchOptions,
                body
            )
        }
        
        return proxyOpts.withCValue
        {
            cProxyOpts in
            
            guard let cProxyOpts: UnsafeMutablePointer<git_proxy_options> = cProxyOpts
            else
            {
                return body(nil)
            }
            
            fetchOptions.pointee.proxy_opts = cProxyOpts.pointee
            
            return withCustomHeaders(
                fetchOptions,
                body
            )
        }
    }
    
    
    
    /// Updates the given `git_fetch_options` instance with the value of ``customHeaders``,
    /// then finishes the composition by calling the given closure.
    /// - Parameters:
    ///   - fetchOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    private func withCustomHeaders<T>(
        _   fetchOptions    : UnsafeMutablePointer<git_fetch_options>,
        _   body            : (UnsafeMutablePointer<git_fetch_options>?) -> T
    ) -> T
    {
        return customHeaders.withGitStrarray
        {
            cCustomHeaders in
            
            fetchOptions.pointee.custom_headers = cCustomHeaders.pointee
            
            return body(fetchOptions)
        }
    }
}
