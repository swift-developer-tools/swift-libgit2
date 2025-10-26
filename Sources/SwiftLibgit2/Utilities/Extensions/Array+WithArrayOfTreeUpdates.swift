//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
// Parts of this file are adapted from the Swift.org open source project.
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors.
// Licensed under the Apache License, Version 2.0, with Runtime Library
// Exception.
//
// See https://swift.org/LICENSE.txt for license information.
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors.
//
//===----------------------------------------------------------------------===//

/// Parts of the function below are adapted from the Swift.org open source
/// project. Original source code:
/// https://github.com/swiftlang/swift/blob/c3b7709a7c4789f1ad7249d357f69509fb8be731/stdlib/private/SwiftPrivate/SwiftPrivate.swift

import CLibgit2
import Foundation



internal extension Array where Element == GitTreeUpdate
{
    /// Calls the given closure with a pointer to an array of `git_tree_update`
    /// instances, and the length of that array.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withArrayOfGitTreeUpdates<T>(
        _ body: (UnsafePointer<git_tree_update>?, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        /// Collect the instances with non-`nil` `path` properties.
        /// Valid tree updates do not have `nil` `path` properties.
        /// The optional typing of this property in ``GitTreeUpdate`` is
        /// used to to safeguard against force-unwrapping `nil` C strings.
        let validTreeUpdates: [GitTreeUpdate] = self.compactMap
        {
            treeUpdate in
            
            guard treeUpdate.path != nil
            else
            {
                return nil
            }
            
            return treeUpdate
        }
        
        guard !validTreeUpdates.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        /// Create an array of mutable C string pointers.
        let strings         : [String]  = validTreeUpdates.map { $0.path! }
        let argsCounts      : [Int]     = Swift.Array(strings.map { $0.utf8.count + 1 })
        let argsOffsets     : [Int]     = [0] + scan(argsCounts, 0, +)
        let argsBufferSize  : Int       = argsOffsets.last ?? 0
        
        
        
        var argsBuffer: [UInt8] = []
        
        argsBuffer.reserveCapacity(argsBufferSize)
        
        for arg in strings
        {
            argsBuffer.append(contentsOf: arg.utf8)
            argsBuffer.append(0)
        }
        
        
        
        return try argsBuffer.withUnsafeMutableBufferPointer
        {
            argsBuffer in
            
            guard let baseAddress: UnsafeMutablePointer<UInt8>
                    = argsBuffer.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            
            
            let pointer = UnsafeMutableRawPointer(baseAddress)
                .bindMemory(
                    to:         CChar.self,
                    capacity:   argsBuffer.count
                )
            
            
            
            let cStrings: [UnsafeMutablePointer<CChar>?]
                = argsOffsets.map { pointer + $0 }
            
            
            
            let arrayOfTreeUpdates: [git_tree_update]
                = validTreeUpdates.enumerated().map
            {
                index, treeUpdate in
                
                var cTreeUpdate = git_tree_update()
                
                cTreeUpdate.action      = treeUpdate.action.cValue()
                cTreeUpdate.id          = treeUpdate.id.cValue()
                cTreeUpdate.filemode    = treeUpdate.fileMode.cValue()
                cTreeUpdate.path        = cStrings[index].map { UnsafePointer($0) }
                
                return cTreeUpdate
            }
            
            return try arrayOfTreeUpdates.withUnsafeBufferPointer
            {
                arrayOfTreeUpdatesBufferPointer in
                
                guard let baseAddress: UnsafePointer<git_tree_update>
                        = arrayOfTreeUpdatesBufferPointer.baseAddress
                else
                {
                    throw NSError.makeCConversionError()
                }
                
                return try body(
                    baseAddress,
                    arrayOfTreeUpdates.count
                )
            }
        }
    }
}
