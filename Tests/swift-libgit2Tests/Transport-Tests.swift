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



final class TransportTests: XCTestCaseStopOnFail
{
    func testGitTransportCB() throws
    {
        let successCallback: GitTransportCB =
        {
            out, owner, payload in
            
            XCTAssertNotNil(out)
            XCTAssertNil(owner)
            XCTAssertNil(payload)
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        let errorCallback: GitTransportCB =
        {
            out, owner, payload in
            
            XCTAssertNotNil(out)
            XCTAssertNil(owner)
            XCTAssertNil(payload)
            
            if let out: UnsafeMutablePointer<UnsafeMutablePointer<git_transport>?>
                = out
            {
                out.pointee = nil
            }
            
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        
        
        var transportPointer: UnsafeMutablePointer<git_transport>? = nil
        
        let successCallbackResult: Int32 = successCallback(
            &transportPointer,
            nil,
            nil
        )
        
        XCTAssertEqual(successCallbackResult, GitErrorCode.gitOK.rawValue)
        
        let errorCallbackResult: Int32 = errorCallback(
            &transportPointer,
            nil,
            nil
        )
        
        XCTAssertEqual(errorCallbackResult, -123)
        
        XCTAssertNil(transportPointer)
    }
    
    
    
    func testGitTransportMessageCB() throws
    {
        let message         : String    = "abc"
        let messageCount    : Int32     = Int32(message.count)
        
        
        
        let successCallback: GitTransportMessageCB =
        {
            strPointer, len, payload in
            
            guard let str = String(optionalCString: strPointer)
            else
            {
                XCTFail("The string pointer was nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            XCTAssertEqual(str, "abc")
            XCTAssertEqual(len, 3)
            XCTAssertNil(payload)
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        let errorCallback: GitTransportMessageCB =
        {
            strPointer, len, payload in
            
            guard let str = String(optionalCString: strPointer)
            else
            {
                XCTFail("The string pointer was nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            XCTAssertEqual(str, "abc")
            XCTAssertEqual(len, 3)
            XCTAssertNil(payload)
            
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        
        
        message.withCString
        {
            cMessage in
            
            let successCallbackResult: Int32 = successCallback(
                cMessage,
                messageCount,
                nil
            )
            
            XCTAssertEqual(successCallbackResult, GitErrorCode.gitOK.rawValue)
            
            let errorCallbackResult: Int32 = errorCallback(
                cMessage,
                messageCount,
                nil
            )
            
            XCTAssertEqual(errorCallbackResult, -123)
        }
    }
}
