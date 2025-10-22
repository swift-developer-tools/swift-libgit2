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



final class DiffTests: XCTestCaseStopOnFail
{
    func testGitDeltaT() throws
    {
        XCTAssertEqual(GitDeltaT.gitDeltaUnmodified.rawValue, GIT_DELTA_UNMODIFIED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaAdded.rawValue, GIT_DELTA_ADDED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaDeleted.rawValue, GIT_DELTA_DELETED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaModified.rawValue, GIT_DELTA_MODIFIED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaRenamed.rawValue, GIT_DELTA_RENAMED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaCopied.rawValue, GIT_DELTA_COPIED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaIgnored.rawValue, GIT_DELTA_IGNORED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaUntracked.rawValue, GIT_DELTA_UNTRACKED.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaTypeChange.rawValue, GIT_DELTA_TYPECHANGE.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaUnreadable.rawValue, GIT_DELTA_UNREADABLE.rawValue)
        XCTAssertEqual(GitDeltaT.gitDeltaConflicted.rawValue, GIT_DELTA_CONFLICTED.rawValue)
        
        XCTAssertNil(GitDeltaT(rawValue: 123))
        
        XCTAssertEqual(GitDeltaT.gitDeltaUnmodified.cValue(), GIT_DELTA_UNMODIFIED)
        XCTAssertEqual(GitDeltaT.gitDeltaAdded.cValue(), GIT_DELTA_ADDED)
        XCTAssertEqual(GitDeltaT.gitDeltaDeleted.cValue(), GIT_DELTA_DELETED)
        XCTAssertEqual(GitDeltaT.gitDeltaModified.cValue(), GIT_DELTA_MODIFIED)
        XCTAssertEqual(GitDeltaT.gitDeltaRenamed.cValue(), GIT_DELTA_RENAMED)
        XCTAssertEqual(GitDeltaT.gitDeltaCopied.cValue(), GIT_DELTA_COPIED)
        XCTAssertEqual(GitDeltaT.gitDeltaIgnored.cValue(), GIT_DELTA_IGNORED)
        XCTAssertEqual(GitDeltaT.gitDeltaUntracked.cValue(), GIT_DELTA_UNTRACKED)
        XCTAssertEqual(GitDeltaT.gitDeltaTypeChange.cValue(), GIT_DELTA_TYPECHANGE)
        XCTAssertEqual(GitDeltaT.gitDeltaUnreadable.cValue(), GIT_DELTA_UNREADABLE)
        XCTAssertEqual(GitDeltaT.gitDeltaConflicted.cValue(), GIT_DELTA_CONFLICTED)
        
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_UNMODIFIED), .gitDeltaUnmodified)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_ADDED), .gitDeltaAdded)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_DELETED), .gitDeltaDeleted)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_MODIFIED), .gitDeltaModified)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_RENAMED), .gitDeltaRenamed)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_COPIED), .gitDeltaCopied)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_IGNORED), .gitDeltaIgnored)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_UNTRACKED), .gitDeltaUntracked)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_TYPECHANGE), .gitDeltaTypeChange)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_UNREADABLE), .gitDeltaUnreadable)
        XCTAssertEqual(GitDeltaT(cValue: GIT_DELTA_CONFLICTED), .gitDeltaConflicted)
    }
    
    
    
    func testGitDiffBinary() throws
    {
        let diffBinary = GitDiffBinary(cValue: git_diff_binary())
        
        XCTAssertFalse(diffBinary.containsData)
        XCTAssertNotNil(diffBinary.oldFile)
        XCTAssertNotNil(diffBinary.newFile)
        
        try diffBinary.withCValue
        {
            cDiffBinary in
            
            XCTAssertFalse(Bool(cDiffBinary.pointee.contains_data))
            XCTAssertNotNil(cDiffBinary.pointee.old_file)
            XCTAssertNotNil(cDiffBinary.pointee.new_file)
        }
    }
    
    
    
    func testGitDiffBinaryFile() throws
    {
        let diffBinaryFile = GitDiffBinaryFile(cValue: git_diff_binary_file())
        
        XCTAssertEqual(diffBinaryFile.type, .gitDiffBinaryNone)
        XCTAssertNil(diffBinaryFile.data)
        XCTAssertEqual(diffBinaryFile.dataLen, 0)
        XCTAssertEqual(diffBinaryFile.inflatedLen, 0)
        
        try diffBinaryFile.withCValue
        {
            cDiffBinaryFile in
            
            XCTAssertEqual(GitDiffBinaryT(cValue: cDiffBinaryFile.pointee.type), .gitDiffBinaryNone)
            XCTAssertNil(cDiffBinaryFile.pointee.data)
            XCTAssertEqual(cDiffBinaryFile.pointee.datalen, 0)
            XCTAssertEqual(cDiffBinaryFile.pointee.inflatedlen, 0)
        }
    }
    
    
    
    func testGitDiffBinaryT() throws
    {
        XCTAssertEqual(GitDiffBinaryT.gitDiffBinaryNone.rawValue, GIT_DIFF_BINARY_NONE.rawValue)
        XCTAssertEqual(GitDiffBinaryT.gitDiffBinaryLiteral.rawValue, GIT_DIFF_BINARY_LITERAL.rawValue)
        XCTAssertEqual(GitDiffBinaryT.gitDiffBinaryDelta.rawValue, GIT_DIFF_BINARY_DELTA.rawValue)
        
        XCTAssertNil(GitDiffBinaryT(rawValue: 123))
        
        XCTAssertEqual(GitDiffBinaryT.gitDiffBinaryNone.cValue(), GIT_DIFF_BINARY_NONE)
        XCTAssertEqual(GitDiffBinaryT.gitDiffBinaryLiteral.cValue(), GIT_DIFF_BINARY_LITERAL)
        XCTAssertEqual(GitDiffBinaryT.gitDiffBinaryDelta.cValue(), GIT_DIFF_BINARY_DELTA)
        
        XCTAssertEqual(GitDiffBinaryT(cValue: GIT_DIFF_BINARY_NONE), .gitDiffBinaryNone)
        XCTAssertEqual(GitDiffBinaryT(cValue: GIT_DIFF_BINARY_LITERAL), .gitDiffBinaryLiteral)
        XCTAssertEqual(GitDiffBinaryT(cValue: GIT_DIFF_BINARY_DELTA), .gitDiffBinaryDelta)
    }
    
    
    
    func testGitDiffBlobs() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var oldBlobPointer  : OpaquePointer?    = nil
            var newBlobPointer  : OpaquePointer?    = nil
            
            defer
            {
                gitBlobFree(blob: oldBlobPointer)
                gitBlobFree(blob: newBlobPointer)
            }
            
            
            
            let oldBlobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: Data("Old blob content".utf8))
            )
            
            let newBlobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: Data("New blob content".utf8))
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
            
            
            
            _ = gitDiffBlobs(
                oldBlob:    oldBlobPointer,
                oldAsPath:  "old.txt",
                newBlob:     newBlobPointer,
                newAsPath:  "new.txt",
                options:    nil,
                fileCB:     nil,
                binaryCB:   nil,
                hunkCB:     nil,
                lineCB:     nil,
                payload:    nil
            )
            
            
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var diffOptions = GitDiffOptions()
                
                diffOptions.notifyCB    = Self.notifyCB
                diffOptions.progressCB  = Self.progressCB
                
                let diffBlobsResult: GitErrorCode = gitDiffBlobs(
                    oldBlob:    oldBlobPointer,
                    oldAsPath:  "old.txt",
                    newBlob:     newBlobPointer,
                    newAsPath:  "new.txt",
                    options:    diffOptions,
                    fileCB:     Self.fileCB,
                    binaryCB:   Self.binaryCB,
                    hunkCB:     Self.hunkCB,
                    lineCB:     Self.lineCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(diffBlobsResult)
            }
            
            XCTAssertEqual(callbackData.binaryCount, 0)
            XCTAssertGreaterThan(callbackData.fileCount, 0)
            XCTAssertGreaterThan(callbackData.hunkCount, 0)
            XCTAssertGreaterThan(callbackData.lineCount, 0)
            XCTAssertEqual(callbackData.notifyCount, 0)
            XCTAssertEqual(callbackData.progressCount, 0)
        }
    }
    
    
    
    func testGitDiffBlobToBuffer() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobPointer: OpaquePointer? = nil
            
            defer
            {
                gitBlobFree(blob: blobPointer)
            }
            
            
            
            let bufferData = Data("Buffer content".utf8)
            
            let blobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .buffer(data: Data("Blob content".utf8))
            )
            
            let blobLookupResult: GitErrorCode = gitBlobLookup(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            XCTAssertNotNil(blobPointer)
            
            
            
            _ = gitDiffBlobToBuffer(
                oldBlob:        blobPointer,
                oldAsPath:      "blob.txt",
                buffer:         bufferData,
                bufferLen:      bufferData.count,
                bufferAsPath:   "buffer.txt",
                options:        nil,
                fileCB:         nil,
                binaryCB:       nil,
                hunkCB:         nil,
                lineCB:         nil,
                payload:        nil
            )
            
            
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var diffOptions = GitDiffOptions()
                
                diffOptions.notifyCB    = Self.notifyCB
                diffOptions.progressCB  = Self.progressCB
                
                let diffBlobToBufferResult: GitErrorCode = gitDiffBlobToBuffer(
                    oldBlob:        blobPointer,
                    oldAsPath:      "blob.txt",
                    buffer:         bufferData,
                    bufferLen:      bufferData.count,
                    bufferAsPath:   "buffer.txt",
                    options:        diffOptions,
                    fileCB:         Self.fileCB,
                    binaryCB:       Self.binaryCB,
                    hunkCB:         Self.hunkCB,
                    lineCB:         Self.lineCB,
                    payload:        UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(diffBlobToBufferResult)
            }
            
            XCTAssertEqual(callbackData.binaryCount, 0)
            XCTAssertGreaterThan(callbackData.fileCount, 0)
            XCTAssertGreaterThan(callbackData.hunkCount, 0)
            XCTAssertGreaterThan(callbackData.lineCount, 0)
            XCTAssertEqual(callbackData.notifyCount, 0)
            XCTAssertEqual(callbackData.progressCount, 0)
        }
    }
    
    
    
    func testGitDiffBuffers() throws
    {
        let oldBufferData   = Data("Old buffer".utf8)
        let newBufferData   = Data("New buffer".utf8)
        
        
        
        _ = gitDiffBuffers(
            oldBuffer:          oldBufferData,
            oldBufferLen:       oldBufferData.count,
            oldBufferAsPath:    "old.txt",
            newBuffer:          newBufferData,
            newBufferLen:       newBufferData.count,
            newBufferAsPath:    "new.txt",
            options:            nil,
            fileCB:             nil,
            binaryCB:           nil,
            hunkCB:             nil,
            lineCB:             nil,
            payload:            nil
        )
        
        
        
        var callbackData = CallbackData()
        
        withUnsafeMutablePointer(to: &callbackData)
        {
            callbackDataPointer in
            
            var diffOptions = GitDiffOptions()
            
            diffOptions.notifyCB    = Self.notifyCB
            diffOptions.progressCB  = Self.progressCB
            
            let diffBuffersResult: GitErrorCode = gitDiffBuffers(
                oldBuffer:          oldBufferData,
                oldBufferLen:       oldBufferData.count,
                oldBufferAsPath:    "old.txt",
                newBuffer:          newBufferData,
                newBufferLen:       newBufferData.count,
                newBufferAsPath:    "new.txt",
                options:            diffOptions,
                fileCB:             Self.fileCB,
                binaryCB:           Self.binaryCB,
                hunkCB:             Self.hunkCB,
                lineCB:             Self.lineCB,
                payload:            UnsafeMutableRawPointer(callbackDataPointer)
            )
            
            XCTAssertOK(diffBuffersResult)
        }
        
        XCTAssertEqual(callbackData.binaryCount, 0)
        XCTAssertGreaterThan(callbackData.fileCount, 0)
        XCTAssertGreaterThan(callbackData.hunkCount, 0)
        XCTAssertGreaterThan(callbackData.lineCount, 0)
        XCTAssertEqual(callbackData.notifyCount, 0)
        XCTAssertEqual(callbackData.progressCount, 0)
    }
    
    
    
    func testGitDiffDelta() throws
    {
        let diffDelta = GitDiffDelta(cValue: git_diff_delta())
        
        XCTAssertEqual(diffDelta.status, .gitDeltaUnmodified)
        XCTAssertEqual(diffDelta.flags, [])
        XCTAssertEqual(diffDelta.similarity, 0)
        XCTAssertEqual(diffDelta.nFiles, 0)
        XCTAssertNotNil(diffDelta.oldFile)
        XCTAssertNotNil(diffDelta.newFile)
        
        diffDelta.withCValue
        {
            cDiffDelta in
            
            XCTAssertEqual(GitDeltaT(cValue: cDiffDelta.pointee.status), .gitDeltaUnmodified)
            XCTAssertEqual(GitDiffFlagT(rawValue: cDiffDelta.pointee.flags), [])
            XCTAssertEqual(cDiffDelta.pointee.similarity, 0)
            XCTAssertEqual(cDiffDelta.pointee.nfiles, 0)
            XCTAssertNotNil(cDiffDelta.pointee.old_file)
            XCTAssertNotNil(cDiffDelta.pointee.new_file)
        }
    }
    
    
    
    func testGitDiffFile() throws
    {
        let diffFile = GitDiffFile(cValue: git_diff_file())
        
        XCTAssertZeroOID(diffFile.id)
        XCTAssertNil(diffFile.path)
        XCTAssertEqual(diffFile.size, 0)
        XCTAssertEqual(diffFile.flags, [])
        XCTAssertEqual(diffFile.mode, .gitFileModeUnreadable)
        XCTAssertEqual(diffFile.idAbbrev, 0)
        
        diffFile.withCValue
        {
            cDiffFile in
            
            XCTAssertZeroOID(GitOID(cValue: cDiffFile.pointee.id))
            XCTAssertNil(cDiffFile.pointee.path)
            XCTAssertEqual(cDiffFile.pointee.size, 0)
            XCTAssertEqual(GitDiffFlagT(rawValue: cDiffFile.pointee.flags), [])
            XCTAssertEqual(GitFileModeT(rawValue: cDiffFile.pointee.mode), .gitFileModeUnreadable)
            XCTAssertEqual(cDiffFile.pointee.id_abbrev, 0)
        }
    }
    
    
    
    func testGitDiffFindOptions() throws
    {
        let diffFindOptions = GitDiffFindOptions()
        
        XCTAssertEqual(diffFindOptions.version, gitDiffOptionsVersion)
        XCTAssertEqual(diffFindOptions.flags, .gitDiffFindByConfig)
        XCTAssertEqual(diffFindOptions.renameThreshold, 50)
        XCTAssertEqual(diffFindOptions.renameFromRewriteThreshold, 50)
        XCTAssertEqual(diffFindOptions.copyThreshold, 50)
        XCTAssertEqual(diffFindOptions.breakRewriteThreshold, 50)
        XCTAssertEqual(diffFindOptions.renameLimit, 1000)
        XCTAssertNil(diffFindOptions.metric)
        
        let cDiffFindOptions: git_diff_find_options = try diffFindOptions.cValue()
        
        XCTAssertEqual(cDiffFindOptions.version, gitDiffOptionsVersion)
        XCTAssertEqual(GitDiffFindT(rawValue: cDiffFindOptions.flags), .gitDiffFindByConfig)
        XCTAssertEqual(cDiffFindOptions.rename_threshold, 50)
        XCTAssertEqual(cDiffFindOptions.rename_from_rewrite_threshold, 50)
        XCTAssertEqual(cDiffFindOptions.copy_threshold, 50)
        XCTAssertEqual(cDiffFindOptions.break_rewrite_threshold, 50)
        XCTAssertEqual(cDiffFindOptions.rename_limit, 1000)
        XCTAssertNil(cDiffFindOptions.metric)
    }
    
    
    
    func testGitDiffFindOptionsInit() throws
    {
        var diffFindOptions = git_diff_find_options()
        
        let diffFindOptionsInitResult: GitErrorCode = gitDiffFindOptionsInit(
            opts:       &diffFindOptions,
            version:    gitDiffFindOptionsVersion
        )
        
        XCTAssertOK(diffFindOptionsInitResult)
    }
    
    
    
    func testGitDiffFindOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitDiffFindOptionsVersion), GIT_DIFF_FIND_OPTIONS_VERSION)
    }
    
    
    
    func testGitDiffFindSimilar() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            try repository.commit(
                "Original content",
                toFile:     "original.txt",
                message:    "Add original file"
            )
            
            
            
            let fileURL: URL = repository.url.appending(
                path:           "original.txt",
                directoryHint:  .notDirectory
            )
            
            let renamedURL: URL = repository.url.appending(
                path:           "renamed.txt",
                directoryHint:  .notDirectory
            )
            
            try FileManager.default.moveItem(
                at:     fileURL,
                to:     renamedURL
            )
            
            
            
            var treePointer : OpaquePointer?    = nil
            var diffPointer : OpaquePointer?    = nil
            
            defer
            {
                Free.freeTree(treePointer)
                gitDiffFree(diff: diffPointer)
            }
            
            
            
            let indexRemoveByPathResult: GitErrorCode = gitIndexRemoveByPath(
                index:  indexPointer,
                path:   "original.txt"
            )
            
            XCTAssertOK(indexRemoveByPathResult)
            
            
            
            let indexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   "renamed.txt"
            )
            
            XCTAssertOK(indexAddByPathResult)
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let commitTreeResult: GitErrorCode = gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
                
                XCTAssertOK(commitTreeResult)
                XCTAssertNotNil(treePointer)
            }
            
            
            
            let diffIndexToIndexResult: GitErrorCode = gitDiffTreeToIndex(
                diff:       &diffPointer,
                repo:       repository.pointer,
                oldTree:    treePointer,
                index:      indexPointer,
                opts:       nil
            )
            
            XCTAssertOK(diffIndexToIndexResult)
            
            guard let diffPointer: OpaquePointer = diffPointer
            else
            {
                XCTFail("The diff pointer was nil.")
                return
            }
            
            
            
            var diffFindOptions = GitDiffFindOptions()
            
            diffFindOptions.flags = .gitDiffFindRenames
            
            
            
            let diffFindSimilarResult: GitErrorCode = gitDiffFindSimilar(
                diff:       diffPointer,
                options:    diffFindOptions
            )
            
            XCTAssertOK(diffFindSimilarResult)
            
            Diff.assertDiffChanges(
                diffPointer:    diffPointer,
                type:           .gitDeltaRenamed
            )
        }
    }
    
    
    
    func testGitDiffFindT() throws
    {
        XCTAssertEqual(GitDiffFindT.gitDiffFindByConfig.rawValue, GIT_DIFF_FIND_BY_CONFIG.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRenames.rawValue, GIT_DIFF_FIND_RENAMES.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRenamesFromRewrites.rawValue, GIT_DIFF_FIND_RENAMES_FROM_REWRITES.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindCopies.rawValue, GIT_DIFF_FIND_COPIES.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindCopiesFromUnmodified.rawValue, GIT_DIFF_FIND_COPIES_FROM_UNMODIFIED.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRewrites.rawValue, GIT_DIFF_FIND_REWRITES.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffBreakRewrites.rawValue, GIT_DIFF_BREAK_REWRITES.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindAndBreakRewrites.rawValue, GIT_DIFF_FIND_AND_BREAK_REWRITES.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindForUntracked.rawValue, GIT_DIFF_FIND_FOR_UNTRACKED.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindAll.rawValue, GIT_DIFF_FIND_ALL.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindIgnoreLeadingWhitespace.rawValue, GIT_DIFF_FIND_IGNORE_LEADING_WHITESPACE.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindIgnoreWhitespace.rawValue, GIT_DIFF_FIND_IGNORE_WHITESPACE.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindDoNotIgnoreWhitespace.rawValue, GIT_DIFF_FIND_DONT_IGNORE_WHITESPACE.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindExactMatchOnly.rawValue, GIT_DIFF_FIND_EXACT_MATCH_ONLY.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffBreakRewritesForRenamesOnly.rawValue, GIT_DIFF_BREAK_REWRITES_FOR_RENAMES_ONLY.rawValue)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRemoveUnmodified.rawValue, GIT_DIFF_FIND_REMOVE_UNMODIFIED.rawValue)
        
        XCTAssertEqual(GitDiffFindT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitDiffFindT.gitDiffFindByConfig.cValue(), GIT_DIFF_FIND_BY_CONFIG)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRenames.cValue(), GIT_DIFF_FIND_RENAMES)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRenamesFromRewrites.cValue(), GIT_DIFF_FIND_RENAMES_FROM_REWRITES)
        XCTAssertEqual(GitDiffFindT.gitDiffFindCopies.cValue(), GIT_DIFF_FIND_COPIES)
        XCTAssertEqual(GitDiffFindT.gitDiffFindCopiesFromUnmodified.cValue(), GIT_DIFF_FIND_COPIES_FROM_UNMODIFIED)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRewrites.cValue(), GIT_DIFF_FIND_REWRITES)
        XCTAssertEqual(GitDiffFindT.gitDiffBreakRewrites.cValue(), GIT_DIFF_BREAK_REWRITES)
        XCTAssertEqual(GitDiffFindT.gitDiffFindAndBreakRewrites.cValue(), GIT_DIFF_FIND_AND_BREAK_REWRITES)
        XCTAssertEqual(GitDiffFindT.gitDiffFindForUntracked.cValue(), GIT_DIFF_FIND_FOR_UNTRACKED)
        XCTAssertEqual(GitDiffFindT.gitDiffFindAll.cValue(), GIT_DIFF_FIND_ALL)
        XCTAssertEqual(GitDiffFindT.gitDiffFindIgnoreLeadingWhitespace.cValue(), GIT_DIFF_FIND_IGNORE_LEADING_WHITESPACE)
        XCTAssertEqual(GitDiffFindT.gitDiffFindIgnoreWhitespace.cValue(), GIT_DIFF_FIND_IGNORE_WHITESPACE)
        XCTAssertEqual(GitDiffFindT.gitDiffFindDoNotIgnoreWhitespace.cValue(), GIT_DIFF_FIND_DONT_IGNORE_WHITESPACE)
        XCTAssertEqual(GitDiffFindT.gitDiffFindExactMatchOnly.cValue(), GIT_DIFF_FIND_EXACT_MATCH_ONLY)
        XCTAssertEqual(GitDiffFindT.gitDiffBreakRewritesForRenamesOnly.cValue(), GIT_DIFF_BREAK_REWRITES_FOR_RENAMES_ONLY)
        XCTAssertEqual(GitDiffFindT.gitDiffFindRemoveUnmodified.cValue(), GIT_DIFF_FIND_REMOVE_UNMODIFIED)
        
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_BY_CONFIG), .gitDiffFindByConfig)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_RENAMES), .gitDiffFindRenames)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_RENAMES_FROM_REWRITES), .gitDiffFindRenamesFromRewrites)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_COPIES), .gitDiffFindCopies)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_COPIES_FROM_UNMODIFIED), .gitDiffFindCopiesFromUnmodified)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_REWRITES), .gitDiffFindRewrites)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_BREAK_REWRITES), .gitDiffBreakRewrites)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_AND_BREAK_REWRITES), .gitDiffFindAndBreakRewrites)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_FOR_UNTRACKED), .gitDiffFindForUntracked)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_ALL), .gitDiffFindAll)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_IGNORE_LEADING_WHITESPACE), .gitDiffFindIgnoreLeadingWhitespace)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_IGNORE_WHITESPACE), .gitDiffFindIgnoreWhitespace)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_DONT_IGNORE_WHITESPACE), .gitDiffFindDoNotIgnoreWhitespace)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_EXACT_MATCH_ONLY), .gitDiffFindExactMatchOnly)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_BREAK_REWRITES_FOR_RENAMES_ONLY), .gitDiffBreakRewritesForRenamesOnly)
        XCTAssertEqual(GitDiffFindT(cValue: GIT_DIFF_FIND_REMOVE_UNMODIFIED), .gitDiffFindRemoveUnmodified)
        
        
        
        let flags: GitDiffFindT =
        [
            .gitDiffBreakRewrites,
            .gitDiffFindExactMatchOnly
        ]
        
        XCTAssertTrue(flags.contains(.gitDiffBreakRewrites))
        XCTAssertTrue(flags.contains(.gitDiffFindExactMatchOnly))
        XCTAssertFalse(flags.contains(.gitDiffFindRemoveUnmodified))
    }
    
    
    
    func testGitDiffFlagT() throws
    {
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagBinary.rawValue, GIT_DIFF_FLAG_BINARY.rawValue)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagNotBinary.rawValue, GIT_DIFF_FLAG_NOT_BINARY.rawValue)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagValidID.rawValue, GIT_DIFF_FLAG_VALID_ID.rawValue)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagExists.rawValue, GIT_DIFF_FLAG_EXISTS.rawValue)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagValidSize.rawValue, GIT_DIFF_FLAG_VALID_SIZE.rawValue)
        
        XCTAssertEqual(GitDiffFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagBinary.cValue(), GIT_DIFF_FLAG_BINARY)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagNotBinary.cValue(), GIT_DIFF_FLAG_NOT_BINARY)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagValidID.cValue(), GIT_DIFF_FLAG_VALID_ID)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagExists.cValue(), GIT_DIFF_FLAG_EXISTS)
        XCTAssertEqual(GitDiffFlagT.gitDiffFlagValidSize.cValue(), GIT_DIFF_FLAG_VALID_SIZE)
        
        XCTAssertEqual(GitDiffFlagT(cValue: GIT_DIFF_FLAG_BINARY), .gitDiffFlagBinary)
        XCTAssertEqual(GitDiffFlagT(cValue: GIT_DIFF_FLAG_NOT_BINARY), .gitDiffFlagNotBinary)
        XCTAssertEqual(GitDiffFlagT(cValue: GIT_DIFF_FLAG_VALID_ID), .gitDiffFlagValidID)
        XCTAssertEqual(GitDiffFlagT(cValue: GIT_DIFF_FLAG_EXISTS), .gitDiffFlagExists)
        XCTAssertEqual(GitDiffFlagT(cValue: GIT_DIFF_FLAG_VALID_SIZE), .gitDiffFlagValidSize)
        
        
        
        let flags: GitDiffFlagT =
        [
            .gitDiffFlagNotBinary,
            .gitDiffFlagExists
        ]
        
        XCTAssertTrue(flags.contains(.gitDiffFlagNotBinary))
        XCTAssertTrue(flags.contains(.gitDiffFlagExists))
        XCTAssertFalse(flags.contains(.gitDiffFlagValidSize))
    }
    
    
    
    func testGitDiffForEach() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiffPointer(in: repository)
            {
                diffPointer in
                
                _ = gitDiffForEach(
                    diff:       diffPointer,
                    fileCB:     nil,
                    binaryCB:   nil,
                    hunkCB:     nil,
                    lineCB:     nil,
                    payload:    nil
                )
                
                
                
                var callbackData = CallbackData()
                
                withUnsafeMutablePointer(to: &callbackData)
                {
                    callbackDataPointer in
                    
                    let diffForEachResult: GitErrorCode = gitDiffForEach(
                        diff:       diffPointer,
                        fileCB:     Self.fileCB,
                        binaryCB:   Self.binaryCB,
                        hunkCB:     Self.hunkCB,
                        lineCB:     Self.lineCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                    
                    XCTAssertOK(diffForEachResult)
                }
                
                XCTAssertEqual(callbackData.binaryCount, 0)
                XCTAssertGreaterThan(callbackData.fileCount, 0)
                XCTAssertGreaterThan(callbackData.hunkCount, 0)
                XCTAssertGreaterThan(callbackData.lineCount, 0)
            }
        }
    }
    
    
    
    func testGitDiffFormatT() throws
    {
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatPatch.rawValue, GIT_DIFF_FORMAT_PATCH.rawValue)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatPatchHeader.rawValue, GIT_DIFF_FORMAT_PATCH_HEADER.rawValue)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatRaw.rawValue, GIT_DIFF_FORMAT_RAW.rawValue)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatNameOnly.rawValue, GIT_DIFF_FORMAT_NAME_ONLY.rawValue)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatNameStatus.rawValue, GIT_DIFF_FORMAT_NAME_STATUS.rawValue)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatPatchID.rawValue, GIT_DIFF_FORMAT_PATCH_ID.rawValue)
        
        XCTAssertNil(GitDiffFormatT(rawValue: 123))
        
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatPatch.cValue(), GIT_DIFF_FORMAT_PATCH)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatPatchHeader.cValue(), GIT_DIFF_FORMAT_PATCH_HEADER)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatRaw.cValue(), GIT_DIFF_FORMAT_RAW)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatNameOnly.cValue(), GIT_DIFF_FORMAT_NAME_ONLY)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatNameStatus.cValue(), GIT_DIFF_FORMAT_NAME_STATUS)
        XCTAssertEqual(GitDiffFormatT.gitDiffFormatPatchID.cValue(), GIT_DIFF_FORMAT_PATCH_ID)
        
        XCTAssertEqual(GitDiffFormatT(cValue: GIT_DIFF_FORMAT_PATCH), .gitDiffFormatPatch)
        XCTAssertEqual(GitDiffFormatT(cValue: GIT_DIFF_FORMAT_PATCH_HEADER), .gitDiffFormatPatchHeader)
        XCTAssertEqual(GitDiffFormatT(cValue: GIT_DIFF_FORMAT_RAW), .gitDiffFormatRaw)
        XCTAssertEqual(GitDiffFormatT(cValue: GIT_DIFF_FORMAT_NAME_ONLY), .gitDiffFormatNameOnly)
        XCTAssertEqual(GitDiffFormatT(cValue: GIT_DIFF_FORMAT_NAME_STATUS), .gitDiffFormatNameStatus)
        XCTAssertEqual(GitDiffFormatT(cValue: GIT_DIFF_FORMAT_PATCH_ID), .gitDiffFormatPatchID)
    }
    
    
    
    func testGitDiffFree() throws
    {
        gitDiffFree(diff: nil)
    }
    
    
    
    func testGitDiffFromBuffer() throws
    {
        let patchContent: String =
        """
        diff --git a/test.txt b/test.txt
        new file mode 100644
        index 0000000..1234567
        --- /dev/null
        +++ b/test.txt
        @@ -0,0 +1 @@
        +hello
        
        """
        
        let patchData = Data(patchContent.utf8)
        
        
        
        var diffPointer: OpaquePointer? = nil
        
        defer
        {
            gitDiffFree(diff: diffPointer)
        }
        
        
        
        let diffFromBufferResult: GitErrorCode = gitDiffFromBuffer(
            out:            &diffPointer,
            content:        patchData,
            contentLen:     patchData.count
        )
        
        XCTAssertOK(diffFromBufferResult)
        Diff.assertDiffChanges(diffPointer: diffPointer)
    }
    
    
    
    func testGitDiffGetStats() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiffPointer(in: repository)
            {
                diffPointer in
                
                var diffStatsPointer: OpaquePointer? = nil
                
                defer
                {
                    gitDiffStatsFree(stats: diffStatsPointer)
                }
                
                
                
                let diffGetStatsResult: GitErrorCode = gitDiffGetStats(
                    out:    &diffStatsPointer,
                    diff:   diffPointer
                )
                
                XCTAssertOK(diffGetStatsResult)
                
                guard let diffStatsPointer: OpaquePointer = diffStatsPointer
                else
                {
                    XCTFail("The diff stats pointer was nil.")
                    return
                }
                
                
                
                let filesChanged: Int
                    = gitDiffStatsFilesChanged(stats: diffStatsPointer)
                
                XCTAssertGreaterThan(filesChanged, 0)
                
                
                
                let insertions: Int
                    = gitDiffStatsInsertions(stats: diffStatsPointer)
                
                XCTAssertGreaterThanOrEqual(insertions, 0)
                
                
                
                let deletions: Int
                    = gitDiffStatsDeletions(stats: diffStatsPointer)
                
                XCTAssertGreaterThanOrEqual(deletions, 0)
                
                
                
                var diffStatistics = Data()
                
                let diffStatsToBufResult: GitErrorCode = gitDiffStatsToBuf(
                    out:        &diffStatistics,
                    stats:      diffStatsPointer,
                    format:     .gitDiffStatsFull,
                    width:      80
                )
                
                XCTAssertOK(diffStatsToBufResult)
                XCTAssertGreaterThan(diffStatistics.count, 0)
            }
        }
    }
    
    
    
    func testGitDiffHunk() throws
    {
        let diffHunk = GitDiffHunk()
        
        XCTAssertEqual(diffHunk.oldStart, 0)
        XCTAssertEqual(diffHunk.oldLines, 0)
        XCTAssertEqual(diffHunk.newStart, 0)
        XCTAssertEqual(diffHunk.newLines, 0)
        XCTAssertEqual(diffHunk.headerLen, 0)
        XCTAssertNil(diffHunk.header)
        
        
        
        let cDiffHunk: git_diff_hunk = diffHunk.cValue()
        
        XCTAssertEqual(cDiffHunk.old_start, 0)
        XCTAssertEqual(cDiffHunk.old_lines, 0)
        XCTAssertEqual(cDiffHunk.new_start, 0)
        XCTAssertEqual(cDiffHunk.new_lines, 0)
        XCTAssertEqual(cDiffHunk.header_len, 0)
        XCTAssertEqual(String(cArray: cDiffHunk.header, count: 0), "")
    }
    
    
    
    func testGitDiffHunkHeaderSize() throws
    {
        XCTAssertEqual(Int32(gitDiffHunkHeaderSize), GIT_DIFF_HUNK_HEADER_SIZE)
    }
    
    
    
    func testGitDiffIndexToIndex() throws
    {
        try Repository.withIndexPointer
        {
            repository, oldIndexPointer in
            
            var newIndexPointer : OpaquePointer?    = nil
            var diffPointer     : OpaquePointer?    = nil
            
            defer
            {
                gitIndexFree(index: newIndexPointer)
                gitDiffFree(diff: diffPointer)
            }
            
            
            
            try repository.modifyFile(
                at:     "index-test.txt",
                with:   "Index test content"
            )
            
            
            
            let oldIndexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                index:  oldIndexPointer,
                path:   "index-test.txt"
            )
            
            XCTAssertOK(oldIndexAddByPathResult)
            
            
            
            let indexWriteResult: GitErrorCode
                = gitIndexWrite(index: oldIndexPointer)
            
            XCTAssertOK(indexWriteResult)
            
            
            
            let newRepositoryIndexResult: Int32 = git_repository_index(
                &newIndexPointer,
                repository.pointer
            )
            
            XCTAssertOK(GitErrorCode(rawValue: newRepositoryIndexResult))
            
            guard let newIndexPointer: OpaquePointer = newIndexPointer
            else
            {
                XCTFail("The new index pointer was nil.")
                return
            }
            
            
            
            try repository.modifyFile(
                at:     "another-file.txt",
                with:   "Another file content"
            )
            
            
            
            let newIndexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                index:  newIndexPointer,
                path:   "another-file.txt"
            )
            
            XCTAssertOK(newIndexAddByPathResult)
            
            
            
            let diffIndexToIndexResult: GitErrorCode = gitDiffIndexToIndex(
                diff:       &diffPointer,
                repo:       repository.pointer,
                oldIndex:   oldIndexPointer,
                newIndex:   newIndexPointer,
                opts:       nil
            )
            
            XCTAssertOK(diffIndexToIndexResult)
            XCTAssertNotNil(diffPointer)
        }
    }
    
    
    
    func testGitDiffIndexToWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   "Modified content"
            )
            
            
            
            var diffPointer: OpaquePointer? = nil
            
            defer
            {
                gitDiffFree(diff: diffPointer)
            }
            
            
            
            let diffIndexToWorkdirResult: GitErrorCode = gitDiffIndexToWorkdir(
                diff:   &diffPointer,
                repo:   repository.pointer,
                index:  nil,
                opts:   nil
            )
            
            XCTAssertOK(diffIndexToWorkdirResult)
            Diff.assertDiffChanges(diffPointer: diffPointer)
        }
    }
    
    
    
    func testGitDiffLine() throws
    {
        let diffLine = GitDiffLine()
        
        XCTAssertEqual(diffLine.origin, .gitDiffLineContext)
        XCTAssertEqual(diffLine.oldLineNo, 0)
        XCTAssertEqual(diffLine.newLineNo, 0)
        XCTAssertEqual(diffLine.numLines, 0)
        XCTAssertEqual(diffLine.contentLen, 0)
        XCTAssertEqual(diffLine.contentOffset, 0)
        XCTAssertNil(diffLine.content)
        
        try diffLine.withCValue
        {
            cDiffLine in
            
            XCTAssertEqual(cDiffLine.pointee.origin, CChar(GitDiffLineT.gitDiffLineContext.rawValue))
            XCTAssertEqual(cDiffLine.pointee.old_lineno, 0)
            XCTAssertEqual(cDiffLine.pointee.new_lineno, 0)
            XCTAssertEqual(cDiffLine.pointee.num_lines, 0)
            XCTAssertEqual(cDiffLine.pointee.content_len, 0)
            XCTAssertEqual(cDiffLine.pointee.content_offset, 0)
            XCTAssertNil(cDiffLine.pointee.content)
        }
    }
    
    
    
    func testGitDiffLineT() throws
    {
        XCTAssertEqual(GitDiffLineT.gitDiffLineContext.rawValue, GIT_DIFF_LINE_CONTEXT.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineAddition.rawValue, GIT_DIFF_LINE_ADDITION.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineDeletion.rawValue, GIT_DIFF_LINE_DELETION.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineContextEOFNL.rawValue, GIT_DIFF_LINE_CONTEXT_EOFNL.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineAddEOFNL.rawValue, GIT_DIFF_LINE_ADD_EOFNL.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineDelEOFNL.rawValue, GIT_DIFF_LINE_DEL_EOFNL.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineFileHDR.rawValue, GIT_DIFF_LINE_FILE_HDR.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineHunkHDR.rawValue, GIT_DIFF_LINE_HUNK_HDR.rawValue)
        XCTAssertEqual(GitDiffLineT.gitDiffLineBinary.rawValue, GIT_DIFF_LINE_BINARY.rawValue)
        
        XCTAssertNil(GitDiffLineT(rawValue: 123))
        
        XCTAssertEqual(GitDiffLineT.gitDiffLineContext.cValue(), GIT_DIFF_LINE_CONTEXT)
        XCTAssertEqual(GitDiffLineT.gitDiffLineAddition.cValue(), GIT_DIFF_LINE_ADDITION)
        XCTAssertEqual(GitDiffLineT.gitDiffLineDeletion.cValue(), GIT_DIFF_LINE_DELETION)
        XCTAssertEqual(GitDiffLineT.gitDiffLineContextEOFNL.cValue(), GIT_DIFF_LINE_CONTEXT_EOFNL)
        XCTAssertEqual(GitDiffLineT.gitDiffLineAddEOFNL.cValue(), GIT_DIFF_LINE_ADD_EOFNL)
        XCTAssertEqual(GitDiffLineT.gitDiffLineDelEOFNL.cValue(), GIT_DIFF_LINE_DEL_EOFNL)
        XCTAssertEqual(GitDiffLineT.gitDiffLineFileHDR.cValue(), GIT_DIFF_LINE_FILE_HDR)
        XCTAssertEqual(GitDiffLineT.gitDiffLineHunkHDR.cValue(), GIT_DIFF_LINE_HUNK_HDR)
        XCTAssertEqual(GitDiffLineT.gitDiffLineBinary.cValue(), GIT_DIFF_LINE_BINARY)
        
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_CONTEXT), .gitDiffLineContext)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_ADDITION), .gitDiffLineAddition)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_DELETION), .gitDiffLineDeletion)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_CONTEXT_EOFNL), .gitDiffLineContextEOFNL)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_ADD_EOFNL), .gitDiffLineAddEOFNL)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_DEL_EOFNL), .gitDiffLineDelEOFNL)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_FILE_HDR), .gitDiffLineFileHDR)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_HUNK_HDR), .gitDiffLineHunkHDR)
        XCTAssertEqual(GitDiffLineT(cValue: GIT_DIFF_LINE_BINARY), .gitDiffLineBinary)
    }
    
    
    
    func testGitDiffMerge() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            repository.reset(to: firstCommitOID)
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            let thirdCommitOID: GitOID = try repository.commit(
                "Third content",
                toFile:     "third.txt",
                message:    "Third commit"
            )
            
            
            
            try Diff.withTreeToTreeDiffPointer(
                in:             repository,
                oldCommitOID:   firstCommitOID,
                newCommitOID:   secondCommitOID
            )
            {
                firstToSecondDiffPointer in
                
                try Diff.withTreeToTreeDiffPointer(
                    in:             repository,
                    oldCommitOID:   secondCommitOID,
                    newCommitOID:   thirdCommitOID
                )
                {
                    secondToThirdDiffPointer in
                    
                    let diffMergeResult: GitErrorCode = gitDiffMerge(
                        onto:   firstToSecondDiffPointer,
                        from:   secondToThirdDiffPointer
                    )
                    
                    XCTAssertOK(diffMergeResult)
                }
            }
        }
    }
    
    
    
    func testGitDiffOptions() throws
    {
        let diffOptions = GitDiffOptions()
        
        XCTAssertEqual(diffOptions.version, gitDiffOptionsVersion)
        XCTAssertEqual(diffOptions.flags, .gitDiffNormal)
        XCTAssertEqual(diffOptions.ignoreSubmodules, .gitSubmoduleIgnoreUnspecified)
        XCTAssertEqual(diffOptions.pathspec, [])
        XCTAssertNil(diffOptions.notifyCB)
        XCTAssertNil(diffOptions.progressCB)
        XCTAssertNil(diffOptions.payload)
        XCTAssertEqual(diffOptions.contextLines, 3)
        XCTAssertEqual(diffOptions.interHunkLines, 0)
        XCTAssertNil(diffOptions.oidType)
        XCTAssertNil(diffOptions.idAbbrev)
        XCTAssertEqual(diffOptions.maxSize, 536_870_912)
        XCTAssertEqual(diffOptions.oldPrefix, "a")
        XCTAssertEqual(diffOptions.newPrefix, "b")
        
        try diffOptions.withCValue
        {
            cDiffOptions in
            
            XCTAssertEqual(cDiffOptions.pointee.version, gitDiffOptionsVersion)
            XCTAssertEqual(cDiffOptions.pointee.flags, 0)
            XCTAssertEqual(GitSubmoduleIgnoreT(cValue: cDiffOptions.pointee.ignore_submodules), .gitSubmoduleIgnoreUnspecified)
            XCTAssertEqual(Array(cDiffOptions.pointee.pathspec), [])
            XCTAssertNil(cDiffOptions.pointee.notify_cb)
            XCTAssertNil(cDiffOptions.pointee.progress_cb)
            XCTAssertNil(cDiffOptions.pointee.payload)
            XCTAssertEqual(cDiffOptions.pointee.context_lines, 3)
            XCTAssertEqual(cDiffOptions.pointee.interhunk_lines, 0)
            XCTAssertEqual(cDiffOptions.pointee.oid_type, GitOIDT.gitOIDSHA1.cValue())
            XCTAssertEqual(cDiffOptions.pointee.id_abbrev, 7)
            XCTAssertEqual(cDiffOptions.pointee.max_size, 536_870_912)
            XCTAssertEqual(String(optionalCString: cDiffOptions.pointee.old_prefix), "a")
            XCTAssertEqual(String(optionalCString: cDiffOptions.pointee.new_prefix), "b")
        }
    }
    
    
    
    func testGitDiffOptionsInit() throws
    {
        var diffOptions = git_diff_options()
        
        let diffOptionsInitResult: GitErrorCode = gitDiffOptionsInit(
            opts:       &diffOptions,
            version:    gitDiffOptionsVersion
        )
        
        XCTAssertOK(diffOptionsInitResult)
    }
    
    
    
    func testGitDiffOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitDiffOptionsVersion), GIT_DIFF_OPTIONS_VERSION)
    }
    
    
    
    func testGitDiffOptionT() throws
    {
        XCTAssertEqual(GitDiffOptionT.gitDiffNormal.rawValue, GIT_DIFF_NORMAL.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffReverse.rawValue, GIT_DIFF_REVERSE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeIgnored.rawValue, GIT_DIFF_INCLUDE_IGNORED.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffRecurseIgnoredDirs.rawValue, GIT_DIFF_RECURSE_IGNORED_DIRS.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeUntracked.rawValue, GIT_DIFF_INCLUDE_UNTRACKED.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffRecurseUntrackedDirs.rawValue, GIT_DIFF_RECURSE_UNTRACKED_DIRS.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeUnmodified.rawValue, GIT_DIFF_INCLUDE_UNMODIFIED.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeTypeChange.rawValue, GIT_DIFF_INCLUDE_TYPECHANGE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeTypeChangeTrees.rawValue, GIT_DIFF_INCLUDE_TYPECHANGE_TREES.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreFileMode.rawValue, GIT_DIFF_IGNORE_FILEMODE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreSubmodules.rawValue, GIT_DIFF_IGNORE_SUBMODULES.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreCase.rawValue, GIT_DIFF_IGNORE_CASE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeCaseChange.rawValue, GIT_DIFF_INCLUDE_CASECHANGE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffDisablePathspecMatch.rawValue, GIT_DIFF_DISABLE_PATHSPEC_MATCH.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffSkipBinaryCheck.rawValue, GIT_DIFF_SKIP_BINARY_CHECK.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffEnableFastUntrackedDirs.rawValue, GIT_DIFF_ENABLE_FAST_UNTRACKED_DIRS.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffUpdateIndex.rawValue, GIT_DIFF_UPDATE_INDEX.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeUnreadable.rawValue, GIT_DIFF_INCLUDE_UNREADABLE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIndentHeuristic.rawValue, GIT_DIFF_INDENT_HEURISTIC.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreBlankLines.rawValue, GIT_DIFF_IGNORE_BLANK_LINES.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffForceText.rawValue, GIT_DIFF_FORCE_TEXT.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffForceBinary.rawValue, GIT_DIFF_FORCE_BINARY.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreWhitespace.rawValue, GIT_DIFF_IGNORE_WHITESPACE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreWhitespaceChange.rawValue, GIT_DIFF_IGNORE_WHITESPACE_CHANGE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreWhitespaceEOL.rawValue, GIT_DIFF_IGNORE_WHITESPACE_EOL.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffShowUntrackedContent.rawValue, GIT_DIFF_SHOW_UNTRACKED_CONTENT.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffShowUnmodified.rawValue, GIT_DIFF_SHOW_UNMODIFIED.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffPatience.rawValue, GIT_DIFF_PATIENCE.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffMinimal.rawValue, GIT_DIFF_MINIMAL.rawValue)
        XCTAssertEqual(GitDiffOptionT.gitDiffShowBinary.rawValue, GIT_DIFF_SHOW_BINARY.rawValue)
        
        XCTAssertEqual(GitDiffOptionT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitDiffOptionT.gitDiffNormal.cValue(), GIT_DIFF_NORMAL)
        XCTAssertEqual(GitDiffOptionT.gitDiffReverse.cValue(), GIT_DIFF_REVERSE)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeIgnored.cValue(), GIT_DIFF_INCLUDE_IGNORED)
        XCTAssertEqual(GitDiffOptionT.gitDiffRecurseIgnoredDirs.cValue(), GIT_DIFF_RECURSE_IGNORED_DIRS)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeUntracked.cValue(), GIT_DIFF_INCLUDE_UNTRACKED)
        XCTAssertEqual(GitDiffOptionT.gitDiffRecurseUntrackedDirs.cValue(), GIT_DIFF_RECURSE_UNTRACKED_DIRS)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeUnmodified.cValue(), GIT_DIFF_INCLUDE_UNMODIFIED)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeTypeChange.cValue(), GIT_DIFF_INCLUDE_TYPECHANGE)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeTypeChangeTrees.cValue(), GIT_DIFF_INCLUDE_TYPECHANGE_TREES)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreFileMode.cValue(), GIT_DIFF_IGNORE_FILEMODE)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreSubmodules.cValue(), GIT_DIFF_IGNORE_SUBMODULES)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreCase.cValue(), GIT_DIFF_IGNORE_CASE)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeCaseChange.cValue(), GIT_DIFF_INCLUDE_CASECHANGE)
        XCTAssertEqual(GitDiffOptionT.gitDiffDisablePathspecMatch.cValue(), GIT_DIFF_DISABLE_PATHSPEC_MATCH)
        XCTAssertEqual(GitDiffOptionT.gitDiffSkipBinaryCheck.cValue(), GIT_DIFF_SKIP_BINARY_CHECK)
        XCTAssertEqual(GitDiffOptionT.gitDiffEnableFastUntrackedDirs.cValue(), GIT_DIFF_ENABLE_FAST_UNTRACKED_DIRS)
        XCTAssertEqual(GitDiffOptionT.gitDiffUpdateIndex.cValue(), GIT_DIFF_UPDATE_INDEX)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeUnreadable.cValue(), GIT_DIFF_INCLUDE_UNREADABLE)
        XCTAssertEqual(GitDiffOptionT.gitDiffIncludeUnreadableAsUntracked.cValue(), GIT_DIFF_INCLUDE_UNREADABLE_AS_UNTRACKED)
        XCTAssertEqual(GitDiffOptionT.gitDiffIndentHeuristic.cValue(), GIT_DIFF_INDENT_HEURISTIC)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreBlankLines.cValue(), GIT_DIFF_IGNORE_BLANK_LINES)
        XCTAssertEqual(GitDiffOptionT.gitDiffForceText.cValue(), GIT_DIFF_FORCE_TEXT)
        XCTAssertEqual(GitDiffOptionT.gitDiffForceBinary.cValue(), GIT_DIFF_FORCE_BINARY)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreWhitespace.cValue(), GIT_DIFF_IGNORE_WHITESPACE)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreWhitespaceChange.cValue(), GIT_DIFF_IGNORE_WHITESPACE_CHANGE)
        XCTAssertEqual(GitDiffOptionT.gitDiffIgnoreWhitespaceEOL.cValue(), GIT_DIFF_IGNORE_WHITESPACE_EOL)
        XCTAssertEqual(GitDiffOptionT.gitDiffShowUntrackedContent.cValue(), GIT_DIFF_SHOW_UNTRACKED_CONTENT)
        XCTAssertEqual(GitDiffOptionT.gitDiffShowUnmodified.cValue(), GIT_DIFF_SHOW_UNMODIFIED)
        XCTAssertEqual(GitDiffOptionT.gitDiffPatience.cValue(), GIT_DIFF_PATIENCE)
        XCTAssertEqual(GitDiffOptionT.gitDiffMinimal.cValue(), GIT_DIFF_MINIMAL)
        XCTAssertEqual(GitDiffOptionT.gitDiffShowBinary.cValue(), GIT_DIFF_SHOW_BINARY)
        
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_NORMAL), .gitDiffNormal)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_REVERSE), .gitDiffReverse)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_IGNORED), .gitDiffIncludeIgnored)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_RECURSE_IGNORED_DIRS), .gitDiffRecurseIgnoredDirs)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_UNTRACKED), .gitDiffIncludeUntracked)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_RECURSE_UNTRACKED_DIRS), .gitDiffRecurseUntrackedDirs)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_UNMODIFIED), .gitDiffIncludeUnmodified)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_TYPECHANGE), .gitDiffIncludeTypeChange)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_TYPECHANGE_TREES), .gitDiffIncludeTypeChangeTrees)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_IGNORE_FILEMODE), .gitDiffIgnoreFileMode)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_IGNORE_SUBMODULES), .gitDiffIgnoreSubmodules)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_IGNORE_CASE), .gitDiffIgnoreCase)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_CASECHANGE), .gitDiffIncludeCaseChange)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_DISABLE_PATHSPEC_MATCH), .gitDiffDisablePathspecMatch)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_SKIP_BINARY_CHECK), .gitDiffSkipBinaryCheck)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_ENABLE_FAST_UNTRACKED_DIRS), .gitDiffEnableFastUntrackedDirs)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_UPDATE_INDEX), .gitDiffUpdateIndex)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_UNREADABLE), .gitDiffIncludeUnreadable)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INCLUDE_UNREADABLE_AS_UNTRACKED), .gitDiffIncludeUnreadableAsUntracked)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_INDENT_HEURISTIC), .gitDiffIndentHeuristic)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_IGNORE_BLANK_LINES), .gitDiffIgnoreBlankLines)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_FORCE_TEXT), .gitDiffForceText)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_FORCE_BINARY), .gitDiffForceBinary)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_IGNORE_WHITESPACE), .gitDiffIgnoreWhitespace)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_IGNORE_WHITESPACE_CHANGE), .gitDiffIgnoreWhitespaceChange)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_IGNORE_WHITESPACE_EOL), .gitDiffIgnoreWhitespaceEOL)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_SHOW_UNTRACKED_CONTENT), .gitDiffShowUntrackedContent)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_SHOW_UNMODIFIED), .gitDiffShowUnmodified)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_PATIENCE), .gitDiffPatience)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_MINIMAL), .gitDiffMinimal)
        XCTAssertEqual(GitDiffOptionT(cValue: GIT_DIFF_SHOW_BINARY), .gitDiffShowBinary)
        
        
        
        let flags: GitDiffOptionT =
        [
            .gitDiffIgnoreBlankLines,
            .gitDiffIgnoreCase
        ]
        
        XCTAssertTrue(flags.contains(.gitDiffIgnoreBlankLines))
        XCTAssertTrue(flags.contains(.gitDiffIgnoreCase))
        XCTAssertFalse(flags.contains(.gitDiffPatience))
    }
    
    
    
    func testGitDiffParseOptions() throws
    {
        let diffParseOptions = GitDiffParseOptions()
        
        XCTAssertEqual(diffParseOptions.version, gitDiffParseOptionsVersion)
        XCTAssertEqual(diffParseOptions.oidType, .gitOIDSHA1)
        
        let cDiffParseOptions: git_diff_parse_options = diffParseOptions.cValue()
        
        XCTAssertEqual(cDiffParseOptions.version, gitDiffParseOptionsVersion)
        XCTAssertEqual(GitOIDT(cValue: cDiffParseOptions.oid_type), .gitOIDSHA1)
    }
    
    
    
    func testGitDiffParseOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitDiffParseOptionsVersion), GIT_DIFF_PARSE_OPTIONS_VERSION)
    }
    
    
    
    func testGitDiffPatchID() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiffPointer(in: repository)
            {
                diffPointer in
                
                var patchID = GitOID()
                
                let diffPatchIDResult: GitErrorCode = gitDiffPatchID(
                    out:    &patchID,
                    diff:   diffPointer,
                    opts:   nil
                )
                
                XCTAssertOK(diffPatchIDResult)
                XCTAssertNotZeroOID(patchID)
            }
        }
    }
    
    
    
    func testGitDiffPatchIDOptions() throws
    {
        let diffPatchIDOptions = GitDiffPatchIDOptions()
        
        XCTAssertEqual(diffPatchIDOptions.version, gitDiffPatchIDOptionsVersion)
        
        let cDiffPatchIDOptions: git_diff_patchid_options = try diffPatchIDOptions.cValue()
        
        XCTAssertEqual(cDiffPatchIDOptions.version, gitDiffPatchIDOptionsVersion)
    }
    
    
    
    func testGitDiffPatchIDOptionsInit() throws
    {
        var diffPatchIDOptions = git_diff_patchid_options()
        
        let diffPatchIDOptionsInitResult: GitErrorCode
            = gitDiffPatchIDOptionsInit(
                opts:       &diffPatchIDOptions,
                version:    gitDiffPatchIDOptionsVersion
            )
        
        XCTAssertOK(diffPatchIDOptionsInitResult)
    }
    
    
    
    func testGitDiffPatchIDOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitDiffPatchIDOptionsVersion), GIT_DIFF_PATCHID_OPTIONS_VERSION)
    }
    
    
    
    func testGitDiffPrintAndToBuf() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiffPointer(in: repository)
            {
                diffPointer in
                
                var callbackData = CallbackData()
                
                withUnsafeMutablePointer(to: &callbackData)
                {
                    callbackDataPointer in
                    
                    let diffPrintResult: GitErrorCode = gitDiffPrint(
                        diff:       diffPointer,
                        format:     .gitDiffFormatRaw,
                        printCB:    Self.lineCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                    
                    XCTAssertOK(diffPrintResult)
                }
                
                XCTAssertGreaterThan(callbackData.lineCount, 0)
                
                
                
                var diff = Data()
                
                let diffToBufResult: GitErrorCode = gitDiffToBuf(
                    out:        &diff,
                    diff:       diffPointer,
                    format:     .gitDiffFormatPatch
                )
                
                XCTAssertOK(diffToBufResult)
                XCTAssertGreaterThan(diff.count, 0)
            }
        }
    }
    
    
    
    func testGitDiffSimilarityMetric() throws
    {
        let diffSimilarityMetric = GitDiffSimilarityMetric()
        
        XCTAssertNil(diffSimilarityMetric.fileSignature)
        XCTAssertNil(diffSimilarityMetric.bufferSignature)
        XCTAssertNil(diffSimilarityMetric.freeSignature)
        XCTAssertNil(diffSimilarityMetric.similarity)
        XCTAssertNil(diffSimilarityMetric.payload)
        
        let cDiffSimilarityMetric: git_diff_similarity_metric
            = diffSimilarityMetric.cValue()
        
        XCTAssertNil(cDiffSimilarityMetric.file_signature)
        XCTAssertNil(cDiffSimilarityMetric.buffer_signature)
        XCTAssertNil(cDiffSimilarityMetric.free_signature)
        XCTAssertNil(cDiffSimilarityMetric.similarity)
        XCTAssertNil(cDiffSimilarityMetric.payload)
    }
    
    
    
    func testGitDiffStatsFormatT() throws
    {
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsNone.rawValue, GIT_DIFF_STATS_NONE.rawValue)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsFull.rawValue, GIT_DIFF_STATS_FULL.rawValue)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsShort.rawValue, GIT_DIFF_STATS_SHORT.rawValue)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsNumber.rawValue, GIT_DIFF_STATS_NUMBER.rawValue)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsIncludeSummary.rawValue, GIT_DIFF_STATS_INCLUDE_SUMMARY.rawValue)
        
        XCTAssertEqual(GitDiffStatsFormatT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsNone.cValue(), GIT_DIFF_STATS_NONE)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsFull.cValue(), GIT_DIFF_STATS_FULL)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsShort.cValue(), GIT_DIFF_STATS_SHORT)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsNumber.cValue(), GIT_DIFF_STATS_NUMBER)
        XCTAssertEqual(GitDiffStatsFormatT.gitDiffStatsIncludeSummary.cValue(), GIT_DIFF_STATS_INCLUDE_SUMMARY)
        
        XCTAssertEqual(GitDiffStatsFormatT(cValue: GIT_DIFF_STATS_NONE), .gitDiffStatsNone)
        XCTAssertEqual(GitDiffStatsFormatT(cValue: GIT_DIFF_STATS_FULL), .gitDiffStatsFull)
        XCTAssertEqual(GitDiffStatsFormatT(cValue: GIT_DIFF_STATS_SHORT), .gitDiffStatsShort)
        XCTAssertEqual(GitDiffStatsFormatT(cValue: GIT_DIFF_STATS_NUMBER), .gitDiffStatsNumber)
        XCTAssertEqual(GitDiffStatsFormatT(cValue: GIT_DIFF_STATS_INCLUDE_SUMMARY), .gitDiffStatsIncludeSummary)
        
        
        
        let flags: GitDiffStatsFormatT =
        [
            .gitDiffStatsFull,
            .gitDiffStatsNumber
        ]
        
        XCTAssertTrue(flags.contains(.gitDiffStatsFull))
        XCTAssertTrue(flags.contains(.gitDiffStatsNumber))
        XCTAssertFalse(flags.contains(.gitDiffStatsShort))
    }
    
    
    
    func testGitDiffStatsFree() throws
    {
        gitDiffStatsFree(stats: nil)
    }
    
    
    
    func testGitDiffStatusChar() throws
    {
        let addedChar: CChar = gitDiffStatusChar(status: .gitDeltaAdded)
        
        XCTAssertEqual(addedChar, CChar(UnicodeScalar("A").value))
        
        
        
        let deletedChar: CChar = gitDiffStatusChar(status: .gitDeltaDeleted)
        
        XCTAssertEqual(deletedChar, CChar(UnicodeScalar("D").value))
        
        
        
        let modifiedChar: CChar = gitDiffStatusChar(status: .gitDeltaModified)
        
        XCTAssertEqual(modifiedChar, CChar(UnicodeScalar("M").value))
        
        
        
        let renamedChar: CChar = gitDiffStatusChar(status: .gitDeltaRenamed)
        
        XCTAssertEqual(renamedChar, CChar(UnicodeScalar("R").value))
    }
    
    
    
    func testGitDiffTreeToIndex() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            try repository.modifyFile(
                at:     "staged.txt",
                with:   "Staged content"
            )
            
            
            
            var treePointer : OpaquePointer?    = nil
            var diffPointer : OpaquePointer?    = nil
            
            defer
            {
                Free.freeTree(treePointer)
                gitDiffFree(diff: diffPointer)
            }
            
            
            
            let indexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   "staged.txt"
            )
            
            XCTAssertOK(indexAddByPathResult)
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let commitTreeResult: GitErrorCode = gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
                
                XCTAssertOK(commitTreeResult)
                XCTAssertNotNil(treePointer)
            }
            
            
            
            let diffTreeToIndexResult: GitErrorCode = gitDiffTreeToIndex(
                diff:       &diffPointer,
                repo:       repository.pointer,
                oldTree:    treePointer,
                index:      indexPointer,
                opts:       nil
            )
            
            XCTAssertOK(diffTreeToIndexResult)
            Diff.assertDiffChanges(diffPointer: diffPointer)
        }
    }
    
    
    
    func testGitDiffTreeToTree() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let oldCommitOID: GitOID = try repository.commit(
                "Old content",
                toFile:     "old.txt",
                message:    "Old commit"
            )
            
            let newCommitOID: GitOID = try repository.commit(
                "New content",
                toFile:     "new.txt",
                message:    "New commit"
            )
            
            try Diff.withTreeToTreeDiffPointer(
                in:             repository,
                oldCommitOID:   oldCommitOID,
                newCommitOID:   newCommitOID
            ) { _ in }
        }
    }
    
    
    
    func testGitDiffTreeToWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiffPointer(in: repository) { _ in }
        }
    }
    
    
    
    func testGitDiffTreeToWorkdirWithIndex() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.modifyFile(
                at:     Repository.readmeFileName,
                with:   "Modified content"
            )
            
            
            
            var treePointer : OpaquePointer?    = nil
            var diffPointer : OpaquePointer?    = nil
            
            defer
            {
                Free.freeTree(treePointer)
                gitDiffFree(diff: diffPointer)
            }
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let commitTreeResult: GitErrorCode = gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
                
                XCTAssertOK(commitTreeResult)
                XCTAssertNotNil(treePointer)
            }
            
            
            
            let diffTreeToWorkdirWithIndexResult: GitErrorCode
                = gitDiffTreeToWorkdirWithIndex(
                    diff:       &diffPointer,
                    repo:       repository.pointer,
                    oldTree:    treePointer,
                    opts:       nil
                )
            
            XCTAssertOK(diffTreeToWorkdirWithIndexResult)
            Diff.assertDiffChanges(diffPointer: diffPointer)
        }
    }
}



