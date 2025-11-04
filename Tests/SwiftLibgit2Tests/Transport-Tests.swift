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



final class TransportTests: XCTestCaseStopOnFail
{
    func testGitTransportCB() throws
    {
        let transportCB: GitTransportCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let transportCBResult: Int32 = transportCB(
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: transportCBResult))
    }
    
    
    
    func testGitTransportMessageCB() throws
    {
        let transportMessageCB: GitTransportMessageCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        let transportMessageCBResult: Int32 = transportMessageCB(
            nil,
            0,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: transportMessageCBResult))
    }
}
