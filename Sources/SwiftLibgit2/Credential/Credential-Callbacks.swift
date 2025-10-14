//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback for credential acquisition.
/// - Parameters:
///   - out: The pointer in which to store the acquired credential.
///   - url: The resource for which a credential is being demanded.
///   - usernameFromURL: The username that is embedded in a `user@host` remote
///   URL.
///   - allowedTypes: The allowed credential types. See ``GitCredentialT``.
///   - payload: The payload provided by the caller.
/// - Returns: A negative value if an error occurred, a positive value if no
/// credential was acquired, or `0` on success.
///
/// ## Discussion
///
/// This callback is usually involved any time another system might need
/// authentication. A valid `git_credential` object must be provided, depending
/// on `allowedTypes`.
///
/// - Important: Most authentication details are the caller's responsibility.
/// This callback will be called repeatedly until the authentication succeeds
/// or an error is reported. Take care to stop providing the same incorrect
/// credentials, otherwise it is easy to fall into an infinite loop.
///
/// ## C Equivalent
///
/// [`git_credential_acquire_cb()`](https://libgit2.org/docs/reference/main/credential/git_credential_acquire_cb.html)
public typealias GitCredentialAcquireCB = @convention(c)
(
    UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>?,
    UnsafePointer<CChar>?,
    UnsafePointer<CChar>?,
    UInt32,
    UnsafeMutableRawPointer?
) -> Int32



/// The callback for interactive SSH credentials.
/// - Parameters:
///   - name: The name of the authentication instruction.
///   - nameLen: The length of the authentication instruction.
///   - instruction: The authentication instruction.
///   - instructionLen: The length of the authentication instruction.
///   - numPrompts: The number of authentication prompts.
///   - prompts: The authentication prompts. The underlying type must be
///   `LIBSSH2_USERAUTH_KBDINT_PROMPT`.
///   - responses: The authentication responses. The underlying type must be
///   `LIBSSH2_USERAUTH_KBDINT_RESPONSE`.
///   - abstract: The libssh2 abstract authentication state.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_interactive_cb()`](https://libgit2.org/docs/reference/main/credential/git_credential_ssh_interactive_cb.html)
public typealias GitCredentialSSHInteractiveCB = @convention(c)
(
    UnsafePointer<CChar>?,
    Int32,
    UnsafePointer<CChar>?,
    Int32,
    Int32,
    OpaquePointer?,
    OpaquePointer?,
    UnsafeMutablePointer<UnsafeMutableRawPointer?>?
) -> Void



/// The callback for credential signing.
/// - Parameters:
///   - session: The libssh2 session. The underlying type must be
///   `LIBSSH_SESSION`.
///   - sig: The signature.
///   - sigLen: The length of the signature.
///   - data: The credential data.
///   - dataLen: The length of the credential data.
///   - abstract: The libssh2 abstract authentication state.
/// - Returns: A negative value if an error occurred, a positive value if no
/// credential was acquired, or `0` on success.
///
/// ## C Equivalent
///
/// [`git_credential_sign_cb()`](https://libgit2.org/docs/reference/main/credential/git_credential_sign_cb.html)
public typealias GitCredentialSignCB = @convention(c)
(
    OpaquePointer?,
    UnsafeMutablePointer<UnsafeMutablePointer<UInt8>?>?,
    UnsafeMutablePointer<Int>?,
    UnsafePointer<UInt8>?,
    Int,
    UnsafeMutablePointer<UnsafeMutableRawPointer?>?
) -> Int32
