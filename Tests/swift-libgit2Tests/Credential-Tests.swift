//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import XCTest
@testable import SwiftLibgit2



final class CredentialTests: XCTestCaseStopOnFail
{
    func testGitCredentialAcquireCB() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let credentialAcquireCB: GitCredentialAcquireCB =
        {
            out, url, usernameFromURL, allowedTypes, payload in
            
            guard
                let out     : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>   = out,
                let payload : UnsafeMutableRawPointer                                       = payload
            else
            {
                return -1
            }
            
            let payloadPointer: UnsafeMutablePointer<CallbackData>
                = payload.assumingMemoryBound(to: CallbackData.self)
            
            payloadPointer.pointee.count            += 1
            payloadPointer.pointee.allowedTypes     = allowedTypes
            
            if let url = String(optionalCString: url)
            {
                payloadPointer.pointee.url = url
            }
            
            if let usernameFromURL = String(optionalCString: usernameFromURL)
            {
                payloadPointer.pointee.usernameFromURL = usernameFromURL
            }
            
            return gitCredentialUsernameNew(
                out:        out,
                username:   Repository.commitAuthorName
            )
        }
        
        
        
        let url         : String    = "https://example.com/test/repo.git"
        let allowedType : UInt32    = GitCredentialT.gitCredentialUserPassPlaintext.rawValue
        
        var callbackData = CallbackData()
        
        withUnsafeMutablePointer(to: &callbackData)
        {
            callbackDataPointer in
            
            var remoteCallbacks = GitRemoteCallbacks()
            
            remoteCallbacks.credentials     = credentialAcquireCB
            remoteCallbacks.payload         = UnsafeMutableRawPointer(callbackDataPointer)
            
            let callbackResult: Int32 = remoteCallbacks.credentials!(
                &credentialPointer,
                url,
                Repository.commitAuthorName,
                allowedType,
                remoteCallbacks.payload
            )
            
            XCTAssertOK(callbackResult)
        }
        
