//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The details of an error.
///
/// ## C Equivalent
///
/// [`git_error`](https://libgit2.org/docs/reference/main/errors/git_error.html)
public struct GitError: CStructReadable, WithCConvertible, Sendable
{
    /// The error message.
    public let message  : String?
    
    /// The category of the error.
    public let klass    : GitErrorT
    
    
    
    /// Initializes a ``GitError`` instance from the given `git_error` instance.
    /// - Parameter error: The `git_error` instance to use.
    internal init(
        cValue error: git_error
    )
    {
        self.message    = String(optionalCString: error.message)
        self.klass      = GitErrorT(rawValue: error.klass)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_error`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_error>) throws -> T
    ) throws -> T
    {
        var error = git_error()
        
        error.klass = klass.rawValue
        
        return try message.withOptionalMutableCString
        {
            cMessage in
            
            error.message = cMessage
            
            return try body(&error)
        }
    }
}
