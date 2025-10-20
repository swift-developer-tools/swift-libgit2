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



/// The options for remote creation.
///
/// ## C Equivalent
///
/// [`git_remote_create_options`](https://libgit2.org/docs/reference/main/remote/git_remote_create_options.html)
public struct GitRemoteCreateOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRemoteCreateOptionsVersion``.
    public var version      : UInt32
    
    /// The repository that should own the remote.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// If this is `nil`, the remote will be a detached remote.
    public var repository   : OpaquePointer?
    
    /// The acceptable prune settings when performing a fetch operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// If this is `nil`, the remote will be an in-memory/anonymous remote.
    public var name         : String?
    
    /// The fetchspec the remote should use.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var fetchspec    : String?
    
    /// The flags controlling remote creation.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags        : GitRemoteCreateFlags
    
    
    
    /// Initializes a ``GitRemoteCreateOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version     : UInt32                = gitRemoteCreateOptionsVersion,
        repository  : OpaquePointer?        = nil,
        name        : String?               = nil,
        fetchspec   : String?               = nil,
        flags       : GitRemoteCreateFlags  = []
    )
    {
        self.version        = version
        self.repository     = repository
        self.name           = name
        self.fetchspec      = fetchspec
        self.flags          = flags
    }
    
    
    
    /// Initializes a ``GitRemoteCreateOptions`` instance from the given
    /// `git_remote_create_options` instance.
    /// - Parameter remoteCreateOptions: The `git_remote_create_options`
    /// instance to use.
    internal init(
        cValue remoteCreateOptions: git_remote_create_options
    )
    {
        self.version        = remoteCreateOptions.version
        self.repository     = remoteCreateOptions.repository
        self.name           = String(optionalCString: remoteCreateOptions.name)
        self.fetchspec      = String(optionalCString: remoteCreateOptions.fetchspec)
        self.flags          = GitRemoteCreateFlags(rawValue: remoteCreateOptions.flags)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_remote_create_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_remote_create_options>) throws -> T
    ) throws -> T
    {
        var remoteCreateOptions = git_remote_create_options()
        
        let remoteCreateOptionsInitResult: GitErrorCode
            = gitRemoteCreateOptionsInit(
                opts:       &remoteCreateOptions,
                version:    version
            )
        
        if remoteCreateOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        remoteCreateOptions.repository  = repository
        remoteCreateOptions.flags       = flags.rawValue
        
        return try name.withOptionalCString
        {
            cName in
            
            remoteCreateOptions.name = cName
            
            return try fetchspec.withOptionalCString
            {
                cFetchspec in
                
                remoteCreateOptions.fetchspec = cFetchspec
                
                return try body(&remoteCreateOptions)
            }
        }
    }
}



/// An update that will be performed on the remote during a push operation.
///
/// ## C Equivalent
///
/// [`git_push_update`](https://libgit2.org/docs/reference/main/remote/git_push_update.html)
public struct GitPushUpdate: CStructInternalMutable, WithCConvertible, Sendable
{
    /// The source name of the reference.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var srcRefName  : String?   = nil
    
    /// The destination name of the reference.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public private(set) var dstRefName  : String?   = nil
    
    /// The ID of the current target of the reference.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitOID`` instance.
    public private(set) var src         : GitOID    = GitOID()
    
