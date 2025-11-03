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



final class TransportAdvancedTests: XCTestCaseStopOnFail
{
    func testGitFetchNegotiation() throws
    {
        let fetchNegotiation = GitFetchNegotiation(cValue: git_fetch_negotiation())
        
        XCTAssertTrue(fetchNegotiation.refs.isEmpty)
        XCTAssertEqual(fetchNegotiation.refsLen, 0)
        XCTAssertTrue(fetchNegotiation.shallowRoots.isEmpty)
        XCTAssertEqual(fetchNegotiation.shallowRootsLen, 0)
        XCTAssertEqual(fetchNegotiation.depth, 0)
        
        try fetchNegotiation.withCValue
        {
            cFetchNegotiation in
            
            let refsLen         : Int   = cFetchNegotiation.pointee.refs_len
            let shallowRootsLen : Int   = cFetchNegotiation.pointee.shallow_roots_len
            
            XCTAssertTrue(Array(cFetchNegotiation.pointee.refs, count: refsLen).isEmpty)
            XCTAssertEqual(refsLen, 0)
            XCTAssertTrue(Array(cFetchNegotiation.pointee.shallow_roots, count: shallowRootsLen).isEmpty)
            XCTAssertEqual(cFetchNegotiation.pointee.shallow_roots_len, 0)
            XCTAssertEqual(cFetchNegotiation.pointee.depth, 0)
        }
    }
    
    
    
    func testGitSmartServiceT() throws
    {
        XCTAssertEqual(GitSmartServiceT.gitServiceUploadPackLS.rawValue, GIT_SERVICE_UPLOADPACK_LS.rawValue)
        XCTAssertEqual(GitSmartServiceT.gitServiceUploadPack.rawValue, GIT_SERVICE_UPLOADPACK.rawValue)
        XCTAssertEqual(GitSmartServiceT.gitServiceReceivePackLS.rawValue, GIT_SERVICE_RECEIVEPACK_LS.rawValue)
        XCTAssertEqual(GitSmartServiceT.gitServiceReceivePack.rawValue, GIT_SERVICE_RECEIVEPACK.rawValue)
        
        XCTAssertNil(GitSmartServiceT(rawValue: 123))
        
        XCTAssertEqual(GitSmartServiceT.gitServiceUploadPackLS.cValue(), GIT_SERVICE_UPLOADPACK_LS)
        XCTAssertEqual(GitSmartServiceT.gitServiceUploadPack.cValue(), GIT_SERVICE_UPLOADPACK)
        XCTAssertEqual(GitSmartServiceT.gitServiceReceivePackLS.cValue(), GIT_SERVICE_RECEIVEPACK_LS)
        XCTAssertEqual(GitSmartServiceT.gitServiceReceivePack.cValue(), GIT_SERVICE_RECEIVEPACK)
        
        XCTAssertEqual(GitSmartServiceT(cValue: GIT_SERVICE_UPLOADPACK_LS), .gitServiceUploadPackLS)
        XCTAssertEqual(GitSmartServiceT(cValue: GIT_SERVICE_UPLOADPACK), .gitServiceUploadPack)
        XCTAssertEqual(GitSmartServiceT(cValue: GIT_SERVICE_RECEIVEPACK_LS), .gitServiceReceivePackLS)
        XCTAssertEqual(GitSmartServiceT(cValue: GIT_SERVICE_RECEIVEPACK), .gitServiceReceivePack)
    }
    
    
    
    func testGitSmartSubtransportDefinition() throws
    {
        let smartSubtransportDefinition = GitSmartSubtransportDefinition()
        
        XCTAssertNil(smartSubtransportDefinition.callback)
        XCTAssertFalse(smartSubtransportDefinition.rpc)
        XCTAssertNil(smartSubtransportDefinition.param)
        
        smartSubtransportDefinition.withCValue
        {
            cSmartSubtransportDefinition in
            
            XCTAssertNil(cSmartSubtransportDefinition.pointee.callback)
            XCTAssertFalse(Bool(cSmartSubtransportDefinition.pointee.rpc))
            XCTAssertNil(cSmartSubtransportDefinition.pointee.param)
        }
    }
    
    
    
    func testGitTransportInit() throws
    {
        var transport = git_transport()
        
        let transportInitResult: GitErrorCode = gitTransportInit(
            transport:  &transport,
            version:    gitTransportVersion
        )
        
        XCTAssertOK(transportInitResult)
    }
    
    
    
