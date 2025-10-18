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



/// The callbacks invoked by the remote to inform the user about the progress
/// of network operations.
///
/// ## C Equivalent
///
/// [`git_remote_callbacks`](https://libgit2.org/docs/reference/main/remote/git_remote_callbacks.html)
public struct GitRemoteCallbacks: CStructMutable, ThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRemoteCallbacksVersion``.
    public var version              : UInt32
    
    /// The callback invoked for transport messages.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// Text sent over the progress side-band will be passed to this function.
    /// This is the "counting objects" output.
    public var sidebandProgress     : GitTransportMessageCB?
    
    /// The callback invoked to report download progress.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This callback is currently unused.
    public var completion           : GitRemoteCompletionCB?
    
    /// The callback invoked to acquire credentials.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var credentials          : GitCredentialAcquireCB?
    
    /// The callback invoked to check custom certificates.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var certificateCheck     : GitTransportCertificateCheckCB?
    
    /// The callback invoked to report indexing progress.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var transferProgress     : GitIndexerProgressCB?
    
    /// The callback invoked for local reference update notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// - Warning: This is deprecated in libgit2 and will be removed in the
    /// next major release. Use ``updateRefs`` instead.
    public var updateTips           : GitRemoteUpdateTipsCB?
    
    /// The callback invoked to report packfile iteration progress.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var packProgress         : GitPackbuilderProgressCB?
    
    /// The callback invoked to report push network progress.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var pushTransferProgress : GitPushTransferProgressCB?
    
    /// The callback invoked for remote status update notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var pushUpdateReference  : GitPushUpdateReferenceCB?
    
    /// The callback invoked for upcoming update notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var pushNegotation       : GitPushNegotiationCB?
    
    /// The callback invoked to create a transport.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var transport            : GitTransportCB?
    
    /// The callback invoked immediately before attempting a remote connection.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var remoteReady          : GitRemoteReadyCB?
    
    /// The payload passed to the callbacks of ``GitRemoteCallbacks``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload              : UnsafeMutableRawPointer?
    
    /// The callback invoked to resolve URLs.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// - Warning: This is deprecated in libgit2 and will be removed in the
    /// next major release. Use ``remoteReady`` instead.
    public var resolveURL           : GitURLResolveCB?
    
    /// The callback invoked for local reference update notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var updateRefs           : GitRemoteUpdateRefsCB?
    
    
    
    /// Initializes a ``GitRemoteCallbacks`` instance, optionally specifying
    /// values for its properties.
    public init(
        version                 : UInt32                            = gitRemoteCallbacksVersion,
        sidebandProgress        : GitTransportMessageCB?            = nil,
        completion              : GitRemoteCompletionCB?            = nil,
        credentials             : GitCredentialAcquireCB?           = nil,
        certificateCheck        : GitTransportCertificateCheckCB?   = nil,
        transferProgress        : GitIndexerProgressCB?             = nil,
        updateTips              : GitRemoteUpdateTipsCB?            = nil,
        packProgress            : GitPackbuilderProgressCB?         = nil,
        pushTransferProgress    : GitPushTransferProgressCB?        = nil,
        pushUpdateReference     : GitPushUpdateReferenceCB?         = nil,
        pushNegotation          : GitPushNegotiationCB?             = nil,
        transport               : GitTransportCB?                   = nil,
        remoteReady             : GitRemoteReadyCB?                 = nil,
        payload                 : UnsafeMutableRawPointer?          = nil,
        resolveURL              : GitURLResolveCB?                  = nil,
        updateRefs              : GitRemoteUpdateRefsCB?            = nil
    )
    {
        self.version                = version
        self.sidebandProgress       = sidebandProgress
        self.completion             = completion
        self.credentials            = credentials
        self.certificateCheck       = certificateCheck
        self.transferProgress       = transferProgress
        self.updateTips             = updateTips
        self.packProgress           = packProgress
        self.pushTransferProgress   = pushTransferProgress
        self.pushUpdateReference    = pushUpdateReference
        self.pushNegotation         = pushNegotation
        self.transport              = transport
        self.remoteReady            = remoteReady
        self.payload                = payload
        self.resolveURL             = resolveURL
        self.updateRefs             = updateRefs
    }
    
    
    
    /// Initializes a ``GitRemoteCallbacks`` instance from the given
    /// `git_remote_callbacks` instance.
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
    
    
    
    /// Converts the ``GitRemoteCallbacks`` instance into a
    /// `git_remote_callbacks` instance.
    /// - Returns: The `git_remote_callbacks` instance.
    /// - Throws: An error if the conversion fails.
    internal func cValue() throws -> git_remote_callbacks
    {
        var remoteCallbacks = git_remote_callbacks()
        
        let remoteInitCallbacksResult: GitErrorCode = gitRemoteInitCallbacks(
            opts:       &remoteCallbacks,
            version:    version
        )
        
        if remoteInitCallbacksResult != .gitOK
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
public struct GitFetchOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitFetchOptionsVersion``.
    public var version          : Int32
    
    /// The callbacks invoked by the remote to inform the user about the
    /// progress of network operations.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitRemoteCallbacks``
    /// instance.
    public var callbacks        : GitRemoteCallbacks
    
    /// The acceptable prune settings when performing a fetch operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitFetchPruneT/gitFetchPruneUnspecified``.
    public var prune            : GitFetchPruneT
    
    /// The flags controlling remote updates.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRemoteUpdateFlags/gitRemoteUpdateFETCHHEAD``.
    public var updateFETCHHEAD  : GitRemoteUpdateFlags
    
    /// The automatic tag-following option used to determine which `--tags`
    /// option to use.
    ///
    /// ## Discussion
    ///
    /// The default value is
    /// ``GitRemoteAutoTagOptionT/gitRemoteDownloadTagsAuto``.
    public var downloadTags     : GitRemoteAutoTagOptionT
    
    /// The options for connecting through a proxy.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitProxyOptions``
    /// instance.
    public var proxyOpts        : GitProxyOptions
    
    /// The shallowness of the fetch operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitFetchDepthT/gitFetchDepthFull``.
    public var depth            : GitFetchDepthT
    
    /// The remote redirection settings.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRemoteRedirectT/gitRemoteRedirectNone``.
    public var followRedirects  : GitRemoteRedirectT
    
    /// The extra headers for the fetch operation.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var customHeaders    : [String]
    
    
    
    /// Initializes a ``GitFetchOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : Int32                     = gitFetchOptionsVersion,
        callbacks       : GitRemoteCallbacks        = GitRemoteCallbacks(),
        prune           : GitFetchPruneT            = .gitFetchPruneUnspecified,
        updateFETCHHEAD : GitRemoteUpdateFlags      = .gitRemoteUpdateFETCHHEAD,
        downloadTags    : GitRemoteAutoTagOptionT   = .gitRemoteDownloadTagsAuto,
        proxyOpts       : GitProxyOptions           = GitProxyOptions(),
        depth           : GitFetchDepthT            = .gitFetchDepthFull,
        followRedirects : GitRemoteRedirectT        = .gitRemoteRedirectNone,
        customHeaders   : [String]                  = []
    )
    {
        self.version            = version
        self.callbacks          = callbacks
        self.prune              = prune
        self.updateFETCHHEAD    = updateFETCHHEAD
        self.downloadTags       = downloadTags
        self.proxyOpts          = proxyOpts
        self.depth              = depth
        self.followRedirects    = followRedirects
        self.customHeaders      = customHeaders
    }
    
    
    
    /// Initializes a ``GitFetchOptions`` instance from the given
    /// `git_fetch_options` instance.
    /// - Parameter fetchOptions: The `git_fetch_options` instance to use.
    internal init(
        cValue fetchOptions: git_fetch_options
    )
    {
        self.version            = fetchOptions.version
        self.callbacks          = GitRemoteCallbacks(cValue: fetchOptions.callbacks)
        self.prune              = GitFetchPruneT(cValue: fetchOptions.prune)                            ?? .gitFetchPruneUnspecified
        self.updateFETCHHEAD    = GitRemoteUpdateFlags(rawValue: fetchOptions.update_fetchhead)
        self.downloadTags       = GitRemoteAutoTagOptionT(cValue: fetchOptions.download_tags)           ?? .gitRemoteDownloadTagsUnspecified
        self.proxyOpts          = GitProxyOptions(cValue: fetchOptions.proxy_opts)
        self.followRedirects    = GitRemoteRedirectT(rawValue: fetchOptions.follow_redirects.rawValue)  ?? .gitRemoteRedirectInitial
        self.customHeaders      = Array(fetchOptions.custom_headers)
        
        if
            fetchOptions.depth >= 0,
            let fetchDepth = GitFetchDepthT(rawValue: UInt32(fetchOptions.depth))
        {
            self.depth = fetchDepth
        }
        else
        {
            self.depth = .gitFetchDepthFull
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_fetch_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_fetch_options>) throws -> T
    ) throws -> T
    {
        guard
            version >= 0,
            depth.rawValue <= Int32.max
        else
        {
            throw NSError.makeCConversionError()
        }
        
        var fetchOptions = git_fetch_options()
        
        let fetchOptionsInitResult: GitErrorCode = gitFetchOptionsInit(
            opts:       &fetchOptions,
            version:    UInt32(version)
        )
        
        if fetchOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        fetchOptions.callbacks          = try callbacks.cValue()
        fetchOptions.prune              = prune.cValue()
        fetchOptions.update_fetchhead   = updateFETCHHEAD.rawValue
        fetchOptions.download_tags      = downloadTags.cValue()
        fetchOptions.depth              = Int32(depth.rawValue)
        fetchOptions.follow_redirects   = followRedirects.cValue()
        
        return try proxyOpts.withCValue
        {
            cProxyOpts in
            
            fetchOptions.proxy_opts = cProxyOpts.pointee
            
            return try customHeaders.withGitStrArray
            {
                cCustomHeaders in
                
                fetchOptions.custom_headers = cCustomHeaders.pointee
                
                return try body(&fetchOptions)
            }
        }
    }
}
