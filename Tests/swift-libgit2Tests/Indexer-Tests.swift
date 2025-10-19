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
        
        let cIndexerProgress: git_indexer_progress = indexerProgress.cValue()
        
        XCTAssertEqual(cIndexerProgress.total_objects, 0)
        XCTAssertEqual(cIndexerProgress.indexed_objects, 0)
        XCTAssertEqual(cIndexerProgress.received_objects, 0)
        XCTAssertEqual(cIndexerProgress.local_objects, 0)
        XCTAssertEqual(cIndexerProgress.total_deltas, 0)
        XCTAssertEqual(cIndexerProgress.indexed_deltas, 0)
        XCTAssertEqual(cIndexerProgress.received_bytes, 0)
    }
    
    
    
    func testGitIndexerOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var callbackData = CallbackData()
            
            let indexerProgressCB: GitIndexerProgressCB =
            {
                stats, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
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
            
            
            
            let packfileData: Data = try createPackfileData(from: repository)
            
            try withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var indexerOptions = GitIndexerOptions()
                
                indexerOptions.progressCB           = indexerProgressCB
                indexerOptions.progressCBPayload    = UnsafeMutableRawPointer(callbackDataPointer)
                indexerOptions.verify               = false
                
                try testIndexerWithPackfile(
                    in:         repository,
                    data:       packfileData,
                    options:    indexerOptions
                )
                
                
                
                indexerOptions.verify = true
                
                try testIndexerWithPackfile(
                    in:         repository,
                    data:       packfileData,
                    options:    indexerOptions
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
        
        let cIndexerOptions: git_indexer_options = try indexerOptions.cValue()
        
        XCTAssertEqual(cIndexerOptions.version, gitIndexerOptionsVersion)
        XCTAssertNil(cIndexerOptions.progress_cb)
        XCTAssertNil(cIndexerOptions.progress_cb_payload)
        XCTAssertFalse(Bool(cIndexerOptions.verify))
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
    
    
    
    /// Creates packfile data from the given repository.
    /// - Parameter repository: The repository to use.
    /// - Returns: The packfile data.
    /// - Throws: An error if an operation fails.
    func createPackfileData(
        from repository: Repository
    ) throws -> Data
    {
        var packbuilderPointer: OpaquePointer? = nil
        
        defer
        {
            gitPackbuilderFree(pb: packbuilderPointer)
        }
        
        
        
        let packbuilderNewResult: GitErrorCode = gitPackbuilderNew(
            out:    &packbuilderPointer,
            repo:   repository.pointer
        )
        
        XCTAssertOK(packbuilderNewResult)
        
        guard let packbuilderPointer: OpaquePointer = packbuilderPointer
        else
        {
            throw NSError.makeError("The packbuilder pointer was nil.")
        }
        
        
        
        let headOID: GitOID = OID.getHEADCommitOID(in: repository)
        
        let packbuilderInsertCommitResult: GitErrorCode
            = gitPackbuilderInsertCommit(
                pb: packbuilderPointer,
                id: headOID
            )
        
        XCTAssertOK(packbuilderInsertCommitResult)
        
        
        
        var packData = Data()
        
        let packbuilderForEachCB: GitPackbuilderForEachCB =
        {
            data, size, payload in
            
            guard let data: UnsafeMutableRawPointer = data
            else
            {
                XCTFail("The data was nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            guard let payload: UnsafeMutableRawPointer = payload
            else
            {
                XCTFail("The payload was nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            let payloadPointer: UnsafeMutablePointer<Data>
                = payload.assumingMemoryBound(to: Data.self)
            
            let bytes = Data(
                bytes:  data,
                count:  size
            )
            
            payloadPointer.pointee.append(bytes)
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        withUnsafeMutablePointer(to: &packData)
        {
            packDataPointer in
            
            let packbuilderForEachResult: GitErrorCode = gitPackbuilderForEach(
                pb:         packbuilderPointer,
                cb:         packbuilderForEachCB,
                payload:    packDataPointer
            )
            
            XCTAssertOK(packbuilderForEachResult)
        }
        
        return packData
    }
    
    
    
    /// Tests the indexer workflow with the given packfile data.
    /// - Parameters:
    ///   - repository: The repository from which the packfile data was created.
    ///   - packfileData: The packfile data to index.
    ///   - indexerOptions: The indexer options.
    /// - Throws: An error if an operation fails.
    func testIndexerWithPackfile(
        in          repository      : Repository,
        data        packfileData    : Data,
        options     indexerOptions  : GitIndexerOptions?
    ) throws
    {
        var indexerPointer  : OpaquePointer?    = nil
        var odbPointer      : OpaquePointer?    = nil
        let indexerURL      : URL               = try Repository.createTemporaryDirectory(named: "SwiftLibgit2IndexerTests")
        
        defer
        {
            gitIndexerFree(idx: indexerPointer)
            gitODBFree(db: odbPointer)
            
            try? FileManager.default.removeItem(at: indexerURL)
        }
        
        
        
        if indexerOptions?.verify == true
        {
            let repositoryODBResult: Int32 = git_repository_odb(
                &odbPointer,
                repository.pointer
            )
            
            XCTAssertOK(GitErrorCode(rawValue: repositoryODBResult))
        }
        
        
        
        let indexerNewResult: GitErrorCode = gitIndexerNew(
            out:    &indexerPointer,
            path:   indexerURL.path(),
            mode:   0,
            odb:    odbPointer,
            opts:   indexerOptions
        )
        
        XCTAssertOK(indexerNewResult)
        
        guard let indexerPointer: OpaquePointer = indexerPointer
        else
        {
            XCTFail("The indexer pointer was nil.")
            return
        }
        
        
        
        var indexerProgress = GitIndexerProgress()
        
        let indexerAppendResult: GitErrorCode = gitIndexerAppend(
            idx:    indexerPointer,
            data:   packfileData,
            size:   packfileData.count,
            stats:  &indexerProgress
        )
        
        XCTAssertOK(indexerAppendResult)
        
        
        
        let indexerCommitResult: GitErrorCode = gitIndexerCommit(
            idx:    indexerPointer,
            stats:  &indexerProgress
        )
        
        XCTAssertOK(indexerCommitResult)
        XCTAssertGreaterThan(indexerProgress.indexedObjects, 0)
        
        
        
        let packfileName: String? = gitIndexerName(idx: indexerPointer)
        
        XCTAssertNotNil(packfileName)
        XCTAssertFalse(packfileName?.isEmpty ?? true)
        
        
        
        let packfileOID: GitOID? = gitIndexerHash(idx: indexerPointer)
        
        XCTAssertNotNil(packfileOID)
        XCTAssertNotZeroOID(packfileOID)
    }
}
