//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The flags controlling the allowed credential types.
///
/// ## C Equivalent
///
/// [`git_credential_t`](https://libgit2.org/docs/reference/main/credential/git_credential_t.html)
public struct GitCredentialT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitCredentialT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// A username/password authentication request.
    public static let gitCredentialUserPassPlaintext    = GitCredentialT(rawValue: GIT_CREDENTIAL_USERPASS_PLAINTEXT.rawValue)
    
    /// An SSH key-based authentication request.
    public static let gitCredentialSSHKey               = GitCredentialT(rawValue: GIT_CREDENTIAL_SSH_KEY.rawValue)
    
    /// An SSH key-based authentication request, with a custom signature.
    public static let gitCredentialSSHCustom            = GitCredentialT(rawValue: GIT_CREDENTIAL_SSH_CUSTOM.rawValue)
    
    /// An NTLM/Negotiate-based authentication request.
    public static let gitCredentialDefault              = GitCredentialT(rawValue: GIT_CREDENTIAL_DEFAULT.rawValue)
    
    /// An SSH interactive authentication request.
    public static let gitCredentialSSHInteractive       = GitCredentialT(rawValue: GIT_CREDENTIAL_SSH_INTERACTIVE.rawValue)
    
    /// A username-only authentication request.
    ///
    /// ## Discussion
    ///
    /// This is used as a pre-authentication step if the underlying transport does not know which
    /// username to use (for example, SSH with no username in its URL).
    public static let gitCredentialUsername             = GitCredentialT(rawValue: GIT_CREDENTIAL_USERNAME.rawValue)
    
    /// An SSH key-based authentication request.
    public static let gitCredentialSSHMemory            = GitCredentialT(rawValue: GIT_CREDENTIAL_SSH_MEMORY.rawValue)
    
    
    
    /// Converts the ``GitCredentialT`` instance into a `git_credential_t` instance.
    /// - Returns: The `git_credential_t` instance.
    internal func cValue() -> git_credential_t
    {
        return git_credential_t(rawValue)
    }
}
