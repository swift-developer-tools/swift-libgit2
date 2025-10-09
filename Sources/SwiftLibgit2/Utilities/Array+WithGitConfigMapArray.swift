//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



internal extension Array where Element == GitConfigMap
{
    /// Calls the given closure with a  pointer to a `git_configmap` array, by recursively converting
    /// each ``GitConfigMap`` element of the receiver.
    /// - Parameters:
    ///   - recursionIndex: The current recursion index.
    ///   - accumulatedMaps: The accumulated `git_configmap` instances.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the array is empty or if memory allocation fails.
    ///
    /// Neither ``recursionIndex`` nor ``accumulatedMaps`` should be provided by the caller.
    func withGitConfigMapArray<T>(
        index           recursionIndex  : Int                                   = 0,
        accumulating    accumulatedMaps : [git_configmap]                       = [],
        _               body            : (UnsafePointer<git_configmap>?) -> T
    ) -> T
    {
        guard !self.isEmpty
        else
        {
            return body(nil)
        }
        
        guard recursionIndex < self.count
        else
        {
            return accumulatedMaps.withUnsafeBufferPointer
            {
                accumulatedMapsBufferPointer in
                
                /// The base address should not be `nil` at this point, since the array is not empty.
                /// No `guard` is necessary, since the alternative would be to call `body(nil)`.
                return body(accumulatedMapsBufferPointer.baseAddress)
            }
        }
        
        
        
        return self[recursionIndex].withCValue
        {
            configMap in
            
            var updatedConfigMaps: [git_configmap] = accumulatedMaps
            
            updatedConfigMaps.append(configMap.pointee)
            
            return self.withGitConfigMapArray(
                index:          recursionIndex + 1,
                accumulating:   updatedConfigMaps,
                body
            )
        }
    }
}
