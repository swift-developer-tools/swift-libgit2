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



/// The unique identity of any object.
///
/// ## C Equivalent
///
/// [`git_oid`](https://libgit2.org/docs/reference/main/oid/git_oid.html)
public struct GitOID: GitStructInternalMutable, CConvertible
{
    /// The raw binary-formatted ID.
    ///
    /// ## Discussion
    ///
    /// The default value is a `Data` instance with a `count` of 20 bytes.
    public private(set) var id: Data = Data(count: Self.size)
    
    /// The size of a Git ID in bytes.
    internal static let size: Int = 20
    
    
    
    /// Creates a ``GitOID`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
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
    
    
    
    /// Converts the ``GitOID`` instance into a `git_oid` instance.
    /// - Returns: The `git_oid` instance.
    internal func cValue() -> git_oid
    {
        var oid = git_oid()
        
        id.withUnsafeBytes
        {
            cID in
            
            _ = memcpy(
                &oid.id,
                cID.baseAddress,
                min(cID.count, Self.size)
            )
        }
        
        return oid
    }
}
