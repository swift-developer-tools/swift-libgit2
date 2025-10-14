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



/// The options for connecting through a proxy.
///
/// ## C Equivalent
///
/// [`git_proxy_options`](https://libgit2.org/docs/reference/main/proxy/git_proxy_options.html)
public struct GitProxyOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitProxyOptionsVersion``.
    public var version          : UInt32                            = gitProxyOptionsVersion
    
    /// The type of proxy.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitProxyT/gitProxyNone``.
    public var type             : GitProxyT                         = .gitProxyNone
    
    /// The URL of the proxy.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var url              : String?                           = nil
    
    /// The callback for credential acquisition.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This function will be called if the remote host requires authentication
    /// in order to connect. Returning `GIT_PASSTHROUGH` will make libgit2
    /// behave as though this field were not set.
    public var credentials      : GitCredentialAcquireCB?           = nil
    
    /// The callback for the user's custom certificate checks.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// If  certificate verification fails, this function will be called to
    /// let the user make the final decision of whether to allow the connection
    /// to proceed.
    public var certificateCheck : GitTransportCertificateCheckCB?   = nil
    
    /// The caller-specified payload passed to ``credentials`` and
    /// ``certificateCheck``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload          : UnsafeMutableRawPointer?          = nil
    
    
    
    /// Creates a ``GitProxyOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitProxyOptions`` instance from a `git_proxy_options`
    /// instance.
    /// - Parameter proxyOptions: The `git_proxy_options` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``type`` defaults to ``GitProxyT/gitProxyNone`` if an unexpected value
    /// is encountered, although this should never occur.
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
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_proxy_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_proxy_options>) throws -> T
    ) throws -> T
    {
        var proxyOptions = git_proxy_options()
        
        let proxyOptionsInitResult: GitErrorCode = gitProxyOptionsInit(
            opts:       &proxyOptions,
            version:    version
        )
        
        if proxyOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        proxyOptions.type               = type.cValue()
        proxyOptions.credentials        = credentials
        proxyOptions.certificate_check  = certificateCheck
        proxyOptions.payload            = payload
        
        return try url.withOptionalCString
        {
            cUrl in
            
            proxyOptions.url = cUrl
            
            return try body(&proxyOptions)
        }
    }
}
