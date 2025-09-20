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
