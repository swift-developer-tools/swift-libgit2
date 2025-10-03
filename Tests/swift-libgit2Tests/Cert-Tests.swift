//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import XCTest
@testable import SwiftLibgit2



final class CertTests: XCTestCaseStopOnFail
{
    func testGitCert() throws
    {
        var cCert = git_cert()
        
        cCert.cert_type = GIT_CERT_X509
        
        
        
        let cert = GitCert(cValue: cCert)
        
        XCTAssertEqual(cert.certType, .gitCertX509)
        XCTAssertEqual(GitCertT(cValue: cert.cValue().cert_type), .gitCertX509)
        
        
        
        cCert.cert_type = git_cert_t(rawValue: 123)
        
        let fallbackCert = GitCert(cValue: cCert)
        
        XCTAssertEqual(fallbackCert.certType, .gitCertNone)
        XCTAssertEqual(GitCertT(cValue: fallbackCert.cValue().cert_type), .gitCertNone)
    }
    
    
    
    func testGitCertHostKey() throws
    {
        guard let hostKeyData: Data = "ssh-rsa ABCXYZHostKey".data(using: .utf8)
        else
        {
            XCTFail("The data was nil.")
            return
        }
        
        
        
        let md5Hash = Data(
        [
            0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07, 0x08,
            0x09, 0x0A, 0x0B, 0x0C, 0x0D, 0x0E, 0x0F, 0x10
        ])

        let sha1Hash = Data(
        [
            0x11, 0x12, 0x13, 0x14, 0x15, 0x16, 0x17, 0x18,
            0x19, 0x1A, 0x1B, 0x1C, 0x1D, 0x1E, 0x1F, 0x20,
            0x21, 0x22, 0x23, 0x24
        ])

        let sha256Hash = Data(
        [
            0x31, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38,
            0x39, 0x3A, 0x3B, 0x3C, 0x3D, 0x3E, 0x3F, 0x40,
            0x41, 0x42, 0x43, 0x44, 0x45, 0x46, 0x47, 0x48,
            0x49, 0x4A, 0x4B, 0x4C, 0x4D, 0x4E, 0x4F, 0x50
        ])
        
        
        
        var cParentCert = git_cert()
        
        cParentCert.cert_type = GIT_CERT_HOSTKEY_LIBSSH2
        
        
        
        var cCertHostKey = git_cert_hostkey()
        
        cCertHostKey.parent     = cParentCert
        cCertHostKey.raw_type   = GIT_CERT_SSH_RAW_TYPE_RSA
        
        cCertHostKey.type = git_cert_ssh_t(rawValue:
            GIT_CERT_SSH_MD5.rawValue
            | GIT_CERT_SSH_SHA1.rawValue
            | GIT_CERT_SSH_SHA256.rawValue
            | GIT_CERT_SSH_RAW.rawValue
        )
        
        
        
        /// Copy the hash data to the C structs.
        md5Hash.withUnsafeBytes
        {
            bytes in
            
            _ = memcpy(
                &cCertHostKey.hash_md5,
                bytes.baseAddress,
                min(bytes.count, GitCertHostKey.hashMD5Size)
            )
        }
        
        sha1Hash.withUnsafeBytes
        {
            bytes in
            
            _ = memcpy(
                &cCertHostKey.hash_sha1,
                bytes.baseAddress,
                min(bytes.count, GitCertHostKey.hashSHA1Size)
            )
        }
        
        sha256Hash.withUnsafeBytes
        {
            bytes in
            
            _ = memcpy(
                &cCertHostKey.hash_sha256,
                bytes.baseAddress,
                min(bytes.count, GitCertHostKey.hashSHA256Size)
            )
        }
        
        
        
        let expectedFlags: GitCertSSHT =
        [
            .gitCertSSHMD5,
            .gitCertSSHSHA1,
            .gitCertSSHSHA256,
            .gitCertSSHRaw
        ]
        
        hostKeyData.withUnsafeBytes
        {
            bytes in
            
            cCertHostKey.hostkey        = bytes.baseAddress?.assumingMemoryBound(to: CChar.self)
            cCertHostKey.hostkey_len    = bytes.count
            
            let certHostKey = GitCertHostKey(cValue: cCertHostKey)
            
            XCTAssertEqual(certHostKey.parent.certType, .gitCertHostKeyLibSSH2)
            XCTAssertEqual(certHostKey.type, expectedFlags)
            XCTAssertEqual(certHostKey.hashMD5, md5Hash)
            XCTAssertEqual(certHostKey.hashSHA1, sha1Hash)
            XCTAssertEqual(certHostKey.hashSHA256, sha256Hash)
            XCTAssertEqual(certHostKey.rawType, .gitCertSSHRawTypeRSA)
            XCTAssertNotNil(certHostKey.hostKey)
            XCTAssertEqual(certHostKey.hostKeyLen, hostKeyData.count)
            
            XCTAssertTrue(certHostKey.type.contains(.gitCertSSHMD5))
            XCTAssertTrue(certHostKey.type.contains(.gitCertSSHSHA1))
            XCTAssertTrue(certHostKey.type.contains(.gitCertSSHSHA256))
            XCTAssertTrue(certHostKey.type.contains(.gitCertSSHRaw))
            
            certHostKey.withCValue
            {
                cCertHostKey in
                
                XCTAssertEqual(GitCertT(cValue: cCertHostKey.pointee.parent.cert_type), .gitCertHostKeyLibSSH2)
                XCTAssertEqual(GitCertSSHT(rawValue: cCertHostKey.pointee.type.rawValue), expectedFlags)
                XCTAssertEqual(GitCertSSHRawTypeT(cValue: cCertHostKey.pointee.raw_type), .gitCertSSHRawTypeRSA)
                XCTAssertNotNil(cCertHostKey.pointee.hostkey)
                XCTAssertEqual(cCertHostKey.pointee.hostkey_len, hostKeyData.count)
                
                XCTAssertTrue(cCertHostKey.pointee.type.rawValue & GitCertSSHT.gitCertSSHMD5.rawValue != 0)
                XCTAssertTrue(cCertHostKey.pointee.type.rawValue & GitCertSSHT.gitCertSSHSHA1.rawValue != 0)
                XCTAssertTrue(cCertHostKey.pointee.type.rawValue & GitCertSSHT.gitCertSSHSHA256.rawValue != 0)
                XCTAssertTrue(cCertHostKey.pointee.type.rawValue & GitCertSSHT.gitCertSSHRaw.rawValue != 0)
            }
        }
    }
    
    
    
