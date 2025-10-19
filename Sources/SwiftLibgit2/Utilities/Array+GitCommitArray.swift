//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



internal extension Array where Element == OpaquePointer
{
    /// Initializes an array of `OpaquePointer` instances from the given
    /// `git_commitarray` instance.
    /// - Parameter commitArray: The `git_commitarray` instance to convert.
    init(
        _ commitArray: git_commitarray
    )
    {
        guard
            commitArray.count > 0,
            let commits: UnsafePointer<OpaquePointer?> = commitArray.commits
        else
        {
            self = []
            return
        }
        
        
        
        var opaquePointers: [OpaquePointer] = []
        
        opaquePointers.reserveCapacity(commitArray.count)
        
        
        
        for index in 0..<commitArray.count
        {
            if let commit: OpaquePointer = commits[index]
            {
                opaquePointers.append(commit)
            }
        }
        
        self = opaquePointers
    }
}
