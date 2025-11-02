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



final class RefsAdvancedTests: XCTestCaseStopOnFail
{
    func testGitReferenceAlloc() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var directRefPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: directRefPointer)
            }
            
            
            
            let refName : String    = "HEAD"
            let refOID  : GitOID    = repository.headOID
            
            directRefPointer = gitReferenceAlloc(
                name:   refName,
                oid:    refOID,
                peel:   refOID
            )
            
            guard let directRefPointer: OpaquePointer = directRefPointer
            else
            {
                XCTFail("The direct reference pointer was nil.")
                return
            }
            
            
            
            let directRefName: String?
                = gitReferenceName(ref: directRefPointer)
            
            XCTAssertNotNil(directRefName)
            XCTAssertEqual(directRefName, refName)
            
            
            
            let directRefType: GitReferenceT?
                = gitReferenceType(ref: directRefPointer)
            
            XCTAssertNotNil(directRefType)
            XCTAssertEqual(directRefType, .gitReferenceDirect)
            
            
            
            let directTargetOID: GitOID?
                = gitReferenceTarget(ref: directRefPointer)
            
            XCTAssertNotNil(directTargetOID)
            XCTAssertEqual(directTargetOID, refOID)
        }
    }
    
    
    
    func testGitReferenceAllocSymbolic() throws
    {
        var symbolicRefPointer: OpaquePointer? = nil
        
        defer
        {
            gitReferenceFree(ref: symbolicRefPointer)
        }
        
        
        
        let refName         : String    = "refs/heads/symbolic-test"
        let refTargetName   : String    = "HEAD"
        
        symbolicRefPointer = gitReferenceAllocSymbolic(
            name:       refName,
            target:     refTargetName
        )
        
        guard let symbolicRefPointer: OpaquePointer = symbolicRefPointer
        else
        {
            XCTFail("The symbolic reference pointer was nil.")
            return
        }
        
        
        
        let symbolicRefName: String?
            = gitReferenceName(ref: symbolicRefPointer)
        
        XCTAssertNotNil(symbolicRefName)
        XCTAssertEqual(symbolicRefName, refName)
        
        
        
        let symbolicRefType: GitReferenceT?
            = gitReferenceType(ref: symbolicRefPointer)
        
        XCTAssertNotNil(symbolicRefType)
        XCTAssertEqual(symbolicRefType, .gitReferenceSymbolic)
        
        
        
        let symbolicTarget: String?
            = gitReferenceSymbolicTarget(ref: symbolicRefPointer)
        
        XCTAssertNotNil(symbolicTarget)
        XCTAssertEqual(symbolicTarget, refTargetName)
    }
}
