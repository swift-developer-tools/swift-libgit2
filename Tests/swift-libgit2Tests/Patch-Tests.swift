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



final class PatchTests: XCTestCaseStopOnFail
{
    func testGitPatchFree() throws
    {
        gitPatchFree(patch: nil)
    }
    
    
    
    func testGitPatchFromBlobAndBuffer() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobPointer     : OpaquePointer?    = nil
            var patchPointer    : OpaquePointer?    = nil
            
            defer
            {
                gitBlobFree(blob: blobPointer)
                gitPatchFree(patch: patchPointer)
            }
            
            
            
            let blobData = Data("Blob content".utf8)
            
            let blobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: blobData)
            )
            
            
            
            let blobLookupResult: GitErrorCode = gitBlobLookup(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            XCTAssertNotNil(blobPointer)
            
            
            
            let buffer = Data("Buffer content".utf8)
            
            let patchFromBlobAndBufferResult: GitErrorCode
                = gitPatchFromBlobAndBuffer(
                    out:            &patchPointer,
                    oldBlob:        blobPointer,
                    oldAsPath:      "blob.txt",
                    buffer:         buffer,
                    bufferLen:      buffer.count,
                    bufferAsPath:   "buffer.txt",
                    opts:           nil
                )
            
            XCTAssertOK(patchFromBlobAndBufferResult)
            XCTAssertNotNil(patchPointer)
        }
    }
    
    
    
    func testGitPatchFromBlobs() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var oldBlobPointer  : OpaquePointer?    = nil
            var newBlobPointer  : OpaquePointer?    = nil
            var patchPointer    : OpaquePointer?    = nil
            
            defer
            {
                gitBlobFree(blob: oldBlobPointer)
                gitBlobFree(blob: newBlobPointer)
                gitPatchFree(patch: patchPointer)
            }
            
            
            
            let oldBlobData     = Data("Old blob content".utf8)
            let newBlobData     = Data("New blob content".utf8)
            
            let oldBlobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: oldBlobData)
            )
            
            let newBlobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: newBlobData)
            )
            
            
            
            let oldBlobLookupResult: GitErrorCode = gitBlobLookup(
                blob:   &oldBlobPointer,
                repo:   repository.pointer,
                id:     oldBlobOID
            )
            
            XCTAssertOK(oldBlobLookupResult)
            XCTAssertNotNil(oldBlobPointer)
            
            
            
            let newBlobLookupResult: GitErrorCode = gitBlobLookup(
                blob:   &newBlobPointer,
                repo:   repository.pointer,
                id:     newBlobOID
            )
            
            XCTAssertOK(newBlobLookupResult)
            XCTAssertNotNil(newBlobPointer)
            
            
            
            let patchFromBlobsResult: GitErrorCode = gitPatchFromBlobs(
                out:        &patchPointer,
                oldBlob:    oldBlobPointer,
                oldAsPath:  "old.txt",
                newBlob:    newBlobPointer,
                newAsPath:  "new.txt",
                opts:       nil
            )
            
            XCTAssertOK(patchFromBlobsResult)
            XCTAssertNotNil(patchPointer)
        }
    }
    
    
    
    func testGitPatchFromBuffers() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var patchPointer: OpaquePointer? = nil
            
            defer
            {
                gitPatchFree(patch: patchPointer)
            }
            
            
            
            let oldBufferData   = Data("Old buffer content".utf8)
            let newBufferData   = Data("New buffer content".utf8)
            
            let patchFromBuffersResult: GitErrorCode = gitPatchFromBuffers(
                out:            &patchPointer,
                oldBuffer:      oldBufferData,
                oldBufferLen:   oldBufferData.count,
                oldAsPath:      "old.txt",
                newBuffer:      newBufferData,
                newBufferLen:   newBufferData.count,
                newAsPath:      "new.txt",
                opts:           nil
            )
            
            XCTAssertOK(patchFromBuffersResult)
            XCTAssertNotNil(patchPointer)
        }
    }
    
    
    
    func testGitPatchFromDiff() throws
    {
        try withPatchPointer
        {
            _ in
        }
    }
    
    
    
    func testGitPatchGetHunkAndLineInHunk() throws
    {
        try withPatchPointer
        {
            patchPointer in
            
            var diffHunk    : GitDiffHunk   = GitDiffHunk()
            var linesInHunk : Int           = 0
            
            let patchGetHunkResult: GitErrorCode = gitPatchGetHunk(
                out:            &diffHunk,
                linesInHunk:    &linesInHunk,
                patch:          patchPointer,
                hunkIdx:        0
            )
            
            XCTAssertOK(patchGetHunkResult)
            XCTAssertGreaterThan(linesInHunk, 0)
            
            
            
            let numLines: Int32 = gitPatchNumLinesInHunk(
                patch:      patchPointer,
                hunkIdx:    0
            )
            
            XCTAssertGreaterThan(numLines, 0)
            XCTAssertEqual(Int(numLines), linesInHunk)
            
            
            
            var diffLine = GitDiffLine()
            
            let patchGetLineInHunkResult: GitErrorCode = gitPatchGetLineInHunk(
                out:            &diffLine,
                patch:          patchPointer,
                hunkIdx:        0,
                lineOfHunk:     0
            )
            
            XCTAssertOK(patchGetLineInHunkResult)
        }
    }
    
    
    
    func testGitPatchLineStats() throws
    {
        try withPatchPointer
        {
            patchPointer in
            
            var totalContext    : Int = 0
            var totalAdditions  : Int = 0
            var totalDeletions  : Int = 0
            
            let patchLineStatsResult: GitErrorCode = gitPatchLineStats(
                totalContext:       &totalContext,
                totalAdditions:     &totalAdditions,
                totalDeletions:     &totalDeletions,
                patch:              patchPointer
            )
            
            XCTAssertOK(patchLineStatsResult)
            XCTAssertGreaterThanOrEqual(totalContext, 0)
            XCTAssertGreaterThanOrEqual(totalAdditions, 0)
            XCTAssertGreaterThanOrEqual(totalDeletions, 0)
        }
    }
    
    
    
    func testGitPatchPrint() throws
    {
        try withPatchPointer
        {
            patchPointer in
            
            var callbackData = CallbackData()
            
            let diffLineCB: GitDiffLineCB =
            {
                delta, hunk, line, payload in
                
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
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let patchPrintResult: GitErrorCode = gitPatchPrint(
                    patch:      patchPointer,
                    printCB:    diffLineCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(patchPrintResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
        }
    }
    
    
    
    func testGitPatchSize() throws
    {
        try withPatchPointer
        {
            patchPointer in
            
            let sizeWithAll: Int = gitPatchSize(
                patch:                  patchPointer,
                includeContext:         true,
                includeHunkHeaders:     true,
                includeFileHeaders:     true
            )
            
            XCTAssertGreaterThan(sizeWithAll, 0)
            
            
            
            let sizeWithoutContext: Int = gitPatchSize(
                patch:                  patchPointer,
                includeContext:         false,
                includeHunkHeaders:     true,
                includeFileHeaders:     true
            )
            
            XCTAssertGreaterThanOrEqual(sizeWithoutContext, 0)
            XCTAssertLessThanOrEqual(sizeWithoutContext, sizeWithAll)
        }
    }
    
    
    
    func testGitPatchToBuf() throws
    {
        try withPatchPointer
        {
            patchPointer in
            
            var patchData = Data()
            
            let patchToBufResult: GitErrorCode = gitPatchToBuf(
                out:    &patchData,
                patch:  patchPointer
            )
            
            XCTAssertOK(patchToBufResult)
            XCTAssertGreaterThan(patchData.count, 0)
            
            
            
            let patchString: String? = String(
                data:       patchData,
                encoding:   .utf8
            )
            
            XCTAssertNotNil(patchString)
        }
    }
}



// MARK: - Extensions

private extension PatchTests
{
    struct CallbackData
    {
        var callCount: Int = 0
    }
    
    
    
    /// Calls the given closure with a pointer to a patch.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withPatchPointer(
        _ body: (OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiffPointer(in: repository)
            {
                diffPointer in
                
                var patchPointer: OpaquePointer? = nil
                
                defer
                {
                    gitPatchFree(patch: patchPointer)
                }
                
                
                
                let patchFromDiffResult: GitErrorCode = gitPatchFromDiff(
                    out:    &patchPointer,
                    diff:   diffPointer,
                    idx:    0
                )
                
                XCTAssertOK(patchFromDiffResult)
                
                guard let patchPointer: OpaquePointer = patchPointer
                else
                {
                    throw NSError.makeError("The patch pointer was nil.")
                }
                
                
                
                let ownerPointer: OpaquePointer
                    = gitPatchOwner(patch: patchPointer)
                
                XCTAssertEqual(ownerPointer, repository.pointer)
                
                
                
                let diffDelta: GitDiffDelta?
                    = gitPatchGetDelta(patch: patchPointer)
                
                XCTAssertNotNil(diffDelta)
                XCTAssertNotNil(diffDelta?.oldFile.path)
                XCTAssertNotNil(diffDelta?.newFile.path)
                
                
                
                let numHunks: Int = gitPatchNumHunks(patch: patchPointer)
                
                XCTAssertGreaterThan(numHunks, 0)
                
                
                
                return try body(patchPointer)
            }
        }
    }
}
