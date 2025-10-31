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



final class IndexAdvancedTests: XCTestCaseStopOnFail
{
    func testGitIndexNameAdd() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addNameEntry(
                to:     indexPointer,
                in:     repository
            )
        }
    }
    
    
    
    func testGitIndexNameClear() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addNameEntry(
                to:     indexPointer,
                in:     repository
            )
            
            
            
            let indexNameClearResult: GitErrorCode
                = gitIndexNameClear(index: indexPointer)
            
            XCTAssertOK(indexNameClearResult)
            
            
            
            let entryCountAfterClear: Int
                = gitIndexNameEntryCount(index: indexPointer)
            
            XCTAssertEqual(entryCountAfterClear, 0)
        }
    }
    
    
    
    func testGitIndexNameEntry() throws
    {
        let indexNameEntry = GitIndexNameEntry()
        
        XCTAssertNil(indexNameEntry.ancestor)
        XCTAssertNil(indexNameEntry.ours)
        XCTAssertNil(indexNameEntry.theirs)
        
        try indexNameEntry.withCValue
        {
            cIndexNameEntry in
            
            XCTAssertNil(cIndexNameEntry.pointee.ancestor)
            XCTAssertNil(cIndexNameEntry.pointee.ours)
            XCTAssertNil(cIndexNameEntry.pointee.theirs)
        }
    }
    
    
    
    func testGitIndexNameEntryCount() throws
    {
        try Repository.withIndex
        {
            _, indexPointer in
            
            let entryCount: Int = gitIndexNameEntryCount(index: indexPointer)
            
            XCTAssertEqual(entryCount, 0)
        }
    }
    
    
    
    func testGitIndexNameGetByIndex() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addNameEntry(
                to:     indexPointer,
                in:     repository
            )
            
            
            let indexNameEntry: GitIndexNameEntry? = gitIndexNameGetByIndex(
                index:  indexPointer,
                n:      0
            )
            
            XCTAssertNotNil(indexNameEntry)
            XCTAssertNotNil(indexNameEntry?.ancestor)
            XCTAssertNotNil(indexNameEntry?.ours)
            XCTAssertNotNil(indexNameEntry?.theirs)
            XCTAssertEqual(indexNameEntry?.ancestor, Self.ancestorPath)
            XCTAssertEqual(indexNameEntry?.ours, Self.ourPath)
            XCTAssertEqual(indexNameEntry?.theirs, Self.theirPath)
            
            
            
            let entryCount: Int = gitIndexNameEntryCount(index: indexPointer)
            
            let invalidIndexNameEntry: GitIndexNameEntry?
                = gitIndexNameGetByIndex(
                    index:  indexPointer,
                    n:      entryCount + 100
                )
            
            XCTAssertNil(invalidIndexNameEntry)
        }
    }
    
    
    
    func testGitIndexREUCAdd() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addREUCEntry(
                to:     indexPointer,
                in:     repository
            )
        }
    }
    
    
    
    func testGitIndexREUCClear() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addREUCEntry(
                to:     indexPointer,
                in:     repository
            )
            
            
            
            let indexREUCClearResult: GitErrorCode
                = gitIndexREUCClear(index: indexPointer)
            
            XCTAssertOK(indexREUCClearResult)
            
            
            
            let entryCountAfterClear: Int
                = gitIndexREUCEntryCount(index: indexPointer)
            
            XCTAssertEqual(entryCountAfterClear, 0)
        }
    }
    
    
    
    func testGitIndexREUCEntry() throws
    {
        let indexREUCEntry = GitIndexREUCEntry()
        
        XCTAssertEqual(indexREUCEntry.mode.0, 0)
        XCTAssertEqual(indexREUCEntry.mode.1, 0)
        XCTAssertEqual(indexREUCEntry.mode.2, 0)
        XCTAssertZeroOID(indexREUCEntry.oid.0)
        XCTAssertZeroOID(indexREUCEntry.oid.1)
        XCTAssertZeroOID(indexREUCEntry.oid.2)
        XCTAssertNil(indexREUCEntry.path)
        
        try indexREUCEntry.withCValue
        {
            cIndexREUCEntry in
            
            XCTAssertEqual(cIndexREUCEntry.pointee.mode.0, 0)
            XCTAssertEqual(cIndexREUCEntry.pointee.mode.1, 0)
            XCTAssertEqual(cIndexREUCEntry.pointee.mode.2, 0)
            XCTAssertZeroOID(GitOID(cValue: cIndexREUCEntry.pointee.oid.0))
            XCTAssertZeroOID(GitOID(cValue: cIndexREUCEntry.pointee.oid.1))
            XCTAssertZeroOID(GitOID(cValue: cIndexREUCEntry.pointee.oid.2))
            XCTAssertNil(cIndexREUCEntry.pointee.path)
        }
    }
    
    
    
    func testGitIndexREUCEntryCount() throws
    {
        try Repository.withIndex
        {
            _, indexPointer in
            
            let entryCount: Int = gitIndexREUCEntryCount(index: indexPointer)
            
            XCTAssertEqual(entryCount, 0)
        }
    }
    
    
    
    func testGitIndexREUCFind() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addREUCEntry(
                to:     indexPointer,
                in:     repository
            )
            
            
            
            var position: Int = -1
            
            var indexREUCFindResult: GitErrorCode = gitIndexREUCFind(
                atPos:  &position,
                index:  indexPointer,
                path:   Self.fileName
            )
            
            XCTAssertOK(indexREUCFindResult)
            XCTAssertGreaterThanOrEqual(position, 0)
            
            
            
            indexREUCFindResult = gitIndexREUCFind(
                atPos:  &position,
                index:  indexPointer,
                path:   "non-existent.txt"
            )
            
            XCTAssertNotOK(indexREUCFindResult)
        }
    }
    
    
    
    func testGitIndexREUCGetByIndex() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addREUCEntry(
                to:     indexPointer,
                in:     repository
            )
            
            
            
            let indexREUCEntry: GitIndexREUCEntry? = gitIndexREUCGetByIndex(
                index:  indexPointer,
                n:      0
            )
            
            guard let indexREUCEntry: GitIndexREUCEntry = indexREUCEntry
            else
            {
                XCTFail("The index REUC entry was nil.")
                return
            }
            
            XCTAssertEqual(indexREUCEntry.mode.0, Self.fileModeUInt32)
            XCTAssertEqual(indexREUCEntry.mode.1, Self.fileModeUInt32)
            XCTAssertEqual(indexREUCEntry.mode.2, Self.fileModeUInt32)
            XCTAssertNotZeroOID(indexREUCEntry.oid.0)
            XCTAssertNotZeroOID(indexREUCEntry.oid.1)
            XCTAssertNotZeroOID(indexREUCEntry.oid.2)
            XCTAssertEqual(indexREUCEntry.path, Self.fileName)
            
            
            
            let entryCount: Int = gitIndexREUCEntryCount(index: indexPointer)
            
            let invalidIndexREUCEntry: GitIndexREUCEntry?
                = gitIndexREUCGetByIndex(
                    index:  indexPointer,
                    n:      entryCount + 100
                )
            
            XCTAssertNil(invalidIndexREUCEntry)
        }
    }
    
    
    
    func testGitIndexREUCGetByPath() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addREUCEntry(
                to:     indexPointer,
                in:     repository
            )
            
            
            
            let indexREUCEntry: GitIndexREUCEntry? = gitIndexREUCGetByPath(
                index:  indexPointer,
                path:   Self.fileName
            )
            
            guard let indexREUCEntry: GitIndexREUCEntry = indexREUCEntry
            else
            {
                XCTFail("The index REUC entry was nil.")
                return
            }
            
            XCTAssertEqual(indexREUCEntry.mode.0, Self.fileModeUInt32)
            XCTAssertEqual(indexREUCEntry.mode.1, Self.fileModeUInt32)
            XCTAssertEqual(indexREUCEntry.mode.2, Self.fileModeUInt32)
            XCTAssertNotZeroOID(indexREUCEntry.oid.0)
            XCTAssertNotZeroOID(indexREUCEntry.oid.1)
            XCTAssertNotZeroOID(indexREUCEntry.oid.2)
            XCTAssertEqual(indexREUCEntry.path, Self.fileName)
            
            
            
            let invalidIndexREUCEntry: GitIndexREUCEntry?
                = gitIndexREUCGetByPath(
                    index:  indexPointer,
                    path:   "non-existent.txt"
                )
            
            XCTAssertNil(invalidIndexREUCEntry)
        }
    }
    
    
    
    func testGitIndexREUCRemove() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            addREUCEntry(
                to:     indexPointer,
                in:     repository
            )
            
            
            
            let indexREUCRemoveResult: GitErrorCode
                = gitIndexREUCRemove(
                    index:  indexPointer,
                    n:      0
                )
            
            XCTAssertOK(indexREUCRemoveResult)
            
            
            
            let entryCountAfterRemove: Int
                = gitIndexREUCEntryCount(index: indexPointer)
            
            XCTAssertEqual(entryCountAfterRemove, 0)
        }
    }
}



