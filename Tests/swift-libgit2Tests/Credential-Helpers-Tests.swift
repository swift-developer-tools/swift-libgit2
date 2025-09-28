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



final class CredentialHelpersTests: XCTestCaseStopOnFail
{
    func testGitCredentialUserPass() throws
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
                let out         : UnsafeMutablePointer<UnsafeMutablePointer<git_credential>?>   = out,
                let url         : UnsafePointer<CChar>                                          = url,
                let userFromURL : UnsafePointer<CChar>                                          = usernameFromURL,
                let payload     : UnsafeMutableRawPointer                                       = payload
            else
            {
                return -1
            }
            
            return gitCredentialUserPass(
                out:            out,
                url:            String(cString: url),
                userFromURL:    String(cString: userFromURL),
                allowedTypes:   GitCredentialT(rawValue: allowedTypes),
                payload:        payload
            )
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
                    
                    XCTAssertOK(callbackResult)
                }
            }
        }
        
        XCTAssertNotNil(credentialPointer)
    }
}
