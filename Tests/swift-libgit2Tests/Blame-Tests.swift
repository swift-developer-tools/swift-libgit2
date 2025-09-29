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



final class BlameTests: XCTestCaseStopOnFail
{
    func testGitBlameBuffer() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var baseBlamePointer    : OpaquePointer?    = nil
            var bufferBlamePointer  : OpaquePointer?    = nil
            
            defer
            {
                Free.freeBlame(baseBlamePointer)
                Free.freeBlame(bufferBlamePointer)
            }
            
            
            
            let blameFileResult: Int32 = gitBlameFile(
                out:        &baseBlamePointer,
                repo:       repository.pointer,
                path:       Repository.blameFileName,
                options:    nil
            )
            
            XCTAssertOK(blameFileResult)
            
            guard let baseBlamePointer: OpaquePointer = baseBlamePointer
            else
            {
                XCTFail("The base blame pointer was nil.")
                return
            }
            
            
            
            let bufferContent: String = "Buffer content\n"
            
            let blameBufferResult: Int32 = gitBlameBuffer(
                out:        &bufferBlamePointer,
                base:       baseBlamePointer,
                buffer:     bufferContent,
                bufferLen:  bufferContent.utf8.count
            )
            
            XCTAssertOK(blameBufferResult)
            XCTAssertNotNil(bufferBlamePointer)
        }
    }
    
    
    
    func testGitBlameFile() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blamePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeBlame(blamePointer)
            }
            
            
            
            let blameOptions = GitBlameOptions()
            
            var blameFileResult: Int32 = gitBlameFile(
                out:        &blamePointer,
                repo:       repository.pointer,
                path:       Repository.blameFileName,
                options:    blameOptions
            )
            
            XCTAssertOK(blameFileResult)
            
            
            
            blameFileResult = gitBlameFile(
                out:        &blamePointer,
                repo:       repository.pointer,
                path:       Repository.blameFileName,
                options:    nil
            )
            
            XCTAssertOK(blameFileResult)
            
            guard let blamePointer: OpaquePointer = blamePointer
            else
            {
                XCTFail("The blame pointer was nil.")
                return
            }
            
            
            
            let lineCount   : Int   = gitBlameLineCount(blame: blamePointer)
            let hunkCount   : Int   = gitBlameHunkCount(blame: blamePointer)
            
            XCTAssertGreaterThan(lineCount, 0)
            XCTAssertGreaterThan(hunkCount, 0)
            
            
            
            let firstHunk: GitBlameHunk? = gitBlameHunkByIndex(
                blame:  blamePointer,
                index:  0
            )
            
            guard let firstHunk: GitBlameHunk = firstHunk
            else
            {
                XCTFail("The first hunk was nil.")
                return
            }
            
            XCTAssertGreaterThan(firstHunk.linesInHunk, 0)
            XCTAssertGreaterThanOrEqual(firstHunk.finalStartLineNumber, 0)
            XCTAssertGreaterThanOrEqual(firstHunk.origStartLineNumber, 0)
            
            
            
            let hunkForFirstLine: GitBlameHunk? = gitBlameHunkByLine(
                blame:      blamePointer,
                lineNo:     1
            )
            
            XCTAssertNotNil(hunkForFirstLine)
            
            
            
            let firstLine: GitBlameLine? = gitBlameLineByIndex(
                blame:  blamePointer,
                idx:    1
            )
            
            guard let firstLine: GitBlameLine = firstLine
            else
            {
                XCTFail("The first line was nil.")
                return
            }
            
            XCTAssertGreaterThan(firstLine.len, 0)
            
            
            
            let invalidHunk: GitBlameHunk? = gitBlameHunkByIndex(
                blame:  blamePointer,
                index:  hunkCount + 10
            )
            
            XCTAssertNil(invalidHunk)
            
            
            
            let invalidLine: GitBlameLine? = gitBlameLineByIndex(
                blame:  blamePointer,
                idx:    hunkCount + 10
            )
            
            XCTAssertNil(invalidLine)
        }
    }
    
    
    
    func testGitBlameFlagT() throws
    {
        XCTAssertEqual(GitBlameFlagT.gitBlameNormal.rawValue, GIT_BLAME_NORMAL.rawValue)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesSameFile.rawValue, GIT_BLAME_TRACK_COPIES_SAME_FILE.rawValue)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesSameCommitMoves.rawValue, GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES.rawValue)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesSameCommitCopies.rawValue, GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES.rawValue)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesAnyCommitCopies.rawValue, GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES.rawValue)
        XCTAssertEqual(GitBlameFlagT.gitBlameFirstParent.rawValue, GIT_BLAME_FIRST_PARENT.rawValue)
        XCTAssertEqual(GitBlameFlagT.gitBlameUseMailmap.rawValue, GIT_BLAME_USE_MAILMAP.rawValue)
        XCTAssertEqual(GitBlameFlagT.gitBlameIgnoreWhitespace.rawValue, GIT_BLAME_IGNORE_WHITESPACE.rawValue)
        
        XCTAssertEqual(GitBlameFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitBlameFlagT.gitBlameNormal.cValue(), GIT_BLAME_NORMAL)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesSameFile.cValue(), GIT_BLAME_TRACK_COPIES_SAME_FILE)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesSameCommitMoves.cValue(), GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesSameCommitCopies.cValue(), GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES)
        XCTAssertEqual(GitBlameFlagT.gitBlameTrackCopiesAnyCommitCopies.cValue(), GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES)
        XCTAssertEqual(GitBlameFlagT.gitBlameFirstParent.cValue(), GIT_BLAME_FIRST_PARENT)
        XCTAssertEqual(GitBlameFlagT.gitBlameUseMailmap.cValue(), GIT_BLAME_USE_MAILMAP)
        XCTAssertEqual(GitBlameFlagT.gitBlameIgnoreWhitespace.cValue(), GIT_BLAME_IGNORE_WHITESPACE)
        
        
        
        let flags: GitBlameFlagT =
        [
            .gitBlameUseMailmap,
            .gitBlameIgnoreWhitespace
        ]
        
        XCTAssertTrue(flags.contains(.gitBlameUseMailmap))
        XCTAssertTrue(flags.contains(.gitBlameIgnoreWhitespace))
        XCTAssertFalse(flags.contains(.gitBlameTrackCopiesSameFile))
    }
    
    
    
    func testGitBlameOptions() throws
    {
        var blameOptions = GitBlameOptions()
        
        XCTAssertEqual(blameOptions.version, gitBlameOptionsVersion)
        XCTAssertEqual(blameOptions.flags, .gitBlameNormal)
        XCTAssertNil(blameOptions.minMatchCharacters)
        XCTAssertNil(blameOptions.newestCommit)
        XCTAssertNil(blameOptions.oldestCommit)
        XCTAssertNil(blameOptions.minLine)
        XCTAssertNil(blameOptions.maxLine)
        
        XCTAssertEqual(gitBlameOptionsVersion, UInt32(GIT_BLAME_OPTIONS_VERSION))
        
        blameOptions.flags =
        [
            .gitBlameFirstParent,
            .gitBlameUseMailmap
        ]
        
        XCTAssertTrue(blameOptions.flags.contains(.gitBlameFirstParent))
        XCTAssertTrue(blameOptions.flags.contains(.gitBlameUseMailmap))
        XCTAssertFalse(blameOptions.flags.contains(.gitBlameIgnoreWhitespace))
    }
}
