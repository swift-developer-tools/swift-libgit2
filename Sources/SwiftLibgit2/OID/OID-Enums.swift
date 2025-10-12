//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The type of ID.
///
/// ## C Equivalent
///
/// [`git_oid_t`](https://libgit2.org/docs/reference/main/oid/git_oid_t.html)
public enum GitOIDT: UInt32, GitEnum
{
    /// SHA-1.
    case gitOIDSHA1 = 1
    
    
    
    /// Creates a ``GitOIDT`` instance from a `git_oid_t` instance.
    /// - Parameter oid: The `git_oid_t` instance to use.
    internal init?(
        cValue oid: git_oid_t
    )
    {
        switch oid
        {
            case GIT_OID_SHA1   : self = .gitOIDSHA1
            default             : return nil
        }
    }
    
    
    
    /// Converts the ``GitOIDT`` instance into a `git_oid_t` instance.
    /// - Returns: The `git_oid_t` instance.
    internal func cValue() -> git_oid_t
    {
        switch self
        {
            case .gitOIDSHA1: return GIT_OID_SHA1
        }
    }
}
