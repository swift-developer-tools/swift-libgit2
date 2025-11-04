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



final class MidxAdvancedTests: XCTestCaseStopOnFail
{
    func testGitMidxWriterAdd() throws
    {
        try withMidxWriter
        {
            repository, midxWriterPointer in
            
            try repository.commit(
                "File content",
                toFile:     "file.txt",
                message:    "File commit"
            )
            
            
            
            let packfileData: Data = try repository.createPackfileData()
            
            let indexURL: URL = try repository.validatePackfileData(
                packfileData,
                options: nil
            )
            
            
            
            let midxWriterAddResult: GitErrorCode = gitMidxWriterAdd(
                w:          midxWriterPointer,
                idxPath:    indexURL.path()
            )
            
            XCTAssertOK(midxWriterAddResult)
        }
    }
    
    
    
    func testGitMidxWriterCommit() throws
    {
        try withMidxWriter
        {
            _, midxWriterPointer in
            
            let midxWriterCommitResult: GitErrorCode
                = gitMidxWriterCommit(w: midxWriterPointer)
            
            XCTAssertOK(midxWriterCommitResult)
        }
    }
    
    
    
    func testGitMidxWriterDump() throws
    {
        try withMidxWriter
        {
            _, midxWriterPointer in
            
            var midxData = Data()
            
            let midxWriterDumpResult: GitErrorCode = gitMidxWriterDump(
                midx:   &midxData,
                w:      midxWriterPointer
            )
            
            XCTAssertOK(midxWriterDumpResult)
            XCTAssertGreaterThan(midxData.count, 0)
        }
    }
    
    
    
    func testGitMidxWriterFree() throws
    {
        gitMidxWriterFree(w: nil)
    }
    
    
    
    func testGitMidxWriterNew() throws
    {
        try withMidxWriter
        {
            _, _ in
        }
    }
}



// MARK: - Extensions

private extension MidxAdvancedTests
{
    /// Calls the given closure with ``Repository`` instance and a pointer
    /// to a multi-pack index writer.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withMidxWriter(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var midxWriterPointer: OpaquePointer? = nil
            
            defer
            {
                gitMidxWriterFree(w: midxWriterPointer)
            }
            
            
            
            let packfileData: Data = try repository.createPackfileData()
            
            let indexURL: URL = try repository.validatePackfileData(
                packfileData,
                options: nil
            )
            
            
            
            let midxWriterNewResult: GitErrorCode = gitMidxWriterNew(
                out:        &midxWriterPointer,
                packDir:    indexURL.deletingLastPathComponent().path()
            )
            
            XCTAssertOK(midxWriterNewResult)
            
            guard let midxWriterPointer
            else
            {
                XCTFail("The multi-pack index writer pointer was nil.")
                return
            }
            
            
            
            try body(
                repository,
                midxWriterPointer
            )
        }
    }
}
