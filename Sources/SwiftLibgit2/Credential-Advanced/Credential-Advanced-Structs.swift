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
/// used by other bindings. All binding use `git_credential` instead.
///
/// ## C Equivalent
///
/// [`git_credential`](https://libgit2.org/docs/reference/main/sys/credential/git_credential.html)
public struct GitCredential: CStruct, Sendable
{
    /// The type of supported credential.
    public let credType : GitCredentialT
    
    /// Frees the memory allocated for the given `git_credential` instance.
    public let free     : GitCredential.Free?
    
    
    
    /// Initializes a ``GitCredential`` instance from the given
    /// `git_credential` instance.
    /// - Parameter credential: The `git_credential` instance to use.
    internal init(
        cValue credential: git_credential
    )
    {
        self.credType   = GitCredentialT(rawValue: credential.credtype.rawValue)
        self.free       = credential.free
    }
    
    
    
    /// The callback invoked to free the memory allocated for the given
    /// `git_credential` instance.
    /// - Parameter cred: The credential to free.
    public typealias Free = @convention(c)
    (
        UnsafeMutablePointer<git_credential>?
    ) -> Void
}



/// A plaintext username and password credential.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_credential_userpass_plaintext`
/// instead.
///
/// ## C Equivalent
///
/// [`git_credential_userpass_plaintext`](https://libgit2.org/docs/reference/main/sys/credential/git_credential_userpass_plaintext.html)
public struct GitCredentialUserPassPlaintext: CStruct, Sendable
{
    /// The parent of the credential.
    public let parent   : GitCredential
    
    /// The username of the credential.
    public let username : String?
    
    /// The password of the credential.
    public let password : String?
    
    
    
    /// Initializes a ``GitCredentialUserPassPlaintext`` instance from the
    /// given `git_credential_userpass_plaintext` instance.
    /// - Parameter credentialUserpassPlaintext: The
    /// `git_credential_userpass_plaintext` instance to use.
    internal init(
        cValue credentialUserpassPlaintext: git_credential_userpass_plaintext
    )
    {
        self.parent     = GitCredential(cValue: credentialUserpassPlaintext.parent)
        self.username   = String(optionalCString: credentialUserpassPlaintext.username)
        self.password   = String(optionalCString: credentialUserpassPlaintext.password)
    }
}



/// A username-only credential.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_credential_username` instead.
///
/// ## C Equivalent
///
/// [`git_credential_username`](https://libgit2.org/docs/reference/main/sys/credential/git_credential_username.html)
public struct GitCredentialUsername: CStruct, Sendable
{
    /// The parent of the credential.
    public let parent   : GitCredential
    
    /// The username of the credential.
    public let username : CChar
    
    
    
    /// Initializes a ``GitCredentialUsername`` instance from the
    /// given `git_credential_username` instance.
    /// - Parameter credentialUsername: The `git_credential_username` instance
    /// to use.
    internal init(
        cValue credentialUsername: git_credential_username
    )
    {
        self.parent     = GitCredential(cValue: credentialUsername.parent)
        self.username   = credentialUsername.username
    }
}



/// An on-disk SSH key.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_credential_ssh_key` instead.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_key`](https://libgit2.org/docs/reference/main/sys/credential/git_credential_ssh_key.html)
public struct GitCredentialSSHKey: CStruct, Sendable
{
    /// The parent of the credential.
    public let parent       : GitCredential
    
    /// The username of the credential.
    public let username     : String?
    
    /// The path to the public key of the credential.
    public let publicKey    : String?
    
    /// The path to the private key of the credential.
    public let privateKey   : String?
    
    /// The passphrase of the credential.
    public let passphrase   : String?
    
    
    
    /// Initializes a ``GitCredentialSSHKey`` instance from the given
    /// `git_credential_ssh_key` instance.
    /// - Parameter credentialSSHKey: The `git_credential_ssh_key` instance
    /// to use.
    internal init(
        cValue credentialSSHKey: git_credential_ssh_key
    )
    {
        self.parent         = GitCredential(cValue: credentialSSHKey.parent)
        self.username       = String(optionalCString: credentialSSHKey.username)
        self.publicKey      = String(optionalCString: credentialSSHKey.publickey)
        self.privateKey     = String(optionalCString: credentialSSHKey.privatekey)
        self.passphrase     = String(optionalCString: credentialSSHKey.passphrase)
    }
}



/// An interactive SSH authenticator.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_credential_ssh_interactive`
/// instead.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_interactive`](https://libgit2.org/docs/reference/main/sys/credential/git_credential_ssh_interactive.html)
public struct GitCredentialSSHInteractive: CStruct
{
    /// The parent of the credential.
    public let parent           : GitCredential
    
    /// The username of the credential.
    public let username         : String?
    
    /// The callback invoked for interactive SSH credential prompts.
    public let promptCallback   : GitCredentialSSHInteractiveCB
    
    /// The payload passed to ``promptCallback``.
    public let payload          : UnsafeMutableRawPointer?
    
    
    
    /// Initializes a ``GitCredentialSSHInteractive`` instance from the given
    /// `git_credential_ssh_interactive` instance.
    /// - Parameter credentialSSHInteractive: The
    /// `git_credential_ssh_interactive` instance to use.
    internal init(
        cValue credentialSSHInteractive: git_credential_ssh_interactive
    )
    {
        self.parent             = GitCredential(cValue: credentialSSHInteractive.parent)
        self.username           = String(optionalCString: credentialSSHInteractive.username)
        self.promptCallback     = credentialSSHInteractive.prompt_callback
        self.payload            = credentialSSHInteractive.payload
    }
}



/// SSH credentials with a custom signature function.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_credential_ssh_custom` instead.
///
/// ## C Equivalent
///
/// [`git_credential_ssh_custom`](https://libgit2.org/docs/reference/main/sys/credential/git_credential_ssh_custom.html)
public struct GitCredentialSSHCustom: CStruct
{
    /// The parent of the credential.
    public let parent       : GitCredential
    
    /// The username of the credential.
    public let username     : String?
    
    /// The path to the public key of the credential.
    public let publicKey    : String?
    
    /// The length of ``publicKey``.
    public let publicKeyLen : Int
    
    /// The callback invoked to sign credentials.
    public let signCallback : GitCredentialSignCB
    
    /// The payload passed to ``signCallback``.
    public let payload      : UnsafeMutableRawPointer?
    
    
    
    /// Initializes a ``GitCredentialSSHCustom`` instance from the given
    /// `git_credential_ssh_custom` instance.
    /// - Parameter credentialSSHCustom: The `git_credential_ssh_custom`
    /// instance to use.
    internal init(
        cValue credentialSSHCustom: git_credential_ssh_custom
    )
    {
        self.parent         = GitCredential(cValue: credentialSSHCustom.parent)
        self.username       = String(optionalCString: credentialSSHCustom.username)
        self.publicKey      = String(optionalCString: credentialSSHCustom.publickey)
        self.publicKeyLen   = credentialSSHCustom.publickey_len
        self.signCallback   = credentialSSHCustom.sign_callback
        self.payload        = credentialSSHCustom.payload
    }
}
