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



final class OIDArrayTests: XCTestCaseStopOnFail
{
    func testGitOIDArrayDefaultInitialization() throws
    {
        let oidArray = GitOIDArray()
        
        XCTAssertTrue(oidArray.ids.isEmpty)
        XCTAssertEqual(oidArray.count, 0)
    }
    
    
    
    func testGitOIDArrayDispose() throws
    {
        var oidArray = git_oidarray()
        
        gitOIDArrayDispose(array: &oidArray)
        gitOIDArrayDispose(array: &oidArray)
        gitOIDArrayDispose(array: nil)
    }
    
    
    
    func testGitOIDArrayFromCValueInitialization() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let cOIDs = UnsafeMutablePointer<git_oid>.allocate(capacity: 1)
            
            defer
            {
                cOIDs.deallocate()
            }
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            cOIDs[0] = headOID.cValue()
            
            
            
            var cOIDArray = git_oidarray()
            
            cOIDArray.ids       = cOIDs
            cOIDArray.count     = 1
            
            
            
            let swiftOIDArray = GitOIDArray(cValue: cOIDArray)
            
            XCTAssertEqual(swiftOIDArray.ids[0], headOID)
            XCTAssertEqual(swiftOIDArray.count, 1)
            
            
            
            swiftOIDArray.withCValue
            {
                cOIDArray in
                
                XCTAssertEqual(GitOID(cValue: cOIDArray.pointee.ids[0]), headOID)
                XCTAssertEqual(cOIDArray.pointee.count, 1)
            }
        }
    }
    
    
    
    func testGitOIDWithCValueEmpty() throws
    {
        GitOIDArray().withCValue
        {
            cOIDArray in
            
            XCTAssertNil(cOIDArray.pointee.ids)
            XCTAssertEqual(cOIDArray.pointee.count, 0)
        }
    }
}