    func testGitTransportLocal() throws
    {
        try Repository.withRemote
        {
            _, remotePointer in
            
            var transportPointer: UnsafeMutablePointer<git_transport>? = nil
            
            defer
            {
                if transportPointer != nil
                {
                    transportPointer?.pointee.free(transportPointer)
                }
            }
            
            
            
            var transportLocalResult: GitErrorCode = gitTransportLocal(
                out:        &transportPointer,
                owner:      remotePointer,
                payload:    nil
            )
            
            XCTAssertOK(transportLocalResult)
            XCTAssertNotNil(transportPointer)
            
            
            
            transportLocalResult = gitTransportLocal(
                out:        &transportPointer,
                owner:      remotePointer,
                payload:    UnsafeMutableRawPointer(bitPattern: 0x1)
            )
            
            XCTAssertOK(transportLocalResult)
            XCTAssertNotNil(transportPointer)
        }
    }

    
    
    func testGitTransportNew() throws
    {
        try Repository.withRemote
        {
            _, remotePointer in
            
            var transportPointer: UnsafeMutablePointer<git_transport>? = nil
            
            defer
            {
                if transportPointer != nil
                {
                    transportPointer?.pointee.free(transportPointer)
                }
            }
            
            
            
            let transportNewResult: GitErrorCode = gitTransportNew(
                out:    &transportPointer,
                owner:  remotePointer,
                url:    Repository.remoteURL
            )
            
            XCTAssertOK(transportNewResult)
            XCTAssertNotNil(transportPointer)
        }
    }
    
    
    
    func testGitTransportRegister() throws
    {
        let transportCB: GitTransportCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitPassthrough.rawValue
        }
        
        let prefix: String = "test://"
        
        let transportRegisterResult: GitErrorCode = gitTransportRegister(
            prefix:     prefix,
            cb:         transportCB,
            param:      nil
        )
        
        XCTAssertOK(transportRegisterResult)
        
        
        
        let transportUnregisterResult: GitErrorCode
            = gitTransportUnregister(prefix: prefix)
        
