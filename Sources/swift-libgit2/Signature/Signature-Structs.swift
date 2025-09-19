//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// A signature for commits, tags, and other actions.
///
/// ## C Equivalent
///
/// [`git_signature`](https://libgit2.org/docs/reference/main/signature/git_signature.html)
public struct GitSignature
{
    /// The full name of the actor.
    ///
    /// ## Discussion
    ///
    /// Angle brackets (`<` and `>`) are not allowed.
    public private(set) var name    : String
    
    /// The email of the actor.
    ///
    /// ## Discussion
    ///
    /// Angle brackets (`<` and `>`) are not allowed.
    public private(set) var email   : String
    
    /// The time when the action happened.
    public private(set) var when    : GitTime
    
    
    
    /// Creates a ``GitSignature`` instance.
    public init()
    {
        /// Direct initialization with `self.init(cValue: git_signature())` is not used
        /// since the unitialized C struct contains `nil` pointers for the `name` and `email` fields.
        self.name   = ""
        self.email  = ""
        self.when   = GitTime(cValue: git_time())
    }
    
    
    
    /// Creates a ``GitSignature`` instance from a `git_signature` instance.
    /// - Parameter signature: The `git_signature` instance to use.
    internal init(
        cValue signature: git_signature
    )
    {
        /// Use empty strings for `nil` pointers to ensure validation failures, since Git requires
        /// non-empty identity information. Generally, neither of these should ever be `nil`.
        self.name   = String(optionalCString: signature.name)   ?? ""
        self.email  = String(optionalCString: signature.email)  ?? ""
        self.when   = GitTime(cValue: signature.when)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_signature` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this function when working with C APIs that work with existing signatures and expect
    /// `const git_signature *` parameters.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_signature>) -> T
    ) -> T
    {
        var signature = git_signature()
        
        signature.when = when.cValue
        
        return name.withMutableCString
        {
            cName in
            
            signature.name = cName
            
            return email.withMutableCString
            {
                cEmail in
                
                signature.email = cEmail
                
                return body(&signature)
            }
        }
    }
    
    
    
    /// Calls the given closure with a pointer to a pointer to a `git_signature` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// Use this function when working with C APIs that allocate a new signature and expect
    /// `git_signature **` parameters.
    internal mutating func withMutatingCValue<T>(
        _ body: (UnsafeMutablePointer<UnsafeMutablePointer<git_signature>?>) -> T
    ) -> T
    {
        var signaturePointer: UnsafeMutablePointer<git_signature>? = nil
        
        defer
        {
            if signaturePointer != nil
            {
                gitSignatureFree(sig: signaturePointer)
            }
        }
        
        
        
        let result: T = body(&signaturePointer)
        
        guard let signaturePointer: UnsafeMutablePointer<git_signature> = signaturePointer
        else
        {
            return result
        }
        
        if let intResult = result as? Int32
        {
            if intResult == GIT_OK.rawValue
            {
                self = GitSignature(cValue: signaturePointer.pointee)
            }
        }
        else
        {
            self = GitSignature(cValue: signaturePointer.pointee)
        }
        
        
        
        return result
    }
}
