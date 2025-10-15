//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The type of proxy.
///
/// ## C Equivalent
///
/// [`git_proxy_t`](https://libgit2.org/docs/reference/main/proxy/git_proxy_t.html)
public enum GitProxyT: UInt32, CEnum
{
    /// Do not attempt to connect through a proxy.
    case gitProxyNone       = 0
    
    /// Try to auto-detect the proxy from the Git configuration.
    case gitProxyAuto       = 1
    
    /// Connect via the URL given in ``GitProxyOptions``.
    case gitProxySpecified  = 2
    
    
    
    /// Initializes a ``GitProxyT`` instance from the given `git_proxy_t`
    /// instance.
    /// - Parameter attrValue: The `git_proxy_t` instance to use.
    internal init?(
        cValue proxy: git_proxy_t
    )
    {
        switch proxy
        {
            case GIT_PROXY_NONE         : self = .gitProxyNone
            case GIT_PROXY_AUTO         : self = .gitProxyAuto
            case GIT_PROXY_SPECIFIED    : self = .gitProxySpecified
            default                     : return nil
        }
    }
    
    
    
    /// Converts the ``GitProxyT`` instance into a `git_proxy_t` instance.
    /// - Returns: The `git_proxy_t` instance.
    internal func cValue() -> git_proxy_t
    {
        switch self
        {
            case .gitProxyNone      : return GIT_PROXY_NONE
            case .gitProxyAuto      : return GIT_PROXY_AUTO
            case .gitProxySpecified : return GIT_PROXY_SPECIFIED
        }
    }
}
