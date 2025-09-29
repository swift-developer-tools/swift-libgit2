//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import Foundation



/// The callbacks invoked by the remote to inform the user about the progress of network operations.
///
/// ## C Equivalent
///
/// [`git_remote_callbacks`](https://libgit2.org/docs/reference/main/remote/git_remote_callbacks.html)
public struct GitRemoteCallbacks: GitStructMutable, ThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRemoteCallbacksVersion``.
    public var version              : UInt32                            = gitRemoteCallbacksVersion
    
    /// The callback for messages received by the transport.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Text sent over the progress side-band will be passed to this function. This is the "counting objects"
    /// output.
    public var sidebandProgress     : GitTransportMessageCB?            = nil
    
    /// The callback invoked when different parts of the download process are completed.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This callback is currently unused.
    public var completion           : GitRemoteCompletionCB?            = nil
    
    /// The callback for credential acquisition.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var credentials          : GitCredentialAcquireCB?           = nil
    
    /// The callback for the user's custom certificate checks.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var certificateCheck     : GitTransportCertificateCheckCB?   = nil
    
    /// The callback to report progress during the indexing process.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var transferProgress     : GitIndexerProgressCB?             = nil
    
    /// The callback invoked for local reference updates.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This is deprecated in libgit2 and will be removed in the next major release.
    /// Use ``updateRefs`` instead.
    public var updateTips           : GitRemoteUpdateTipsCB?            = nil
    
    /// The callback for progress notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var packProgress         : GitPackbuilderProgressCB?         = nil
    
    /// The callback to push network progress notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var pushTransferProgress : GitPushTransferProgressCB?        = nil
    
    /// The callback to inform of the update status from the remote.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var pushUpdateReference  : GitPushUpdateReferenceCB?         = nil
    
    /// The callback to inform of upcoming updates.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var pushNegotation       : GitPushNegotiationCB?             = nil
    
    /// The callback to create a transport.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var transport            : GitTransportCB?                   = nil
    
    /// The callback invoked immediately before attempting to connect to the given URL.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var remoteReady          : GitRemoteReadyCB?                 = nil
    
    /// The caller-specified payload passed to each callback in ``GitRemoteCallbacks``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload              : UnsafeMutableRawPointer?          = nil
    
    /// The callback to resolve URLs before connecting to the remote.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This is deprecated in libgit2 and will be removed in the next major release.
    /// Use ``remoteReady`` instead.
    public var resolveURL           : GitURLResolveCB?                  = nil
    
    /// The callback invoked for local reference updates.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var updateRefs           : GitRemoteUpdateRefsCB?            = nil
    
    
    
    /// Creates a ``GitRemoteCallbacks`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
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
    
    
    
    /// Converts the ``GitRemoteCallbacks`` instance into a `git_remote_callbacks` instance.
    /// - Returns: The `git_remote_callbacks` instance.
    /// - Throws: An `NSError` if the conversion failed.
    internal func cValue() throws -> git_remote_callbacks
    {
        var remoteCallbacks = git_remote_callbacks()
        
        let remoteInitCallbacksResult: Int32 = git_remote_init_callbacks(
            &remoteCallbacks,
            version
        )
        
        if remoteInitCallbacksResult != GIT_OK.rawValue
        {
            throw NSError.makeCConversionError()
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
public struct GitFetchOptions: GitStructMutable, WithThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitFetchOptionsVersion``.
    public var version          : UInt32                    = gitFetchOptionsVersion
    
    /// The callbacks invoked by the remote to inform the user about the progress of network operations.
    public var callbacks        : GitRemoteCallbacks?       = nil
    
    /// The acceptable prune settings when performing a fetch operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitFetchPruneT/gitFetchPruneUnspecified``.
    public var prune            : GitFetchPruneT            = .gitFetchPruneUnspecified
    
    /// The flags controlling remote updates.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRemoteUpdateFlags/gitRemoteUpdateFetchHEAD``.
    public var updateFetchHEAD  : GitRemoteUpdateFlags      = .gitRemoteUpdateFetchHEAD
    
    /// The automatic tag-following option used to determine which `--tags` option to use.
    ///
    /// ## Discussion
    ///
    /// The default value is
    /// ``GitRemoteAutoTagOptionT/gitRemoteDownloadTagsAuto``.
    public var downloadTags     : GitRemoteAutoTagOptionT   = .gitRemoteDownloadTagsAuto
    
    /// The options for connecting through a proxy.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the
    /// default proxy options.
    public var proxyOpts        : GitProxyOptions?          = nil
    
    /// The shallowness of the fetch operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitFetchDepthT/gitFetchDepthFull``.
    public var depth            : GitFetchDepthT            = .gitFetchDepthFull
    
    /// The remote redirection settings.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRemoteRedirectT/gitRemoteRedirectNone``.
    public var followRedirects  : GitRemoteRedirectT        = .gitRemoteRedirectNone
    
    /// The extra headers for the fetch operation.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var customHeaders    : [String]                  = []
    
    
    
    /// Creates a ``GitFetchOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
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
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_fetch_options>) throws -> T
    ) throws -> T
    {
        var fetchOptions = git_fetch_options()
        
        let fetchOptionsInitResult: Int32 = git_fetch_options_init(
            &fetchOptions,
            version
        )
        
        if fetchOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.makeCConversionError()
        }
        
        fetchOptions.prune              = prune.cValue()
        fetchOptions.update_fetchhead   = updateFetchHEAD.rawValue
        fetchOptions.download_tags      = downloadTags.cValue()
        fetchOptions.depth              = Int32(depth.rawValue)
        fetchOptions.follow_redirects   = followRedirects.cValue()
        
        if let cCallbacks: git_remote_callbacks = try callbacks?.cValue()
        {
            fetchOptions.callbacks = cCallbacks
        }
        
        return try proxyOpts.withOptionalCValue
        {
            cProxyOpts in
            
            if let cProxyOpts: UnsafeMutablePointer<git_proxy_options> = cProxyOpts
            {
                fetchOptions.proxy_opts = cProxyOpts.pointee
            }
            
            return try customHeaders.withGitStrArray
            {
                cCustomHeaders in
                
                fetchOptions.custom_headers = cCustomHeaders.pointee
                
                return try body(&fetchOptions)
            }
        }
    }
}
