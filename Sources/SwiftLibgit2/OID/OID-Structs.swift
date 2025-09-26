//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import Foundation



/// The unique identity of any object.
///
/// ## C Equivalent
///
/// [`git_oid`](https://libgit2.org/docs/reference/main/oid/git_oid.html)
public struct GitOID: GitStructInternalMutable, NonOptionalCConvertible
{
    /// The raw binary-formatted ID.
    public private(set) var id: Data = Data(count: Self.size)
    
    /// The size of a Git OID in bytes.
    internal static let size: Int = 20
    
    
    
    /// Creates a ``GitOID`` instance.
    public init() { }
    
    
    
    /// Creates a ``GitOID`` instance from a `git_oid` instance.
    /// - Parameter oid: The `git_oid` instance to use.
    internal init(
        cValue oid: git_oid
    )
    {
        var oidCopy: git_oid = oid
        
        self.id = Data(
            bytes:  &oidCopy.id,
            count:  Self.size
        )
    }
    
    
    
    /// The equivalent C value.
    internal var cValue: git_oid
    {
        var oid = git_oid()
        
        id.withUnsafeBytes
        {
            bytes in
            
            _ = memcpy(
                &oid.id,
                bytes.baseAddress,
                min(bytes.count, Self.size)
            )
        }
        
        return oid
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_oid` instance, and updates this ``GitOID``
    /// instance with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<git_oid>) -> T
    ) -> T
    {
        var oid = cValue
        
        let result: T = body(&oid)
        
        self = GitOID(cValue: oid)
        
        return result
    }
}
