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
public struct GitOID
{
    /// The raw binary-formatted ID.
    public private(set) var id: Data = Data(count: Self.size)
    
    /// The size of a Git OID in bytes.
    private static let size: Int = 20
    
    
    
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
                Self.size
            )
        }
        
        return oid
    }
}
