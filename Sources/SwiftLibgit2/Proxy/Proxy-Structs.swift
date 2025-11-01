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
    /// The struct version.
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
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var url              : String?
    
    /// The callback invoked to acquire credentials.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This function will be called if the remote host requires authentication
    /// in order to connect. Returning ``GitErrorCode/gitPassthrough`` will
    /// make libgit2 behave as if this field were not set.
    public var credentials      : GitCredentialAcquireCB?
    
    /// The callback invoked to check custom certificates.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// If certificate verification fails, this function will be called to
    /// let the user make the final decision of whether to allow the connection
    /// to proceed.
    public var certificateCheck : GitTransportCertificateCheckCB?
    
    /// The payload passed to ``credentials`` and ``certificateCheck``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload          : UnsafeMutableRawPointer?
    
    
    
    /// Initializes a ``GitProxyOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version             : UInt32                            = gitProxyOptionsVersion,
        type                : GitProxyT                         = .gitProxyNone,
        url                 : String?                           = nil,
        credentials         : GitCredentialAcquireCB?           = nil,
        certificateCheck    : GitTransportCertificateCheckCB?   = nil,
        payload             : UnsafeMutableRawPointer?          = nil
    )
    {
        self.version            = version
        self.type               = type
        self.url                = url
        self.credentials        = credentials
        self.certificateCheck   = certificateCheck
        self.payload            = payload
    }
    
    
    
    /// Initializes a ``GitProxyOptions`` instance from the given
    /// `git_proxy_options` instance.
    /// - Parameter proxyOptions: The `git_proxy_options` instance to use.
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
