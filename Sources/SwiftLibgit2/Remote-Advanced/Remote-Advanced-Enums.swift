//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The flags indicating a remote's capabilities.
///
/// ## C Equivalent
///
/// [`git_remote_capability_t`](https://libgit2.org/docs/reference/main/sys/remote/git_remote_capability_t.html)
public struct GitRemoteCapabilityT: COptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    
    
    /// Initializes a ``GitRemoteCapabilityT`` instance from the given raw
    /// value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// Initializes a ``GitRemoteCapabilityT`` instance from the given
    /// `git_remote_capability_t` instance.
    /// - Parameter remoteCapability: The `git_remote_capability_t` instance
    /// to use.
    internal init(
        cValue remoteCapability: git_remote_capability_t
    )
    {
        self.rawValue = remoteCapability.rawValue
    }
    
    
    
    /// The remote supports fetching an advertised object by its ID.
    public static let gitRemoteCapabilityTipOID         = GitRemoteCapabilityT(rawValue: GIT_REMOTE_CAPABILITY_TIP_OID.rawValue)
    
    /// The remote supports fetching an individual reachable object.
    public static let gitRemoteCapabilityReachableOID   = GitRemoteCapabilityT(rawValue: GIT_REMOTE_CAPABILITY_REACHABLE_OID.rawValue)
    
    /// The remote supports push options.
    public static let gitRemoteCapabilityPushOptions    = GitRemoteCapabilityT(rawValue: GIT_REMOTE_CAPABILITY_PUSH_OPTIONS.rawValue)
    
    
    
    /// Converts the ``GitRemoteCapabilityT`` instance into a
    /// `git_remote_capability_t` instance.
    /// - Returns: The `git_remote_capability_t` instance.
    internal func cValue() -> git_remote_capability_t
    {
        return git_remote_capability_t(rawValue)
    }
}
