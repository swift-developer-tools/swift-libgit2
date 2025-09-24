//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The options for connecting through a proxy.
///
/// ## C Equivalent
///
/// [`git_proxy_options`](https://libgit2.org/docs/reference/main/proxy/git_proxy_options.html)
public struct GitProxyOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitProxyOptionsVersion``.
    public var version          : UInt32
    
    /// The type of proxy.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitProxyT/gitProxyNone``.
    public var type             : GitProxyT
    
    /// The URL of the proxy.
    public var url              : String?
    
    /// The callback for credential acquisition.
    ///
    /// ## Discussion
    ///
    /// This function will be called if the remote host requires authentication in order to connect.
    /// Returning `GIT_PASSTHROUGH` will make libgit2 behave as though this field were not set.
    public var credentials      : GitCredentialAcquireCB?
    
    /// The callback for the user's custom certificate checks.
    ///
    /// ## Discussion
    ///
    /// If  certificate verification fails, this function will be called to let the user make the final decision
    /// of whether to allow the connection to proceed.
    public var certificateCheck : GitTransportCertificateCheckCB?
    
    /// The caller-specified payload passed to ``credentials`` and ``certificateCheck``.
    public var payload          : UnsafeMutableRawPointer?
    
    
    
    /// Creates a ``GitProxyOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to ``gitProxyOptionsVersion``.
    public init?(
        version: UInt32 = gitProxyOptionsVersion
    )
    {
        var proxyOptions = git_proxy_options()
        
        let proxyOptionsInitResult: Int32 = git_proxy_options_init(
            &proxyOptions,
            version
        )
        
        if proxyOptionsInitResult != GIT_OK.rawValue
        {
            return nil
        }
        
        self.init(cValue: proxyOptions)
    }
    
    
    
    /// Creates a ``GitProxyOptions`` instance from a `git_proxy_options` instance.
    /// - Parameter proxyOptions: The `git_proxy_options` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``type`` defaults to ``GitProxyT/gitProxyNone`` if an unexpected value is
    /// encountered, although this should never occur.
    internal init(
        cValue proxyOptions: git_proxy_options
    )
    {
        self.version            = proxyOptions.version
        self.type               = GitProxyT(cValue: proxyOptions.type) ?? .gitProxyNone
        self.url                = String(optionalCString: proxyOptions.url)
        self.credentials        = proxyOptions.credentials
        self.certificateCheck   = proxyOptions.certificate_check
        self.payload            = proxyOptions.payload
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_proxy_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the initialization failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_proxy_options>?) -> T
    ) -> T
    {
        var proxyOptions = git_proxy_options()
        
        let proxyOptionsInitResult: Int32 = git_proxy_options_init(
            &proxyOptions,
            version
        )
        
        if proxyOptionsInitResult != GIT_OK.rawValue
        {
            return body(nil)
        }
        
        proxyOptions.type               = type.cValue
        proxyOptions.credentials        = credentials
        proxyOptions.certificate_check  = certificateCheck
        proxyOptions.payload            = payload
        
        return url.withOptionalCString
        {
            cUrl in
            
            proxyOptions.url = cUrl
            
            return body(&proxyOptions)
        }
    }
}
