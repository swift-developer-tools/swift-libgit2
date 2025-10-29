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



final class DiffAdvancedTests: XCTestCaseStopOnFail
{
    func testGitDiffGetPerfData() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiff(in: repository)
            {
                diffPointer in
                
                var diffPerfData = GitDiffPerfData()
                
                let diffGetPerfDataResult: GitErrorCode = gitDiffGetPerfData(
                    out:    &diffPerfData,
                    diff:   diffPointer
                )
                
                XCTAssertOK(diffGetPerfDataResult)
                XCTAssertGreaterThan(diffPerfData.statCalls, 0)
                XCTAssertGreaterThan(diffPerfData.oidCalculations, 0)
            }
        }
    }
    
    
    
    func testGitDiffPerfData()
    {
        let diffPerfData = GitDiffPerfData()
        
        XCTAssertEqual(diffPerfData.version, gitDiffPerfDataVersion)
        XCTAssertEqual(diffPerfData.statCalls, 0)
        XCTAssertEqual(diffPerfData.oidCalculations, 0)
        
        diffPerfData.withCValue
        {
            cDiffPerfData in
            
            XCTAssertEqual(cDiffPerfData.pointee.version, gitDiffPerfDataVersion)
            XCTAssertEqual(cDiffPerfData.pointee.stat_calls, 0)
            XCTAssertEqual(cDiffPerfData.pointee.oid_calculations, 0)
        }
    }
    
    
    
    func testGitDiffPerfDataVersion() throws
    {
        XCTAssertEqual(Int32(gitDiffPerfDataVersion), GIT_DIFF_PERFDATA_VERSION)
    }
    
    
    
    func testGitDiffStatusListGetPerfData() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var statusListPointer: OpaquePointer? = nil
            
            defer
            {
                gitStatusListFree(statusList: statusListPointer)
            }
            
            
            
            let statusListNewResult: GitErrorCode = gitStatusListNew(
                out:    &statusListPointer,
                repo:   repository.pointer,
                opts:   nil
            )
            
            XCTAssertOK(statusListNewResult)
            
            guard let statusListPointer: OpaquePointer = statusListPointer
            else
            {
                XCTFail("The status list pointer was nil.")
                return
            }
            
            
            
            var diffPerfData = GitDiffPerfData()
            
            let diffGetPerfDataResult: GitErrorCode = gitStatusListGetPerfData(
                out:        &diffPerfData,
                status:     statusListPointer
            )
            
            XCTAssertOK(diffGetPerfDataResult)
            XCTAssertGreaterThan(diffPerfData.statCalls, 0)
        }
    }
}
