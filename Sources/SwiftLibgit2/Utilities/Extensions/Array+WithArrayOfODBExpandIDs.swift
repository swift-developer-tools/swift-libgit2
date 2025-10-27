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



internal extension Array where Element == GitODBExpandID
{
    /// Calls the given closure with a pointer to an array of
    /// `git_odb_expand_id` instances, and the length of that array.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withArrayOfGitODBExpandIDs<T>(
        _ body: (UnsafePointer<git_odb_expand_id>?, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        let arrayOfODBExpandIDs: [git_odb_expand_id] = self.map { $0.cValue() }
        
        return try arrayOfODBExpandIDs.withUnsafeBufferPointer
        {
            arrayOfODBExpandIDsBufferPointer in
            
            guard let baseAddress: UnsafePointer<git_odb_expand_id>
                    = arrayOfODBExpandIDsBufferPointer.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            return try body(
                baseAddress,
                arrayOfODBExpandIDsBufferPointer.count
            )
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_odb_expand_id`
    /// instance, and the length of that array, and updates the receiver with
    /// any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    mutating func withMutatingArrayOfGitODBExpandIDs<T>(
        _ body: (UnsafeMutablePointer<git_odb_expand_id>, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            var odbExpandID = git_odb_expand_id()
            
            return try withUnsafeMutablePointer(to: &odbExpandID)
            {
                odbExpandIDPointer in
                
                return try body(odbExpandIDPointer, 0)
            }
        }
        
        
        
        var arrayOfODBExpandIDs: [git_odb_expand_id] = self.map { $0.cValue() }
        
        let result: T = try arrayOfODBExpandIDs.withUnsafeMutableBufferPointer
        {
            arrayOfODBExpandIDsBufferPointer in
            
            guard let baseAddress: UnsafeMutablePointer<git_odb_expand_id>
                    = arrayOfODBExpandIDsBufferPointer.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            return try body(
                baseAddress,
                arrayOfODBExpandIDsBufferPointer.count
            )
        }
        
        if isSuccess(result)
        {
            self = arrayOfODBExpandIDs.map { GitODBExpandID(cValue: $0 )}
        }
        
        return result
    }
}
