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
    let id: Data
    
    
    
    /// Creates a ``GitOID`` instance from a `git_oid` instance.
    /// - Parameter oid: The `git_oid` instance to use.
    internal init(
        cValue oid: inout git_oid
    )
    {
        self.id = Data(
            bytes:  &oid.id,
            count:  20
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
                20
            )
        }
        
        return oid
    }
}
