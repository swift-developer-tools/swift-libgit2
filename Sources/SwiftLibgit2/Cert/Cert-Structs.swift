//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import Foundation



/// The parent type for ``GitCertHostKey`` and ``GitCertX509``.
///
/// ## C Equivalent
///
/// [`git_cert`](https://libgit2.org/docs/reference/main/cert/git_cert.html)
public struct GitCert: GitStructReadOnly
{
    /// The type of host certificate.
    public let certType: GitCertT
    
    
    
    /// Creates a ``GitCert`` instance from a `git_cert` instance.
    /// - Parameter cert: The `git_cert` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``certType`` defaults to ``GitCertT/gitCertNone`` if an unexpected
    /// value is encountered, although this should never occur.
    internal init(
        cValue cert: git_cert
    )
    {
        self.certType = GitCertT(cValue: cert.cert_type) ?? .gitCertNone
    }
    
    
    
    /// The equivalent C value.
    internal var cValue: git_cert
    {
        var cert = git_cert()
        
        cert.cert_type = certType.cValue
        
        return cert
    }
}



/// Host key information from libssh2.
///
/// ## C Equivalent
///
/// [`git_cert_hostkey`](https://libgit2.org/docs/reference/main/cert/git_cert_hostkey.html)
public struct GitCertHostKey: GitStructReadOnly
{
    /// The parent certificate.
    public let parent       : GitCert
    
    /// The type of SSH host fingerprint.
    public let type         : GitCertSSHT
    
    /// The MD5 hash of the host key.
    ///
    /// ## Discussion
    ///
    /// This will represent the MD5 hash of the host key if ``GitCertHostKey/type``
    /// contains ``GitCertSSHT/gitCertSSHMD5``.
    public let hashMD5      : Data
    
    /// The SHA-1 hash of the host key.
    ///
    /// ## Discussion
    ///
    /// This will represent the SHA-1 hash of the host key if ``GitCertHostKey/type``
    /// contains ``GitCertSSHT/gitCertSSHSHA1``.
    public let hashSHA1     : Data
    
    /// The SHA-256 hash of the host key.
    ///
    /// ## Discussion
    ///
    /// This will represent the SHA-256 hash of the host key if ``GitCertHostKey/type``
    /// contains ``GitCertSSHT/gitCertSSHSHA256``.
    public let hashSHA256   : Data
    
    /// The type of the raw host key.
    ///
    /// ## Discussion
    ///
    /// This will represent the type of the raw host key if ``GitCertHostKey/type``
    /// contains ``GitCertSSHT/gitCertSSHRaw``.
    public let rawType      : GitCertSSHRawTypeT
    
    /// The content of the raw host key.
    ///
    /// ## Discussion
    ///
    /// This will represent the content of the raw host key if ``GitCertHostKey/type``
    /// contains ``GitCertSSHT/gitCertSSHRaw``.
    public let hostKey      : Data?
    
    /// The content length of the raw host key.
    ///
    /// ## Discussion
    ///
    /// This will represent the content length of the raw host key if ``GitCertHostKey/type``
    /// contains ``GitCertSSHT/gitCertSSHRaw``.
    public let hostKeyLen   : Int
    
    
    
    /// The size of ``hashMD5`` in bytes.
    internal static let hashMD5Size     : Int   = 16
    
    /// The size of ``hashSHA1`` in bytes.
    internal static let hashSHA1Size    : Int   = 20
    
    /// The size of ``hashSHA256`` in bytes.
    internal static let hashSHA256Size  : Int   = 32
    
    
    
    /// Creates a ``GitCertHostKey`` instance from a `git_cert_hostkey` instance.
    /// - Parameter certHostKey: The `git_cert_hostkey` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``GitCertHostKey/rawType`` defaults to
    /// ``GitCertSSHRawTypeT/gitCertSSHRawTypeUnknown`` if an unexpected value is
    /// encountered, although this should never occur.
    internal init(
        cValue certHostKey: git_cert_hostkey
    )
    {
        var certHostKeyCopy: git_cert_hostkey = certHostKey
        
        self.parent         = GitCert(cValue: certHostKey.parent)
        self.type           = GitCertSSHT(rawValue: certHostKey.type.rawValue)
        self.hashMD5        = Data(bytes: &certHostKeyCopy.hash_md5, count: Self.hashMD5Size)
        self.hashSHA1       = Data(bytes: &certHostKeyCopy.hash_sha1, count: Self.hashSHA1Size)
        self.hashSHA256     = Data(bytes: &certHostKeyCopy.hash_sha256, count: Self.hashSHA256Size)
        self.rawType        = GitCertSSHRawTypeT(cValue: certHostKey.raw_type) ?? .gitCertSSHRawTypeUnknown
        self.hostKey        = certHostKey.hostkey.map { Data(bytes: $0, count: certHostKey.hostkey_len) }
        self.hostKeyLen     = certHostKey.hostkey_len
    }
    
    
    
    // TODO: cValue or withCValue(_:)
}



/// X.509 certificate information.
///
/// ## C Equivalent
///
/// [`git_cert_x509`](https://libgit2.org/docs/reference/main/cert/git_cert_x509.html)
public struct GitCertX509: GitStructReadOnly
{
    /// The parent certificate.
    public let parent   : GitCert
    
    /// The X.509 certificate data.
    public let data     : UnsafeMutableRawPointer?
    
    /// The length of the memory block pointed to by ``GitCertX509/data``.
    public let len      : Int
    
    
    
    /// Creates a ``GitCertX509`` instance from a `git_cert_x509` instance.
    /// - Parameter certX509: The `git_cert_x509` instance to use.
    internal init(
        cValue certX509: git_cert_x509
    )
    {
        self.parent     = GitCert(cValue: certX509.parent)
        self.data       = certX509.data
        self.len        = certX509.len
    }
    
    
    
    // TODO: cValue or withCValue(_:)
}
