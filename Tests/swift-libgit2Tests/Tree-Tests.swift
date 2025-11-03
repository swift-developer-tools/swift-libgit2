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



final class TreeTests: XCTestCaseStopOnFail
{
    func testGitFileModeT() throws
    {
        XCTAssertEqual(UInt32(GitFileModeT.gitFileModeUnreadable.rawValue), GIT_FILEMODE_UNREADABLE.rawValue)
        XCTAssertEqual(UInt32(GitFileModeT.gitFileModeTree.rawValue), GIT_FILEMODE_TREE.rawValue)
        XCTAssertEqual(UInt32(GitFileModeT.gitFileModeBlob.rawValue), GIT_FILEMODE_BLOB.rawValue)
        XCTAssertEqual(UInt32(GitFileModeT.gitFileModeBlobExecutable.rawValue), GIT_FILEMODE_BLOB_EXECUTABLE.rawValue)
        XCTAssertEqual(UInt32(GitFileModeT.gitFileModeLink.rawValue), GIT_FILEMODE_LINK.rawValue)
        XCTAssertEqual(UInt32(GitFileModeT.gitFileModeCommit.rawValue), GIT_FILEMODE_COMMIT.rawValue)
        
        XCTAssertNil(GitFileModeT(rawValue: 123))
        
        XCTAssertEqual(GitFileModeT.gitFileModeUnreadable.cValue(), GIT_FILEMODE_UNREADABLE)
        XCTAssertEqual(GitFileModeT.gitFileModeTree.cValue(), GIT_FILEMODE_TREE)
        XCTAssertEqual(GitFileModeT.gitFileModeBlob.cValue(), GIT_FILEMODE_BLOB)
        XCTAssertEqual(GitFileModeT.gitFileModeBlobExecutable.cValue(), GIT_FILEMODE_BLOB_EXECUTABLE)
        XCTAssertEqual(GitFileModeT.gitFileModeLink.cValue(), GIT_FILEMODE_LINK)
        XCTAssertEqual(GitFileModeT.gitFileModeCommit.cValue(), GIT_FILEMODE_COMMIT)
        
        XCTAssertEqual(GitFileModeT(cValue: GIT_FILEMODE_UNREADABLE), .gitFileModeUnreadable)
        XCTAssertEqual(GitFileModeT(cValue: GIT_FILEMODE_TREE), .gitFileModeTree)
        XCTAssertEqual(GitFileModeT(cValue: GIT_FILEMODE_BLOB), .gitFileModeBlob)
        XCTAssertEqual(GitFileModeT(cValue: GIT_FILEMODE_BLOB_EXECUTABLE), .gitFileModeBlobExecutable)
        XCTAssertEqual(GitFileModeT(cValue: GIT_FILEMODE_LINK), .gitFileModeLink)
        XCTAssertEqual(GitFileModeT(cValue: GIT_FILEMODE_COMMIT), .gitFileModeCommit)
    }
    
    
    
    func testGitTreebuilderClear() throws
    {
        try Repository.withTreebuilder
        {
            _, treebuilderPointer in
            
            let entryCountBeforeClear: Int
                = gitTreebuilderEntryCount(bld: treebuilderPointer)
            
            XCTAssertEqual(entryCountBeforeClear, 1)
            
            
            
            let treebuilderClearResult: GitErrorCode
                = gitTreebuilderClear(bld: treebuilderPointer)
            
            XCTAssertOK(treebuilderClearResult)
            
            
            
            let entryCountAfterClear: Int
                = gitTreebuilderEntryCount(bld: treebuilderPointer)
            
            XCTAssertEqual(entryCountAfterClear, 0)
        }
    }
    
    
    
    func testGitTreebuilderEntryCount() throws
    {
        try Repository.withTreebuilder
        {
            _, treebuilderPointer in
            
            let entryCount: Int
                = gitTreebuilderEntryCount(bld: treebuilderPointer)
            
            XCTAssertEqual(entryCount, 1)
        }
    }
    
    
    
