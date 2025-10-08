//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



internal extension Array where Element == GitOID
{
    /// Creates a `[GitOID]` from a `git_oidarray` instance.
    /// - Parameter oidArray: The `git_oidarray` instance to convert.
    init(
        _ oidArray: git_oidarray
    )
    {
        guard
            oidArray.count > 0,
            let cOIDs: UnsafeMutablePointer<git_oid> = oidArray.ids
        else
        {
            self = []
            return
        }
        
        
        
        var swiftOIDs: [GitOID] = []
        
        swiftOIDs.reserveCapacity(oidArray.count)
        
        
        
        for index in 0..<oidArray.count
        {
            let cOID: git_oid = cOIDs[index]
            
            swiftOIDs.append(GitOID(cValue: cOID))
        }
        
        self = swiftOIDs
    }
}