// MARK: - Extensions

private extension IndexAdvancedTests
{
    static let fileName         : String    = "conflict.txt"
    static let ancestorPath     : String    = "ancestor.txt"
    static let ourPath          : String    = "ours.txt"
    static let theirPath        : String    = "theirs.txt"
    static let ancestorContent  : Data      = Data("Ancestor content".utf8)
    static let ourContent       : Data      = Data("Our content".utf8)
    static let theirContent     : Data      = Data("Their content".utf8)
    
    
    static let fileModeInt32    = Int32(GitFileModeT.gitFileModeBlob.rawValue)
    static let fileModeUInt32   = UInt32(GitFileModeT.gitFileModeBlob.rawValue)
    
    
    
    /// Adds a file name conflict entry to the given index in the given
    /// repository.
    /// - Parameters:
    ///   - indexPointer: The index to update. The underlying type must be
    ///   `git_index`.
    ///   - repository: The repository containing the index.
    func addNameEntry(
        to  indexPointer    : OpaquePointer,
        in  repository      : Repository
    )
    {
        let entryCountBeforeAdd: Int
            = gitIndexNameEntryCount(index: indexPointer)
        
        XCTAssertEqual(entryCountBeforeAdd, 0)
        
        
        
        let indexNameAddResult: GitErrorCode = gitIndexNameAdd(
            index:      indexPointer,
            ancestor:   Self.ancestorPath,
            ours:       Self.ourPath,
            theirs:     Self.theirPath
        )
        
        XCTAssertOK(indexNameAddResult)
        
        
        
        
        let entryCountAfterAdd: Int
            = gitIndexNameEntryCount(index: indexPointer)
        
        XCTAssertEqual(entryCountAfterAdd, entryCountBeforeAdd + 1)
    }
    
    
    
