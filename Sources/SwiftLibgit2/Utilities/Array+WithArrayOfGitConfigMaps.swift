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



internal extension Array where Element == GitConfigMap
{
    /// Calls the given closure with a pointer to an array of `git_configmap`
    /// instances, and the length of that array.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    func withArrayOfGitConfigMaps<T>(
        _ body: (UnsafePointer<git_configmap>?, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        /// Collect the non-`nil` `strMatch` properties with their original
        /// indices.
        let stringEntries: [(index: Int, string: String)]
            = self.enumerated().compactMap
        {
            index, configMap in
            
            guard let strMatch: String = configMap.strMatch
            else
            {
                return nil
            }
            
            return (index, strMatch)
        }
        
        
        
        /// If there were no non-`nil` `strMatch` properties, perform
        /// direct conversion.
        guard !stringEntries.isEmpty
        else
        {
            let arrayOfConfigMaps: [git_configmap] = self.map
            {
                configMap in
                
                var cConfigMap = git_configmap()
                
                cConfigMap.type         = configMap.type.cValue()
                cConfigMap.str_match    = nil
                cConfigMap.map_value    = Int32(configMap.mapValue)
                
                return cConfigMap
            }
            
            return try arrayOfConfigMaps.withUnsafeBufferPointer
            {
                arrayOfConfigMapsBufferPointer in
                
                guard let baseAddress: UnsafePointer<git_configmap>
                        = arrayOfConfigMapsBufferPointer.baseAddress
                else
                {
                    throw NSError.makeCConversionError()
                }
                
                return try body(
                    baseAddress,
                    arrayOfConfigMaps.count
                )
            }
        }
        
        
        
        /// Create an array of mutable C string pointers.
        ///
        /// Use `Swift.Array` instead of the unqualified `Array` because within
        /// the`extension Array where Element == GitConfigMap` context, the
        /// compiler resolves unqualified `Array(_:)` calls to
        /// `Array<GitConfigMap>.init(_:)` rather than the generic
        /// `Array<T>.init(_:)` initializer. This causes a type mismatch since
        /// the assigned type is `[Int]`, but the compiler expects
        /// `[GitConfigMap]`.
        let strings         : [String]  = stringEntries.map { $0.string }
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
            
            
            
            var cStringsByIndex: [Int : UnsafeMutablePointer<CChar>] = [:]
            
            for (stringIndex, entry) in stringEntries.enumerated()
            {
                cStringsByIndex[entry.index] = cStrings[stringIndex]
            }
            
            
            
            let arrayOfConfigMaps: [git_configmap] = self.enumerated().map
            {
                index, configMap in
                
                var cConfigMap = git_configmap()
                
                cConfigMap.type         = configMap.type.cValue()
                cConfigMap.str_match    = cStringsByIndex[index].map { UnsafePointer($0) }
                cConfigMap.map_value    = Int32(configMap.mapValue)
                
                return cConfigMap
            }
            
            return try arrayOfConfigMaps.withUnsafeBufferPointer
            {
                arrayOfConfigMapsBufferPointer in
                
                guard let baseAddress: UnsafePointer<git_configmap>
                        = arrayOfConfigMapsBufferPointer.baseAddress
                else
                {
                    throw NSError.makeCConversionError()
                }
                
                return try body(
                    baseAddress,
                    arrayOfConfigMaps.count
                )
            }
        }
    }
}
