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

/// The ``withMutableCString(_:)`` function below is adapted from the
/// Swift.org open source project. Original source code:
/// https://github.com/swiftlang/swift/blob/c3b7709a7c4789f1ad7249d357f69509fb8be731/stdlib/private/SwiftPrivate/SwiftPrivate.swift

import Foundation



internal extension String
{
    /// Calls the given closure with a mutable C string.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the closure.
    /// - Throws: An error if the conversion fails.
    func withMutableCString<T>(
        _ body: (UnsafeMutablePointer<CChar>) throws -> T
    ) throws -> T
    {
        var buffer: [UInt8] = []
        
        buffer.reserveCapacity(self.utf8.count + 1)
        
        
        
        if !self.isEmpty
        {
            buffer.append(contentsOf: self.utf8)
        }
        
        buffer.append(0)
        
        
        
        return try buffer.withUnsafeMutableBufferPointer
        {
            buffer in
            
            guard let baseAddress: UnsafeMutablePointer<UInt8>
                    = buffer.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            let mutableCString = UnsafeMutableRawPointer(baseAddress)
                .bindMemory(
                    to:         CChar.self,
                    capacity:   buffer.count
                )
            
            return try body(mutableCString)
        }
    }
    
    
    
    /// Initializes a new string from the given optional C string pointer.
    ///
    /// This initializer handles C string pointers that may be `nil` in cases
    /// where libgit2 returns `nil` for absent or inapplicable values, such as
    /// optional struct fields or context-dependent return values.
    ///
    /// libgit2's nullability annotations in its headers do not always reflect
    /// actual runtime behavior. libgit2 functions annotated as returning
    /// non-`nil` pointers may return `nil` under certain conditions.
    /// For example, `git_annotated_commit_ref()` returns `nil` if the given
    /// commit was created from a revspec, and `git_pathspec_match_list_entry()`
    /// returns `nil` if the given pathspec match list was created by matching
    /// against a diff. The latter behavior is documented, but the headers do
    /// not reflect the possibility of a `nil` value.
    ///
    /// - Important: When converting C string pointers to Swift strings,
    /// always use this initializer to prevent runtime crashes, unless an
    /// explicit `guard` statement has been used to verify that the pointer
    /// is not `nil`.
    ///
    /// - Parameter cString: The optional C string pointer from which to
    /// initialize a new string.
    init?(
        optionalCString cString: UnsafePointer<CChar>?
    )
    {
        guard let cString
        else
        {
            return nil
        }
        
        self.init(cString: cString)
    }
}



internal extension Optional where Wrapped == String
{
    /// Calls the given closure with an optional C string.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    func withOptionalCString<T>(
        _ body: (UnsafePointer<CChar>?) throws -> T
    ) rethrows -> T
    {
        switch self
        {
            case .none:
                
                return try body(nil)
                
            case .some(let wrapped):
                
                return try wrapped.withCString
                {
                    cString in
                    
                    return try body(cString)
                }
        }
    }
    
    
    
    /// Calls the given closure with an an optional mutable C string.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    func withOptionalMutableCString<T>(
        _ body: (UnsafeMutablePointer<CChar>?) throws -> T
    ) throws -> T
    {
        switch self
        {
            case .none:
                
                return try body(nil)
                
            case .some(let wrapped):
                
                return try wrapped.withMutableCString
                {
                    cString in
                    
                    return try body(cString)
                }
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to an optional C string,
    /// and updates the receiver with any changes made by the closure.
    ///
    /// - Important: This method does not free any memory. Only use this method
    /// with libgit2 functions that return pointers to memory owned by other
    /// objects. Do not use this method with libgit2 functions that allocate
    /// memory that must be freed by the caller.
    ///
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    mutating func withOptionalMutatingCString<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<CChar>?>) throws -> T
    ) rethrows -> T
    {
        switch self
        {
            case .none:
                
                var cString: UnsafePointer<CChar>? = nil
                
                let result: T = try body(&cString)
                
                if isSuccess(result)
                {
                    self = String(optionalCString: cString)
                }
                
                return result
                
            case .some(let wrapped):
                
                return try wrapped.withCString
                {
                    cString in
                    
                    var optionalCString: UnsafePointer<CChar>? = cString
                    
                    let result: T = try body(&optionalCString)
                    
                    if isSuccess(result)
                    {
                        self = String(optionalCString: optionalCString)
                    }
                    
                    return result
                }
        }
    }
}