    /// The ID of the new target of the reference.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitOID`` instance.
    public private(set) var dst         : GitOID    = GitOID()
    
    
    
    
    /// Initializes a default ``GitPushUpdate`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitPushUpdate`` instance from the given
    /// `git_push_update` instance.
    /// - Parameter pushUpdate: The `git_push_update` instance to use.
    internal init(
        cValue pushUpdate: git_push_update
    )
    {
        self.srcRefName     = String(optionalCString: pushUpdate.src_refname)
        self.dstRefName     = String(optionalCString: pushUpdate.dst_refname)
        self.src            = GitOID(cValue: pushUpdate.src)
        self.dst            = GitOID(cValue: pushUpdate.dst)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_push_update`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_push_update>) throws -> T
    ) throws -> T
    {
        var pushUpdate = git_push_update()
        
        pushUpdate.src  = src.cValue()
        pushUpdate.dst  = dst.cValue()
        
        return try srcRefName.withOptionalMutableCString
        {
            cSrcRefName in
            
            pushUpdate.src_refname = cSrcRefName
            
            return try dstRefName.withOptionalMutableCString
            {
                cDstRefName in
                
                pushUpdate.dst_refname = cDstRefName
                
                return try body(&pushUpdate)
            }
        }
    }
}



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



/// The options for fetch operations.
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
    /// The default value is an empty option set.
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
        updateFETCHHEAD : GitRemoteUpdateFlags      = [],
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



/// The options for push operations.
///
/// ## C Equivalent
///
/// [`git_push_options`](https://libgit2.org/docs/reference/main/remote/git_push_options.html)
public struct GitPushOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitPushOptionsVersion``.
    public var version              : UInt32
    
    /// Whether to auto-detect the number of worker threads to create when
    /// building a packfile.
    ///
    /// ## Discussion
    ///
    /// The default value is `true`.
    public var pbParallelism        : Bool
    
    /// The callbacks invoked by the remote to inform the user about the
    /// progress of network operations.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitRemoteCallbacks``
    /// instance.
    public var callbacks            : GitRemoteCallbacks
    
    /// The options for connecting through a proxy.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitProxyOptions``
    /// instance.
    public var proxyOpts            : GitProxyOptions
    
    /// The remote redirection settings.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRemoteRedirectT/gitRemoteRedirectNone``.
    public var followRedirects      : GitRemoteRedirectT
    
    /// The extra headers for the push operation.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var customHeaders        : [String]
    
    /// The push options to deliver to the remote.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var remotePushOptions    : [String]
    
    
    
    /// Initializes a ``GitPushOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version             : UInt32                = gitPushOptionsVersion,
        pbParallelism       : Bool                  = true,
        callbacks           : GitRemoteCallbacks    = GitRemoteCallbacks(),
        proxyOpts           : GitProxyOptions       = GitProxyOptions(),
        followRedirects     : GitRemoteRedirectT    = .gitRemoteRedirectNone,
        customHeaders       : [String]              = [],
        remotePushOptions   : [String]              = []
    )
    {
        self.version            = version
        self.pbParallelism      = pbParallelism
        self.callbacks          = callbacks
        self.proxyOpts          = proxyOpts
        self.followRedirects    = followRedirects
        self.customHeaders      = customHeaders
        self.remotePushOptions  = remotePushOptions
    }
    
    
    
    /// Initializes a ``GitPushOptions`` instance from the given
    /// `git_push_options` instance.
    /// - Parameter pushOptions: The `git_push_options` instance to use.
    internal init(
        cValue pushOptions: git_push_options
    )
    {
        self.version            = pushOptions.version
        self.pbParallelism      = Bool(pushOptions.pb_parallelism)
        self.callbacks          = GitRemoteCallbacks(cValue: pushOptions.callbacks)
        self.proxyOpts          = GitProxyOptions(cValue: pushOptions.proxy_opts)
        self.followRedirects    = GitRemoteRedirectT(cValue: pushOptions.follow_redirects) ?? .gitRemoteRedirectNone
        self.customHeaders      = Array(pushOptions.custom_headers)
        self.remotePushOptions  = Array(pushOptions.remote_push_options)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_push_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_push_options>) throws -> T
    ) throws -> T
    {
        var pushOptions = git_push_options()
        
        let pushOptionsInitResult: GitErrorCode = gitPushOptionsInit(
            opts:       &pushOptions,
            version:    UInt32(version)
        )
        
        if pushOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        pushOptions.pb_parallelism      = pbParallelism.uint32Value
        pushOptions.callbacks           = try callbacks.cValue()
        pushOptions.follow_redirects    = followRedirects.cValue()
        
        return try proxyOpts.withCValue
        {
            cProxyOpts in
            
            pushOptions.proxy_opts = cProxyOpts.pointee
            
            return try customHeaders.withGitStrArray
            {
                cCustomHeaders in
                
                pushOptions.custom_headers = cCustomHeaders.pointee
                
                return try remotePushOptions.withGitStrArray
                {
                    cRemotePushOptions in
                    
                    pushOptions.remote_push_options
                        = cRemotePushOptions.pointee
                    
                    return try body(&pushOptions)
                }
            }
        }
    }
}



/// The options for push operations.
///
/// ## C Equivalent
///
/// [`git_remote_connect_options`](https://libgit2.org/docs/reference/main/remote/git_remote_connect_options.html)
public struct GitRemoteConnectOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRemoteConnectOptionsVersion``.
    public var version              : UInt32
    
    /// The callbacks invoked by the remote to inform the user about the
    /// progress of network operations.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitRemoteCallbacks``
    /// instance.
    public var callbacks            : GitRemoteCallbacks
    
    /// The options for connecting through a proxy.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitProxyOptions``
    /// instance.
    public var proxyOpts            : GitProxyOptions
    
    /// The remote redirection settings.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRemoteRedirectT/gitRemoteRedirectNone``.
    public var followRedirects      : GitRemoteRedirectT
    
    /// The extra headers for the push operation.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var customHeaders        : [String]
    
    
    
    /// Initializes a ``GitRemoteConnectOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version             : UInt32                = gitRemoteConnectOptionsVersion,
        callbacks           : GitRemoteCallbacks    = GitRemoteCallbacks(),
        proxyOpts           : GitProxyOptions       = GitProxyOptions(),
        followRedirects     : GitRemoteRedirectT    = .gitRemoteRedirectNone,
        customHeaders       : [String]              = []
    )
    {
        self.version            = version
        self.callbacks          = callbacks
        self.proxyOpts          = proxyOpts
        self.followRedirects    = followRedirects
        self.customHeaders      = customHeaders
    }
    
    
    
    /// Initializes a ``GitRemoteConnectOptions`` instance from the given
    /// `git_remote_connect_options` instance.
    /// - Parameter remoteConnectOptions: The `git_remote_connect_options`
    /// instance to use.
    internal init(
        cValue remoteConnectOptions: git_remote_connect_options
    )
    {
        self.version            = remoteConnectOptions.version
        self.callbacks          = GitRemoteCallbacks(cValue: remoteConnectOptions.callbacks)
        self.proxyOpts          = GitProxyOptions(cValue: remoteConnectOptions.proxy_opts)
        self.followRedirects    = GitRemoteRedirectT(cValue: remoteConnectOptions.follow_redirects) ?? .gitRemoteRedirectNone
        self.customHeaders      = Array(remoteConnectOptions.custom_headers)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_remote_connect_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_remote_connect_options>) throws -> T
    ) throws -> T
    {
        var remoteConnectOptions = git_remote_connect_options()
        
        let remoteConnectOptionsInitResult: GitErrorCode
            = gitRemoteConnectOptionsInit(
                opts:       &remoteConnectOptions,
                version:    UInt32(version)
            )
        
        if remoteConnectOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        remoteConnectOptions.callbacks          = try callbacks.cValue()
        remoteConnectOptions.follow_redirects   = followRedirects.cValue()
        
        return try proxyOpts.withCValue
        {
            cProxyOpts in
            
            remoteConnectOptions.proxy_opts = cProxyOpts.pointee
            
            return try customHeaders.withGitStrArray
            {
                cCustomHeaders in
                
                remoteConnectOptions.custom_headers = cCustomHeaders.pointee
                
                return try body(&remoteConnectOptions)
            }
        }
    }
}
