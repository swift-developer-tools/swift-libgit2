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



internal extension Array where Element == GitMessageTrailer
{
    /// Calls the given closure with a pointer to an array of
    /// `git_message_trailer` instances, and the length of that array.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withArrayOfMessageTrailers<T>(
        _ body: (UnsafePointer<git_message_trailer>?, Int) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        /// Collect the instances with non-`nil` `key` and `value` properties.
        /// Message trailers should not have `nil` `key` and `value`
        /// properties. The optional typing of these properties in
        /// ``GitMessageTrailer`` is used to to safeguard against
        /// force-unwrapping `nil` C strings.
        let validMessageTrailers: [GitMessageTrailer] = self.compactMap
        {
            messageTrailer in
            
            guard
                messageTrailer.key != nil,
                messageTrailer.value != nil
            else
            {
                return nil
            }
            
            return messageTrailer
        }
        
        guard !validMessageTrailers.isEmpty
        else
        {
            return try body(nil, 0)
        }
        
        
        
        /// Create an array of mutable C string pointers.
        ///
        /// Use `Swift.Array` instead of the unqualified `Array` because within
        /// the`extension Array where Element == GitMessageTrailer` context,
        /// the compiler resolves unqualified `Array(_:)` calls to
        /// `Array<GitMessageTrailer>.init(_:)` rather than the generic
        /// `Array<T>.init(_:)` initializer. This causes a type mismatch since
        /// the assigned type is `[Int]`, but the compiler expects
        /// `[GitMessageTrailer]`.
        ///
        /// All keys and values are collected in a single flattened array
        /// (`[key0, value0, key1, value1, ... keyN, valueN]`).
        let strings         : [String]  = validMessageTrailers.flatMap { [$0.key!, $0.value!] }
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
            
            
            
            let arrayOfMessageTrailers: [git_message_trailer]
                = validMessageTrailers.enumerated().map
            {
                index, _ in
                
                let keyOffset   : Int   = argsOffsets[index * 2]
                let valueOffset : Int   = argsOffsets[index * 2 + 1]
                
                var cMessageTrailer = git_message_trailer()
                
                cMessageTrailer.key     = UnsafePointer(pointer + keyOffset)
                cMessageTrailer.value   = UnsafePointer(pointer + valueOffset)
                
                return cMessageTrailer
            }
            
            return try arrayOfMessageTrailers.withUnsafeBufferPointer
            {
                arrayOfMessageTrailersBufferPointer in
                
                guard let baseAddress: UnsafePointer<git_message_trailer>
                        = arrayOfMessageTrailersBufferPointer.baseAddress
                else
                {
                    throw NSError.makeCConversionError()
                }
                
                return try body(
                    baseAddress,
                    arrayOfMessageTrailers.count
                )
            }
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_message_trailer_array` instance, and updates the receiver with
    /// any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    mutating func withMutatingGitMessageTrailerArray<T>(
        _ body: (UnsafeMutablePointer<git_message_trailer_array>) throws -> T
    ) throws -> T
    {
        guard !self.isEmpty
        else
        {
            var messageTrailerArray = git_message_trailer_array()
            
            defer
            {
                gitMessageTrailerArrayFree(arr: &messageTrailerArray)
            }
            
            let result: T = try body(&messageTrailerArray)
            
            self = Array(messageTrailerArray)
            
            return result
        }
        
        
        
        return try self.withArrayOfMessageTrailers
        {
            cArrayOfMessageTrailers, cArrayOfMessageTrailersCount in
            
            let originalPointer: UnsafeMutablePointer<git_message_trailer>?
                = UnsafeMutablePointer(mutating: cArrayOfMessageTrailers)
            
            var messageTrailerArray = git_message_trailer_array()
            
            messageTrailerArray.trailers    = originalPointer
            messageTrailerArray.count       = cArrayOfMessageTrailersCount
            
            
            
            let result: T = try body(&messageTrailerArray)
            
            self = Array(messageTrailerArray)
            
            if messageTrailerArray.trailers != originalPointer
            {
                /// libgit2 allocated new memory that must be freed.
                gitMessageTrailerArrayFree(arr: &messageTrailerArray)
            }
            
            return result
        }
    }
    
    
    
    /// Creates an array of ``GitMessageTrailer`` instances from a
    /// `git_message_trailer_array` instance.
    /// - Parameter messageTrailerArray: The `git_message_trailer_array`
    /// instance to convert.
    init(
        _ messageTrailerArray: git_message_trailer_array
    )
    {
        guard
            messageTrailerArray.count > 0,
            let cMessageTrailers: UnsafeMutablePointer<git_message_trailer>
                = messageTrailerArray.trailers
        else
        {
            self = []
            return
        }
        
        
        
        var swiftMessageTrailers: [GitMessageTrailer] = []
        
        swiftMessageTrailers.reserveCapacity(messageTrailerArray.count)
        
        
        
        for index in 0..<messageTrailerArray.count
        {
            let cMessageTrailer: git_message_trailer = cMessageTrailers[index]
            
            swiftMessageTrailers.append(
                GitMessageTrailer(cValue: cMessageTrailer)
            )
        }
        
        self = swiftMessageTrailers
    }
}
