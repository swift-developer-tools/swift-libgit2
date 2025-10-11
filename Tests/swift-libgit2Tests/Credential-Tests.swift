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



final class CredentialTests: XCTestCaseStopOnFail
{
    func testGitCredentialAcquireCB() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            gitCredentialFree(cred: credentialPointer)
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
            ).rawValue
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
            
            XCTAssertOK(GitErrorCode(rawValue: callbackResult))
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
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        let credentialDefaultNewResult: GitErrorCode
            = gitCredentialDefaultNew(out: &credentialPointer)
        
        XCTAssertOK(credentialDefaultNewResult)
        XCTAssertNotNil(credentialPointer)
    }
    
    
    
    func testGitCredentialFree() throws
    {
        gitCredentialFree(cred: nil)
    }
    
    
    
    func testGitCredentialSSHCustomNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        let credentialSignCB: GitCredentialSignCB =
        {
            session, sig, sigLen, data, dataLen, abstract in
            
            /// `abstract` is not the standard payload parameter. This callback
            /// will be invoked by libssh2 during actual SSH authentication,
            /// so the payload cannot be used for standard testing.
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        let publicKey = Data("ssh-rsa ABCDEFGHIJKLMNOPQRSTUVWXYZ...".utf8)
        
        let credentialSSHCustomNewResult: GitErrorCode
            = gitCredentialSSHCustomNew(
                out:            &credentialPointer,
                username:       Repository.commitAuthorName,
                publicKey:      publicKey,
                publicKeyLen:   publicKey.count,
                signCallback:   credentialSignCB,
                payload:        nil
            )
        
        XCTAssertOK(credentialSSHCustomNewResult)
        
        validateUsername(of: credentialPointer)
    }
    
    
    
    func testGitCredentialSSHInteractiveNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        let credentialSSHInteractiveCB: GitCredentialSSHInteractiveCB =
        {
            name, nameLen, instructon, instructionLen,
            numPrompts, prompts, responses, abstract in
            
            /// `abstract` is not the standard payload parameter. This callback
            /// will be invoked by libssh2 during actual SSH authentication,
            /// so the payload cannot be used for standard testing.
        }
        
        
        
        let credentialSSHInteractiveNewResult: GitErrorCode
            = gitCredentialSSHInteractiveNew(
                out:                &credentialPointer,
                username:           Repository.commitAuthorName,
                promptCallback:     credentialSSHInteractiveCB,
                payload:            nil
            )
        
        XCTAssertOK(credentialSSHInteractiveNewResult)
        
        validateUsername(of: credentialPointer)
    }
    
    
    
    func testGitCredentialSSHKeyFromAgent() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        let credentialSSHKeyFromAgentResult: GitErrorCode
            = gitCredentialSSHKeyFromAgent(
                out:        &credentialPointer,
                username:   Repository.commitAuthorName
            )
        
        XCTAssertOK(credentialSSHKeyFromAgentResult)
        
        validateUsername(of: credentialPointer)
    }
    
    
    
    func testGitCredentialSSHKeyMemoryNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        let publicKey   : String    = "ssh-rsa ABCDEFGHIJKLMNOPQRSTUVWXYZ..."
        let privateKey  : String    = "-----BEGIN OPENSSH PRIVATE KEY-----\nABC"
        
        var credentialSSHKeyMemoryNewResult: GitErrorCode
            = gitCredentialSSHKeyMemoryNew(
                out:            &credentialPointer,
                username:       Repository.commitAuthorName,
                publicKey:      publicKey,
                privateKey:     privateKey,
                passphrase:     nil
            )
        
        XCTAssertOK(credentialSSHKeyMemoryNewResult)
        
        validateUsername(of: credentialPointer)
        
        
        
        credentialSSHKeyMemoryNewResult = gitCredentialSSHKeyMemoryNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      publicKey,
            privateKey:     privateKey,
            passphrase:     "helloworld"
        )
        
        XCTAssertOK(credentialSSHKeyMemoryNewResult)
        
        validateUsername(of: credentialPointer)
    }
    
    
    
    func testGitCredentialSSHKeyNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        var credentialSSHKeyNewResult: GitErrorCode = gitCredentialSSHKeyNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      "",
            privateKey:     "",
            passphrase:     nil
        )
        
        /// There is no verification of SSH keys, so invalid paths will not
        /// cause a failure.
        XCTAssertOK(credentialSSHKeyNewResult)
        
        validateUsername(of: credentialPointer)
        
        
        
        credentialSSHKeyNewResult = gitCredentialSSHKeyNew(
            out:            &credentialPointer,
            username:       Repository.commitAuthorName,
            publicKey:      "",
            privateKey:     "",
            passphrase:     "helloworld"
        )
        
        /// There is no verification of SSH keys, so invalid paths will not
        /// cause a failure.
        XCTAssertOK(credentialSSHKeyNewResult)
        
        validateUsername(of: credentialPointer)
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
        
        XCTAssertEqual(GitCredentialT(cValue: GIT_CREDENTIAL_USERPASS_PLAINTEXT).cValue(), GIT_CREDENTIAL_USERPASS_PLAINTEXT)
        XCTAssertEqual(GitCredentialT(cValue: GIT_CREDENTIAL_SSH_KEY).cValue(), GIT_CREDENTIAL_SSH_KEY)
        XCTAssertEqual(GitCredentialT(cValue: GIT_CREDENTIAL_SSH_CUSTOM).cValue(), GIT_CREDENTIAL_SSH_CUSTOM)
        XCTAssertEqual(GitCredentialT(cValue: GIT_CREDENTIAL_DEFAULT).cValue(), GIT_CREDENTIAL_DEFAULT)
        XCTAssertEqual(GitCredentialT(cValue: GIT_CREDENTIAL_SSH_INTERACTIVE).cValue(), GIT_CREDENTIAL_SSH_INTERACTIVE)
        XCTAssertEqual(GitCredentialT(cValue: GIT_CREDENTIAL_USERNAME).cValue(), GIT_CREDENTIAL_USERNAME)
        XCTAssertEqual(GitCredentialT(cValue: GIT_CREDENTIAL_SSH_MEMORY).cValue(), GIT_CREDENTIAL_SSH_MEMORY)
        
        
        
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
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        let credentialUsernameNewResult: GitErrorCode
            = gitCredentialUsernameNew(
                out:        &credentialPointer,
                username:   Repository.commitAuthorName
            )
        
        XCTAssertOK(credentialUsernameNewResult)
        
        validateUsername(of: credentialPointer)
    }
    
    
    
    func testGitCredentialUserPassPlaintextNew() throws
    {
        var credentialPointer: UnsafeMutablePointer<git_credential>? = nil
        
        defer
        {
            gitCredentialFree(cred: credentialPointer)
        }
        
        
        
        let credentialUserPassPlaintextNewResult: GitErrorCode
            = gitCredentialUserPassPlaintextNew(
                out:        &credentialPointer,
                username:   Repository.commitAuthorName,
                password:   "helloworld"
            )
        
        XCTAssertOK(credentialUserPassPlaintextNewResult)
        
        validateUsername(of: credentialPointer)
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
    
    
    
    /// Checks the the username of the given credential pointer equals the
    /// given username.
    /// - Parameters:
    ///   - credentialPointer: A mutable pointer to the credential to check.
    ///   - expectedUsername: The expected username.
    private func validateUsername(
        of      credentialPointer   : UnsafeMutablePointer<git_credential>?,
        equals  expectedUsername    : String = Repository.commitAuthorName
    )
    {
        guard let credentialPointer: UnsafeMutablePointer<git_credential>
                = credentialPointer
        else
        {
            XCTFail("The credential pointer was nil.")
            return
        }
        
        
        
        let hasUsername : Bool      = gitCredentialHasUsername(cred: credentialPointer)
        let username    : String?   = gitCredentialGetUsername(cred: credentialPointer)
        
        XCTAssertTrue(hasUsername)
        XCTAssertNotNil(username)
        XCTAssertEqual(username, expectedUsername)
    }
}
