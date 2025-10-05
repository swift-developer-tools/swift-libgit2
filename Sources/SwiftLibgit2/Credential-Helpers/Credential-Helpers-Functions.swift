//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a new plaintext username and password credential.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - url: The resource for which a credential is being demanded.
///   - userFromURL: The username that is embedded in a `user@host` remote URL.
///   - allowedTypes: The allowed credential types.
///   - payload: The payload provided by the caller.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is a stock implementation of the ``GitCredentialAcquireCB`` callback, and will call
/// ``gitCredentialUserPassPlaintextNew(out:username:password:)``, unless
/// ``GitCredentialT/gitCredentialUserPassPlaintext`` is not an allowed type.
///
/// ## C Equivalent
///
/// [`git_credential_userpass()`](https://libgit2.org/docs/reference/main/credential_helpers/git_credential_userpass.html)
public func gitCredentialUserPass(
    out             : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    url             : String,
    userFromURL     : String?,
    allowedTypes    : GitCredentialT,
    payload         : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_userpass(
            out,
            url,
            userFromURL,
            allowedTypes.rawValue,
            payload
        )
    }
}
