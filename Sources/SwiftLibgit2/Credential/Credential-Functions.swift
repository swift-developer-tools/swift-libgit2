//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// Frees the memory allocated for a `git_credential`.
/// - Parameter cred: The entry to free.
///
/// ## Discussion
///
/// This function is only needed when libgit2 does not own the `git_credential` (when the caller
/// is a transport).
///
/// ## C Equivalent
///
/// [`git_credential_free()`](https://libgit2.org/docs/reference/main/credential/git_credential_free.html)
public func gitCredentialFree(
    cred: UnsafeMutablePointer<git_credential>?
)
{
    git_credential_free(cred)
}



/// Checks whether the given credential contains username information.
/// - Parameter cred: The credential to check.
///
/// ## C Equivalent
///
/// [`git_credential_has_username()`](https://libgit2.org/docs/reference/main/credential/git_credential_has_username.html)
public func gitCredentialHasUsername(
    cred: UnsafeMutablePointer<git_credential>?
) -> Bool
{
    return Bool(git_cred_has_username(cred))
}



/// Gets the username associated with the given credential.
/// - Parameter cred: The credential to check.
///
/// ## C Equivalent
///
/// [`git_credential_get_username()`](https://libgit2.org/docs/reference/main/credential/git_credential_get_username.html)
public func gitCredentialGetUsername(
    cred: UnsafeMutablePointer<git_credential>?
) -> String?
{
    return String(optionalCString: git_cred_get_username(cred))
}



/// Creates a new plaintext username and password credentials.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - password: The password of the credentials.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The credential will be internally duplicated.
///
/// ## C Equivalent
///
/// [`git_credential_get_username()`](https://libgit2.org/docs/reference/main/credential/git_credential_get_username.html)
public func gitCredentialUserPassPlaintextNew(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username    : String,
    password    : String
) -> Int32
{
    return git_credential_userpass_plaintext_new(
        out,
        username,
        password
    )
}



/// Creates a default credential usable with Negotiate mechanisms like NTLM or Kerberos authentication.
/// - Parameter out: The pointer in which to store the resulting credential.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_credential_default_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_default_new.html)
public func gitCredentialDefaultNew(
    out: UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>
) -> Int32
{
    return git_credential_default_new(out)
}



/// Creates a credential to specify a username.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_credential_username_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_username_new.html)
public func gitCredentialUsernameNew(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username    : String
) -> Int32
{
    return git_credential_username_new(
        out,
        username
    )
}



/// Creates a new SSH key credential.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - publicKey: The path to the public key of the credential.
///   - privateKey: The path to the private key of the credential.
///   - passphrase: The passphrase of the credential.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The credential will be internally duplicated.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_key_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_ssh_key_new.html)
public func gitCredentialSSHKeyNew(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username    : String,
    publicKey   : String,
    privateKey  : String,
    passphrase  : String?
) -> Int32
{
    return git_credential_ssh_key_new(
        out,
        username,
        publicKey,
        privateKey,
        passphrase
    )
}



/// Creates a new SSH key credential by reading the keys from memory.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - publicKey: The public key of the credential.
///   - privateKey: The private key of the credential.
///   - passphrase: The passphrase of the credential.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_key_memory_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_ssh_key_memory_new.html)
public func gitCredentialSSHKeyMemoryNew(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username    : String,
    publicKey   : String,
    privateKey  : String,
    passphrase  : String?
) -> Int32
{
    return git_credential_ssh_key_memory_new(
        out,
        username,
        publicKey,
        privateKey,
        passphrase
    )
}



/// Creates a new SSH keyboard-interactive credential.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - promptCallback: The callback invoked for authentication prompts.
///   - payload: The caller-specified payload passed to `promptCallback`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The credential will be internally duplicated.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_interactive_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_ssh_interactive_new.html)
public func gitCredentialSSHInteractiveNew(
    out             : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username        : String,
    promptCallback  : GitCredentialSSHInteractiveCB?,
    payload         : UnsafeMutableRawPointer?
) -> Int32
{
    return git_credential_ssh_interactive_new(
        out,
        username,
        promptCallback,
        payload
    )
}



/// Creates a new SSH key credential used for querying an SSH agent.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The credential will be internally duplicated.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_key_from_agent()`](https://libgit2.org/docs/reference/main/credential/git_credential_ssh_key_from_agent.html)
public func gitCredentialSSHKeyFromAgent(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username    : String
) -> Int32
{
    return git_credential_ssh_key_from_agent(
        out,
        username
    )
}



/// Creates an SSH key credential with a custom signing function.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - publicKey: The public key of the credential.
///   - publicKeyLen: The length of the public key of the credential.
///   - signCallback: The callback invoked to sign the data during the authentication challenge.
///   - payload: The caller-specified payload passed to `signCallback`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The credential will be internally duplicated.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_custom_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_ssh_custom_new.html)
public func gitCredentialSSHCustomNew(
    out             : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username        : String,
    publicKey       : Data,
    publicKeyLen    : Int,
    signCallback    : GitCredentialSignCB,
    payload         : UnsafeMutableRawPointer?
) -> Int32
{
    return withCConversion
    {
        return try publicKey.withUnsafeBytes
        {
            cPublicKey in
            
            guard let baseAddress: UnsafeRawPointer = cPublicKey.baseAddress
            else
            {
                throw NSError.makeCConversionError()
            }
            
            return git_credential_ssh_custom_new(
                out,
                username,
                baseAddress.assumingMemoryBound(to: CChar.self),
                cPublicKey.count,
                signCallback,
                payload
            )
        }
    }
}
