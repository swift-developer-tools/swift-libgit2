//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// An array of OIDs.
///
/// ## C Equivalent
///
/// [`git_oidarray`](https://libgit2.org/docs/reference/main/oidarray/git_oidarray.html)
public struct GitOIDArray: GitStructInternalMutable, WithCConvertible
{
    /// The OIDs.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public private(set) var ids : [GitOID]  = []
    
    /// The length of ``ids``.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var count            : Int
    {
        ids.count
    }
    
    
    
    /// Creates a ``GitOIDArray`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitOIDArray`` instance from a `git_oidarray` instance.
    /// - Parameter oidArray: The `git_oidarray` instance to use.
    internal init(
        cValue oidArray: git_oidarray
    )
    {
        self.ids = Array(oidArray)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_oidarray` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// ``gitOIDArrayDispose(array:)`` is used only if ``ids`` is empty, since that function
    /// is intended to free the OIDs of a `git_oidarray` which was allocated by libgit2.
    ///
    /// When ``ids`` is not empty, the memory is manually allocated and deallocated.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_oidarray>) throws -> T
    ) rethrows -> T
    {
        guard !ids.isEmpty
        else
        {
            var oidArray = git_oidarray()
            
            defer
            {
                gitOIDArrayDispose(array: &oidArray)
            }
            
            return try body(&oidArray)
        }
        
        
        
        let cOIDs = UnsafeMutablePointer<git_oid>.allocate(capacity: ids.count)
        
        defer
        {
            cOIDs.deallocate()
        }
        
        
        
        for (index, swiftOID) in ids.enumerated()
        {
            cOIDs[index] = swiftOID.cValue()
        }
        
        
        
        var oidArray = git_oidarray()
        
        oidArray.ids    = cOIDs
        oidArray.count  = ids.count
        
        return try body(&oidArray)
    }
}
