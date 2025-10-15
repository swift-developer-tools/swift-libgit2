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



final class ODBTests: XCTestCaseStopOnFail
{
    func testGitAddAlternate() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var odbPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBFree(db: odbPointer)
            }
            
            
            
            let odbNewResult: GitErrorCode = gitODBNew(odb: &odbPointer)
            
            XCTAssertOK(odbNewResult)
            
            guard let odbPointer: OpaquePointer = odbPointer
            else
            {
                XCTFail("The ODB pointer was nil.")
                return
            }
            
            
            
            let alternateDirectoryURL: URL
                = try Repository.createTemporaryDirectory(named: "alternates")
            
            defer
            {
                try? FileManager.default.removeItem(at: alternateDirectoryURL)
            }
            
            
            
            var backendOwnershipTransferred : Bool = false
            
            var looseBackendPointer: UnsafeMutablePointer<git_odb_backend>?
                = nil
            
            defer
            {
                if
                    !backendOwnershipTransferred,
                    looseBackendPointer != nil
                {
                    /// Ownership of the memory transfers to libgit2 after
                    /// adding the backend. Free the memory manually if the
                    /// the memory was allocated, but the add operation failed.
                    looseBackendPointer?.pointee.free(looseBackendPointer)
                }
            }
            
            
            
            let looseBackendResult: GitErrorCode = gitODBBackendLoose(
                out:                &looseBackendPointer,
                objectsDir:         alternateDirectoryURL.path(),
                compressionLevel:   -1,
                doFSync:            false,
                dirMode:            0,
                fileMode:           0
            )
            
            XCTAssertOK(looseBackendResult)
            
            guard let looseBackendPointer: UnsafeMutablePointer<git_odb_backend>
                    = looseBackendPointer
            else
            {
                XCTFail("The loose ODB backend pointer was nil.")
                return
            }
            
            
            
            let odbAddAlternateResult: GitErrorCode = gitODBAddAlternate(
                odb:        odbPointer,
                backend:    looseBackendPointer,
                priority:   5
            )
            
            XCTAssertOK(odbAddAlternateResult)
            
            backendOwnershipTransferred = true
            
            
            
            let backendCount: Int = gitODBNumBackends(odb: odbPointer)
            
            XCTAssertGreaterThan(backendCount, 0)
        }
    }
    
    
    
    func testGitAddBackend() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var odbPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBFree(db: odbPointer)
            }
            
            
            
            let odbNewResult: GitErrorCode = gitODBNew(odb: &odbPointer)
            
            XCTAssertOK(odbNewResult)
            
            guard let odbPointer: OpaquePointer = odbPointer
            else
            {
                XCTFail("The ODB pointer was nil.")
                return
            }
            
            
            
            let objectsDirectoryURL: URL = repository.url.appending(
                path:           ".git/objects",
                directoryHint:  .isDirectory
            )
            
            
            
            var backendOwnershipTransferred : Bool = false
            
            var looseBackendPointer: UnsafeMutablePointer<git_odb_backend>?
                = nil
            
            defer
            {
                if
                    !backendOwnershipTransferred,
                    looseBackendPointer != nil
                {
                    /// Ownership of the memory transfers to libgit2 after
                    /// adding the backend. Free the memory manually if the
                    /// the memory was allocated, but the add operation failed.
                    looseBackendPointer?.pointee.free(looseBackendPointer)
                }
            }
            
            
            
            let looseBackendResult: GitErrorCode = gitODBBackendLoose(
                out:                &looseBackendPointer,
                objectsDir:         objectsDirectoryURL.path(),
                compressionLevel:   -1,
                doFSync:            false,
                dirMode:            0,
                fileMode:           0
            )
            
            XCTAssertOK(looseBackendResult)
            
            guard let looseBackendPointer: UnsafeMutablePointer<git_odb_backend>
                    = looseBackendPointer
            else
            {
                XCTFail("The loose ODB backend pointer was nil.")
                return
            }
            
            
            
            let odbAddBackendResult: GitErrorCode = gitODBAddBackend(
                odb:        odbPointer,
                backend:    looseBackendPointer,
                priority:   1
            )
            
            XCTAssertOK(odbAddBackendResult)
            
            backendOwnershipTransferred = true
            
            
            
            let backendCount: Int = gitODBNumBackends(odb: odbPointer)
            
            XCTAssertGreaterThan(backendCount, 0)
        }
    }
    
    
    
    func testGitODBAddDiskAlternate() throws
    {
        try withOpenedODBPointer
        {
            _, odbPointer in
            
            let alternateDirectoryURL: URL
                = try Repository.createTemporaryDirectory(named: "alternates")
            
            defer
            {
                try? FileManager.default.removeItem(at: alternateDirectoryURL)
            }
            
            
            
            
            let addDiskAlternateResult: GitErrorCode = gitODBAddDiskAlternate(
                odb:    odbPointer,
                path:   alternateDirectoryURL.path()
            )
            
            XCTAssertOK(addDiskAlternateResult)
        }
    }
    
    
    
    func testGitODBBackend() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let backendCount: Int = gitODBNumBackends(odb: odbPointer)
            
            XCTAssertGreaterThan(backendCount, 0)
            
            
            
            var backendPointer: UnsafeMutablePointer<git_odb_backend>? = nil
            
            let odbGetBackendResult: GitErrorCode = gitODBGetBackend(
                out:    &backendPointer,
                odb:    odbPointer,
                pos:    0
            )
            
            XCTAssertOK(odbGetBackendResult)
            XCTAssertNotNil(backendPointer)
        }
    }
    
    
    
    func testGitODBObjectDup() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            var sourceObjectPointer     : OpaquePointer?    = nil
            var duplicatedObjectPointer : OpaquePointer?    = nil
            
            defer
            {
                gitODBObjectFree(object: sourceObjectPointer)
                gitODBObjectFree(object: duplicatedObjectPointer)
            }
            
            
            
            let odbReadResult: GitErrorCode = gitODBRead(
                obj:    &sourceObjectPointer,
                db:     odbPointer,
                id:     headOID
            )
            
            XCTAssertOK(odbReadResult)
            
            guard let sourceObjectPointer: OpaquePointer = sourceObjectPointer
            else
            {
                XCTFail("The source ODB object pointer was nil.")
                return
            }
            
            
            
            let odbObjectDupResult: GitErrorCode = gitODBObjectDup(
                dest:       &duplicatedObjectPointer,
                source:     sourceObjectPointer
            )
            
            XCTAssertOK(odbObjectDupResult)
            
            guard let duplicatedObjectPointer: OpaquePointer
                    = duplicatedObjectPointer
            else
            {
                XCTFail("The duplicated ODB object pointer was nil.")
                return
            }
            
            
            
            let sourceOID       : GitOID    = gitODBObjectID(object: sourceObjectPointer)
            let duplicatedOID   : GitOID    = gitODBObjectID(object: duplicatedObjectPointer)
            
            XCTAssertEqual(sourceOID, headOID)
            XCTAssertEqual(sourceOID, duplicatedOID)
            
            
            
            let sourceData      : Data?     = gitODBObjectData(object: sourceObjectPointer)
            let duplicatedData  : Data?     = gitODBObjectData(object: duplicatedObjectPointer)
            
            XCTAssertNotNil(sourceData)
            XCTAssertGreaterThan(sourceData?.count ?? 0, 0)
            XCTAssertNotNil(duplicatedData)
            XCTAssertGreaterThan(duplicatedData?.count ?? 0, 0)
            XCTAssertEqual(sourceData, duplicatedData)
            
            
            
            let sourceSize      : Int   = gitODBObjectSize(object: sourceObjectPointer)
            let duplicatedSize  : Int   = gitODBObjectSize(object: duplicatedObjectPointer)
            
            XCTAssertGreaterThan(sourceSize, 0)
            XCTAssertEqual(sourceSize, sourceData?.count ?? 0)
            XCTAssertGreaterThan(duplicatedSize, 0)
            XCTAssertEqual(duplicatedSize, duplicatedData?.count ?? 0)
            XCTAssertEqual(sourceSize, duplicatedSize)
            
            
            
            let sourceType      : GitObjectT?   = gitODBObjectType(object: sourceObjectPointer)
            let duplicatedType  : GitObjectT?   = gitODBObjectType(object: duplicatedObjectPointer)
            
            XCTAssertNotNil(sourceType)
            XCTAssertEqual(sourceType, .gitObjectCommit)
            XCTAssertNotNil(duplicatedType)
            XCTAssertEqual(duplicatedType, .gitObjectCommit)
        }
    }
    
    
    
    func testGitODBExists() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let odbExists: Bool = gitODBExists(
                db:     odbPointer,
                id:     headOID
            )
            
            XCTAssertTrue(odbExists)
            
            
            
            var odbExistsExt: Bool = gitODBExistsExt(
                db:         odbPointer,
                id:         headOID,
                flags:      .gitODBLookupNoRefresh
            )
            
            XCTAssertTrue(odbExistsExt)
            
            
            
            odbExistsExt = false
            
            odbExistsExt = gitODBExistsExt(
                db:         odbPointer,
                id:         headOID,
                flags:      []
            )
            
            XCTAssertTrue(odbExistsExt)
            
            
            
            let zeroOIDExists: Bool = gitODBExists(
                db:     odbPointer,
                id:     GitOID()
            )
            
            XCTAssertFalse(zeroOIDExists)
        }
    }
    
    
    
    func testGitODBExistsPrefixAndExpandIDs() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            var fullOID = GitOID()
            
            let odbExistsPrefixResult: GitErrorCode = gitODBExistsPrefix(
                out:        &fullOID,
                db:         odbPointer,
                shortID:    headOID,
                len:        7
            )
            
            XCTAssertOK(odbExistsPrefixResult)
            XCTAssertEqual(fullOID, headOID)
            
            
            
            var expandID = GitODBExpandID()
            
            expandID.id         = headOID
            expandID.length     = 7
            expandID.type       = .gitObjectCommit
            
            var expandIDs: [GitODBExpandID] = [expandID]
            
            
            
            let odbExpandIDsResult: GitErrorCode = gitODBExpandIDs(
                db:     odbPointer,
                ids:    &expandIDs,
                count:  expandIDs.count
            )
            
            XCTAssertOK(odbExpandIDsResult)
            XCTAssertEqual(expandIDs[0].id, headOID)
            XCTAssertEqual(expandIDs[0].type, .gitObjectCommit)
        }
    }
    
    
    
    func testGitODBExpandID() throws
    {
        let odbExpandID = GitODBExpandID()
        
        XCTAssertZeroOID(odbExpandID.id)
        XCTAssertEqual(odbExpandID.length, 0)
        XCTAssertEqual(odbExpandID.type, .gitObjectAny)
        
        let cODBExpandID: git_odb_expand_id = odbExpandID.cValue()
        
        XCTAssertZeroOID(GitOID(cValue: cODBExpandID.id))
        XCTAssertEqual(cODBExpandID.length, 0)
        XCTAssertEqual(GitObjectT(cValue: cODBExpandID.type), .gitObjectAny)
    }
    
    
    
    func testGitODBForEach() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            var callbackData = CallbackData()
            
            let odbForEachCB: GitODBForEachCB =
            {
                oidPointer, payload in
                
                guard
                    let payload     : UnsafeMutableRawPointer   = payload,
                    let oidPointer  : UnsafePointer<git_oid>    = oidPointer
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                payloadPointer.pointee.oids.append(
                    GitOID(cValue: oidPointer.pointee)
                )
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let odbForEachResult: GitErrorCode = gitODBForEach(
                    db:         odbPointer,
                    cb:         odbForEachCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(odbForEachResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            XCTAssertGreaterThan(callbackData.oids.count, 0)
            
            
            
            for oid in callbackData.oids
            {
                let oidExists: Bool = gitODBExists(
                    db:     odbPointer,
                    id:     oid
                )
                
                XCTAssertTrue(oidExists)
            }
        }
    }
    
    
    
    func testGitODBFree() throws
    {
        gitODBFree(db: nil)
    }
    
    
    
    func testGitODBHashAndHashFile() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let blobContent : String    = "Blob content"
            let blobData    : Data      = Data(blobContent.utf8)
            
            var hashOID = GitOID()
            
            let odbHashResult: GitErrorCode = gitODBHash(
                oid:            &hashOID,
                data:           blobData,
                len:            blobData.count,
                objectType:     .gitObjectBlob
            )
            
            XCTAssertOK(odbHashResult)
            XCTAssertNotZeroOID(hashOID)
            
            
            
            let testURL: URL = try repository.modifyFile(
                at:     "hash.txt",
                with:   blobContent
            )
            
            
            
            var fileHashOID = GitOID()
            
            let odbHashFileResult: GitErrorCode = gitODBHashFile(
                oid:            &fileHashOID,
                path:           testURL.path(),
                objectType:     .gitObjectBlob
            )
            
            XCTAssertOK(odbHashFileResult)
            XCTAssertNotZeroOID(fileHashOID)
            XCTAssertEqual(fileHashOID, hashOID)
        }
    }
    
    
    
    func testGitODBLookupFlagsT() throws
    {
        XCTAssertEqual(GitODBLookupFlagsT.gitODBLookupNoRefresh.rawValue, GIT_ODB_LOOKUP_NO_REFRESH.rawValue)
        
        XCTAssertEqual(GitODBLookupFlagsT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitODBLookupFlagsT.gitODBLookupNoRefresh.cValue(), GIT_ODB_LOOKUP_NO_REFRESH)
        
        XCTAssertEqual(GitODBLookupFlagsT(cValue: GIT_ODB_LOOKUP_NO_REFRESH).cValue(), GIT_ODB_LOOKUP_NO_REFRESH)
        
        
        
        let flags: GitODBLookupFlagsT =
        [
            .gitODBLookupNoRefresh
        ]
        
        XCTAssertTrue(flags.contains(.gitODBLookupNoRefresh))
    }
    
    
    
    func testGitODBNew() throws
    {
        var odbPointer: OpaquePointer? = nil
        
        defer
        {
            gitODBFree(db: odbPointer)
        }
        
        
        
        let odbNewResult: GitErrorCode = gitODBNew(odb: &odbPointer)
        
        XCTAssertOK(odbNewResult)
        XCTAssertNotNil(odbPointer)
    }
    
    
    
    func testGitODBObjectFree() throws
    {
        gitODBObjectFree(object: nil)
    }
    
    
    
    func testGitODBOpenAndRefresh() throws
    {
        try withOpenedODBPointer
        {
            _, odbPointer in
            
            let odbRefreshResult: GitErrorCode = gitODBRefresh(db: odbPointer)
            
            XCTAssertOK(odbRefreshResult)
        }
    }
    
    
    
    func testGitODBOptions() throws
    {
        let odbOptions = GitODBOptions()
        
        XCTAssertEqual(odbOptions.version, gitODBOptionsVersion)
        XCTAssertEqual(odbOptions.oidType, .gitOIDSHA1)
        
        let cODBOptions: git_odb_options = odbOptions.cValue()
        
        XCTAssertEqual(cODBOptions.version, gitODBOptionsVersion)
        XCTAssertEqual(GitOIDT(cValue: cODBOptions.oid_type), .gitOIDSHA1)
    }
    
    
    
    func testGitODBOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitODBOptionsVersion), GIT_ODB_OPTIONS_VERSION)
    }
    
    
    
    func testGitODBReadAndObjectGetters() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBObjectFree(object: objectPointer)
            }
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let odbReadResult: GitErrorCode = gitODBRead(
                obj:    &objectPointer,
                db:     odbPointer,
                id:     headOID
            )
            
            XCTAssertOK(odbReadResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The ODB object pointer was nil.")
                return
            }
            
            
            
            let objectOID: GitOID = gitODBObjectID(object: objectPointer)
            
            XCTAssertEqual(objectOID, headOID)
            
            
            
            let objectData: Data? = gitODBObjectData(object: objectPointer)
            
            XCTAssertNotNil(objectData)
            XCTAssertGreaterThan(objectData?.count ?? 0, 0)
            
            
            
            let objectSize: Int = gitODBObjectSize(object: objectPointer)
            
            XCTAssertGreaterThan(objectSize, 0)
            XCTAssertEqual(objectSize, objectData?.count ?? 0)
            
            
            
            let objectType: GitObjectT?
                = gitODBObjectType(object: objectPointer)
            
            XCTAssertNotNil(objectType)
            XCTAssertEqual(objectType, .gitObjectCommit)
        }
    }
    
    
    
    func testGitODBReadPrefixAndHeader() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBObjectFree(object: objectPointer)
            }
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let odbReadPrefixResult: GitErrorCode = gitODBReadPrefix(
                obj:        &objectPointer,
                db:         odbPointer,
                shortID:    headOID,
                len:        7
            )
            
            XCTAssertOK(odbReadPrefixResult)
            XCTAssertNotNil(objectPointer)
            
            
            
            var headerLength    : Int           = 0
            var headerType      : GitObjectT    = .gitObjectAny
            
            let odbReadHeaderResult: GitErrorCode = gitODBReadHeader(
                lenOut:     &headerLength,
                typeOut:    &headerType,
                db:         odbPointer,
                id:         headOID
            )
            
            XCTAssertOK(odbReadHeaderResult)
            XCTAssertGreaterThan(headerLength, 0)
            XCTAssertEqual(headerType, .gitObjectCommit)
        }
    }
    
    
    
    func testGitODBSetCommitGraph() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let odbSetCommitGraphResult: GitErrorCode = gitODBSetCommitGraph(
                odb:        odbPointer,
                cGraph:     nil
            )
            
            XCTAssertOK(odbSetCommitGraphResult)
        }
    }
    
    
    
    func testGitODBStreamFree() throws
    {
        gitODBStreamFree(stream: nil)
    }
    
    
    
    func testGitODBStreamRead() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            var streamPointer: UnsafeMutablePointer<git_odb_stream>? = nil
            
            defer
            {
                gitODBStreamFree(stream: streamPointer)
            }
            
            
            var objectLength    : Int           = 0
            var objectType      : GitObjectT    = .gitObjectAny
            
            let odbOpenRStreamResult: GitErrorCode = gitODBOpenRStream(
                out:    &streamPointer,
                len:    &objectLength,
                type:   &objectType,
                db:     odbPointer,
                oid:    headOID
            )
            
            /// Most backends do not support streaming reads.
            if odbOpenRStreamResult == .gitOK
            {
                XCTAssertGreaterThan(objectLength, 0)
                XCTAssertEqual(objectType, .gitObjectCommit)
                XCTAssertNotNil(streamPointer)
            }
        }
    }
    
    
    
    func testGitODBStreamWrite() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let blobData = Data("Blob content".utf8)
            
            var streamPointer: UnsafeMutablePointer<git_odb_stream>? = nil
            
            defer
            {
                gitODBStreamFree(stream: streamPointer)
            }
            
            
            
            let odbOpenWStreamResult: GitErrorCode = gitODBOpenWStream(
                out:    &streamPointer,
                db:     odbPointer,
                size:   UInt64(blobData.count),
                type:   .gitObjectBlob
            )
            
            XCTAssertOK(odbOpenWStreamResult)
            
            guard let streamPointer: UnsafeMutablePointer<git_odb_stream>
                    = streamPointer
            else
            {
                XCTFail("The stream pointer was nil.")
                return
            }
            
            
            
            let odbStreamWriteResult: GitErrorCode = gitODBStreamWrite(
                stream:     streamPointer,
                buffer:     blobData,
                len:        blobData.count
            )
            
            XCTAssertOK(odbStreamWriteResult)
            
            
            
            var blobOID = GitOID()
            
            let odbStreamFinalizeWriteResult: GitErrorCode
                = gitODBStreamFinalizeWrite(
                    out:        &blobOID,
                    stream:     streamPointer
                )
            
            XCTAssertOK(odbStreamFinalizeWriteResult)
            XCTAssertNotZeroOID(blobOID)
            
            
            
            let blobExists: Bool = gitODBExists(
                db:     odbPointer,
                id:     blobOID
            )
            
            XCTAssertTrue(blobExists)
        }
    }
    
    
    
    func testGitODBWrite() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            let blobData = Data("Blob content".utf8)
            
            var blobOID = GitOID()
            
            let odbWriteResult: GitErrorCode = gitODBWrite(
                out:    &blobOID,
                odb:    odbPointer,
                data:   blobData,
                len:    blobData.count,
                type:   .gitObjectBlob
            )
            
            XCTAssertOK(odbWriteResult)
            XCTAssertNotZeroOID(blobOID)
            
            
            
            let blobExists: Bool = gitODBExists(
                db:     odbPointer,
                id:     blobOID
            )
            
            XCTAssertTrue(blobExists)
            
            
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBObjectFree(object: objectPointer)
            }
            
            
            
            let odbReadResult: GitErrorCode = gitODBRead(
                obj:    &objectPointer,
                db:     odbPointer,
                id:     blobOID
            )
            
            XCTAssertOK(odbReadResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The ODB object pointer was nil.")
                return
            }
            
            
            
            let objectData: Data? = gitODBObjectData(object: objectPointer)
            
            XCTAssertNotNil(objectData)
            XCTAssertEqual(objectData, blobData)
        }
    }
    
    
    
    func testGitODBWritePack() throws
    {
        try withOpenedODBPointer
        {
            repository, odbPointer in
            
            var callbackData = CallbackData()
            
            let indexerProgressCB: GitIndexerProgressCB =
            {
                stats, payload in
                
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
            
            
            
            var writePackPointer: UnsafeMutablePointer<git_odb_writepack>? = nil
            
            defer
            {
                if writePackPointer != nil
                {
                    writePackPointer?.pointee.free?(writePackPointer)
                }
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let odbWritePackResult: GitErrorCode = gitODBWritePack(
                    out:                &writePackPointer,
                    db:                 odbPointer,
                    progressCB:         indexerProgressCB,
                    progressPayload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(odbWritePackResult)
                XCTAssertNotNil(writePackPointer)
            }
            
            
            /// This result is not checked, nor is the callback count checked,
            /// since packfiles may not exist in the repository.
            _ = gitODBWriteMultiPackIndex(db: odbPointer)
        }
    }
}



// MARK: - Extensions

extension ODBTests
{
    struct CallbackData
    {
        var callCount   : Int       = 0
        var oids        : [GitOID]  = []
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to an opened object database.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    private func withOpenedODBPointer(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var odbPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBFree(db: odbPointer)
            }
            
            
            
            let objectsDirectoryURL: URL = repository.url.appending(
                path:           ".git/objects",
                directoryHint:  .isDirectory
            )
            
            let odbOpenResult: GitErrorCode = gitODBOpen(
                odbOut:         &odbPointer,
                objectsDir:     objectsDirectoryURL.path()
            )
            
            XCTAssertOK(odbOpenResult)
            
            guard let odbPointer: OpaquePointer = odbPointer
            else
            {
                XCTFail("The ODB pointer was nil.")
                return
            }
            
            return try body(
                repository,
                odbPointer
            )
        }
    }
}
