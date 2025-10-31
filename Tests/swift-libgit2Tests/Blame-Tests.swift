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
        try withBlame
        {
            blamePointer in
            
            var bufferBlamePointer: OpaquePointer? = nil
            
            defer
            {
                gitBlameFree(blame: bufferBlamePointer)
            }
            
            
            
            let bufferContent = Data("Buffer content\n".utf8)
            
            let blameBufferResult: GitErrorCode = gitBlameBuffer(
                out:        &bufferBlamePointer,
                base:       blamePointer,
                buffer:     bufferContent,
                bufferLen:  bufferContent.count
            )
            
            XCTAssertOK(blameBufferResult)
            XCTAssertNotNil(bufferBlamePointer)
        }
    }
    
    
    
    func testGitBlameFile() throws
    {
        try withBlame
        {
            _ in
        }
    }
    
    
    
    func testGitBlameGetHunkByIndex() throws
    {
        try withBlame
        {
            blamePointer in
            
            let blameHunk: GitBlameHunk? = gitBlameGetHunkByIndex(
                blame:  blamePointer,
                index:  0
            )
            
            guard let blameHunk: GitBlameHunk = blameHunk
            else
            {
                XCTFail("The blame hunk was nil.")
                return
            }
            
            XCTAssertGreaterThan(blameHunk.linesInHunk, 0)
            XCTAssertNotZeroOID(blameHunk.finalCommitID)
            XCTAssertGreaterThan(blameHunk.finalStartLineNumber, 0)
            XCTAssertNotNil(blameHunk.finalSignature)
            XCTAssertNotNil(blameHunk.finalCommitter)
            XCTAssertNotZeroOID(blameHunk.origCommitID)
            XCTAssertNotNil(blameHunk.origPath)
            XCTAssertGreaterThan(blameHunk.origStartLineNumber, 0)
            XCTAssertNotNil(blameHunk.origSignature)
            XCTAssertNotNil(blameHunk.origCommitter)
            XCTAssertNotNil(blameHunk.summary)
            XCTAssertFalse(blameHunk.boundary)
            
            
            
            let hunkCount: Int = gitBlameHunkCount(blame: blamePointer)
            
            XCTAssertGreaterThan(hunkCount, 0)
            
            
            
            let invalidHunkIndex: Int = hunkCount + 1
            
            guard
                invalidHunkIndex >= UInt32.min,
                invalidHunkIndex <= UInt32.max
            else
            {
                XCTFail("The invalid hunk index was out of UInt32 range.")
                return
            }
            
            
            
            let invalidBlameHunk: GitBlameHunk? = gitBlameGetHunkByIndex(
                blame:  blamePointer,
                index:  UInt32(invalidHunkIndex)
            )
            
            XCTAssertNil(invalidBlameHunk)
        }
    }
    
    
    
    func testGitBlameGetHunkByLine() throws
    {
        try withBlame
        {
            blamePointer in
            
            let blameHunk: GitBlameHunk? = gitBlameGetHunkByLine(
                blame:      blamePointer,
                lineNo:     1
            )
            
            XCTAssertNotNil(blameHunk)
        }
    }
    
    
    
    func testGitBlameGetHunkCount() throws
    {
        try withBlame
        {
            blamePointer in
            
            let hunkCount: Int = gitBlameHunkCount(blame: blamePointer)
            
            XCTAssertGreaterThan(hunkCount, 0)
            
            
            
            let hunkCountDeprecated: UInt32
                = gitBlameGetHunkCount(blame: blamePointer)
            
            XCTAssertEqual(hunkCountDeprecated, UInt32(hunkCount))
        }
    }
    
    
    
    func testGitBlameHunkByIndex() throws
    {
        try withBlame
        {
            blamePointer in
            
            let blameHunk: GitBlameHunk? = gitBlameHunkByIndex(
                blame:  blamePointer,
                index:  0
            )
            
            guard let blameHunk: GitBlameHunk = blameHunk
            else
            {
                XCTFail("The blame hunk was nil.")
                return
            }
            
            XCTAssertGreaterThan(blameHunk.linesInHunk, 0)
            XCTAssertNotZeroOID(blameHunk.finalCommitID)
            XCTAssertGreaterThan(blameHunk.finalStartLineNumber, 0)
            XCTAssertNotNil(blameHunk.finalSignature)
            XCTAssertNotNil(blameHunk.finalCommitter)
            XCTAssertNotZeroOID(blameHunk.origCommitID)
            XCTAssertNotNil(blameHunk.origPath)
            XCTAssertGreaterThan(blameHunk.origStartLineNumber, 0)
            XCTAssertNotNil(blameHunk.origSignature)
            XCTAssertNotNil(blameHunk.origCommitter)
            XCTAssertNotNil(blameHunk.summary)
            XCTAssertFalse(blameHunk.boundary)
            
            
            
            let hunkCount: Int = gitBlameHunkCount(blame: blamePointer)
            
            XCTAssertGreaterThan(hunkCount, 0)
            
            
            
            let invalidBlameHunk: GitBlameHunk? = gitBlameHunkByIndex(
                blame:  blamePointer,
                index:  hunkCount + 10
            )
            
            XCTAssertNil(invalidBlameHunk)
        }
    }
    
    
    
    func testGitBlameHunkByLine() throws
    {
        try withBlame
        {
            blamePointer in
            
            let blameHunk: GitBlameHunk? = gitBlameHunkByLine(
                blame:      blamePointer,
                lineNo:     1
            )
            
            guard let blameHunk: GitBlameHunk = blameHunk
            else
            {
                XCTFail("The blame hunk was nil.")
                return
            }
            
            XCTAssertGreaterThan(blameHunk.linesInHunk, 0)
            XCTAssertNotZeroOID(blameHunk.finalCommitID)
            XCTAssertGreaterThan(blameHunk.finalStartLineNumber, 0)
            XCTAssertNotNil(blameHunk.finalSignature)
            XCTAssertNotNil(blameHunk.finalCommitter)
            XCTAssertNotZeroOID(blameHunk.origCommitID)
            XCTAssertNotNil(blameHunk.origPath)
            XCTAssertGreaterThan(blameHunk.origStartLineNumber, 0)
            XCTAssertNotNil(blameHunk.origSignature)
            XCTAssertNotNil(blameHunk.origCommitter)
            XCTAssertNotNil(blameHunk.summary)
            XCTAssertFalse(blameHunk.boundary)
        }
    }
    
    
    
    func testGitBlameHunkCount() throws
    {
        try withBlame
        {
            blamePointer in
            
            let hunkCount: Int = gitBlameHunkCount(blame: blamePointer)
            
            XCTAssertGreaterThan(hunkCount, 0)
        }
    }
    
    
    
    func testGitBlameLineByIndex() throws
    {
        try withBlame
        {
            blamePointer in
            
            let blameLine: GitBlameLine? = gitBlameLineByIndex(
                blame:  blamePointer,
                idx:    1
            )
            
            XCTAssertNotNil(blameLine)
            XCTAssertNotNil(blameLine?.ptr)
            XCTAssertGreaterThan(blameLine?.len ?? 0, 0)
            
            
            
            let hunkCount: Int = gitBlameHunkCount(blame: blamePointer)
            
            XCTAssertGreaterThan(hunkCount, 0)
            
            
            
            let invalidBlameLine: GitBlameLine? = gitBlameLineByIndex(
                blame:  blamePointer,
                idx:    hunkCount + 10
            )
            
            XCTAssertNil(invalidBlameLine)
        }
    }
    
    
    
    func testGitBlameLineCount() throws
    {
        try withBlame
        {
            blamePointer in
            
            let lineCount: Int = gitBlameLineCount(blame: blamePointer)
            
            XCTAssertGreaterThan(lineCount, 0)
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
        
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_NORMAL), .gitBlameNormal)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_SAME_FILE), .gitBlameTrackCopiesSameFile)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_SAME_COMMIT_MOVES), .gitBlameTrackCopiesSameCommitMoves)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_SAME_COMMIT_COPIES), .gitBlameTrackCopiesSameCommitCopies)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_TRACK_COPIES_ANY_COMMIT_COPIES), .gitBlameTrackCopiesAnyCommitCopies)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_FIRST_PARENT), .gitBlameFirstParent)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_USE_MAILMAP), .gitBlameUseMailmap)
        XCTAssertEqual(GitBlameFlagT(cValue: GIT_BLAME_IGNORE_WHITESPACE), .gitBlameIgnoreWhitespace)
        
        
        
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
    
    
    
    func testGitBlameHunk() throws
    {
        let blameHunk = GitBlameHunk(cValue: git_blame_hunk())
        
        XCTAssertEqual(blameHunk.linesInHunk, 0)
        XCTAssertZeroOID(blameHunk.finalCommitID)
        XCTAssertEqual(blameHunk.finalStartLineNumber, 0)
        XCTAssertNil(blameHunk.finalSignature)
        XCTAssertNil(blameHunk.finalCommitter)
        XCTAssertZeroOID(blameHunk.origCommitID)
        XCTAssertNil(blameHunk.origPath)
        XCTAssertEqual(blameHunk.origStartLineNumber, 0)
        XCTAssertNil(blameHunk.origSignature)
        XCTAssertNil(blameHunk.origCommitter)
        XCTAssertNil(blameHunk.summary)
        XCTAssertFalse(blameHunk.boundary)
        
        try blameHunk.withCValue
        {
            cBlameHunk in
            
            XCTAssertEqual(cBlameHunk.pointee.lines_in_hunk, 0)
            XCTAssertZeroOID(GitOID(cValue: cBlameHunk.pointee.final_commit_id))
            XCTAssertEqual(cBlameHunk.pointee.final_start_line_number, 0)
            XCTAssertNil(cBlameHunk.pointee.final_signature)
            XCTAssertNil(cBlameHunk.pointee.final_committer)
            XCTAssertZeroOID(GitOID(cValue: cBlameHunk.pointee.orig_commit_id))
            XCTAssertNil(cBlameHunk.pointee.orig_path)
            XCTAssertEqual(cBlameHunk.pointee.orig_start_line_number, 0)
            XCTAssertNil(cBlameHunk.pointee.orig_signature)
            XCTAssertNil(cBlameHunk.pointee.orig_committer)
            XCTAssertNil(cBlameHunk.pointee.summary)
            XCTAssertFalse(Bool(cBlameHunk.pointee.boundary))
        }
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
        XCTAssertZeroOID(blameOptions.newestCommit)
        XCTAssertZeroOID(blameOptions.oldestCommit)
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
    
    
    
    func testGitBlameOptionsInit() throws
    {
        var blameOptions = git_blame_options()
        
        let blameOptionsInitResult: GitErrorCode = gitBlameOptionsInit(
            opts:       &blameOptions,
            version:    gitBlameOptionsVersion
        )
        
        XCTAssertOK(blameOptionsInitResult)
    }
    
    
    
    func testGitBlameOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitBlameOptionsVersion), GIT_BLAME_OPTIONS_VERSION)
    }
}



// MARK: - Extensions

private extension BlameTests
{
    /// Calls the given closure with a pointer to a blame.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withBlame(
        _ body: (OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blamePointer: OpaquePointer? = nil
            
            defer
            {
                gitBlameFree(blame: blamePointer)
            }
            
            
            
            let blameFileResult: GitErrorCode = gitBlameFile(
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
            
            
            
            try body(blamePointer)
        }
    }
}
