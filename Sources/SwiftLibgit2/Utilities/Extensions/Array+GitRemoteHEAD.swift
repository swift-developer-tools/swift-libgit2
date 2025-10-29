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



internal extension Array where Element == GitRemoteHEAD
{
    /// Calls the given closure with a pointer to an array of `git_remote_head`
    /// instances, and the length of that array.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withArrayOfGitRemoteHEADs<T>(
        _ body: (
            UnsafePointer<UnsafePointer<git_remote_head>?>?,
            Int
        ) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        /// Collect the non-`nil` `name` and `symRefTarget` properties.
        let strings: [String] = self.flatMap
        {
            remoteHEAD in
            
            let stringProperties: [String?] =
            [
                remoteHEAD.name,
                remoteHEAD.symRefTarget
            ]
            
            return stringProperties.compactMap { $0 }
        }
        
        
        
        /// If there were no non-`nil` `name` and `symRefTarget` properties,
        /// perform direct conversion.
        guard !strings.isEmpty
        else
        {
            let arrayOfRemoteHEADs: [git_remote_head] = self.map
            {
                remoteHEAD in
                
                var cRemoteHEAD = git_remote_head()
                
                cRemoteHEAD.local           = remoteHEAD.local.int32Value
                cRemoteHEAD.oid             = remoteHEAD.oid.cValue()
                cRemoteHEAD.loid            = remoteHEAD.loid.cValue()
                cRemoteHEAD.name            = nil
                cRemoteHEAD.symref_target   = nil
                
                return cRemoteHEAD
            }
            
            return try arrayOfRemoteHEADs.withUnsafeBufferPointer
            {
                arrayOfRemoteHEADsBufferPointer in
                
                var baseAddress: UnsafePointer<git_remote_head>?
                    = arrayOfRemoteHEADsBufferPointer.baseAddress
                
                guard baseAddress != nil
                else
                {
                    throw NSError.makeCConversionError()
                }
                
                return try body(
                    &baseAddress,
                    arrayOfRemoteHEADsBufferPointer.count
                )
            }
        }
        
        
        
        /// Create an array of mutable C string pointers.
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
            
            
            
            var currentStringIndex: Int = 0
            
            let arrayOfRemoteHEADs: [git_remote_head] = self.enumerated().map
            {
                index, remoteHEAD in
                
                var cRemoteHEAD = git_remote_head()
                
                cRemoteHEAD.local           = remoteHEAD.local.int32Value
                cRemoteHEAD.oid             = remoteHEAD.oid.cValue()
                cRemoteHEAD.loid            = remoteHEAD.loid.cValue()
                
                if remoteHEAD.name != nil
                {
                    cRemoteHEAD.name = UnsafeMutablePointer(
                        pointer + argsOffsets[currentStringIndex]
                    )
                    
                    currentStringIndex += 1
                }
                
                if remoteHEAD.symRefTarget != nil
                {
                    cRemoteHEAD.symref_target = UnsafeMutablePointer(
                        pointer + argsOffsets[currentStringIndex]
                    )
                    
                    currentStringIndex += 1
                }
                
                return cRemoteHEAD
            }
            
            
            
            return try arrayOfRemoteHEADs.withUnsafeBufferPointer
            {
                arrayOfRemoteHEADsBufferPointer in
                
                var baseAddress: UnsafePointer<git_remote_head>?
                    = arrayOfRemoteHEADsBufferPointer.baseAddress
                
                guard baseAddress != nil
                else
                {
                    throw NSError.makeCConversionError()
                }
                
                return try body(
                    &baseAddress,
                    arrayOfRemoteHEADsBufferPointer.count
                )
            }
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an array of
    /// `git_remote_head` instances, and a mutable pointer to the length of
    /// that array, and updates the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// This method is used with ``gitRemoteLS(out:size:remote:)``. The memory
    /// allocated by libgit2 belongs to the remote, and must not be freed by
    /// this method. The memory is valid as long as a new connection is not
    /// initiated. The caller must manage the lifetime of the remote itself.
    mutating func withMutatingArrayOfGitRemoteHEADs<T>(
        _ body: (
            UnsafeMutablePointer<UnsafeMutablePointer<UnsafePointer<git_remote_head>?>?>,
            UnsafeMutablePointer<Int>
        ) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            var arrayOfRemoteHEADs: UnsafeMutablePointer<UnsafePointer<git_remote_head>?>?
                = nil
            
            var count: Int = 0
            
            let result: T = try body(
                &arrayOfRemoteHEADs,
                &count
            )
            
            if isSuccess(result)
            {
                self = Array(
                    arrayOfRemoteHEADs,
                    count: count
                )
            }
            
            return result
        }
        
        
        
        return try self.withArrayOfGitRemoteHEADs
        {
            cArrayOfRemoteHEADs, cArrayOfRemoteHEADsCount in
            
            var arrayOfRemoteHEADs: UnsafeMutablePointer<UnsafePointer<git_remote_head>?>?
                = UnsafeMutablePointer(mutating: cArrayOfRemoteHEADs)
            
            var count: Int = cArrayOfRemoteHEADsCount
            
            let result: T = try body(
                &arrayOfRemoteHEADs,
                &count
            )
            
            if isSuccess(result)
            {
                self = Array(
                    arrayOfRemoteHEADs,
                    count: count
                )
            }
            
            return result
        }
    }
    
    
    
    /// Initializes an array of ``GitRemoteHEAD`` instances from the given
    /// pointer to an array of `git_remote_head` instances.
    /// - Parameters:
    ///   - cArrayOfRemoteHEADs: The pointer to the array of `git_remote_head`
    ///   instances.
    ///   - count: The length of `cArrayOfRemoteHEADs`.
    init(
        _ cArrayOfRemoteHEADs   : UnsafePointer<UnsafePointer<git_remote_head>?>?,
        count                   : Int
    )
    {
        guard
            count > 0,
            let cArrayOfRemoteHEADs: UnsafePointer<UnsafePointer<git_remote_head>?>
                = cArrayOfRemoteHEADs
        else
        {
            self = []
            return
        }
        
        
        
        var swiftArrayRemoteHEADs: [GitRemoteHEAD] = []
        
        swiftArrayRemoteHEADs.reserveCapacity(count)
        
        
        
        for index in 0..<count
        {
            guard let cRemoteHEAD: git_remote_head
                    = cArrayOfRemoteHEADs[index]?.pointee
            else
            {
                continue
            }
            
            swiftArrayRemoteHEADs.append(GitRemoteHEAD(cValue: cRemoteHEAD))
        }
        
        self = swiftArrayRemoteHEADs
    }
}
