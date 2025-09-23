//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



internal extension Array where Element == OpaquePointer
{
    /// Creates an `[OpaquePointer]` from a `git_commitarray` instance.
    /// - Parameter commitarray: The `git_commitarray` instance to convert.
    init(
        _ commitarray: git_commitarray
    )
    {
        guard
            commitarray.count > 0,
            let commits: UnsafePointer<OpaquePointer?> = commitarray.commits
        else
        {
            self = []
            return
        }
        
        
        
        var opaquePointers: [OpaquePointer] = []
        
        opaquePointers.reserveCapacity(commitarray.count)
        
        
        
        for index in 0..<commitarray.count
        {
            if let commit: OpaquePointer = commits[index]
            {
                opaquePointers.append(commit)
            }
        }
        
        self = opaquePointers
    }
}
