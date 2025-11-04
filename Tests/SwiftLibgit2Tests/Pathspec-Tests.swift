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



final class PathspecTests: XCTestCaseStopOnFail
{
    func testGitPathspecFree() throws
    {
        gitPathspecFree(ps: nil)
    }
    
    
    
    func testGitPathspecFlagT() throws
    {
        XCTAssertEqual(GitPathspecFlagT.gitPathspecDefault.rawValue, GIT_PATHSPEC_DEFAULT.rawValue)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecIgnoreCase.rawValue, GIT_PATHSPEC_IGNORE_CASE.rawValue)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecUseCase.rawValue, GIT_PATHSPEC_USE_CASE.rawValue)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecNoGlob.rawValue, GIT_PATHSPEC_NO_GLOB.rawValue)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecNoMatchError.rawValue, GIT_PATHSPEC_NO_MATCH_ERROR.rawValue)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecFindFailures.rawValue, GIT_PATHSPEC_FIND_FAILURES.rawValue)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecFailuresOnly.rawValue, GIT_PATHSPEC_FAILURES_ONLY.rawValue)
        
        XCTAssertEqual(GitPathspecFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitPathspecFlagT.gitPathspecDefault.cValue(), GIT_PATHSPEC_DEFAULT)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecIgnoreCase.cValue(), GIT_PATHSPEC_IGNORE_CASE)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecUseCase.cValue(), GIT_PATHSPEC_USE_CASE)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecNoGlob.cValue(), GIT_PATHSPEC_NO_GLOB)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecNoMatchError.cValue(), GIT_PATHSPEC_NO_MATCH_ERROR)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecFindFailures.cValue(), GIT_PATHSPEC_FIND_FAILURES)
        XCTAssertEqual(GitPathspecFlagT.gitPathspecFailuresOnly.cValue(), GIT_PATHSPEC_FAILURES_ONLY)
        
        XCTAssertEqual(GitPathspecFlagT(cValue: GIT_PATHSPEC_DEFAULT), .gitPathspecDefault)
        XCTAssertEqual(GitPathspecFlagT(cValue: GIT_PATHSPEC_IGNORE_CASE), .gitPathspecIgnoreCase)
        XCTAssertEqual(GitPathspecFlagT(cValue: GIT_PATHSPEC_USE_CASE), .gitPathspecUseCase)
        XCTAssertEqual(GitPathspecFlagT(cValue: GIT_PATHSPEC_NO_GLOB), .gitPathspecNoGlob)
        XCTAssertEqual(GitPathspecFlagT(cValue: GIT_PATHSPEC_NO_MATCH_ERROR), .gitPathspecNoMatchError)
        XCTAssertEqual(GitPathspecFlagT(cValue: GIT_PATHSPEC_FIND_FAILURES), .gitPathspecFindFailures)
        XCTAssertEqual(GitPathspecFlagT(cValue: GIT_PATHSPEC_FAILURES_ONLY), .gitPathspecFailuresOnly)
        
        
        
        let flags: GitPathspecFlagT =
        [
            .gitPathspecIgnoreCase,
            .gitPathspecUseCase
        ]
        
        XCTAssertTrue(flags.contains(.gitPathspecIgnoreCase))
        XCTAssertTrue(flags.contains(.gitPathspecUseCase))
        XCTAssertFalse(flags.contains(.gitPathspecNoGlob))
    }
    
    
    
    func testGitPathspecMatchDiffAndListDiffEntry() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let oldCommitOID: GitOID = try repository.commit(
                "File1 content",
                toFile:     "file1.txt",
                message:    "Add file1"
            )
            
            try repository.commit(
                "Updated file1 content",
                toFile:     "file1.txt",
                message:    "Modify file1"
            )
            
            let newCommitOID: GitOID = try repository.commit(
                "File2 content",
                toFile:     "file2.md",
                message:    "Add file2"
            )
            
            
            
            var matchListPointer: OpaquePointer? = nil
            
            defer
            {
                gitPathspecMatchListFree(m: matchListPointer)
            }
            
            
            
            try Diff.withTreeToTreeDiff(
                in:             repository,
                oldCommitOID:   oldCommitOID,
                newCommitOID:   newCommitOID
            )
            {
                diffPointer in
                
                try withPathspec
                {
                    pathspecPointer in
                    
                    let pathspecMatchDiffResult: GitErrorCode
                        = gitPathspecMatchDiff(
                            out:    &matchListPointer,
                            diff:   diffPointer,
                            flags:  .gitPathspecDefault,
                            ps:     pathspecPointer
                        )
                    
                    XCTAssertOK(pathspecMatchDiffResult)
                }
                
                
                
                /// The match list contains pointers to the data owned by the
                /// diff. Validate the match list within the closure to avoid
                /// accessing freed memory.
                try validateMatchList(
                    matchListPointer,
                    expectedMatches:    ["file1.txt", "file2.md"],
                    expectDiffEntries:  true
                )
            }
        }
    }
    
    
    
    func testGitPathspecMatchesPath() throws
    {
        try withPathspec(pathspec: ["*.txt", "docs/*.md"])
        {
            pathspecPointer in
            
            var pathspecMatches: Bool = gitPathspecMatchesPath(
                ps:     pathspecPointer,
                flags:  .gitPathspecDefault,
                path:   "test.txt"
            )
            
            XCTAssertTrue(pathspecMatches)
            
            
            
            pathspecMatches = gitPathspecMatchesPath(
                ps:     pathspecPointer,
                flags:  .gitPathspecIgnoreCase,
                path:   "TEST.TXT"
            )
            
            XCTAssertTrue(pathspecMatches)
            
            
            
            pathspecMatches = gitPathspecMatchesPath(
                ps:     pathspecPointer,
                flags:  .gitPathspecDefault,
                path:   "docs/README.md"
            )
            
            XCTAssertTrue(pathspecMatches)
            
            
            
            pathspecMatches = gitPathspecMatchesPath(
                ps:     pathspecPointer,
                flags:  .gitPathspecIgnoreCase,
                path:   "DOCS/README.md"
            )
            
            XCTAssertTrue(pathspecMatches)
            
            
            
            pathspecMatches = gitPathspecMatchesPath(
                ps:     pathspecPointer,
                flags:  .gitPathspecDefault,
                path:   "test.swift"
            )
            
            XCTAssertFalse(pathspecMatches)
        }
    }
    
    
    
    func testGitPathspecMatchIndex() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            let files: [String : String] =
            [
                "file1.txt"     : "Content 1",
                "file2.md"      : "Content 2",
                "file3.swift"   : "Content 3"
            ]
            
            for (fileName, content) in files
            {
                try repository.modifyFile(
                    at:     fileName,
                    with:   content
                )
                
                let addByPathResult: GitErrorCode = gitIndexAddByPath(
                    index:  indexPointer,
                    path:   fileName
                )
                
                XCTAssertOK(addByPathResult)
            }
            
            
            
            var matchListPointer: OpaquePointer? = nil
            
            defer
            {
                gitPathspecMatchListFree(m: matchListPointer)
            }
            
            
            
            try withPathspec
            {
                pathspecPointer in
                
                let pathspecMatchIndexResult: GitErrorCode
                    = gitPathspecMatchIndex(
                        out:    &matchListPointer,
                        index:  indexPointer,
                        flags:  .gitPathspecDefault,
                        ps:     pathspecPointer
                    )
                
                XCTAssertOK(pathspecMatchIndexResult)
            }
            
            
            
            try validateMatchList(
                matchListPointer,
                expectedMatches:    ["file1.txt", "file2.md"],
                expectDiffEntries:  false
            )
        }
    }
    
    
    
    func testGitPathspecMatchListFailedEntry() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let existingFilename: String = "exists.txt"
            
            try repository.modifyFile(
                at:     existingFilename,
                with:   "This file exists"
            )
            
            var matchListPointer: OpaquePointer? = nil
            
            defer
            {
                gitPathspecMatchListFree(m: matchListPointer)
            }
            
            
            
            let pathspec: [String] =
            [
                existingFilename,
                "missing.txt",
                "missing.md"
            ]
            
            try withPathspec(pathspec: pathspec)
            {
                pathspecPointer in
                
                let pathspecMatchWorkdirResult: GitErrorCode
                    = gitPathspecMatchWorkdir(
                        out:    &matchListPointer,
                        repo:   repository.pointer,
                        flags:  .gitPathspecFindFailures,
                        ps:     pathspecPointer
                    )
                
                XCTAssertOK(pathspecMatchWorkdirResult)
            }
            
            guard let matchListPointer
            else
            {
                XCTFail("The match list pointer was nil.")
                return
            }
            
            
            
            let failedEntryCount: Int
                = gitPathspecMatchListFailedEntryCount(m: matchListPointer)
            
            XCTAssertGreaterThanOrEqual(failedEntryCount, 2)
            
            
            
            var failedEntryFilenames: [String] = []
            
            for index in 0..<failedEntryCount
            {
                if let failedEntryFilename: String
                    = gitPathspecMatchListFailedEntry(
                        m:      matchListPointer,
                        pos:    index
                    )
                {
                    failedEntryFilenames.append(failedEntryFilename)
                }
            }
            
            XCTAssertTrue(failedEntryFilenames.contains(pathspec[1]))
            XCTAssertTrue(failedEntryFilenames.contains(pathspec[2]))
        }
    }
    
    
    
    func testGitPathspecMatchListFree() throws
    {
        gitPathspecMatchListFree(m: nil)
    }
    
    
    
    func testGitPathspecMatchTree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.commit(
                "Tree 1 content",
                toFile:     "tree1.txt",
                message:    "Add Tree 1"
            )
            
            try repository.commit(
                "Tree 2 content",
                toFile:     "tree2.md",
                message:    "Add Tree 2"
            )
            
            
            
            var treePointer         : OpaquePointer?    = nil
            var matchListPointer    : OpaquePointer?    = nil
            
            defer
            {
                gitTreeFree(tree: treePointer)
                gitPathspecMatchListFree(m: matchListPointer)
            }
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let commitTreeResult: GitErrorCode = gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
                
                XCTAssertOK(commitTreeResult)
            }
            
            guard let treePointer
            else
            {
                XCTFail("The tree pointer was nil.")
                return
            }
            
            
            
            try withPathspec
            {
                pathspecPointer in
                
                let pathspecMatchTreeResult: GitErrorCode
                    = gitPathspecMatchTree(
                        out:    &matchListPointer,
                        tree:   treePointer,
                        flags:  .gitPathspecDefault,
                        ps:     pathspecPointer
                    )
                
                XCTAssertOK(pathspecMatchTreeResult)
            }
            
            
            
            try validateMatchList(
                matchListPointer,
                expectedMatches:    ["tree1.txt", "tree2.md"],
                expectDiffEntries:  false
            )
        }
    }
    
    
    
    func testGitPathspecMatchWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let files: [String : String] =
            [
                "file1.txt"     : "Content 1",
                "file2.md"      : "Content 2",
                "file3.swift"   : "Content 3"
            ]
            
            for (fileName, content) in files
            {
                try repository.modifyFile(
                    at:     fileName,
                    with:   content
                )
            }
            
            
            
            var matchListPointer: OpaquePointer? = nil
            
            defer
            {
                gitPathspecMatchListFree(m: matchListPointer)
            }
            
            
            
            try withPathspec
            {
                pathspecPointer in
                
                let pathspecMatchWorkdirResult: GitErrorCode
                    = gitPathspecMatchWorkdir(
                        out:    &matchListPointer,
                        repo:   repository.pointer,
                        flags:  .gitPathspecDefault,
                        ps:     pathspecPointer
                    )
                
                XCTAssertOK(pathspecMatchWorkdirResult)
            }
            
            
            
            try validateMatchList(
                matchListPointer,
                expectedMatches:    ["file1.txt", "file2.md"],
                expectDiffEntries:  false
            )
        }
    }
    
    
    
    func testGitPathspecNew() throws
    {
        try withPathspec
        {
            _ in
        }
    }
}