        XCTAssertOK(transportUnregisterResult)
    }
    
    
    
    func testGitTransportRemoteConnectOptions() throws
    {
        try Repository.withRemote
        {
            _, remotePointer in
            
            var transportPointer: UnsafeMutablePointer<git_transport>? = nil
            
            defer
            {
                if transportPointer != nil
                {
                    transportPointer?.pointee.free(transportPointer)
                }
            }
            
            
            
            let transportNewResult: GitErrorCode = gitTransportNew(
                out:    &transportPointer,
                owner:  remotePointer,
                url:    Repository.remoteURL
            )
            
            XCTAssertOK(transportNewResult)
            
            guard let transportPointer: UnsafeMutablePointer<git_transport>
                    = transportPointer
            else
            {
                XCTFail("The transport pointer was nil.")
                return
            }
            
            
            
            var remoteConnectOptions = GitRemoteConnectOptions()
            
            let transportOptionsResult: GitErrorCode
                = gitTransportRemoteConnectOptions(
                    out:        &remoteConnectOptions,
                    transport:  transportPointer
                )
            
            XCTAssertOK(transportOptionsResult)
        }
    }
    
    
    
    func testGitTransportSmart() throws
    {
        try withSmartTransport
        {
            _ in
        }
    }
    
    
    
    func testGitTransportSmartCertificateCheck() throws
    {
        try withSmartTransport
        {
            transportPointer in
            
            var cert = git_cert()
            
            cert.cert_type = GIT_CERT_X509
            
            
            
            let transportSmartCertCheckResult: GitErrorCode
                = gitTransportSmartCertificateCheck(
                    transport:  transportPointer,
                    cert:       &cert,
                    valid:      true,
                    hostName:   "example.com"
                )
            
            XCTAssertEqual(transportSmartCertCheckResult, .gitPassthrough)
        }
    }
    
    
    
    func testGitTransportSmartCredentials() throws
    {
        try withSmartTransport
        {
            transportPointer in
            
            var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
            
            defer
            {
                gitCredentialFree(cred: credentialPointer)
            }
            
            
            
            let transportSmartCredentialsResult: GitErrorCode
                = gitTransportSmartCredentials(
                    out:        &credentialPointer,
                    transport:  transportPointer,
                    user:       nil,
                    methods:    0
                )
            
            XCTAssertEqual(transportSmartCredentialsResult, .gitPassthrough)
            XCTAssertNil(credentialPointer)
        }
    }
    
    
    
    func testGitTransportSSHWithPaths() throws
    {
        try Repository.withRemote
        {
            _, remotePointer in
            
            var transportPointer: UnsafeMutablePointer<git_transport>? = nil
            
            defer
            {
                if transportPointer != nil
                {
                    transportPointer?.pointee.free(transportPointer)
                }
            }
            
            
            
            let transportSSHWithPathsResult: GitErrorCode
                = gitTransportSSHWithPaths(
                    out:        &transportPointer,
                    owner:      remotePointer,
                    payload:    ["", ""]
                )
            
            XCTAssertOK(transportSSHWithPathsResult)
            XCTAssertNotNil(transportPointer)
        }
    }
    
    
    
    func testGitTransportSubtransportGit() throws
    {
        try withSmartTransport
        {
            transportPointer in
            
            var subtransportPointer: UnsafeMutablePointer<git_smart_subtransport>?
                = nil
            
            defer
            {
                if subtransportPointer != nil
                {
                    subtransportPointer?.pointee.free(subtransportPointer)
                }
            }
            
            
            
            let smartSubtransportGitResult: GitErrorCode
                = gitSmartSubtransportGit(
                    out:    &subtransportPointer,
                    owner:  transportPointer,
                    param:  nil
                )
            
            XCTAssertOK(smartSubtransportGitResult)
            XCTAssertNotNil(subtransportPointer)
        }
    }
    
    
    
    func testGitTransportSubtransportHTTP() throws
    {
        try withSmartTransport
        {
            transportPointer in
            
            var subtransportPointer: UnsafeMutablePointer<git_smart_subtransport>?
                = nil
            
            defer
            {
                if subtransportPointer != nil
                {
                    subtransportPointer?.pointee.free(subtransportPointer)
                }
            }
            
            
            
            let smartSubtransportHTTPResult: GitErrorCode
                = gitSmartSubtransportHTTP(
                    out:    &subtransportPointer,
                    owner:  transportPointer,
                    param:  nil
                )
            
            XCTAssertOK(smartSubtransportHTTPResult)
            XCTAssertNotNil(subtransportPointer)
        }
    }
    
    
    
    func testGitTransportSubtransportSSH() throws
    {
        try withSmartTransport
        {
            transportPointer in
            
            var subtransportPointer: UnsafeMutablePointer<git_smart_subtransport>?
                = nil
            
            defer
            {
                if subtransportPointer != nil
                {
                    subtransportPointer?.pointee.free(subtransportPointer)
                }
            }
            
            
            
            let smartSubtransportSSHResult: GitErrorCode
                = gitSmartSubtransportSSH(
                    out:    &subtransportPointer,
                    owner:  transportPointer,
                    param:  nil
                )
            
            XCTAssertOK(smartSubtransportSSHResult)
            XCTAssertNotNil(subtransportPointer)
        }
    }
    
    
    
    func testGitTransportUnregister() throws
    {
        let transportUnregisterResult: GitErrorCode
            = gitTransportUnregister(prefix: "non-existent://")
        
        XCTAssertNotOK(transportUnregisterResult)
    }
    
    
    
    func testGitTransportVersion() throws
    {
        XCTAssertEqual(Int32(gitTransportVersion), GIT_TRANSPORT_VERSION)
    }
}



// MARK: - Extensions

private extension TransportAdvancedTests
{
    struct CallbackData
    {
        var callCount: Int = 0
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a smart transport.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withSmartTransport(
        _ body: (UnsafeMutablePointer<git_transport>) throws -> Void
    ) throws
    {
        try Repository.withRemote
        {
            _, remotePointer in
            
            var transportOwnershipTransferred: Bool = false
            
            var transportPointer: UnsafeMutablePointer<git_transport>? = nil
            
            defer
            {
                if
                    !transportOwnershipTransferred,
                    transportPointer != nil
                {
                    transportPointer?.pointee.free(transportPointer)
                }
            }
            
            
            
            var callbackData = CallbackData()
            
            let smartSubtransportCB: GitSmartSubtransportCB =
            {
                _, _, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var definition = GitSmartSubtransportDefinition()
                
                definition.callback     = smartSubtransportCB
                definition.rpc          = true
                definition.param        = UnsafeMutableRawPointer(callbackDataPointer)
                
                let transportSmartResult: GitErrorCode = gitTransportSmart(
                    out:        &transportPointer,
                    owner:      remotePointer,
                    payload:    definition
                )
                
                XCTAssertOK(transportSmartResult)
            }
            
            transportOwnershipTransferred = true
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            
            guard let transportPointer: UnsafeMutablePointer<git_transport>
                    = transportPointer
            else
            {
                XCTFail("The transport pointer was nil.")
                return
            }
            
            
            
            return try body(transportPointer)
        }
    }
}
