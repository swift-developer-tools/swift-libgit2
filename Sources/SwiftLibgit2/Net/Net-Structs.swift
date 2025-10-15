//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The description of a reference advertised by a remote server, given out
/// on `ls` calls.
///
/// ## C Equivalent
///
/// [`git_remote_head`](https://libgit2.org/docs/reference/main/net/git_remote_head.html)
public struct GitRemoteHEAD: CStructReadable, WithCConvertible
{
    /// Whether the reference exists locally.
    public let local        : Bool
    
    /// The ID of the reference.
    public let oid          : GitOID
    
    /// The local ID of the reference.
    public let loid         : GitOID
    
    /// The name of the reference.
    public let name         : String?
    
    /// The target of the symbolic reference, if the server sent a symref
    /// mapping for the reference.
    public let symrefTarget : String?
    
    
    
    /// Initializes a ``GitRemoteHEAD`` instance from the given
    /// `git_remote_head` instance.
    /// - Parameter remoteHEAD: The `git_remote_head` instance to use.
    internal init(
        cValue remoteHEAD: git_remote_head
    )
    {
        self.local          = Bool(remoteHEAD.local)
        self.oid            = GitOID(cValue: remoteHEAD.oid)
        self.loid           = GitOID(cValue: remoteHEAD.loid)
        self.name           = String(optionalCString: remoteHEAD.name)
        self.symrefTarget   = String(optionalCString: remoteHEAD.symref_target)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_remote_head`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_remote_head>) throws -> T
    ) throws -> T
    {
        var remoteHEAD = git_remote_head()
        
        remoteHEAD.local    = local.int32Value
        remoteHEAD.oid      = oid.cValue()
        remoteHEAD.loid     = loid.cValue()
        
        return try name.withOptionalMutableCString
        {
            cName in
            
            remoteHEAD.name = cName
            
            return try symrefTarget.withOptionalMutableCString
            {
                cSymrefTarget in
                
                remoteHEAD.symref_target = cSymrefTarget
                
                return try body(&remoteHEAD)
            }
        }
    }
}
