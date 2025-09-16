//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// An action signature commits, tags, and other signable operations.
///
/// ## C Equivalent
///
/// [`git_signature`](https://libgit2.org/docs/reference/main/signature/git_signature.html)
public struct GitSignature
{
    /// The full name of the author.
    let name    : String
    
    /// The email of the author.
    let email   : String
    
    /// The time when the action happened.
    let when    : GitTime
    
    
    
    /// Creates a ``GitSignature`` instance from a `git_signature` instance.
    /// - Parameter signature: The `git_signature` instance to use.
    internal init(
        cValue signature: git_signature
    )
    {
        self.name   = String(cString: signature.name)
        self.email  = String(cString: signature.email)
        self.when   = GitTime(cValue: signature.when)
    }
}