// MARK: - Extensions

private extension DiffTests
{
    struct CallbackData
    {
        var binaryCount     : Int   = 0
        var fileCount       : Int   = 0
        var hunkCount       : Int   = 0
        var lineCount       : Int   = 0
        var notifyCount     : Int   = 0
        var progressCount   : Int   = 0
    }
    
    
    
    static let binaryCB: GitDiffBinaryCB =
    {
        delta, binary, payload in
        
        guard let payload: UnsafeMutableRawPointer = payload
        else
        {
            XCTFail("The payload was nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.binaryCount += 1
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    static let fileCB: GitDiffFileCB =
    {
        delta, progress, payload in
        
        guard let payload: UnsafeMutableRawPointer = payload
        else
        {
            XCTFail("The payload was nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.fileCount += 1
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    static let hunkCB: GitDiffHunkCB =
    {
        delta, hunk, payload in
        
        guard let payload: UnsafeMutableRawPointer = payload
        else
        {
            XCTFail("The payload was nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.hunkCount += 1
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    static let lineCB: GitDiffLineCB =
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
        
        payloadPointer.pointee.lineCount += 1
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    static let progressCB: GitDiffProgressCB =
    {
        diffSoFar, oldPath, newPath, payload in
        
        guard let payload: UnsafeMutableRawPointer = payload
        else
        {
            XCTFail("The payload was nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.progressCount += 1
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    static let notifyCB: GitDiffNotifyCB =
    {
        diffSoFar, deltaToAdd, matchedPathspec, payload in
        
        guard let payload: UnsafeMutableRawPointer = payload
        else
        {
            XCTFail("The payload was nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.notifyCount += 1
        
        return GitErrorCode.gitOK.rawValue
    }
}
