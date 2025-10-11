//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The base for all credential types.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. `git_credential` is treated as an opaque struct
/// since its function pointer is allocated and managed by libgit2, and cannot
/// be meaningfully recreated or translated.
///
/// ## C Equivalent
///
/// [`git_credential`](https://libgit2.org/docs/reference/main/sys/credential/git_credential.html)
public struct GitCredential: GitStruct
{
    /// The type of supported credential.
    public let credType: GitCredentialT
    
    /// The function to free a credential.
    public let free: @convention(c)
    (
        UnsafeMutablePointer<git_credential>?
    ) -> Void
    
    
    
    /// Creates a ``GitCredential`` instance from a `git_credential` instance.
    /// - Parameter credential: The `git_credential` instance to use.
    internal init(
        cValue credential: git_credential
    )
    {
        self.credType   = GitCredentialT(rawValue: credential.credtype.rawValue)
        self.free       = credential.free
    }
}
