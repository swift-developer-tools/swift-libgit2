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
                gitBlameFree(blame: baseBlamePointer)
                gitBlameFree(blame: bufferBlamePointer)
            }
            
            
            
            let blameFileResult: GitErrorCode = gitBlameFile(
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
            
            
            
            let bufferContent = Data("Buffer content\n".utf8)
            
            let blameBufferResult: GitErrorCode = gitBlameBuffer(
                out:        &bufferBlamePointer,
                base:       baseBlamePointer,
                buffer:     bufferContent,
                bufferLen:  bufferContent.count
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
                gitBlameFree(blame: blamePointer)
            }
            
            
            
            let blameOptions = GitBlameOptions()
            
            var blameFileResult: GitErrorCode = gitBlameFile(
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
            XCTAssertNotZeroOID(firstHunk.finalCommitID)
            XCTAssertGreaterThan(firstHunk.finalStartLineNumber, 0)
            XCTAssertNotNil(firstHunk.finalSignature)
            XCTAssertNotNil(firstHunk.finalCommitter)
            XCTAssertNotZeroOID(firstHunk.origCommitID)
            XCTAssertNotNil(firstHunk.origPath)
            XCTAssertGreaterThan(firstHunk.origStartLineNumber, 0)
            XCTAssertNotNil(firstHunk.origSignature)
            XCTAssertNotNil(firstHunk.origCommitter)
            XCTAssertNotNil(firstHunk.summary)
            XCTAssertFalse(firstHunk.boundary)
            
            
            
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
        
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_NORMAL).cValue(), GIT_BLAME_NORMAL)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_SAME_FILE).cValue(), GIT_BLAME_TRACK_COPIES_SAME_FILE)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES).cValue(), GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES).cValue(), GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES).cValue(), GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_FIRST_PARENT).cValue(), GIT_BLAME_FIRST_PARENT)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_USE_MAILMAP).cValue(), GIT_BLAME_USE_MAILMAP)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_IGNORE_WHITESPACE).cValue(), GIT_BLAME_IGNORE_WHITESPACE)
        
        
        
        let flags: GitBlameFlagT =
        [
            .gitBlameUseMailmap,
            .gitBlameIgnoreWhitespace
        ]
        
        XCTAssertTrue(flags.contains(.gitBlameUseMailmap))
        XCTAssertTrue(flags.contains(.gitBlameIgnoreWhitespace))
        XCTAssertFalse(flags.contains(.gitBlameTrackCopiesSameFile))
    }
    
    
    
    func testGitBlameFree() throws
    {
        gitBlameFree(blame: nil)
    }
    
    
    
    func testGitBlameLine() throws
    {
        let blameLine = GitBlameLine(cValue: git_blame_line())
        
        XCTAssertNil(blameLine.ptr)
        XCTAssertEqual(blameLine.len, 0)
        
        try blameLine.withCValue
        {
            cBlameLine in
            
            XCTAssertNil(cBlameLine.pointee.ptr)
            XCTAssertEqual(cBlameLine.pointee.len, 0)
        }
    }
    
    
    
    func testGitBlameOptions() throws
    {
        let blameOptions = GitBlameOptions()
        
        XCTAssertEqual(blameOptions.version, gitBlameOptionsVersion)
        XCTAssertEqual(blameOptions.flags, .gitBlameNormal)
        XCTAssertEqual(blameOptions.minMatchCharacters, 20)
        XCTAssertNil(blameOptions.newestCommit)
        XCTAssertNil(blameOptions.oldestCommit)
        XCTAssertEqual(blameOptions.minLine, 1)
        XCTAssertNil(blameOptions.maxLine)
        
        try blameOptions.withCValue
        {
            cBlameOptions in
            
            XCTAssertEqual(cBlameOptions.pointee.version, gitBlameOptionsVersion)
            XCTAssertEqual(GitBlameFlagT(rawValue: cBlameOptions.pointee.flags), .gitBlameNormal)
            XCTAssertEqual(cBlameOptions.pointee.min_match_characters, 20)
            XCTAssertZeroOID(GitOID(cValue: cBlameOptions.pointee.newest_commit))
            XCTAssertZeroOID(GitOID(cValue: cBlameOptions.pointee.oldest_commit))
            XCTAssertEqual(cBlameOptions.pointee.min_line, 1)
            XCTAssertNotNil(cBlameOptions.pointee.max_line)
        }
    }
    
    
    
    func testGitBlameOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitBlameOptionsVersion), GIT_BLAME_OPTIONS_VERSION)
    }
}
