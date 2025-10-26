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



final class IndexTests: XCTestCaseStopOnFail
{
    func testGitIndexAdd() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let buffer      = Data("Custom content".utf8)
            var blobOID     = GitOID()
            
            let blobCreateFromBufferResult: GitErrorCode
                = gitBlobCreateFromBuffer(
                    id:         &blobOID,
                    repo:       repository.pointer,
                    buffer:     buffer,
                    len:        buffer.count
                )
            
            XCTAssertOK(blobCreateFromBufferResult)
            
            
            
            let fileMode = UInt32(GitFileModeT.gitFileModeBlob.rawValue)
            
            var indexEntry = GitIndexEntry()
            
            indexEntry.path     = "custom-entry.txt"
            indexEntry.mode     = fileMode
            indexEntry.id       = blobOID
            
            
            
            let indexAddResult: GitErrorCode = gitIndexAdd(
                index:          indexPointer,
                sourceEntry:    indexEntry
            )
            
            XCTAssertOK(indexAddResult)
            
            
            
            let retrievedIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   indexEntry.path,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNotNil(retrievedIndexEntry)
            XCTAssertEqual(retrievedIndexEntry?.path, indexEntry.path)
            XCTAssertEqual(retrievedIndexEntry?.mode, fileMode)
            XCTAssertEqual(retrievedIndexEntry?.id, blobOID)
        }
    }
    
    
    
    func testGitIndexAddAllAndRemoveAll() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let fileName1   : String    = "test1.txt"
            let fileName2   : String    = "test2.txt"
            
            try repository.modifyFile(
                at:     fileName1,
                with:   "Test 1"
            )
            
            try repository.modifyFile(
                at:     fileName2,
                with:   "Test 2"
            )
            
            
            
            let initialCount: Int = gitIndexEntryCount(index: indexPointer)
            
            
            
            let indexAddAllResult: GitErrorCode = gitIndexAddAll(
                index:      indexPointer,
                pathspec:   [],
                flags:      .gitIndexAddDefault,
                callback:   nil,
                payload:    nil
            )
            
            XCTAssertOK(indexAddAllResult)
            
            
            
            let afterAddCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(afterAddCount, initialCount)
            
            
            
            let indexEntry1AfterAdd: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   fileName1,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNotNil(indexEntry1AfterAdd)
            
            
            
            let indexEntry2AfterAdd: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   fileName2,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNotNil(indexEntry2AfterAdd)
            
            
            
            let indexRemoveAllResult: GitErrorCode = gitIndexRemoveAll(
                index:      indexPointer,
                pathspec:   [],
                callback:   nil,
                payload:    nil
            )
            
            XCTAssertOK(indexRemoveAllResult)
            
            
            
            let afterRemoveCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertLessThan(afterRemoveCount, afterAddCount)
            
            
            
            let indexEntry1AfterRemove: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   fileName1,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(indexEntry1AfterRemove)
            
            
            
            let indexEntry2AfterRemove: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   fileName2,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(indexEntry2AfterRemove)
        }
    }
    
    
    
    func testGitIndexAddFromBuffer() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let fileMode = UInt32(GitFileModeT.gitFileModeBlob.rawValue)
            
            var indexEntry = GitIndexEntry()
            
            indexEntry.path     = "buffer-file.txt"
            indexEntry.mode     = fileMode
            
            
            
            let bufferContent   : String    = "Buffer content"
            let buffer          : Data      = Data(bufferContent.utf8)
            
            let indexAddFromBufferResult: GitErrorCode = gitIndexAddFromBuffer(
                index:      indexPointer,
                entry:      indexEntry,
                buffer:     buffer,
                len:        buffer.count
            )
            
            XCTAssertOK(indexAddFromBufferResult)
            
            
            
            let retrievedIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   indexEntry.path,
                stage:  .gitIndexStageNormal
            )
            
            guard let retrievedIndexEntry: GitIndexEntry = retrievedIndexEntry
            else
            {
                XCTFail("The retrieved index entry was nil.")
                return
            }
            
            XCTAssertEqual(retrievedIndexEntry.path, indexEntry.path)
            XCTAssertEqual(retrievedIndexEntry.mode, fileMode)
            XCTAssertNotZeroOID(retrievedIndexEntry.id)
            
            Blob.validateBlobContent(
                in:     repository,
                id:     retrievedIndexEntry.id,
                as:     bufferContent
            )
        }
    }
    
    
    
    func testGitIndexAddAllWithCallback() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            try repository.modifyFile(
                at:     "included.txt",
                with:   "Included content"
            )
            
            try repository.modifyFile(
                at:     "skipped.txt",
                with:   "Skipped content"
            )
            
            
            
            var callbackData = CallbackData()
            
            let indexMatchedPathCB: GitIndexMatchedPathCB =
            {
                path, matchedPathspec, payload in
                
                guard
                    let payload: UnsafeMutableRawPointer = payload,
                    let path = String(optionalCString: path)
                else
                {
                    XCTFail("All or some callback parameters were nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                if path.contains("skipped")
                {
                    return 1
                }
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let indexAddAllResult: GitErrorCode = gitIndexAddAll(
                    index:      indexPointer,
                    pathspec:   [],
                    flags:      .gitIndexAddDefault,
                    callback:   indexMatchedPathCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(indexAddAllResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            
            
            
            let includedIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   "included.txt",
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNotNil(includedIndexEntry)
            
            
            
            let skippedIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   "skipped.txt",
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(skippedIndexEntry)
        }
    }
    
    
    
    func testGitIndexAddByPathAndRemoveByPath() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let initialCount: Int = gitIndexEntryCount(index: indexPointer)
            
            
            
            let indexRemoveResult: GitErrorCode = gitIndexRemove(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertOK(indexRemoveResult)
            
            
            
            let afterRemoveCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertEqual(afterRemoveCount, initialCount - 1)
            
            
            
            let firstRemovedEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(firstRemovedEntry)
            
            
            
            let fileToRemoveFilename: String = "remove-me.txt"
            
            try repository.modifyFile(
                at:     fileToRemoveFilename,
                with:   "Goodbye World!"
            )
            
            
            
            let indexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   fileToRemoveFilename
            )
            
            XCTAssertOK(indexAddByPathResult)
            
            
            
            let indexRemoveByPathResult: GitErrorCode = gitIndexRemoveByPath(
                index:  indexPointer,
                path:   fileToRemoveFilename
            )
            
            XCTAssertOK(indexRemoveByPathResult)
            
            
            
            let secondRemovedEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   fileToRemoveFilename,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(secondRemovedEntry)
        }
    }
    
    
    
    func testGitIndexAddOptionT() throws
    {
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddDefault.rawValue, GIT_INDEX_ADD_DEFAULT.rawValue)
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddForce.rawValue, GIT_INDEX_ADD_FORCE.rawValue)
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddDisablePathspecMatch.rawValue, GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH.rawValue)
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddCheckPathspec.rawValue, GIT_INDEX_ADD_CHECK_PATHSPEC.rawValue)
        
        XCTAssertEqual(GitIndexAddOptionT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddDefault.cValue(), GIT_INDEX_ADD_DEFAULT)
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddForce.cValue(), GIT_INDEX_ADD_FORCE)
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddDisablePathspecMatch.cValue(), GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH)
        XCTAssertEqual(GitIndexAddOptionT.gitIndexAddCheckPathspec.cValue(), GIT_INDEX_ADD_CHECK_PATHSPEC)
        
        XCTAssertEqual(GitIndexAddOptionT(cValue: GIT_INDEX_ADD_DEFAULT), .gitIndexAddDefault)
        XCTAssertEqual(GitIndexAddOptionT(cValue: GIT_INDEX_ADD_FORCE), .gitIndexAddForce)
        XCTAssertEqual(GitIndexAddOptionT(cValue: GIT_INDEX_ADD_DISABLE_PATHSPEC_MATCH), .gitIndexAddDisablePathspecMatch)
        XCTAssertEqual(GitIndexAddOptionT(cValue: GIT_INDEX_ADD_CHECK_PATHSPEC), .gitIndexAddCheckPathspec)
        
        
        
        let flags: GitIndexAddOptionT =
        [
            .gitIndexAddForce,
            .gitIndexAddCheckPathspec
        ]
        
        XCTAssertTrue(flags.contains(.gitIndexAddForce))
        XCTAssertTrue(flags.contains(.gitIndexAddCheckPathspec))
        XCTAssertFalse(flags.contains(.gitIndexAddDisablePathspecMatch))
    }
    
    
    
    func testGitCapabilityT() throws
    {
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityIgnoreCase.rawValue, GIT_INDEX_CAPABILITY_IGNORE_CASE.rawValue)
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityNoFileMode.rawValue, GIT_INDEX_CAPABILITY_NO_FILEMODE.rawValue)
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityNoSymLinks.rawValue, GIT_INDEX_CAPABILITY_NO_SYMLINKS.rawValue)
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityFromOwner.rawValue, GIT_INDEX_CAPABILITY_FROM_OWNER.rawValue)
        
        XCTAssertNil(GitIndexCapabilityT(rawValue: 123))
        
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityIgnoreCase.cValue(), GIT_INDEX_CAPABILITY_IGNORE_CASE)
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityNoFileMode.cValue(), GIT_INDEX_CAPABILITY_NO_FILEMODE)
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityNoSymLinks.cValue(), GIT_INDEX_CAPABILITY_NO_SYMLINKS)
        XCTAssertEqual(GitIndexCapabilityT.gitIndexCapabilityFromOwner.cValue(), GIT_INDEX_CAPABILITY_FROM_OWNER)
        
        XCTAssertEqual(GitIndexCapabilityT(cValue: GIT_INDEX_CAPABILITY_IGNORE_CASE), .gitIndexCapabilityIgnoreCase)
        XCTAssertEqual(GitIndexCapabilityT(cValue: GIT_INDEX_CAPABILITY_NO_FILEMODE), .gitIndexCapabilityNoFileMode)
        XCTAssertEqual(GitIndexCapabilityT(cValue: GIT_INDEX_CAPABILITY_NO_SYMLINKS), .gitIndexCapabilityNoSymLinks)
        XCTAssertEqual(GitIndexCapabilityT(cValue: GIT_INDEX_CAPABILITY_FROM_OWNER), .gitIndexCapabilityFromOwner)
    }
    
    
    
    func testGitIndexCapsAndSetCaps() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let initialCaps: GitIndexCapabilityT?
                = gitIndexCaps(index: indexPointer)
            
            XCTAssertNotNil(initialCaps)
            
            
            
            let indexSetCapsResult: GitErrorCode = gitIndexSetCaps(
                index:  indexPointer,
                caps:   .gitIndexCapabilityIgnoreCase
            )
            
            XCTAssertOK(indexSetCapsResult)
            
            
            
            let updatedCaps: GitIndexCapabilityT?
                = gitIndexCaps(index: indexPointer)
            
            XCTAssertEqual(updatedCaps, .gitIndexCapabilityIgnoreCase)
        }
    }
    
    
    
    func testGitIndexChecksum() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let indexOID: GitOID? = gitIndexChecksum(index: indexPointer)
            
            XCTAssertNotNil(indexOID)
            XCTAssertNotZeroOID(indexOID)
        }
    }
    
    
    
    func testGitIndexConflictAddGetAndRemove() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let baseIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            guard let baseIndexEntry: GitIndexEntry = baseIndexEntry
            else
            {
                XCTFail("The base index entry was nil.")
                return
            }
            
            
            
            let indexRemoveResult: GitErrorCode = gitIndexRemove(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertOK(indexRemoveResult)
            
            
            
            let indexConflictAddResult: GitErrorCode = gitIndexConflictAdd(
                index:              indexPointer,
                ancestoryEntry:     baseIndexEntry,
                ourEntry:           baseIndexEntry,
                theirEntry:         baseIndexEntry
            )
            
            XCTAssertOK(indexConflictAddResult)
            
            
            
            var ancestorIndexEntry  = GitIndexEntry()
            var ourIndexEntry       = GitIndexEntry()
            var theirIndexEntry     = GitIndexEntry()
            
            let afterAddConflictGetResult: GitErrorCode = gitIndexConflictGet(
                ancestorOut:    &ancestorIndexEntry,
                ourOut:         &ourIndexEntry,
                theirOut:       &theirIndexEntry,
                index:          indexPointer,
                path:           Repository.readmeFileName
            )
            
            XCTAssertOK(afterAddConflictGetResult)
            XCTAssertEqual(ancestorIndexEntry.path, Repository.readmeFileName)
            XCTAssertEqual(ourIndexEntry.path, Repository.readmeFileName)
            XCTAssertEqual(theirIndexEntry.path, Repository.readmeFileName)
            
            
            
            let indexConflictRemoveResult: GitErrorCode
                = gitIndexConflictRemove(
                    index:  indexPointer,
                    path:   Repository.readmeFileName
                )
            
            XCTAssertOK(indexConflictRemoveResult)
            
            
            
            let afterRemoveConflictGetResult: GitErrorCode
                = gitIndexConflictGet(
                    ancestorOut:    &ancestorIndexEntry,
                    ourOut:         &ourIndexEntry,
                    theirOut:       &theirIndexEntry,
                    index:          indexPointer,
                    path:           Repository.readmeFileName
                )
            
            XCTAssertNotOK(afterRemoveConflictGetResult)
        }
    }
    
    
    
    func testGitIndexConflictIterator() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let conflictPaths: [String] =
            [
                "conflict1.txt",
                "conflict2.txt"
            ]
            
            for conflictPath in conflictPaths
            {
                try repository.modifyFile(
                    at:     conflictPath,
                    with:   "Conflict content"
                )
                
                
                
                let indexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                    index:  indexPointer,
                    path:   conflictPath
                )
                
                XCTAssertOK(indexAddByPathResult)
                
                
                
                let baseIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                    index:  indexPointer,
                    path:   conflictPath,
                    stage:  .gitIndexStageNormal
                )
                
                guard let baseIndexEntry: GitIndexEntry = baseIndexEntry
                else
                {
                    XCTFail("The base index entry was nil.")
                    return
                }
                
                
                
                let indexRemoveResult: GitErrorCode = gitIndexRemove(
                    index:  indexPointer,
                    path:   conflictPath,
                    stage:  .gitIndexStageNormal
                )
                
                XCTAssertOK(indexRemoveResult)
                
                
                
                let indexConflictAddResult: GitErrorCode = gitIndexConflictAdd(
                    index:              indexPointer,
                    ancestoryEntry:     baseIndexEntry,
                    ourEntry:           baseIndexEntry,
                    theirEntry:         baseIndexEntry
                )
                
                XCTAssertOK(indexConflictAddResult)
            }
            
            
            
            var iteratorPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexConflictIteratorFree(iterator: iteratorPointer)
            }
            
            
            
            let indexConflictIteratorNewResult: GitErrorCode
                = gitIndexConflictIteratorNew(
                    iteratorOut:    &iteratorPointer,
                    index:          indexPointer
                )
            
            XCTAssertOK(indexConflictIteratorNewResult)
            
            guard let iteratorPointer: OpaquePointer = iteratorPointer
            else
            {
                XCTFail("The index conflict iterator was nil.")
                return
            }
            
            
            
            var conflictCount: Int = 0
            
            var ancestorIndexEntry  = GitIndexEntry()
            var ourIndexEntry       = GitIndexEntry()
            var theirIndexEntry     = GitIndexEntry()
            
            while true
            {
                let indexConflictNextResult: GitErrorCode
                    = gitIndexConflictNext(
                        ancestorOut:    &ancestorIndexEntry,
                        ourOut:         &ourIndexEntry,
                        theirOut:       &theirIndexEntry,
                        iterator:       iteratorPointer
                    )
                
                if indexConflictNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(indexConflictNextResult)
                XCTAssertFalse(ancestorIndexEntry.path.isEmpty)
                XCTAssertFalse(ourIndexEntry.path.isEmpty)
                XCTAssertFalse(theirIndexEntry.path.isEmpty)
                
                conflictCount += 1
            }
            
            XCTAssertEqual(conflictCount, conflictPaths.count)
        }
    }
    
    
    
    func testGitIndexConflictIteratorFree() throws
    {
        gitIndexConflictIteratorFree(iterator: nil)
    }
    
    
    
    func testGitIndexCountAndClear() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let initialCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(initialCount, 0)
            
            
            
            let indexClearResult: GitErrorCode
                = gitIndexClear(index: indexPointer)
            
            XCTAssertOK(indexClearResult)
            
            
            
            let afterClearCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertEqual(afterClearCount, 0)
        }
    }
    
    
    
    func testGitIndexEntry() throws
    {
        let indexEntry = GitIndexEntry()
        
        XCTAssertNotNil(indexEntry.cTime)
        XCTAssertNotNil(indexEntry.mTime)
        XCTAssertEqual(indexEntry.dev, 0)
        XCTAssertEqual(indexEntry.ino, 0)
        XCTAssertEqual(indexEntry.mode, 0)
        XCTAssertEqual(indexEntry.uid, 0)
        XCTAssertEqual(indexEntry.gid, 0)
        XCTAssertEqual(indexEntry.fileSize, 0)
        XCTAssertZeroOID(indexEntry.id)
        XCTAssertEqual(indexEntry.flags, [])
        XCTAssertEqual(indexEntry.flagsExtended, [])
        XCTAssertEqual(indexEntry.path, "")
        
        try indexEntry.withCValue
        {
            cIndexEntry in
            
            XCTAssertNotNil(cIndexEntry.pointee.ctime)
            XCTAssertNotNil(cIndexEntry.pointee.mtime)
            XCTAssertEqual(cIndexEntry.pointee.dev, 0)
            XCTAssertEqual(cIndexEntry.pointee.ino, 0)
            XCTAssertEqual(cIndexEntry.pointee.mode, 0)
            XCTAssertEqual(cIndexEntry.pointee.uid, 0)
            XCTAssertEqual(cIndexEntry.pointee.gid, 0)
            XCTAssertEqual(cIndexEntry.pointee.file_size, 0)
            XCTAssertZeroOID(GitOID(cValue: cIndexEntry.pointee.id))
            XCTAssertEqual(GitIndexEntryFlagT(rawValue: UInt32(cIndexEntry.pointee.flags)), [])
            XCTAssertEqual(GitIndexEntryExtendedFlagT(rawValue: UInt32(cIndexEntry.pointee.flags_extended)), [])
            XCTAssertEqual(String(optionalCString: cIndexEntry.pointee.path), "")
        }
    }
    
    
    
    func testGitIndexEntryExtendedFlagT() throws
    {
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntryIntentToAdd.rawValue, GIT_INDEX_ENTRY_INTENT_TO_ADD.rawValue)
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntrySkipWorktree.rawValue, GIT_INDEX_ENTRY_SKIP_WORKTREE.rawValue)
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntryExtendedFlags.rawValue, GIT_INDEX_ENTRY_EXTENDED_FLAGS.rawValue)
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntryUpToDate.rawValue, GIT_INDEX_ENTRY_UPTODATE.rawValue)
        
        XCTAssertEqual(GitIndexEntryExtendedFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntryIntentToAdd.cValue(), GIT_INDEX_ENTRY_INTENT_TO_ADD)
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntrySkipWorktree.cValue(), GIT_INDEX_ENTRY_SKIP_WORKTREE)
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntryExtendedFlags.cValue(), GIT_INDEX_ENTRY_EXTENDED_FLAGS)
        XCTAssertEqual(GitIndexEntryExtendedFlagT.gitIndexEntryUpToDate.cValue(), GIT_INDEX_ENTRY_UPTODATE)
        
        XCTAssertEqual(GitIndexEntryExtendedFlagT(cValue: GIT_INDEX_ENTRY_INTENT_TO_ADD), .gitIndexEntryIntentToAdd)
        XCTAssertEqual(GitIndexEntryExtendedFlagT(cValue: GIT_INDEX_ENTRY_SKIP_WORKTREE), .gitIndexEntrySkipWorktree)
        XCTAssertEqual(GitIndexEntryExtendedFlagT(cValue: GIT_INDEX_ENTRY_EXTENDED_FLAGS), .gitIndexEntryExtendedFlags)
        XCTAssertEqual(GitIndexEntryExtendedFlagT(cValue: GIT_INDEX_ENTRY_UPTODATE), .gitIndexEntryUpToDate)
        
        
        
        let flags: GitIndexEntryExtendedFlagT =
        [
            .gitIndexEntrySkipWorktree,
            .gitIndexEntryUpToDate
        ]
        
        XCTAssertTrue(flags.contains(.gitIndexEntrySkipWorktree))
        XCTAssertTrue(flags.contains(.gitIndexEntryUpToDate))
        XCTAssertFalse(flags.contains(.gitIndexEntryIntentToAdd))
    }
    
    
    
    func testGitIndexEntryFlagT() throws
    {
        XCTAssertEqual(GitIndexEntryFlagT.gitIndexEntryExtended.rawValue, GIT_INDEX_ENTRY_EXTENDED.rawValue)
        XCTAssertEqual(GitIndexEntryFlagT.gitIndexEntryValid.rawValue, GIT_INDEX_ENTRY_VALID.rawValue)
        
        XCTAssertEqual(GitIndexEntryFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitIndexEntryFlagT.gitIndexEntryExtended.cValue(), GIT_INDEX_ENTRY_EXTENDED)
        XCTAssertEqual(GitIndexEntryFlagT.gitIndexEntryValid.cValue(), GIT_INDEX_ENTRY_VALID)
        
        XCTAssertEqual(GitIndexEntryFlagT(cValue: GIT_INDEX_ENTRY_EXTENDED), .gitIndexEntryExtended)
        XCTAssertEqual(GitIndexEntryFlagT(cValue: GIT_INDEX_ENTRY_VALID), .gitIndexEntryValid)
        
        
        
        let flags: GitIndexEntryFlagT =
        [
            .gitIndexEntryValid
        ]
        
        XCTAssertTrue(flags.contains(.gitIndexEntryValid))
        XCTAssertFalse(flags.contains(.gitIndexEntryExtended))
    }
    
    
    
    func testGitIndexEntryNameMask() throws
    {
        XCTAssertEqual(Int32(gitIndexEntryNameMask), GIT_INDEX_ENTRY_NAMEMASK)
    }
    
    
    
    func testGitIndexEntryStageAndIsConflict() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let indexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            guard let indexEntry: GitIndexEntry = indexEntry
            else
            {
                XCTFail("The index entry was nil.")
                return
            }
            
            
            
            let indexStage: GitIndexStageT?
                = gitIndexEntryStage(entry: indexEntry)
            
            XCTAssertEqual(indexStage, .gitIndexStageNormal)
            
            
            
            guard let isConflict: Bool
                    = gitIndexEntryIsConflict(entry: indexEntry)
            else
            {
                XCTFail("The index-is-conflict boolean was nil.")
                return
            }
            
            XCTAssertFalse(isConflict)
        }
    }
    
    
    
    func testGitIndexEntryStageMask() throws
    {
        XCTAssertEqual(Int32(gitIndexEntryStageMask), GIT_INDEX_ENTRY_STAGEMASK)
    }
    
    
    
    func testGitIndexEntryStageSet() throws
    {
        var indexEntry = GitIndexEntry()
        
        /// The flags are initially empty.
        XCTAssertEqual(indexEntry.flags, [])
        
        
        
        gitIndexEntryStageSet(
            entry:  &indexEntry,
            stage:  .gitIndexStageAny
        )
        
        /// Using ``GitIndexStageT/gitIndexStageAny`` does nothing.
        XCTAssertEqual(indexEntry.flags, [])
        
        
        
        gitIndexEntryStageSet(
            entry:  &indexEntry,
            stage:  .gitIndexStageAncestor
        )
        
        /// Stage 1 (ancestor): the stage bits (positions 12-13) should be `01`.
        XCTAssertEqual(indexEntry.flags.rawValue & 0x3000, 0x1000)
        
        
        
        gitIndexEntryStageSet(
            entry:  &indexEntry,
            stage:  .gitIndexStageOurs
        )
        
        /// Stage 2 (ours): the stage bits (positions 12-13)  should be `10`.
        XCTAssertEqual(indexEntry.flags.rawValue & 0x3000, 0x2000)
        
        
        
        gitIndexEntryStageSet(
            entry:  &indexEntry,
            stage:  .gitIndexStageTheirs
        )
        
        /// Stage 3 (theirs): the stage bits (positions 12-13)  should be `11`.
        XCTAssertEqual(indexEntry.flags.rawValue & 0x3000, 0x3000)
        
        
        
        gitIndexEntryStageSet(
            entry:  &indexEntry,
            stage:  .gitIndexStageNormal
        )
        
        /// Stage 0 (normal): the stage bits (positions 12-13)  should be `00`.
        XCTAssertEqual(indexEntry.flags.rawValue & 0x3000, 0x0000)
    }
    
    
    
    func testGitIndexEntryStageShift() throws
    {
        XCTAssertEqual(Int32(gitIndexEntryStageShift), GIT_INDEX_ENTRY_STAGESHIFT)
    }
    
    
    
    func testGitIndexFind() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            var position: Int = -1
            
            let findResult: GitErrorCode = gitIndexFind(
                atPos:  &position,
                index:  indexPointer,
                path:   Repository.readmeFileName
            )
            
            XCTAssertOK(findResult)
            XCTAssertGreaterThanOrEqual(position, 0)
            
            
            
            let indexEntry: GitIndexEntry? = gitIndexGetByIndex(
                index:  indexPointer,
                n:      position
            )
            
            XCTAssertNotNil(indexEntry)
            XCTAssertEqual(indexEntry?.path, Repository.readmeFileName)
            
            
            
            var notFoundPosition: Int = -1
            
            let notFoundResult: GitErrorCode = gitIndexFind(
                atPos:  &notFoundPosition,
                index:  indexPointer,
                path:   "non-existent-file.txt"
            )
            
            XCTAssertNotOK(notFoundResult)
            XCTAssertEqual(notFoundPosition, -1)
        }
    }
    
    
    
    func testGitIndexFindPrefix() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let prefix      : String    = "prefix-"
            let fileName1   : String    = "\(prefix)file1.txt"
            let fileName2   : String    = "\(prefix)file2.txt"
            
            try repository.modifyFile(
                at:     fileName1,
                with:   "File 1"
            )
            
            try repository.modifyFile(
                at:     fileName2,
                with:   "File 2"
            )
            
            
            
            let addFile1Result: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   fileName1
            )
            
            XCTAssertOK(addFile1Result)
            
            
            
            let addFile2Result: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   fileName2
            )
            
            XCTAssertOK(addFile2Result)
            
            
            
            var position: Int = -1
            
            let indexFindPrefixResult: GitErrorCode = gitIndexFindPrefix(
                atPos:      &position,
                index:      indexPointer,
                prefix:     prefix
            )
            
            XCTAssertOK(indexFindPrefixResult)
            XCTAssertGreaterThanOrEqual(position, 0)
            
            
            
            let indexEntry: GitIndexEntry? = gitIndexGetByIndex(
                index:  indexPointer,
                n:      position
            )
            
            XCTAssertNotNil(indexEntry)
            XCTAssertTrue(indexEntry?.path.hasPrefix(prefix) ?? false)
        }
    }
    
    
    
    func testGitIndexFree() throws
    {
        gitIndexFree(index: nil)
    }
    
    
    
    func testGitIndexGetByIndex() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let entryCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(entryCount, 0)
            
            
            
            let indexEntry: GitIndexEntry? = gitIndexGetByIndex(
                index:  indexPointer,
                n:      0
            )
            
            XCTAssertNotNil(indexEntry)
            XCTAssertFalse(indexEntry?.path.isEmpty ?? true)
            XCTAssertNotZeroOID(indexEntry?.id)
            
            
            
            let invalidEntry: GitIndexEntry? = gitIndexGetByIndex(
                index:  indexPointer,
                n:      entryCount + 100
            )
            
            XCTAssertNil(invalidEntry)
        }
    }
    
    
    
    func testGitIndexGetByPath() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let indexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNotNil(indexEntry)
            XCTAssertFalse(indexEntry?.path.isEmpty ?? true)
            XCTAssertNotZeroOID(indexEntry?.id)
            
            
            
            let invalidEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   "non-existent-file.txt",
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(invalidEntry)
        }
    }
    
    
    
    func testGitIndexHasConflictsAndCleanup() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let baseIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            guard let baseIndexEntry: GitIndexEntry = baseIndexEntry
            else
            {
                XCTFail("The base index entry was nil.")
                return
            }
            
            
            
            let indexRemoveResult: GitErrorCode = gitIndexRemove(
                index:  indexPointer,
                path:   Repository.readmeFileName,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertOK(indexRemoveResult)
            
            
            
            let indexConflictAddResult: GitErrorCode = gitIndexConflictAdd(
                index:              indexPointer,
                ancestoryEntry:     baseIndexEntry,
                ourEntry:           baseIndexEntry,
                theirEntry:         baseIndexEntry
            )
            
            XCTAssertOK(indexConflictAddResult)
            
            
            
            let beforeHasConflicts: Bool
                = gitIndexHasConflicts(index: indexPointer)
            
            XCTAssertTrue(beforeHasConflicts)
            
            
            
            let indexConflictCleanupResult: GitErrorCode
                = gitIndexConflictCleanup(index: indexPointer)
            
            XCTAssertOK(indexConflictCleanupResult)
            
            
            
            let afterHasConflicts: Bool
                = gitIndexHasConflicts(index: indexPointer)
            
            XCTAssertFalse(afterHasConflicts)
        }
    }
    
    
    
    func testGitIndexIterator() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            var iteratorPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexIteratorFree(iterator: iteratorPointer)
            }
            
            
            
            let indexIteratorNewResult: GitErrorCode = gitIndexIteratorNew(
                iteratorOut:    &iteratorPointer,
                index:          indexPointer
            )
            
            XCTAssertOK(indexIteratorNewResult)
            
            guard let iteratorPointer: OpaquePointer = iteratorPointer
            else
            {
                XCTFail("The index iterator was nil.")
                return
            }
            
            
            
            let expectedCount   : Int   = gitIndexEntryCount(index: indexPointer)
            var actualCount     : Int   = 0
            
            var indexEntry = GitIndexEntry()
            
            while true
            {
                let indexIteratorNextResult: GitErrorCode
                    = gitIndexIteratorNext(
                        out:        &indexEntry,
                        iterator:   iteratorPointer
                    )
                
                if indexIteratorNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(indexIteratorNextResult)
                XCTAssertFalse(indexEntry.path.isEmpty)
                
                actualCount += 1
            }
            
            XCTAssertEqual(actualCount, expectedCount)
        }
    }
    
    
    
    func testGitIndexIteratorFree() throws
    {
        gitIndexIteratorFree(iterator: nil)
    }
    
    
    
    func testGitIndexNew() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let indexNewResult: GitErrorCode
                = gitIndexNew(indexOut: &indexPointer)
            
            XCTAssertOK(indexNewResult)
            XCTAssertNotNil(indexPointer)
        }
    }
    
    
    
    func testGitIndexOpen() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let indexURL: URL = repository.url.appending(
                path:           ".git/index",
                directoryHint:  .notDirectory
            )
            
            let indexOpenResult: GitErrorCode = gitIndexOpen(
                indexOut:   &indexPointer,
                indexPath:  indexURL.path()
            )
            
            XCTAssertOK(indexOpenResult)
            XCTAssertNotNil(indexPointer)
        }
    }
    
    
    
    func testGitIndexOwner() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let ownerPointer: OpaquePointer
                = gitIndexOwner(index: indexPointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
        }
    }
    
    
    
    func testGitIndexPath() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let indexPath: String? = gitIndexPath(index: indexPointer)
            
            XCTAssertNotNil(indexPath)
            XCTAssertTrue(indexPath?.hasSuffix(".git/index") ?? false)
        }
    }
    
    
    
    func testGitIndexPathInMemory() throws
    {
        var indexPointer: OpaquePointer? = nil
        
        defer
        {
            gitIndexFree(index: indexPointer)
        }
        
        
        
        let indexNewResult: GitErrorCode = gitIndexNew(indexOut: &indexPointer)
        
        XCTAssertOK(indexNewResult)
        
        guard let indexPointer: OpaquePointer = indexPointer
        else
        {
            XCTFail("The index pointer was nil.")
            return
        }
        
        
        
        let indexPath: String? = gitIndexPath(index: indexPointer)
        
        XCTAssertNil(indexPath)
    }
    
    
    
    func testGitIndexReadAndWrite() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let indexReadResult: GitErrorCode = gitIndexRead(
                index:  indexPointer,
                force:  true
            )
            
            XCTAssertOK(indexReadResult)
            
            
            
            let indexWriteResult: GitErrorCode
                = gitIndexWrite(index: indexPointer)
            
            XCTAssertOK(indexWriteResult)
        }
    }
    
    
    
    func testGitIndexReadTreeAndWriteTree() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            var treePointer: OpaquePointer? = nil
            
            defer
            {
                gitTreeFree(tree: treePointer)
            }
            
            
            
            var treeOID = GitOID()
            
            let firstIndexWriteTreeResult: GitErrorCode = gitIndexWriteTree(
                out:    &treeOID,
                index:  indexPointer
            )
            
            XCTAssertOK(firstIndexWriteTreeResult)
            
            
            
            let treeLookupResult: GitErrorCode = gitTreeLookup(
                out:    &treePointer,
                repo:   repository.pointer,
                id:     treeOID
            )
            
            XCTAssertOK(treeLookupResult)
            
            guard let treePointer: OpaquePointer = treePointer
            else
            {
                XCTFail("The tree pointer was nil.")
                return
            }
            
            
            
            let indexClearResult: GitErrorCode
                = gitIndexClear(index: indexPointer)
            
            XCTAssertOK(indexClearResult)
            
            
            
            let entryCountAfterClear: Int
                = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertEqual(entryCountAfterClear, 0)
            
            
            
            let indexReadTreeResult: GitErrorCode = gitIndexReadTree(
                index:  indexPointer,
                tree:   treePointer
            )
            
            XCTAssertOK(indexReadTreeResult)
            
            
            
            let entryCountAfterRead: Int
                = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(entryCountAfterRead, 0)
            
            
            
            var newTreeOID = GitOID()
            
            let secondIndexWriteTreeResult: GitErrorCode = gitIndexWriteTree(
                out:    &newTreeOID,
                index:  indexPointer
            )
            
            XCTAssertOK(secondIndexWriteTreeResult)
            XCTAssertEqual(newTreeOID, treeOID)
        }
    }
    
    
    
    func testGitIndexRemoveDirectory() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let directoryPath   : String    = "subdirectory"
            let file1Path       : String    = "\(directoryPath)/file1.txt"
            let file2Path       : String    = "\(directoryPath)/file2.txt"
            
            try repository.createDirectory(at: "subdirectory")
            
            try repository.modifyFile(
                at:     file1Path,
                with:   "File 1"
            )
            
            try repository.modifyFile(
                at:     file2Path,
                with:   "File 2"
            )
            
            
            
            let addFile1Result: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   file1Path
            )
            
            XCTAssertOK(addFile1Result)
            
            
            
            let addFile2Result: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   file2Path
            )
            
            XCTAssertOK(addFile2Result)
            
            
            
            let initialCount: Int = gitIndexEntryCount(index: indexPointer)
            
            
            
            let indexRemoveDirectoryResult: GitErrorCode
                = gitIndexRemoveDirectory(
                    index:  indexPointer,
                    dir:    directoryPath,
                    stage:  .gitIndexStageNormal
                )
            
            XCTAssertOK(indexRemoveDirectoryResult)
            
            
            
            let afterRemoveCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertEqual(afterRemoveCount, initialCount - 2)
            
            
            
            let file1Entry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   file1Path,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(file1Entry)
            
            
            
            let file2Entry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   file2Path,
                stage:  .gitIndexStageNormal
            )
            
            XCTAssertNil(file2Entry)
        }
    }
    
    
    
    func testGitStageT() throws
    {
        XCTAssertEqual(GitIndexStageT.gitIndexStageAny.rawValue, GIT_INDEX_STAGE_ANY.rawValue)
        XCTAssertEqual(GitIndexStageT.gitIndexStageNormal.rawValue, GIT_INDEX_STAGE_NORMAL.rawValue)
        XCTAssertEqual(GitIndexStageT.gitIndexStageAncestor.rawValue, GIT_INDEX_STAGE_ANCESTOR.rawValue)
        XCTAssertEqual(GitIndexStageT.gitIndexStageOurs.rawValue, GIT_INDEX_STAGE_OURS.rawValue)
        XCTAssertEqual(GitIndexStageT.gitIndexStageTheirs.rawValue, GIT_INDEX_STAGE_THEIRS.rawValue)
        
        XCTAssertNil(GitIndexStageT(rawValue: 123))
        
        XCTAssertEqual(GitIndexStageT.gitIndexStageAny.cValue(), GIT_INDEX_STAGE_ANY)
        XCTAssertEqual(GitIndexStageT.gitIndexStageNormal.cValue(), GIT_INDEX_STAGE_NORMAL)
        XCTAssertEqual(GitIndexStageT.gitIndexStageAncestor.cValue(), GIT_INDEX_STAGE_ANCESTOR)
        XCTAssertEqual(GitIndexStageT.gitIndexStageOurs.cValue(), GIT_INDEX_STAGE_OURS)
        XCTAssertEqual(GitIndexStageT.gitIndexStageTheirs.cValue(), GIT_INDEX_STAGE_THEIRS)
        
        XCTAssertEqual(GitIndexStageT(cValue: GIT_INDEX_STAGE_ANY), .gitIndexStageAny)
        XCTAssertEqual(GitIndexStageT(cValue: GIT_INDEX_STAGE_NORMAL), .gitIndexStageNormal)
        XCTAssertEqual(GitIndexStageT(cValue: GIT_INDEX_STAGE_ANCESTOR), .gitIndexStageAncestor)
        XCTAssertEqual(GitIndexStageT(cValue: GIT_INDEX_STAGE_OURS), .gitIndexStageOurs)
        XCTAssertEqual(GitIndexStageT(cValue: GIT_INDEX_STAGE_THEIRS), .gitIndexStageTheirs)
    }
    
    
    
    func testGitIndexTime() throws
    {
        let indexTime = GitIndexTime()
        
        XCTAssertEqual(indexTime.seconds, 0)
        XCTAssertEqual(indexTime.nanoseconds, 0)
        
        let cIndexTime: git_index_time = indexTime.cValue()
        
        XCTAssertEqual(cIndexTime.seconds, 0)
        XCTAssertEqual(cIndexTime.nanoseconds, 0)
    }
    
    
    
    func testGitIndexUpdateAll() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let fileName: String = "update.txt"
            
            try repository.modifyFile(
                at:     fileName,
                with:   "Original content"
            )
            
            
            
            let indexAddByPathResult: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   fileName
            )
            
            XCTAssertOK(indexAddByPathResult)
            
            
            
            let indexWriteResult: GitErrorCode
                = gitIndexWrite(index: indexPointer)
            
            XCTAssertOK(indexWriteResult)
            
            
            
            let originalIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   fileName,
                stage:  .gitIndexStageNormal
            )
            
            guard let originalIndexEntry: GitIndexEntry = originalIndexEntry
            else
            {
                XCTFail("The original index entry was nil.")
                return
            }
            
            
            
            try repository.modifyFile(
                at:     fileName,
                with:   "Updated content"
            )
            
            
            
            let indexUpdateAllResult: GitErrorCode = gitIndexUpdateAll(
                index:      indexPointer,
                pathspec:   [],
                callback:   nil,
                payload:    nil
            )
            
            XCTAssertOK(indexUpdateAllResult)
            
            
            
            let updatedIndexEntry: GitIndexEntry? = gitIndexGetByPath(
                index:  indexPointer,
                path:   fileName,
                stage:  .gitIndexStageNormal
            )
            
            guard let updatedIndexEntry: GitIndexEntry = updatedIndexEntry
            else
            {
                XCTFail("The updated index entry was nil.")
                return
            }
            
            XCTAssertNotEqual(updatedIndexEntry.id, originalIndexEntry.id)
        }
    }
    
    
    
    func testGitIndexWriteTreeTo() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            var treeOID = GitOID()
            
            let indexWriteTreeToResult: GitErrorCode = gitIndexWriteTreeTo(
                out:    &treeOID,
                index:  indexPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(indexWriteTreeToResult)
            XCTAssertNotZeroOID(treeOID)
        }
    }
    
    
    
    func testGitIndexVersionAndSetVersion() throws
    {
        try Repository.withIndexPointer
        {
            repository, indexPointer in
            
            let initialVersion: UInt32 = gitIndexVersion(index: indexPointer)
            
            XCTAssertGreaterThanOrEqual(initialVersion, 2)
            XCTAssertLessThanOrEqual(initialVersion, 4)
            
            
            
            let indexSetVersionResult: GitErrorCode = gitIndexSetVersion(
                index:      indexPointer,
                version:    3
            )
            
            XCTAssertOK(indexSetVersionResult)
            
            
            
            let updatedVersion: UInt32 = gitIndexVersion(index: indexPointer)
            
            XCTAssertEqual(updatedVersion, 3)
        }
    }
}



// MARK: - Extensions

private extension IndexTests
{
    struct CallbackData
    {
        var callCount: Int = 0
    }
}
