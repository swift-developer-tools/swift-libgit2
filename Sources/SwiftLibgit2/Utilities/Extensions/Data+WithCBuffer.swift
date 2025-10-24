//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Foundation



internal extension Data
{
    /// Calls the given closure with a pointer to a buffer, and the length of
    /// that buffer.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// Callers must ensure that the receiver is not empty before calling
    /// this method when:
    ///
    /// - Empty data has semantic meaning other than an error. For example,
    /// empty binary diff data may represent no changes, and empty credential
    /// data may be valid.
    /// - The receiver represents data returned by libgit2.
    ///
    /// In these cases, callers must handle the empty data by passing `nil`
    /// for the buffer and `0` for the buffer count.
    ///
    /// Callers may call this method without checking whether the receiver is
    /// empty when:
    ///
    /// - The receiver represents user-provided data, where empty input is
    /// invalid.
    /// - Empty data would cause undefined behavior in the C function.
    ///
    /// In these cases, the thrown error appropriately signals invalid input.
    func withCBuffer<T>(
        _ body: (UnsafePointer<CChar>, Int) throws -> T
    ) throws -> T
    {
        return try self.withUnsafeBytes
        {
            bytes in
            
            guard let baseAddress: UnsafeRawPointer = bytes.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            return try body(
                baseAddress.assumingMemoryBound(to: CChar.self),
                bytes.count
            )
        }
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a buffer, and updates
    /// the receiver with any changes made by the closure.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    mutating func withMutatingCBuffer<T>(
        _ body: (UnsafeMutablePointer<CChar>, Int) throws -> T
    ) throws -> T
    {
        var data: Data = self
        
        let result: T = try data.withUnsafeMutableBytes
        {
            bytes in
            
            guard let baseAddress: UnsafeMutableRawPointer = bytes.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            return try body(
                baseAddress.assumingMemoryBound(to: CChar.self),
                bytes.count
            )
        }
        
        if isSuccess(result)
        {
            self = data
        }
        
        return result
    }
}



internal extension Optional where Wrapped == Data
{
    /// Calls the given closure with an optional pointer to a buffer, and the
    /// length of that buffer.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// When the receiver is `nil`, this method passes `nil` and `0` to the
    /// closure.
    ///
    /// When the receiver contains data, this method will call the
    /// ``Data/withCBuffer(_:)`` method of the wrapped value.
    ///
    /// - Note: See ``Data/withCBuffer(_:)`` for more information on when
    /// to check for empty data before calling this method.
    func withOptionalCBuffer<T>(
        _ body: (UnsafePointer<CChar>?, Int) throws -> T
    ) throws -> T
    {
        switch self
        {
            case .none:
                
                return try body(nil, 0)
                
            case .some(let wrapped):
                
                return try wrapped.withCBuffer(body)
        }
    }
}