    func testGitCertSSHRawTypeT() throws
    {
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeUnknown.rawValue, GIT_CERT_SSH_RAW_TYPE_UNKNOWN.rawValue)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeRSA.rawValue, GIT_CERT_SSH_RAW_TYPE_RSA.rawValue)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeDSS.rawValue, GIT_CERT_SSH_RAW_TYPE_DSS.rawValue)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyECDSA256.rawValue, GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256.rawValue)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyECDSA384.rawValue, GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384.rawValue)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyECDSA521.rawValue, GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521.rawValue)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyED25519.rawValue, GIT_CERT_SSH_RAW_TYPE_KEY_ED25519.rawValue)
        
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeUnknown.cValue(), GIT_CERT_SSH_RAW_TYPE_UNKNOWN)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeRSA.cValue(), GIT_CERT_SSH_RAW_TYPE_RSA)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeDSS.cValue(), GIT_CERT_SSH_RAW_TYPE_DSS)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyECDSA256.cValue(), GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyECDSA384.cValue(), GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyECDSA521.cValue(), GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521)
        XCTAssertEqual(GitCertSSHRawTypeT.gitCertSSHRawTypeKeyED25519.cValue(), GIT_CERT_SSH_RAW_TYPE_KEY_ED25519)
        
        XCTAssertEqual(GitCertSSHRawTypeT(cValue: GIT_CERT_SSH_RAW_TYPE_UNKNOWN), .gitCertSSHRawTypeUnknown)
        XCTAssertEqual(GitCertSSHRawTypeT(cValue: GIT_CERT_SSH_RAW_TYPE_RSA), .gitCertSSHRawTypeRSA)
        XCTAssertEqual(GitCertSSHRawTypeT(cValue: GIT_CERT_SSH_RAW_TYPE_DSS), .gitCertSSHRawTypeDSS)
        XCTAssertEqual(GitCertSSHRawTypeT(cValue: GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_256), .gitCertSSHRawTypeKeyECDSA256)
        XCTAssertEqual(GitCertSSHRawTypeT(cValue: GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_384), .gitCertSSHRawTypeKeyECDSA384)
        XCTAssertEqual(GitCertSSHRawTypeT(cValue: GIT_CERT_SSH_RAW_TYPE_KEY_ECDSA_521), .gitCertSSHRawTypeKeyECDSA521)
        XCTAssertEqual(GitCertSSHRawTypeT(cValue: GIT_CERT_SSH_RAW_TYPE_KEY_ED25519), .gitCertSSHRawTypeKeyED25519)
    }
    
    
    
    func testGitCertSSHT() throws
    {
        XCTAssertEqual(GitCertSSHT.gitCertSSHMD5.rawValue, GIT_CERT_SSH_MD5.rawValue)
        XCTAssertEqual(GitCertSSHT.gitCertSSHSHA1.rawValue, GIT_CERT_SSH_SHA1.rawValue)
        XCTAssertEqual(GitCertSSHT.gitCertSSHSHA256.rawValue, GIT_CERT_SSH_SHA256.rawValue)
        XCTAssertEqual(GitCertSSHT.gitCertSSHRaw.rawValue, GIT_CERT_SSH_RAW.rawValue)
        
        XCTAssertEqual(GitCertSSHT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitCertSSHT.gitCertSSHMD5.cValue(), GIT_CERT_SSH_MD5)
        XCTAssertEqual(GitCertSSHT.gitCertSSHSHA1.cValue(), GIT_CERT_SSH_SHA1)
        XCTAssertEqual(GitCertSSHT.gitCertSSHSHA256.cValue(), GIT_CERT_SSH_SHA256)
        XCTAssertEqual(GitCertSSHT.gitCertSSHRaw.cValue(), GIT_CERT_SSH_RAW)
        
        
        
        let flags: GitCertSSHT =
        [
            .gitCertSSHMD5,
            .gitCertSSHSHA1
        ]
        
        XCTAssertTrue(flags.contains(.gitCertSSHMD5))
        XCTAssertTrue(flags.contains(.gitCertSSHSHA1))
        XCTAssertFalse(flags.contains(.gitCertSSHSHA256))
        XCTAssertFalse(flags.contains(.gitCertSSHRaw))
        
        
        
        let emptyFlags = GitCertSSHT(rawValue: 0)
        
        XCTAssertFalse(emptyFlags.contains(.gitCertSSHMD5))
        
        
        
        let allFlags: GitCertSSHT =
        [
            .gitCertSSHMD5,
            .gitCertSSHSHA1,
            .gitCertSSHSHA256,
            .gitCertSSHRaw
        ]
        
        XCTAssertTrue(allFlags.contains(.gitCertSSHMD5))
        XCTAssertTrue(allFlags.contains(.gitCertSSHSHA1))
        XCTAssertTrue(allFlags.contains(.gitCertSSHSHA256))
        XCTAssertTrue(allFlags.contains(.gitCertSSHRaw))
    }
    
    
    
    func testGitCertT() throws
    {
        XCTAssertEqual(GitCertT.gitCertNone.rawValue, GIT_CERT_NONE.rawValue)
        XCTAssertEqual(GitCertT.gitCertX509.rawValue, GIT_CERT_X509.rawValue)
        XCTAssertEqual(GitCertT.gitCertHostKeyLibSSH2.rawValue, GIT_CERT_HOSTKEY_LIBSSH2.rawValue)
        XCTAssertEqual(GitCertT.gitCertStrArray.rawValue, GIT_CERT_STRARRAY.rawValue)
        
        XCTAssertEqual(GitCertT.gitCertNone.cValue(), GIT_CERT_NONE)
        XCTAssertEqual(GitCertT.gitCertX509.cValue(), GIT_CERT_X509)
        XCTAssertEqual(GitCertT.gitCertHostKeyLibSSH2.cValue(), GIT_CERT_HOSTKEY_LIBSSH2)
        XCTAssertEqual(GitCertT.gitCertStrArray.cValue(), GIT_CERT_STRARRAY)
        
        XCTAssertEqual(GitCertT(cValue: GIT_CERT_NONE), .gitCertNone)
        XCTAssertEqual(GitCertT(cValue: GIT_CERT_X509), .gitCertX509)
        XCTAssertEqual(GitCertT(cValue: GIT_CERT_HOSTKEY_LIBSSH2), .gitCertHostKeyLibSSH2)
        XCTAssertEqual(GitCertT(cValue: GIT_CERT_STRARRAY), .gitCertStrArray)
        XCTAssertNil(GitCertT(cValue: git_cert_t(rawValue: 123)))
    }
    
    
    
    func testGitCertX509() throws
    {
        guard let data: Data = "Mock X.509 certificate data".data(using: .utf8)
        else
        {
            XCTFail("The data was nil.")
            return
        }
        
        
        
        var cParentCert = git_cert()
        
        cParentCert.cert_type = GIT_CERT_X509
        
        
        
        var cCertX509 = git_cert_x509()
        
        cCertX509.parent = cParentCert
        
        
        
        data.withUnsafeBytes
        {
            bytes in
            
            let baseAddressPointer = UnsafeMutableRawPointer(mutating: bytes.baseAddress)
            
            cCertX509.data  = baseAddressPointer
            cCertX509.len   = bytes.count
            
            let certX509 = GitCertX509(cValue: cCertX509)
            
            XCTAssertEqual(certX509.parent.certType, .gitCertX509)
            XCTAssertEqual(certX509.data, baseAddressPointer)
            XCTAssertEqual(certX509.len, data.count)
            
            XCTAssertEqual(GitCertT(cValue: certX509.cValue().parent.cert_type), .gitCertX509)
            XCTAssertEqual(certX509.cValue().data, baseAddressPointer)
            XCTAssertEqual(certX509.cValue().len, data.count)
        }
    }
    
    
    
    func testGitTransportCertificateCheckCB() throws
    {
        var cCert = git_cert()
        
        cCert.cert_type = GIT_CERT_X509
        
        
        
        let acceptCallback: GitTransportCertificateCheckCB =
        {
            _, _, _, _ in
            
            return 0
        }
        
        let rejectCallback: GitTransportCertificateCheckCB =
        {
            _, _, _, _ in
            
            return -1
        }
        
        let deferCallback: GitTransportCertificateCheckCB =
        {
            _, _, _, _ in
            
            return 1
        }
        
        
        
        let host: String = "github.com"
        
        host.withCString
        {
            cHost in
            
            let acceptCallbackResult: Int32 = acceptCallback(
                &cCert,
                1,
                cHost,
                nil
            )
            
            XCTAssertEqual(acceptCallbackResult, 0)
        }
        
        host.withCString
        {
            cHost in
            
            let rejectCallbackResult: Int32 = rejectCallback(
                &cCert,
                1,
                cHost,
                nil
            )
            
            XCTAssertEqual(rejectCallbackResult, -1)
        }
        
        host.withCString
        {
            cHost in
            
            let deferCallbackResult: Int32 = deferCallback(
                &cCert,
                1,
                cHost,
                nil
            )
            
            XCTAssertEqual(deferCallbackResult, 1)
        }
    }
}
