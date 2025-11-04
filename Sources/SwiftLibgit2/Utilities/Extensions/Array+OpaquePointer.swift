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
    /// Calls the given closure with a mutable pointer to a `git_commitarray`
    /// instance.
    ///
    /// - Important: The commits are owned by the caller and must not be freed.
    ///
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    func withGitCommitArray<T>(
        _ body: (UnsafeMutablePointer<git_commitarray>) throws -> T
    ) rethrows -> T
    {
        var commitArray = git_commitarray()
        
        guard !self.isEmpty
        else
        {
            return try body(&commitArray)
        }
        
        
        
        let originalPointers = UnsafeMutablePointer<OpaquePointer?>
            .allocate(capacity: self.count)
        
        defer
        {
            originalPointers.deallocate()
        }
        
        
        
        for (index, opaquePointer) in self.enumerated()
        {
            originalPointers[index] = opaquePointer
        }
        
        commitArray.commits     = UnsafePointer(originalPointers)
        commitArray.count       = self.count
        
        
        
        return try body(&commitArray)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_commitarray`
    /// instance, and updates the receiver with any changes made by the closure.
    ///
    /// - Important: The commits are owned by the caller and must not be freed.
    ///
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    mutating func withMutatingGitCommitArray<T>(
        _ body: (UnsafeMutablePointer<git_commitarray>) throws -> T
    ) rethrows -> T
    {
        return try self.withGitCommitArray
        {
            commitArray in
            
            let result: T = try body(commitArray)
            
            if isSuccess(result)
            {
                self = Array(commitArray.pointee)
            }
            
            return result
        }
    }
    
    
    
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
