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
@testable import SwiftLibgit2TestUtilities



final class CredentialHelpersTests: XCTestCaseStopOnFail
{
    func testGitCredentialUserPass() throws
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
                let out     : UnsafeMutablePointer<
                                UnsafeMutablePointer<git_credential>?>  = out,
                let payload : UnsafeMutableRawPointer                   = payload,
                let url             = String(optionalCString: url),
                let userFromURL     = String(optionalCString: usernameFromURL)
            else
            {
                XCTFail("All or some callback parameters were nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            return gitCredentialUserPass(
                out:            out,
                url:            url,
                userFromURL:    userFromURL,
                allowedTypes:   GitCredentialT(rawValue: allowedTypes),
                payload:        payload
            ).rawValue
        }
        
        
        
        let username    : String    = Repository.commitAuthorName
        let password    : String    = "helloworld"
        let url         : String    = "https://example.com/test/repo.git"
        let allowedType : UInt32    = GitCredentialT.gitCredentialUserPassPlaintext.rawValue
        
        
        
        var payload = git_cred_userpass_payload()
        
        username.withCString
        {
            cUsername in
            
            payload.username = cUsername
            
            password.withCString
            {
                cPassword in
                
                payload.password = cPassword
                
                withUnsafePointer(to: &payload)
                {
                    payloadPointer in
                         
                    var remoteCallbacks = GitRemoteCallbacks()
                    
                    remoteCallbacks.credentials     = credentialAcquireCB
                    remoteCallbacks.payload         = UnsafeMutableRawPointer(mutating: payloadPointer)
                    
                    let callbackResult: Int32 = remoteCallbacks.credentials!(
                        &credentialPointer,
                        url,
                        Repository.commitAuthorName,
                        allowedType,
                        remoteCallbacks.payload
                    )
                    
                    XCTAssertOK(GitErrorCode(rawValue: callbackResult))
                }
            }
        }
        
        XCTAssertNotNil(credentialPointer)
    }
}