// MARK: - Extensions

private extension PathspecTests
{
    /// Calls the given closure with a pointer to a pathspec.
    /// - Parameters:
    ///   - pathspec: The pathspecs to use.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withPathspec(
        pathspec    : [String] = ["*.txt", "*.md"],
        _ body      : (OpaquePointer) throws -> Void
    ) throws
    {
        var pathspecPointer: OpaquePointer? = nil
        
        defer
        {
            gitPathspecFree(ps: pathspecPointer)
        }
        
        
        
        let pathspecNewResult: GitErrorCode = gitPathspecNew(
            out:        &pathspecPointer,
            pathspec:   pathspec
        )
        
        XCTAssertOK(pathspecNewResult)
        
        guard let pathspecPointer
        else
        {
            XCTFail("The pathspec pointer was nil.")
            return
        }
        
        try body(pathspecPointer)
    }
    
    
    
    /// Validates the contents of the given pathspec match list.
    /// - Parameters:
    ///   - matchListPointer: The pathspec match list to validate. The
    ///   underlying type must be `git_pathspec_match_list`.
    ///   - expectedMatches: The expcted matching file names.
    ///   - expectDiffEntries: Whether to expect diff entries instead of
    ///   file names.
    /// - Throws: An error if an operation fails.
    func validateMatchList(
        _ matchListPointer  : OpaquePointer?,
        expectedMatches     : [String],
        expectDiffEntries   : Bool
    ) throws
    {
        guard let matchListPointer
        else
        {
            XCTFail("The match list pointer was nil.")
            return
        }
        
        
        
        let entryCount: Int
            = gitPathspecMatchListEntryCount(m: matchListPointer)
        
        XCTAssertGreaterThanOrEqual(entryCount, expectedMatches.count)
        
        
        
        var fileNames: [String] = []
        
        for index in 0..<entryCount
        {
            if expectDiffEntries
            {
                let diffDelta: GitDiffDelta? = gitPathspecMatchListDiffEntry(
                    m:      matchListPointer,
                    pos:    index
                )
                
                XCTAssertNotNil(diffDelta)
                continue
            }
            
            
            
            guard let fileName: String = gitPathspecMatchListEntry(
                m:      matchListPointer,
                pos:    index
            )
            else
            {
                XCTFail("The file name was nil.")
                return
            }
            
            fileNames.append(fileName)
        }
        
        
        
        if !expectDiffEntries
        {
            XCTAssertGreaterThanOrEqual(fileNames.count, expectedMatches.count)
            
            for expectedMatch in expectedMatches
            {
                XCTAssertTrue(fileNames.contains(expectedMatch))
            }
        }
    }
}