    /// Adds a resolve-undo (REUC) entry to the given index in the given
    /// repository.
    /// - Parameters:
    ///   - indexPointer: The index to update. The underlying type must be
    ///   `git_index`.
    ///   - repository: The repository containing the index.
    func addREUCEntry(
        to  indexPointer    : OpaquePointer,
        in  repository      : Repository
    )
    {
        let entryCountBeforeAdd: Int
            = gitIndexREUCEntryCount(index: indexPointer)
        
        XCTAssertEqual(entryCountBeforeAdd, 0)
        
        
        
        let ancestorOID: GitOID = Blob.createBlob(
            in:     repository,
            from:   .buffer(data: Self.ancestorContent)
        )
        
        let ourOID: GitOID = Blob.createBlob(
            in:     repository,
            from:   .buffer(data: Self.ourContent)
        )
        
        let theirOID: GitOID = Blob.createBlob(
            in:     repository,
            from:   .buffer(data: Self.theirContent)
        )
        
        
        
        let indexREUCAddResult: GitErrorCode = gitIndexREUCAdd(
            index:          indexPointer,
            path:           Self.fileName,
            ancestorMode:   Self.fileModeInt32,
            ancestorID:     ancestorOID,
            ourMode:        Self.fileModeInt32,
            ourID:          ourOID,
            theirMode:      Self.fileModeInt32,
            theirID:        theirOID
        )
        
        XCTAssertOK(indexREUCAddResult)
        
        
        
        let entryCountAfterAdd: Int
            = gitIndexREUCEntryCount(index: indexPointer)
        
        XCTAssertEqual(entryCountAfterAdd, entryCountBeforeAdd + 1)
    }
}
