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



final class NetTests: XCTestCaseStopOnFail
{
    func testGitDefaultPort() throws
    {
        XCTAssertEqual(gitDefaultPort, GIT_DEFAULT_PORT)
    }
    
    
    
    func testGitDirection() throws
    {
        XCTAssertEqual(GitDirection.gitDirectionFetch.rawValue, GIT_DIRECTION_FETCH.rawValue)
        XCTAssertEqual(GitDirection.gitDirectionPush.rawValue, GIT_DIRECTION_PUSH.rawValue)
        
        XCTAssertNil(GitMergeFileFavorT(rawValue: 123))
        
        XCTAssertEqual(GitDirection.gitDirectionFetch.cValue(), GIT_DIRECTION_FETCH)
        XCTAssertEqual(GitDirection.gitDirectionPush.cValue(), GIT_DIRECTION_PUSH)
        
        XCTAssertEqual(GitDirection(cValue: GIT_DIRECTION_FETCH), .gitDirectionFetch)
        XCTAssertEqual(GitDirection(cValue: GIT_DIRECTION_PUSH), .gitDirectionPush)
    }
    
    
    
    func testGitRemoteHEAD() throws
    {
        let remoteHEAD = GitRemoteHEAD(cValue: git_remote_head())
        
        XCTAssertFalse(remoteHEAD.local)
        XCTAssertZeroOID(remoteHEAD.oid)
        XCTAssertZeroOID(remoteHEAD.loid)
        XCTAssertNil(remoteHEAD.name)
        XCTAssertNil(remoteHEAD.symrefTarget)
        
        try remoteHEAD.withCValue
        {
            cRemoteHEAD in
            
            XCTAssertFalse(Bool(cRemoteHEAD.pointee.local))
            XCTAssertZeroOID(GitOID(cValue: cRemoteHEAD.pointee.oid))
            XCTAssertZeroOID(GitOID(cValue: cRemoteHEAD.pointee.loid))
            XCTAssertNil(cRemoteHEAD.pointee.name)
            XCTAssertNil(cRemoteHEAD.pointee.symref_target)
        }
    }
}
