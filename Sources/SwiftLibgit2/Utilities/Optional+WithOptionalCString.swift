//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

internal extension Optional where Wrapped == String
{
    /// Calls the given closure with an optional pointer to the contents of
    /// the string.
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
    
    
    
    /// Calls the given closure with an optional mutable pointer to the
    /// contents of the string.
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
}
