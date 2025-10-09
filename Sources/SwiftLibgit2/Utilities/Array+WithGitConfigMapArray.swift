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



internal extension Array where Element == GitConfigMap
{
    /// Calls the given closure with a  pointer to a `git_configmap` array and the length of that array,
    /// by recursively converting each ``GitConfigMap`` element of the receiver.
    /// - Parameters:
    ///   - recursionIndex: The current recursion index.
    ///   - accumulatedMaps: The accumulated `git_configmap` instances.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    ///
    /// ## Discussion
    ///
    /// - Important: Neither ``recursionIndex`` nor ``accumulatedMaps`` should be
    /// provided by the caller.
    func withGitConfigMapArray<T>(
        index           recursionIndex  : Int               = 0,
        accumulating    accumulatedMaps : [git_configmap]   = [],
        _               body            : (UnsafePointer<git_configmap>?, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        guard recursionIndex < self.count
        else
        {
            return try accumulatedMaps.withUnsafeBufferPointer
            {
                accumulatedMapsBufferPointer in
                
                guard let baseAddress: UnsafePointer<git_configmap>
                        = accumulatedMapsBufferPointer.baseAddress
                else
                {
                    throw NSError.makeCConversionError()
                }
                
                return try body(
                    baseAddress,
                    recursionIndex
                )
            }
        }
        
        
        
        return try self[recursionIndex].withCValue
        {
            configMap in
            
            var updatedConfigMaps: [git_configmap] = accumulatedMaps
            
            updatedConfigMaps.append(configMap.pointee)
            
            return try self.withGitConfigMapArray(
                index:          recursionIndex + 1,
                accumulating:   updatedConfigMaps,
                body
            )
        }
    }
}