        XCTAssertNotNil(credentialPointer)
        XCTAssertEqual(callbackData.count, 1)
        XCTAssertNotNil(callbackData.url)
        XCTAssertEqual(callbackData.url, url)
        XCTAssertNotNil(callbackData.usernameFromURL)
        XCTAssertEqual(callbackData.usernameFromURL, Repository.commitAuthorName)
        XCTAssertNotNil(callbackData.allowedTypes)
        XCTAssertEqual(callbackData.allowedTypes, allowedType)
    }
    
    
    
    func testGitCredentialDefaultNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let credentialDefaultNewResult: Int32 = gitCredentialDefaultNew(out: &credentialPointer)
        
        XCTAssertOK(credentialDefaultNewResult)
        XCTAssertNotNil(credentialPointer)
    }
    
    
    
    func testGitCredentialSSHCustomNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let credentialSignCB: GitCredentialSignCB =
        {
            session, sig, sigLen, data, dataLen, abstract in
            
            /// `abstract` is not the standard payload parameter.
            /// This callback will be invoked by libssh2 during actual SSH authentication, so
            /// the payload cannot be used for standard testing.
            
            return GIT_OK.rawValue
        }
        
        
        
        let publicKey: String = "ssh-rsa ABCDEFGHIJKLMNOPQRSTUVWXYZ..."
        
        let credentialSSHCustomNewResult: Int32 = gitCredentialSSHCustomNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      publicKey,
            publicKeyLen:   publicKey.count,
            signCallback:   credentialSignCB,
            payload:        nil
        )
        
        XCTAssertOK(credentialSSHCustomNewResult)
        
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
    }
    
    
    
    func testGitCredentialSSHInteractiveNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let credentialSSHInteractiveCB: GitCredentialSSHInteractiveCB =
        {
            name, nameLen, instructon, instructionLen,
            numPrompts, prompts, responses, abstract in
            
            /// `abstract` is not the standard payload parameter.
            /// This callback will be invoked by libssh2 during actual SSH authentication, so
            /// the payload cannot be used for standard testing.
        }
        
        
        
        let credentialSSHInteractiveNewResult: Int32 = gitCredentialSSHInteractiveNew(
            out:                &credentialPointer,
            username:           Repository.commitAuthorName,
            promptCallback:     credentialSSHInteractiveCB,
            payload:            nil
        )
        
        XCTAssertOK(credentialSSHInteractiveNewResult)
        
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
    }
    
    
    
    func testGitCredentialSSHKeyFromAgent() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let credentialSSHKeyFromAgentResult: Int32 = gitCredentialSSHKeyFromAgent(
            out:        &credentialPointer,
            username:   Repository.commitAuthorName
        )
        
        XCTAssertOK(credentialSSHKeyFromAgentResult)
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
    }
    
    
    
    func testGitCredentialSSHKeyMemoryNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let publicKey   : String    = "ssh-rsa ABCDEFGHIJKLMNOPQRSTUVWXYZ..."
        let privateKey  : String    = "-----BEGIN OPENSSH PRIVATE KEY-----\nABC"
        
        var credentialSSHKeyMemoryNewResult: Int32 = gitCredentialSSHKeyMemoryNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      publicKey,
            privateKey:     privateKey,
            passphrase:     nil
        )
        
        XCTAssertOK(credentialSSHKeyMemoryNewResult)
        
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
        
        
        
        credentialSSHKeyMemoryNewResult = gitCredentialSSHKeyMemoryNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      publicKey,
            privateKey:     privateKey,
            passphrase:     "helloworld"
        )
        
        XCTAssertOK(credentialSSHKeyMemoryNewResult)
        
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
    }
    
    
    
    func testGitCredentialSSHKeyNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        var credentialSSHKeyNewResult: Int32 = gitCredentialSSHKeyNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      "",
            privateKey:     "",
            passphrase:     nil
        )
        
        /// There is no verification of SSH keys, so invalid paths will not cause a failure.
        XCTAssertOK(credentialSSHKeyNewResult)
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
        
        
        
        credentialSSHKeyNewResult = gitCredentialSSHKeyNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      "",
            privateKey:     "",
            passphrase:     "helloworld"
        )
        
        /// There is no verification of SSH keys, so invalid paths will not cause a failure.
        XCTAssertOK(credentialSSHKeyNewResult)
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
    }
    
    
    
    func testGitCredentialT() throws
    {
        XCTAssertEqual(GitCredentialT.gitCredentialUserPassPlaintext.rawValue, GIT_CREDENTIAL_USERPASS_PLAINTEXT.rawValue)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHKey.rawValue, GIT_CREDENTIAL_SSH_KEY.rawValue)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHCustom.rawValue, GIT_CREDENTIAL_SSH_CUSTOM.rawValue)
        XCTAssertEqual(GitCredentialT.gitCredentialDefault.rawValue, GIT_CREDENTIAL_DEFAULT.rawValue)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHInteractive.rawValue, GIT_CREDENTIAL_SSH_INTERACTIVE.rawValue)
        XCTAssertEqual(GitCredentialT.gitCredentialUsername.rawValue, GIT_CREDENTIAL_USERNAME.rawValue)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHMemory.rawValue, GIT_CREDENTIAL_SSH_MEMORY.rawValue)
        
        XCTAssertEqual(GitCredentialT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitCredentialT.gitCredentialUserPassPlaintext.cValue(), GIT_CREDENTIAL_USERPASS_PLAINTEXT)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHKey.cValue(), GIT_CREDENTIAL_SSH_KEY)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHCustom.cValue(), GIT_CREDENTIAL_SSH_CUSTOM)
        XCTAssertEqual(GitCredentialT.gitCredentialDefault.cValue(), GIT_CREDENTIAL_DEFAULT)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHInteractive.cValue(), GIT_CREDENTIAL_SSH_INTERACTIVE)
        XCTAssertEqual(GitCredentialT.gitCredentialUsername.cValue(), GIT_CREDENTIAL_USERNAME)
        XCTAssertEqual(GitCredentialT.gitCredentialSSHMemory.cValue(), GIT_CREDENTIAL_SSH_MEMORY)
        
        
        
        let flags: GitCredentialT =
        [
            .gitCredentialUserPassPlaintext,
            .gitCredentialSSHCustom
        ]
        
        XCTAssertTrue(flags.contains(.gitCredentialUserPassPlaintext))
        XCTAssertTrue(flags.contains(.gitCredentialSSHCustom))
        XCTAssertFalse(flags.contains(.gitCredentialDefault))
    }
    
    
    
    func testGitCredentialUsernameNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let credentialUsernameNewResult: Int32 = gitCredentialUsernameNew(
            out:        &credentialPointer,
            username:   Repository.commitAuthorName
        )
        
        XCTAssertOK(credentialUsernameNewResult)
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
    }
    
    
    
    func testGitCredentialUserPassPlaintextNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            Free.freeCredential(credentialPointer)
        }
        
        
        
        let credentialUserPassPlaintextNewResult: Int32 = gitCredentialUserPassPlaintextNew(
            out:        &credentialPointer,
            username:   Repository.commitAuthorName,
            password:   "helloworld"
        )
        
        XCTAssertOK(credentialUserPassPlaintextNewResult)
        XCTAssertNotNil(credentialPointer)
        XCTAssertTrue(gitCredentialHasUsername(cred: credentialPointer))
        XCTAssertEqual(gitCredentialGetUsername(cred: credentialPointer), Repository.commitAuthorName)
    }
}



// MARK: - Extensions

extension CredentialTests
{
    private struct CallbackData
    {
        var count           : Int       = 0
        var url             : String?   = nil
        var usernameFromURL : String?   = nil
        var allowedTypes    : UInt32?   = nil
    }
}
