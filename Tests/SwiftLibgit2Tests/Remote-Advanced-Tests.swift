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



final class RemoteAdvancedTests: XCTestCaseStopOnFail
{
    func testGitRemoteCapabilityT() throws
    {
        XCTAssertEqual(GitRemoteCapabilityT.gitRemoteCapabilityTipOID.rawValue, GIT_REMOTE_CAPABILITY_TIP_OID.rawValue)
        XCTAssertEqual(GitRemoteCapabilityT.gitRemoteCapabilityReachableOID.rawValue, GIT_REMOTE_CAPABILITY_REACHABLE_OID.rawValue)
        XCTAssertEqual(GitRemoteCapabilityT.gitRemoteCapabilityPushOptions.rawValue, GIT_REMOTE_CAPABILITY_PUSH_OPTIONS.rawValue)
        
        XCTAssertEqual(GitRemoteCapabilityT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitRemoteCapabilityT.gitRemoteCapabilityTipOID.cValue(), GIT_REMOTE_CAPABILITY_TIP_OID)
        XCTAssertEqual(GitRemoteCapabilityT.gitRemoteCapabilityReachableOID.cValue(), GIT_REMOTE_CAPABILITY_REACHABLE_OID)
        XCTAssertEqual(GitRemoteCapabilityT.gitRemoteCapabilityPushOptions.cValue(), GIT_REMOTE_CAPABILITY_PUSH_OPTIONS)
        
        XCTAssertEqual(GitRemoteCapabilityT(cValue: GIT_REMOTE_CAPABILITY_TIP_OID), .gitRemoteCapabilityTipOID)
        XCTAssertEqual(GitRemoteCapabilityT(cValue: GIT_REMOTE_CAPABILITY_REACHABLE_OID), .gitRemoteCapabilityReachableOID)
        XCTAssertEqual(GitRemoteCapabilityT(cValue: GIT_REMOTE_CAPABILITY_PUSH_OPTIONS), .gitRemoteCapabilityPushOptions)
        
        
        
        let flags: GitRemoteCapabilityT =
        [
            .gitRemoteCapabilityTipOID,
            .gitRemoteCapabilityReachableOID
        ]
        
        XCTAssertTrue(flags.contains(.gitRemoteCapabilityTipOID))
        XCTAssertTrue(flags.contains(.gitRemoteCapabilityReachableOID))
        XCTAssertFalse(flags.contains(.gitRemoteCapabilityPushOptions))
    }
    
    
    
    func testGitRemoteConnectOptionsDispose() throws
    {
        gitRemoteConnectOptionsDispose(opts: nil)
    }
}
