//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The payload for plaintext username/password authentication.
///
/// ## Discussion
///
/// This struct is provided for documentation purposes, but is not used by other bindings.
///
/// All bindings use
/// [`UnsafeMutableRawPointer`](https://developer.apple.com/documentation/swift/unsafemutablerawpointer)
/// payloads.
///
/// ## C Equivalent
///
/// [`git_credential_userpass_payload`](https://libgit2.org/docs/reference/main/credential_helpers/git_credential_userpass_payload.html)
public struct GitCredentialUserPassPayload: GitStruct
{
    /// The username of the credential.
    public let username : String
    
    /// The password of the credential.
    public let password : String

    
    
    /// Creates a ``GitCredentialUserPassPayload`` instance from a
    /// `git_credential_userpass_payload` instance.
    /// - Parameter payload: The `git_credential_userpass_payload` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``username`` and ``password`` default to empty strings if unexpected values are
    /// encountered, although this should never occur.
    internal init(
        cValue payload: git_credential_userpass_payload
    )
    {
        self.username   = String(optionalCString: payload.username) ?? ""
        self.password   = String(optionalCString: payload.password) ?? ""
    }
}