    func testGitTreebuilderFilter() throws
    {
        try Repository.withTreebuilder
        {
            repository, treebuilderPointer in
            
            let keptFileName: String = "keep-this-file.txt"
            
            repository.insertBlob(
                Data("More treebuilder content".utf8),
                named:  keptFileName,
                into:   treebuilderPointer
            )
            
            
            
            var callbackData = CallbackData()
            
            let treebuilderFilterCB: GitTreebuilderFilterCB =
            {
                entry, payload in
                
                guard
                    let entry       : OpaquePointer             = entry,
                    let fileName    : String                    = gitTreeEntryName(entry: entry),
                    let payload     : UnsafeMutableRawPointer   = payload
                else
                {
                    XCTFail("All or some callback parameters were nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                if fileName.hasSuffix("test.txt")
                {
                    /// Remove the entry.
                    return 1
                }
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let treebuilderFilterResult: GitErrorCode
                    = gitTreebuilderFilter(
                        bld:        treebuilderPointer,
                        filter:     treebuilderFilterCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(treebuilderFilterResult)
            }
            
            XCTAssertEqual(callbackData.callCount, 2)
            
            
            
            let entryCount: Int
                = gitTreebuilderEntryCount(bld: treebuilderPointer)
            
            XCTAssertEqual(entryCount, 1)
            
            
            
            var treeEntryPointer: OpaquePointer? = gitTreebuilderGet(
                bld:        treebuilderPointer,
                fileName:   Repository.treebuilderFileName
            )
            
            XCTAssertNil(treeEntryPointer)
            
            
            
            treeEntryPointer = gitTreebuilderGet(
                bld:        treebuilderPointer,
                fileName:   keptFileName
            )
            
            XCTAssertNotNil(treeEntryPointer)
        }
    }
    
    
    
    func testGitTreebuilderFree() throws
    {
        gitTreebuilderFree(bld: nil)
    }
    
    
    
    func testGitTreebuilderGet() throws
    {
        try Repository.withTreebuilder
        {
            _, treebuilderPointer in
            
            let treeEntryPointer: OpaquePointer? = gitTreebuilderGet(
                bld:        treebuilderPointer,
                fileName:   Repository.treebuilderFileName
            )
            
            XCTAssertNotNil(treeEntryPointer)
        }
    }
    
    
    
    func testGitTreebuilderNewAndInsert() throws
    {
        try Repository.withTreebuilder
        {
            _, _ in
        }
    }
    
    
    
    func testGitTreebuilderRemove() throws
    {
        try Repository.withTreebuilder
        {
            _, treebuilderPointer in
            
            let treebuilderRemoveResult: GitErrorCode = gitTreebuilderRemove(
                bld:        treebuilderPointer,
                fileName:   Repository.treebuilderFileName
            )
            
            XCTAssertOK(treebuilderRemoveResult)
        }
    }
    
    
    
    func testGitTreebuilderWrite() throws
    {
        try Repository.withTreebuilder
        {
            _, treebuilderPointer in
            
            var treeOID = GitOID()
            
            let treebuilderWriteResult: GitErrorCode = gitTreebuilderWrite(
                id:     &treeOID,
                bld:    treebuilderPointer
            )
            
            XCTAssertOK(treebuilderWriteResult)
            XCTAssertNotZeroOID(treeOID)
        }
    }
    
    
    
    func testGitTreeCreatedUpdated() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            var blobOID     = GitOID()
            let blobData    = Data("Updated content".utf8)
            
            let blobCreateFromBufferResult: GitErrorCode
                = gitBlobCreateFromBuffer(
                    id:         &blobOID,
                    repo:       repository.pointer,
                    buffer:     blobData,
                    len:        blobData.count
                )
            
            XCTAssertOK(blobCreateFromBufferResult)
            XCTAssertNotZeroOID(blobOID)
            
            
            
            let paths: [String?] =
            [
                "",
                "file.txt",
                nil
            ]
            
            var treeUpdates: [GitTreeUpdate] = paths.map
            {
                return GitTreeUpdate(
                    action:     .gitTreeUpdateUpsert,
                    id:         blobOID,
                    fileMode:   .gitFileModeBlob,
                    path:       $0
                )
            }
            
            
            
            var newTreeOID = GitOID()
            
            var treeCreateUpdatedResult: GitErrorCode = gitTreeCreateUpdated(
                out:        &newTreeOID,
                repo:       repository.pointer,
                baseline:   treePointer,
                nUpdates:   treeUpdates.count,
                updates:    treeUpdates
            )
            
            XCTAssertNotOK(treeCreateUpdatedResult)
            XCTAssertZeroOID(newTreeOID)
            
            
            
            /// Empty paths are invalid. `nil` paths are ignored by
            /// ``withArrayOfGitTreeUpdates(_:)``.
            treeUpdates.removeFirst()
            
            treeCreateUpdatedResult = gitTreeCreateUpdated(
                out:        &newTreeOID,
                repo:       repository.pointer,
                baseline:   treePointer,
                nUpdates:   treeUpdates.count,
                updates:    treeUpdates
            )
            
            XCTAssertOK(treeCreateUpdatedResult)
            XCTAssertNotZeroOID(newTreeOID)
        }
    }
    
    
    
    func testGitTreeDup() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            var duplicatedPointer: OpaquePointer? = nil
            
            defer
            {
                gitTreeFree(tree: duplicatedPointer)
            }
            
            
            
            let treeDupResult: GitErrorCode = gitTreeDup(
                out:        &duplicatedPointer,
                source:     treePointer
            )
            
            XCTAssertOK(treeDupResult)
            XCTAssertNotNil(duplicatedPointer)
            XCTAssertEqual(duplicatedPointer, treePointer)
        }
    }
    
    
    
    func testGitTreeEntryByIndex() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            let treeEntryPointer: OpaquePointer? = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            
            XCTAssertNotNil(treeEntryPointer)
        }
    }
    
    
    
    func testGitTreeEntryByName() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            let treeEntryPointer: OpaquePointer? = gitTreeEntryByName(
                tree:       treePointer,
                fileName:   Repository.treebuilderFileName
            )
            
            XCTAssertNotNil(treeEntryPointer)
        }
    }
    
    
    
    func testGitTreeEntryByPath() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            var treeEntryPointer: OpaquePointer? = nil
            
            defer
            {
                gitTreeEntryFree(entry: treeEntryPointer)
            }
            
            
            
            let treeEntryByPathResult: GitErrorCode = gitTreeEntryByPath(
                out:    &treeEntryPointer,
                root:   treePointer,
                path:   Repository.treebuilderFileName
            )
            
            XCTAssertOK(treeEntryByPathResult)
            XCTAssertNotNil(treeEntryPointer)
        }
    }
    
    
    
    func testGitTreeEntryCmp() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            guard let firstTreeEntryPointer: OpaquePointer
                    = gitTreeEntryByIndex(
                        tree:   treePointer,
                        idx:    0
                    )
            else
            {
                XCTFail("The first tree entry pointer was nil.")
                return
            }
            
            guard let secondTreeEntryPointer: OpaquePointer
                    = gitTreeEntryByName(
                        tree:       treePointer,
                        fileName:   Repository.treebuilderFileName
                    )
            else
            {
                XCTFail("The second tree entry pointer was nil.")
                return
            }
            
            
            
            let comparison: Int32 = gitTreeEntryCmp(
                e1:     firstTreeEntryPointer,
                e2:     secondTreeEntryPointer
            )
            
            XCTAssertEqual(comparison, 0)
        }
    }
    
    
    
    func testGitTreeEntryCount() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            let entryCount: Int = gitTreeEntryCount(tree: treePointer)
            
            XCTAssertEqual(entryCount, 1)
        }
    }
    
    
    
    func testGitTreeEntryDup() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            guard let treeEntryPointer: OpaquePointer = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            else
            {
                XCTFail("The tree entry pointer was nil.")
                return
            }
            
            
            
            var duplicatedPointer: OpaquePointer? = nil
            
            defer
            {
                gitTreeEntryFree(entry: duplicatedPointer)
            }
            
            
            
            let treeEntryDupResult: GitErrorCode = gitTreeEntryDup(
                out:        &duplicatedPointer,
                source:     treeEntryPointer
            )
            
            XCTAssertOK(treeEntryDupResult)
            XCTAssertNotNil(duplicatedPointer)
            XCTAssertNotEqual(duplicatedPointer, treePointer)
        }
    }
    
    
    
    func testGitTreeEntryFileMode() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            guard let treeEntryPointer: OpaquePointer = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            else
            {
                XCTFail("The tree entry pointer was nil.")
                return
            }
            
            
            
            let treeEntryFileMode: GitFileModeT?
                = gitTreeEntryFileMode(entry: treeEntryPointer)
            
            XCTAssertNotNil(treeEntryFileMode)
            XCTAssertEqual(treeEntryFileMode, .gitFileModeBlob)
        }
    }
    
    
    
    func testGitTreeEntryFileModeRaw() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            guard let treeEntryPointer: OpaquePointer = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            else
            {
                XCTFail("The tree entry pointer was nil.")
                return
            }
            
            
            
            let treeEntryRawFileMode: GitFileModeT?
                = gitTreeEntryFileModeRaw(entry: treeEntryPointer)
            
            XCTAssertNotNil(treeEntryRawFileMode)
            XCTAssertEqual(treeEntryRawFileMode, .gitFileModeBlob)
        }
    }
    
    
    
    func testGitTreeEntryFree() throws
    {
        gitTreeEntryFree(entry: nil)
    }
    
    
    
    func testGitTreeEntryID() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            guard let treeEntryPointer: OpaquePointer = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            else
            {
                XCTFail("The tree entry pointer was nil.")
                return
            }
            
            
            
            let treeEntryOID: GitOID? = gitTreeEntryID(entry: treeEntryPointer)
            
            XCTAssertNotNil(treeEntryOID)
            XCTAssertNotZeroOID(treeEntryOID)
        }
    }
    
    
    
    func testGitTreeEntryName() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            guard let treeEntryPointer: OpaquePointer = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            else
            {
                XCTFail("The tree entry pointer was nil.")
                return
            }
            
            
            
            let treeEntryName: String?
                = gitTreeEntryName(entry: treeEntryPointer)
            
            XCTAssertNotNil(treeEntryName)
            XCTAssertEqual(treeEntryName, Repository.treebuilderFileName)
        }
    }
    
    
    
    func testGitTreeEntryToObject() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            guard let treeEntryPointer: OpaquePointer = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            else
            {
                XCTFail("The tree entry pointer was nil.")
                return
            }
            
            
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let treeEntryToObjectResult: GitErrorCode = gitTreeEntryToObject(
                objectOut:  &objectPointer,
                repo:       repository.pointer,
                entry:      treeEntryPointer
            )
            
            XCTAssertOK(treeEntryToObjectResult)
            XCTAssertNotNil(objectPointer)
        }
    }
    
    
    
    func testGitTreeEntryType() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            guard let treeEntryPointer: OpaquePointer = gitTreeEntryByIndex(
                tree:   treePointer,
                idx:    0
            )
            else
            {
                XCTFail("The tree entry pointer was nil.")
                return
            }
            
            
            
            let treeEntryType: GitObjectT?
                = gitTreeEntryType(entry: treeEntryPointer)
            
            XCTAssertNotNil(treeEntryType)
            XCTAssertEqual(treeEntryType, .gitObjectBlob)
        }
    }
    
    
    
    func testGitTreeFree() throws
    {
        gitTreeFree(tree: nil)
    }
    
    
    
    func testGitTreeID() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            let treeOID: GitOID? = gitTreeID(tree: treePointer)
            
            XCTAssertNotNil(treeOID)
            XCTAssertNotZeroOID(treeOID)
        }
    }
    
    
    
    func testGitTreeLookup() throws
    {
        try Repository.withTree
        {
            _, _ in
        }
    }
    
    
    
    func testGitTreeLookupPrefix() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            guard let treeOID: GitOID = gitTreeID(tree: treePointer)
            else
            {
                XCTFail("The tree OID was nil.")
                return
            }
            
            
            
            var prefixTreePointer: OpaquePointer? = nil
            
            defer
            {
                gitTreeFree(tree: prefixTreePointer)
            }
            
            
            
            let treeLookupPrefixResult: GitErrorCode = gitTreeLookupPrefix(
                out:    &prefixTreePointer,
                repo:   repository.pointer,
                id:     treeOID,
                len:    7
            )
            
            XCTAssertOK(treeLookupPrefixResult)
            XCTAssertNotNil(prefixTreePointer)
        }
    }
    
    
    
    func testGitTreeOwner() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            let ownerPointer: OpaquePointer = gitTreeOwner(tree: treePointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
        }
    }
    
    
    
    func testGitTreeUpdate() throws
    {
        let treeUpdate = GitTreeUpdate(cValue: git_tree_update())
        
        XCTAssertEqual(treeUpdate.action, .gitTreeUpdateUpsert)
        XCTAssertZeroOID(treeUpdate.id)
        XCTAssertEqual(treeUpdate.fileMode, .gitFileModeUnreadable)
        XCTAssertNil(treeUpdate.path)
        
        treeUpdate.withCValue
        {
            cTreeUpdate in
            
            XCTAssertEqual(GitTreeUpdateT(cValue: cTreeUpdate.pointee.action), .gitTreeUpdateUpsert)
            XCTAssertZeroOID(GitOID(cValue: cTreeUpdate.pointee.id))
            XCTAssertEqual(GitFileModeT(cValue: cTreeUpdate.pointee.filemode), .gitFileModeUnreadable)
            XCTAssertNil(String(optionalCString: cTreeUpdate.pointee.path))
        }
    }
    
    
    
    func testGitTreeUpdateT() throws
    {
        XCTAssertEqual(GitTreeUpdateT.gitTreeUpdateUpsert.rawValue, GIT_TREE_UPDATE_UPSERT.rawValue)
        XCTAssertEqual(GitTreeUpdateT.gitTreeUpdateRemove.rawValue, GIT_TREE_UPDATE_REMOVE.rawValue)
        
        XCTAssertNil(GitTreeUpdateT(rawValue: 123))
        
        XCTAssertEqual(GitTreeUpdateT.gitTreeUpdateUpsert.cValue(), GIT_TREE_UPDATE_UPSERT)
        XCTAssertEqual(GitTreeUpdateT.gitTreeUpdateRemove.cValue(), GIT_TREE_UPDATE_REMOVE)
        
        XCTAssertEqual(GitTreeUpdateT(cValue: GIT_TREE_UPDATE_UPSERT), .gitTreeUpdateUpsert)
        XCTAssertEqual(GitTreeUpdateT(cValue: GIT_TREE_UPDATE_REMOVE), .gitTreeUpdateRemove)
    }
    
    
    
    func testGitTreeWalk() throws
    {
        try Repository.withTree
        {
            _, treePointer in
            
            var callbackData = CallbackData()
            
            let treeWalkCB: GitTreewalkCB =
            {
                _, _, payload in
                
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
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let treeWalkResult: GitErrorCode = gitTreeWalk(
                    tree:       treePointer,
                    mode:       .gitTreewalkPre,
                    callback:   treeWalkCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(treeWalkResult)
            }
            
            XCTAssertEqual(callbackData.callCount, 1)
        }
    }
    
    
    
    func testGitTreewalkMode() throws
    {
        XCTAssertEqual(GitTreewalkMode.gitTreewalkPre.rawValue, GIT_TREEWALK_PRE.rawValue)
        XCTAssertEqual(GitTreewalkMode.gitTreewalkPost.rawValue, GIT_TREEWALK_POST.rawValue)
        
        XCTAssertNil(GitTreewalkMode(rawValue: 123))
        
        XCTAssertEqual(GitTreewalkMode.gitTreewalkPre.cValue(), GIT_TREEWALK_PRE)
        XCTAssertEqual(GitTreewalkMode.gitTreewalkPost.cValue(), GIT_TREEWALK_POST)
        
        XCTAssertEqual(GitTreewalkMode(cValue: GIT_TREEWALK_PRE), .gitTreewalkPre)
        XCTAssertEqual(GitTreewalkMode(cValue: GIT_TREEWALK_POST), .gitTreewalkPost)
    }
}



// MARK: - Extensions

private extension TreeTests
{
    struct CallbackData
    {
        var callCount: Int = 0
    }
}
