//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// An array of IDs.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All bindings use an array of ``GitOID`` instances
/// instead.
///
/// ## C Equivalent
///
/// [`git_oidarray`](https://libgit2.org/docs/reference/main/oidarray/git_oidarray.html)
public struct GitOIDArray: CStruct, Sendable
{
    /// The IDs.
    public private(set) var ids : [GitOID]
    
    /// The length of ``ids``.
    public var count            : Int
    {
        ids.count
    }
    
    
    
    /// Initializes a ``GitOIDArray`` instance from the given `git_oidarray`
    /// instance.
    /// - Parameter oidArray: The `git_oidarray` instance to use.
    internal init(
        cValue oidArray: git_oidarray
    )
    {
        self.ids = Array(oidArray)
    }
}
