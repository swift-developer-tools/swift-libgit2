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



final class StreamAdvancedTests: XCTestCaseStopOnFail
{
    func testGitStreamCB() throws
    {
        let streamCB: GitStreamCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let streamCBResult: Int32 = streamCB(
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: streamCBResult))
    }
    
    
    
    func testGitStreamRegister() throws
    {
        let initialize: GitStreamRegistration.Initialize =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        let wrap: GitStreamRegistration.Wrap =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        var streamRegistration = git_stream_registration()
        
        streamRegistration.version  = gitStreamVersion
        streamRegistration.`init`   = initialize
        streamRegistration.wrap     = wrap
        
        
        
        var streamRegisterResult: GitErrorCode = gitStreamRegister(
            type:           .gitStreamStandard,
            registration:   &streamRegistration
        )
        
        XCTAssertOK(streamRegisterResult)
        
        
        
        streamRegisterResult = gitStreamRegister(
            type:           .gitStreamTLS,
            registration:   &streamRegistration
        )
        
        
        
        for _ in 0..<2
        {
            streamRegisterResult = gitStreamRegister(
                type:           .gitStreamStandard,
                registration:   nil
            )
            
            XCTAssertOK(streamRegisterResult)
            
            
            
            streamRegisterResult = gitStreamRegister(
                type:           .gitStreamTLS,
                registration:   nil
            )
            
            XCTAssertOK(streamRegisterResult)
        }
    }
    
    
    
    func testGitStreamRegisterTLS() throws
    {
        let streamCB: GitStreamCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        var streamRegisterTLSResult: GitErrorCode
            = gitStreamRegisterTLS(ctor: streamCB)
        
        XCTAssertOK(streamRegisterTLSResult)
        
        
        
        for _ in 0..<2
        {
            streamRegisterTLSResult = gitStreamRegisterTLS(ctor: nil)
            
            XCTAssertOK(streamRegisterTLSResult)
        }
    }
    
    
    
    func testGitStreamT() throws
    {
        XCTAssertEqual(GitStreamT.gitStreamStandard.rawValue, GIT_STREAM_STANDARD.rawValue)
        XCTAssertEqual(GitStreamT.gitStreamTLS.rawValue, GIT_STREAM_TLS.rawValue)
        
        XCTAssertNil(GitStreamT(rawValue: 123))
        
        XCTAssertEqual(GitStreamT.gitStreamStandard.cValue(), GIT_STREAM_STANDARD)
        XCTAssertEqual(GitStreamT.gitStreamTLS.cValue(), GIT_STREAM_TLS)
        
        XCTAssertEqual(GitStreamT(cValue: GIT_STREAM_STANDARD), .gitStreamStandard)
        XCTAssertEqual(GitStreamT(cValue: GIT_STREAM_TLS), .gitStreamTLS)
    }
    
    
    
    func testGitStreamVersion() throws
    {
        XCTAssertEqual(gitStreamVersion, GIT_STREAM_VERSION)
    }
}
