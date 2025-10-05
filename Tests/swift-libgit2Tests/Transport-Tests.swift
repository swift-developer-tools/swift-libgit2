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
            
            if let out: UnsafeMutablePointer<UnsafeMutablePointer<git_transport>?> = out
            {
                out.pointee = nil
            }
            
            return -1
        }
        
        
        
        var transportPointer: UnsafeMutablePointer<git_transport>? = nil
        
        let successCallbackResult: Int32 = successCallback(
            &transportPointer,
            nil,
            nil
        )
        
        XCTAssertEqual(successCallbackResult, 0)
        
        let errorCallbackResult: Int32 = errorCallback(
            &transportPointer,
            nil,
            nil
        )
        
        XCTAssertEqual(errorCallbackResult, -1)
        
        XCTAssertNil(transportPointer)
    }
    
    
    
    func testGitTransportMessageCB() throws
    {
        let message         : String    = "123"
        let messageCount    : Int32     = Int32(message.count)
        
        
        
        let successCallback: GitTransportMessageCB =
        {
            strPointer, len, payload in
            
            guard let str = String(optionalCString: strPointer)
            else
            {
                XCTFail("The string parameter was nil.")
                return 0
            }
            
            XCTAssertEqual(str, "123")
            XCTAssertEqual(len, 3)
            XCTAssertNil(payload)
            
            return 0
        }
        
        let errorCallback: GitTransportMessageCB =
        {
            strPointer, len, payload in
            
            guard let str = String(optionalCString: strPointer)
            else
            {
                XCTFail("The string parameter was nil.")
                return -1
            }
            
            XCTAssertEqual(str, "123")
            XCTAssertEqual(len, 3)
            XCTAssertNil(payload)
            
            return -1
        }
        
        
        
        message.withCString
        {
            cMessage in
            
            let successCallbackResult: Int32 = successCallback(
                cMessage,
                messageCount,
                nil
            )
            
            XCTAssertEqual(successCallbackResult, 0)
            
            let errorCallbackResult: Int32 = errorCallback(
                cMessage,
                messageCount,
                nil
            )
            
            XCTAssertEqual(errorCallbackResult, -1)
        }
    }
}
