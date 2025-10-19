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



internal extension Array where Element == GitOID
{
    /// Calls the given closure with a pointer to an array of `git_oid`
    /// instances, and the length of that array.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withArrayOfGitOIDs<T>(
        _ body: (UnsafePointer<git_oid>?, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        let arrayOfOIDs: [git_oid] = self.map { $0.cValue() }
        
        return try arrayOfOIDs.withUnsafeBufferPointer
        {
            arrayOfOIDsBufferPointer in
            
            guard let baseAddress: UnsafePointer<git_oid>
                    = arrayOfOIDsBufferPointer.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            return try body(
                baseAddress,
                arrayOfOIDs.count
            )
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_oidarray`
    /// instance, and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    mutating func withMutatingGitOIDArray<T>(
        _ body: (UnsafeMutablePointer<git_oidarray>) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            var oidArray = git_oidarray()
            
            defer
            {
                if oidArray.count > 0
                {
                    /// libgit2 allocated new memory that must be freed.
                    gitOIDArrayDispose(array: &oidArray)
                }
            }
            
            let result: T = try body(&oidArray)
            
            self = Array(oidArray)
            
            return result
        }
        
        
        
        return try self.withArrayOfGitOIDs
        {
            cArrayOfOIDs, cArrayOfOIDsCount in
            
            let originalPointer: UnsafeMutablePointer<git_oid>?
                = UnsafeMutablePointer(mutating: cArrayOfOIDs)
            
            var oidArray = git_oidarray()
            
            oidArray.ids    = originalPointer
            oidArray.count  = cArrayOfOIDsCount
            
            
            
            let result: T = try body(&oidArray)
            
            self = Array(oidArray)
            
            if oidArray.ids != originalPointer
            {
                /// libgit2 allocated new memory that must be freed.
                gitOIDArrayDispose(array: &oidArray)
            }
            
            return result
        }
    }
    
    
    
    /// Initializes an array of ``GitOID`` instances from the given
    /// `git_oidarray` instance.
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
