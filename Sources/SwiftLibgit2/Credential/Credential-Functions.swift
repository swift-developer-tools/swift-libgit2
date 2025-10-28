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



/// Frees the memory allocated for the given `git_credential` instance.
/// - Parameter cred: The entry to free.
///
/// ## Discussion
///
/// - Important: This function is only needed when libgit2 does not own the
/// `git_credential` (when the caller is a transport).
///
/// ## C Equivalent
///
/// [`git_credential_free()`](https://libgit2.org/docs/reference/main/credential/git_credential_free.html)
public func gitCredentialFree(
    cred: UnsafeMutablePointer<git_credential>?
)
{
    guard let cred: UnsafeMutablePointer<git_credential> = cred
    else
    {
        return
    }
    
    git_credential_free(cred)
}



/// Checks whether the given credential contains username information.
/// - Parameter cred: The credential to check.
/// - Returns: Whether the given credential contains username information.
///
/// ## C Equivalent
///
/// [`git_credential_has_username()`](https://libgit2.org/docs/reference/main/credential/git_credential_has_username.html)
public func gitCredentialHasUsername(
    cred: UnsafeMutablePointer<git_credential>?
) -> Bool
{
    let hasUsername: Int32 = git_cred_has_username(cred)
    
    return Bool(hasUsername)
}



/// Gets the username associated with the given credential.
/// - Parameter cred: The credential to check.
/// - Returns: The username associated with the given credential.
///
/// ## C Equivalent
///
/// [`git_credential_get_username()`](https://libgit2.org/docs/reference/main/credential/git_credential_get_username.html)
public func gitCredentialGetUsername(
    cred: UnsafeMutablePointer<git_credential>?
) -> String?
{
    let credentialUsername: UnsafePointer<CChar>? = git_cred_get_username(cred)
    
    return String(optionalCString: credentialUsername)
}



/// Creates a new plaintext username and password credentials.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - password: The password of the credentials.
/// - Returns: A ``GitErrorCode`` instance.
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
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_userpass_plaintext_new(
            out,
            username,
            password
        )
    }
}



/// Creates a default credential usable with Negotiate mechanisms like NTLM or
/// Kerberos authentication.
/// - Parameter out: The pointer in which to store the resulting credential.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_credential_default_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_default_new.html)
public func gitCredentialDefaultNew(
    out: UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_default_new(out)
    }
}



/// Creates a credential to specify a username.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_credential_username_new()`](https://libgit2.org/docs/reference/main/credential/git_credential_username_new.html)
public func gitCredentialUsernameNew(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>,
    username    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_username_new(
            out,
            username
        )
    }
}



/// Creates a new SSH key credential.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - publicKey: The path to the public key of the credential.
///   - privateKey: The path to the private key of the credential.
///   - passphrase: The passphrase of the credential.
/// - Returns: A ``GitErrorCode`` instance.
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
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_ssh_key_new(
            out,
            username,
            publicKey,
            privateKey,
            passphrase
        )
    }
}



/// Creates a new SSH key credential by reading the keys from memory.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - publicKey: The public key of the credential.
///   - privateKey: The private key of the credential.
///   - passphrase: The passphrase of the credential.
/// - Returns: A ``GitErrorCode`` instance.
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
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_ssh_key_memory_new(
            out,
            username,
            publicKey,
            privateKey,
            passphrase
        )
    }
}



/// Creates a new SSH keyboard-interactive credential.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - promptCallback: The ``GitCredentialSSHInteractiveCB`` callback to
///   invoke for interactive SSH credential prompts.
///   - payload: The payload to pass to `promptCallback`.
/// - Returns: A ``GitErrorCode`` instance.
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
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_ssh_interactive_new(
            out,
            username,
            promptCallback,
            payload
        )
    }
}



/// Creates a new SSH key credential used for querying an SSH agent.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
/// - Returns: A ``GitErrorCode`` instance.
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
) -> GitErrorCode
{
    return withCConversion
    {
        return git_credential_ssh_key_from_agent(
            out,
            username
        )
    }
}



/// Creates an SSH key credential with a custom signing function.
/// - Parameters:
///   - out: The pointer in which to store the resulting credential.
///   - username: The username of the credential.
///   - publicKey: The public key of the credential.
///   - publicKeyLen: The length of `publicKey`.
///   - signCallback: The ``GitCredentialSignCB`` callback to invoke to
///   sign credentials.
///   - payload: The payload to pass to `signCallback`.
/// - Returns: A ``GitErrorCode`` instance.
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
) -> GitErrorCode
{
    return withCConversion
    {
        guard !publicKey.isEmpty
        else
        {
            return git_credential_ssh_custom_new(
                out,
                username,
                nil,
                0,
                signCallback,
                payload
            )
        }
        
        
        
        /// If `publicKey` is not null-terminated, append a null terminator.
        /// This is necessary due to a bug in libgit2's `ssh_custom_free()`
        /// function. The code flow of the bug is as follows:
        ///
        /// 1. `git_credential_ssh_custom_new()` is a wrapper around the
        /// undocumented `libssh2_userauth_publickey()` function.
        ///
        /// 2. The libssh2 function accepts `const unsigned char *pubkeydata`
        /// and `size_t pubkeydata_len`, which strongly indicate that it is
        /// not a null-terminated string.
        ///
        /// 3. `git_credential_ssh_custom_new()` allocates and copies the
        /// given binary data, then assigns `ssh_custom_free()` to
        /// `git_credential_ssh_custom->parent.free`.
        ///
        /// 4. `ssh_custom_free()` treats the public key as null-terminated by
        /// assigning `size_t key_len strlen(c->publickey)` before calling
        /// `git__memzero(c->publickey, key_len)` and `git__free(c->publickey)`,
        /// where `c` is a `git_credential_ssh_custom` instance.
        ///
        /// This causes a heap buffer overflow when freeing a public key that
        /// is not null-terminated. The overflow was detected by Apple's
        /// Address Sanitizer.
        ///
        /// Instead, `ssh_custom_free()` should use the stored length property
        /// and assign `size_t key_len c->publickey_len`. As long as libgit2
        /// is treating the public key as a null-terminated string, the given
        /// public key must be adjusted to avoid a heap buffer overflow.
        var nullTerminatedPublicKey: Data = publicKey
        
        if
            let lastByte: UInt8 = nullTerminatedPublicKey.last,
            lastByte != 0
        {
            nullTerminatedPublicKey.append(0)
        }
        
        return try nullTerminatedPublicKey.withCBuffer
        {
            cPublicKey, cPublicKeyCount in
            
            return git_credential_ssh_custom_new(
                out,
                username,
                cPublicKey,
                cPublicKeyCount,
                signCallback,
                payload
            )
        }
    }
}
