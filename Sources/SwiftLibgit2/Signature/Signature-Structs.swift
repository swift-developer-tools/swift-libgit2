//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A signature for commits, tags, and other actions.
///
/// ## C Equivalent
///
/// [`git_signature`](https://libgit2.org/docs/reference/main/signature/git_signature.html)
public struct GitSignature: CFreeable, CStructInternalMutable, WithCConvertible, Sendable
{
    /// The full name of the actor.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty string.
    ///
    /// - Note: Angle brackets (`<` and `>`) are not allowed.
    public private(set) var name    : String = ""
    
    /// The email of the actor.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty string.
    ///
    /// - Note: Angle brackets (`<` and `>`) are not allowed.
    public private(set) var email   : String = ""
    
    /// The time when the action happened.
    ///
    /// ## Discussion
    ///
    /// The default value is a ``GitTime`` instance with the default
    /// configuration.
    public private(set) var when    : GitTime = GitTime(cValue: git_time())
    
    
    
    /// Initializes a default ``GitSignature`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitSignature`` instance from the given `git_signature`
    /// instance.
    /// - Parameter signature: The `git_signature` instance to use.
    ///
    /// ## Discussion
    ///
    /// The default values of ``name`` and ``email`` are empty strings instead
    /// of `nil` to ensure validation failures, since Git requires non-empty
    /// identity information. Generally, neither of these should ever be `nil`
    /// when initializing from a `git_signature` returned by libgit2.
    internal init(
        cValue signature: git_signature
    )
    {
        self.name   = String(optionalCString: signature.name)   ?? ""
        self.email  = String(optionalCString: signature.email)  ?? ""
        self.when   = GitTime(cValue: signature.when)
    }
    
    
    
    /// Frees the memory allocated for the C value.
    /// - Parameter pointer: The pointer to the memory to free.
    internal static func freeCValue(
        _ pointer: P
    )
    {
        gitSignatureFree(sig: pointer)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_signature`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_signature>) throws -> T
    ) throws -> T
    {
        var signature = git_signature()
        
        signature.when = when.cValue()
        
        return try name.withMutableCString
        {
            cName in
            
            signature.name = cName
            
            return try email.withMutableCString
            {
                cEmail in
                
                signature.email = cEmail
                
                return try body(&signature)
            }
        }
    }
}
