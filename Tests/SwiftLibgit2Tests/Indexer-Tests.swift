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



final class IndexerTests: XCTestCaseStopOnFail
{
    func testGitIndexerFree() throws
    {
        gitIndexerFree(idx: nil)
    }
    
    
    
    func testGitIndexerProgress() throws
    {
        let indexerProgress = GitIndexerProgress()
        
        XCTAssertEqual(indexerProgress.totalObjects, 0)
        XCTAssertEqual(indexerProgress.indexedObjects, 0)
        XCTAssertEqual(indexerProgress.receivedObjects, 0)
        XCTAssertEqual(indexerProgress.localObjects, 0)
        XCTAssertEqual(indexerProgress.totalDeltas, 0)
        XCTAssertEqual(indexerProgress.indexedDeltas, 0)
        XCTAssertEqual(indexerProgress.receivedBytes, 0)
        
        indexerProgress.withCValue
        {
            cIndexerProgress in
            
            XCTAssertEqual(cIndexerProgress.pointee.total_objects, 0)
            XCTAssertEqual(cIndexerProgress.pointee.indexed_objects, 0)
            XCTAssertEqual(cIndexerProgress.pointee.received_objects, 0)
            XCTAssertEqual(cIndexerProgress.pointee.local_objects, 0)
            XCTAssertEqual(cIndexerProgress.pointee.total_deltas, 0)
            XCTAssertEqual(cIndexerProgress.pointee.indexed_deltas, 0)
            XCTAssertEqual(cIndexerProgress.pointee.received_bytes, 0)
        }
    }
    
    
    
    func testGitIndexerOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var callbackData = CallbackData()
            
            let indexerProgressCB: GitIndexerProgressCB =
            {
                _, payload in
                
                guard let payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            let packfileData: Data = try repository.createPackfileData()
            
            try withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var indexerOptions = GitIndexerOptions()
                
                indexerOptions.progressCB           = indexerProgressCB
                indexerOptions.progressCBPayload    = UnsafeMutableRawPointer(callbackDataPointer)
                indexerOptions.verify               = false
                
                try repository.validatePackfileData(
                    packfileData,
                    options: nil
                )
                
                try repository.validatePackfileData(
                    packfileData,
                    options: indexerOptions
                )
                
                indexerOptions.verify = true
                
                try repository.validatePackfileData(
                    packfileData,
                    options: indexerOptions
                )
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
        }
    }
    
    
    
    func testGitIndexerOptions() throws
    {
        let indexerOptions = GitIndexerOptions()
        
        XCTAssertEqual(indexerOptions.version, gitIndexerOptionsVersion)
        XCTAssertNil(indexerOptions.progressCB)
        XCTAssertNil(indexerOptions.progressCBPayload)
        XCTAssertFalse(indexerOptions.verify)
        
        try indexerOptions.withCValue
        {
            cIndexerOptions in
            
            XCTAssertEqual(cIndexerOptions.pointee.version, gitIndexerOptionsVersion)
            XCTAssertNil(cIndexerOptions.pointee.progress_cb)
            XCTAssertNil(cIndexerOptions.pointee.progress_cb_payload)
            XCTAssertFalse(Bool(cIndexerOptions.pointee.verify))
        }
    }
    
    
    
    func testGitIndexerOptionsInit() throws
    {
        var indexerOptions = git_indexer_options()
        
        let indexerOptionsInitResult: GitErrorCode = gitIndexerOptionsInit(
            opts:       &indexerOptions,
            version:    gitIndexerOptionsVersion
        )
        
        XCTAssertOK(indexerOptionsInitResult)
    }
    
    
    
    func testGitIndexerOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitIndexerOptionsVersion), GIT_INDEXER_OPTIONS_VERSION)
    }
}



// MARK: - Extensions

private extension IndexerTests
{
    struct CallbackData
    {
        var callCount: Int = 0
    }
}
