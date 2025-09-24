//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The type of host certificate passed to ``GitTransportCertificateCheckCB``.
///
/// ## C Equivalent
///
/// [`git_cert_t`](https://libgit2.org/docs/reference/main/cert/git_cert_t.html)
public enum GitCertT: UInt32, GitEnum
{
    /// No information about the certificate is available.
    ///
    /// ## Discussion
    ///
    /// This value may be encountered when using Curl.
    case gitCertNone            = 0
    
    /// The callback's certificate parameter will be a ``GitCertX509`` instance containing
    /// DER-encoded data.
    case gitCertX509            = 1
    
    /// The callback's certificate parameter will be a ``GitCertHostKey`` instance.
    case gitCertHostKeyLibSSH2  = 2
    
    /// The callback's certificate parameter will contain a `git_strarray` with `name:content`
    /// strings.
    ///
    /// ## Discussion
    ///
    /// This value may be encountered when using Curl.
    case gitCertStrArray        = 3
    
    
    
    /// Creates a ``GitCertT`` instance from a `git_cert_t` instance.
    /// - Parameter cert: The `git_cert_t` instance to use.
    internal init?(
        cValue cert: git_cert_t
    )
    {
        switch cert
        {
            case GIT_CERT_NONE              : self = .gitCertNone
            case GIT_CERT_X509              : self = .gitCertX509
            case GIT_CERT_HOSTKEY_LIBSSH2   : self = .gitCertHostKeyLibSSH2
            case GIT_CERT_STRARRAY          : self = .gitCertStrArray
            default                         : return nil
        }
    }
    
    
    
    /// The equivalent C value.
    internal var cValue: git_cert_t
    {
        switch self
        {
            case .gitCertNone           : return GIT_CERT_NONE
            case .gitCertX509           : return GIT_CERT_X509
            case .gitCertHostKeyLibSSH2 : return GIT_CERT_HOSTKEY_LIBSSH2
            case .gitCertStrArray       : return GIT_CERT_STRARRAY
        }
    }
}



/// The type of SSH host fingerprint.
///
/// ## C Equivalent
///
/// [`git_cert_ssh_t`](https://libgit2.org/docs/reference/main/cert/git_cert_ssh_t.html)
public struct GitCertSSHT: GitOptionSet
{
    /// The raw value to use.
    public let rawValue: UInt32
    
    /// Creates a ``GitCertSSHT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    public init(
        rawValue: UInt32
    )
    {
        self.rawValue = rawValue
    }
    
    
    
    /// MD5 is available.
    public static let gitCertSSHMD5     = GitCertSSHT(rawValue: GIT_CERT_SSH_MD5.rawValue)
    
    /// SHA-1 is available.
    public static let gitCertSSHSHA1    = GitCertSSHT(rawValue: GIT_CERT_SSH_SHA1.rawValue)
    
    /// SHA-256 is available.
    public static let gitCertSSHSHA256  = GitCertSSHT(rawValue: GIT_CERT_SSH_SHA256.rawValue)
    
    /// The raw host key is available.
    public static let gitCertSSHRaw     = GitCertSSHT(rawValue: GIT_CERT_SSH_RAW.rawValue)
    
    
    
    /// The equivalent C value.
    internal var cValue: git_cert_ssh_t
    {
        return git_cert_ssh_t(rawValue)
    }
}



/// The type of raw host key.
///
/// ## C Equivalent
///
/// [`git_cert_ssh_raw_type_t`](https://libgit2.org/docs/reference/main/cert/git_cert_ssh_raw_type_t.html)
public enum GitCertSSHRawTypeT: UInt32, GitEnum
{
    /// The raw host key type is unknown.
    case gitCertSSHRawTypeUnknown       = 0
    
    /// The raw host key is an RSA key.
    case gitCertSSHRawTypeRSA           = 1
    
    /// The raw host key is a DSS key.
    case gitCertSSHRawTypeDSS           = 2
    
    /// The raw host key is an ECDSA-256 key.
    case gitCertSSHRawTypeKeyECDSA256   = 3
    
    /// The raw host key is an ECDSA-384 key.
    case gitCertSSHRawTypeKeyECDSA384   = 4
    
    /// The raw host key is an ECDSA-521 key.
    case gitCertSSHRawTypeKeyECDSA521   = 5
    
    /// The raw host key is an Ed25519 key.
    case gitCertSSHRawTypeKeyED25519    = 6
    
    
    
    /// Creates a ``GitCertSSHRawTypeT`` instance from a `git_cert_ssh_raw_type_t`
    /// instance.
    /// - Parameter certSSHRawType: The `git_cert_ssh_raw_type_t` instance to use.
    internal init?(
        cValue certSSHRawType: git_cert_ssh_raw_type_t
    )
    {
        switch certSSHRawType
        {
            case GIT_CERT_SSH_RAW_TYPE_UNKNOWN          : self = .gitCertSSHRawTypeUnknown
            case GIT_CERT_SSH_RAW_TYPE_RSA              : self = .gitCertSSHRawTypeRSA
            case GIT_CERT_SSH_RAW_TYPE_DSS              : self = .gitCertSSHRawTypeDSS
            case GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256    : self = .gitCertSSHRawTypeKeyECDSA256
            case GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384    : self = .gitCertSSHRawTypeKeyECDSA384
            case GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521    : self = .gitCertSSHRawTypeKeyECDSA521
            case GIT_CERT_SSH_RAW_TYPE_KEY_ED25519      : self = .gitCertSSHRawTypeKeyED25519
            default                                     : return nil
        }
    }
    
    
    
    /// The equivalent C value.
    internal var cValue: git_cert_ssh_raw_type_t
    {
        switch self
        {
            case .gitCertSSHRawTypeUnknown      : return GIT_CERT_SSH_RAW_TYPE_UNKNOWN
            case .gitCertSSHRawTypeRSA          : return GIT_CERT_SSH_RAW_TYPE_RSA
            case .gitCertSSHRawTypeDSS          : return GIT_CERT_SSH_RAW_TYPE_DSS
            case .gitCertSSHRawTypeKeyECDSA256  : return GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256
            case .gitCertSSHRawTypeKeyECDSA384  : return GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384
            case .gitCertSSHRawTypeKeyECDSA521  : return GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521
            case .gitCertSSHRawTypeKeyED25519   : return GIT_CERT_SSH_RAW_TYPE_KEY_ED25519
        }
    }
}
