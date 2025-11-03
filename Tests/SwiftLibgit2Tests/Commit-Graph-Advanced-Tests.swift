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



final class CommitGraphAdvancedTests: XCTestCaseStopOnFail
{
    func testGitCommitGraphFree() throws
    {
        gitCommitGraphFree(cGraph: nil)
    }
    
    
    
    func testGitCommitGraphOpen() throws
    {
        try withCommitGraph
        {
            _, _ in
        }
    }
    
    
    
    func testGitCommitGraphSplitStrategyT() throws
    {
        XCTAssertEqual(GitCommitGraphSplitStrategyT.gitCommitGraphSplitStrategySingleFile.rawValue, GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE.rawValue)
        
        XCTAssertNil(GitCommitGraphSplitStrategyT(rawValue: 123))
        
        XCTAssertEqual(GitCommitGraphSplitStrategyT.gitCommitGraphSplitStrategySingleFile.cValue(), GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE)
        
        XCTAssertEqual(GitCommitGraphSplitStrategyT(cValue: GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE), .gitCommitGraphSplitStrategySingleFile)
    }
    
    
    
    func testGitCommitGraphWriterDump() throws
    {
        try withCommitGraphWriter
        {
            _, writerPointer in
            
            var buffer = Data()
            
            let writeDumpResult: GitErrorCode = gitCommitGraphWriterDump(
                buffer:     &buffer,
                w:          writerPointer
            )
            
            XCTAssertOK(writeDumpResult)
            XCTAssertGreaterThan(buffer.count, 0)
        }
    }
    
    
    
    func testGitCommitGraphWriterFree() throws
    {
        gitCommitGraphWriterFree(w: nil)
    }
    
    
    
    func testGitCommitGraphWriterNewAddIndexFile() throws
    {
        try withCommitGraphWriter
        {
            repository, writerPointer in
            
            let packfileData: Data = try repository.createPackfileData()
            
            let indexURL: URL = try repository.validatePackfileData(
                packfileData,
                deleteIndexer: false
            )
            
            defer
            {
                try? FileManager.default.removeItem(
                    at: indexURL.deletingLastPathComponent()
                )
            }
            
            
            
            let writerAddIndexFileResult: GitErrorCode
                = gitCommitGraphWriterAddIndexFile(
                    w:          writerPointer,
                    repo:       repository.pointer,
                    idxPath:    indexURL.path()
                )
            
            XCTAssertOK(writerAddIndexFileResult)
        }
    }
    
    
    
    func testGitCommitGraphWriterNewAddRevwalkAndCommit() throws
    {
        try withCommitGraphWriter
        {
            _, _ in
        }
    }
    
    
    
    func testGitCommitGraphWriterOptions() throws
    {
        let commitGraphWriterOptions = GitCommitGraphWriterOptions()
        
        XCTAssertEqual(commitGraphWriterOptions.version, gitCommitGraphWriterOptionsVersion)
        XCTAssertEqual(commitGraphWriterOptions.splitStategy, .gitCommitGraphSplitStrategySingleFile)
        XCTAssertEqual(commitGraphWriterOptions.sizeMultiple, 2)
        XCTAssertEqual(commitGraphWriterOptions.maxCommits, 64_000)
        
        try commitGraphWriterOptions.withCValue
        {
            cCommitGraphWriterOptions in
            
            XCTAssertEqual(cCommitGraphWriterOptions.pointee.version, gitCommitGraphWriterOptionsVersion)
            XCTAssertEqual(GitCommitGraphSplitStrategyT(cValue: cCommitGraphWriterOptions.pointee.split_strategy), .gitCommitGraphSplitStrategySingleFile)
            XCTAssertEqual(cCommitGraphWriterOptions.pointee.size_multiple, 2)
            XCTAssertEqual(cCommitGraphWriterOptions.pointee.max_commits, 64_000)
        }
    }
    
    
    
    func testGitCommitGraphWriterOptionsInit() throws
    {
        var commitGraphWriterOptions = git_commit_graph_writer_options()
        
        let commitGraphWriterOptionsInitResult: GitErrorCode
            = gitCommitGraphWriterOptionsInit(
                opts:       &commitGraphWriterOptions,
                version:    gitCommitGraphWriterOptionsVersion
            )
        
        XCTAssertOK(commitGraphWriterOptionsInitResult)
    }
    
    
    
    func testGitCommitGraphWriterOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitCommitGraphWriterOptionsVersion), GIT_COMMIT_GRAPH_WRITER_OPTIONS_VERSION)
    }
}



// MARK: - Extensions

private extension CommitGraphAdvancedTests
{
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a commit graph.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withCommitGraph(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try withCommitGraphWriter
        {
            repository, writerPointer in
            
            var commitGraphPointer: OpaquePointer? = nil
            
            defer
            {
                gitCommitGraphFree(cGraph: commitGraphPointer)
            }
            
            
            
            let graphOpenResult: GitErrorCode = gitCommitGraphOpen(
                cGraphOut:      &commitGraphPointer,
                objectsDir:     repository.objectsURL.path()
            )
            
            XCTAssertOK(graphOpenResult)
            
            guard let commitGraphPointer: OpaquePointer = commitGraphPointer
            else
            {
                XCTFail("The commit graph pointer was nil.")
                return
            }
            
            
            
            try body(
                repository,
                commitGraphPointer
            )
        }
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a commit graph writer.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withCommitGraphWriter(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            var revwalkPointer  : OpaquePointer?    = nil
            var writerPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitRevwalkFree(walk: revwalkPointer)
                gitCommitGraphWriterFree(w: writerPointer)
            }
            
            
            
            let revwalkNewResult: GitErrorCode = gitRevwalkNew(
                out:    &revwalkPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(revwalkNewResult)
            
            guard let revwalkPointer: OpaquePointer = revwalkPointer
            else
            {
                XCTFail("The revwalk pointer was nil.")
                return
            }
            
            
            
            let writerNewResult: GitErrorCode = gitCommitGraphWriterNew(
                out:                &writerPointer,
                objectsInfoDir:     repository.objectsInfoURL.path(),
                options:            nil
            )
            
            XCTAssertOK(writerNewResult)
            
            guard let writerPointer: OpaquePointer = writerPointer
            else
            {
                XCTFail("The commit graph writer pointer was nil.")
                return
            }
            
            
            
            let revwalkPushHEADResult: GitErrorCode
                = gitRevwalkPushHEAD(walk: revwalkPointer)
            
            XCTAssertOK(revwalkPushHEADResult)
            
            
            
            let writerAddRevwalkResult: GitErrorCode
                = gitCommitGraphWriterAddRevwalk(
                    w:      writerPointer,
                    walk:   revwalkPointer
                )
            
            XCTAssertOK(writerAddRevwalkResult)
            
            
            
            let writerCommitResult: GitErrorCode
                = gitCommitGraphWriterCommit(w: writerPointer)
            
            XCTAssertOK(writerCommitResult)
            
            
            
            try body(
                repository,
                writerPointer
            )
        }
    }
}
