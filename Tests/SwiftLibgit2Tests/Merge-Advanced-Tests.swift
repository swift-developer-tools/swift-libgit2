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



final class MergeAdvancedTests: XCTestCaseStopOnFail
{
    func testGitMergeDriverApplyFN() throws
    {
        let mergeDriverApplyFN: GitMergeDriverApplyFN =
        {
            _, _, _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let mergeDriverApplyFNResult: Int32 = mergeDriverApplyFN(
            nil,
            nil,
            nil,
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: mergeDriverApplyFNResult))
    }
    
    
    
    func testGitMergeDriverBinary()
    {
        XCTAssertEqual(gitMergeDriverBinary, GIT_MERGE_DRIVER_BINARY)
    }
    
    
    
    func testGitMergeDriverInitFN() throws
    {
        let mergeDriverInitFN: GitMergeDriverInitFN =
        {
            _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let mergeDriverInitFNResult: Int32 = mergeDriverInitFN(nil)
        
        XCTAssertOK(GitErrorCode(rawValue: mergeDriverInitFNResult))
    }
    
    
    
    func testGitMergeDriverLookup() throws
    {
        let binaryMergeDriver: UnsafeMutablePointer<git_merge_driver>?
            = gitMergeDriverLookup(name: gitMergeDriverBinary)
        
        XCTAssertNotNil(binaryMergeDriver)
        
        
        
        let textMergeDriver: UnsafeMutablePointer<git_merge_driver>?
            = gitMergeDriverLookup(name: gitMergeDriverText)
        
        XCTAssertNotNil(textMergeDriver)
        
        
        
        let unionMergeDriver: UnsafeMutablePointer<git_merge_driver>?
            = gitMergeDriverLookup(name: gitMergeDriverUnion)
        
        XCTAssertNotNil(unionMergeDriver)
        
        
        
        let invalidMergeDirver: UnsafeMutablePointer<git_merge_driver>?
            = gitMergeDriverLookup(name: "invalid")
        
        XCTAssertNil(invalidMergeDirver)
    }
    
    
    
    func testGitMergeDriverRegister() throws
    {
        let mergeDriverName: String = "test-driver"
        
        let mergeDriverPointer = UnsafeMutablePointer<git_merge_driver>
            .allocate(capacity: 1)
        
        defer
        {
            let mergeDriverUnregisterResult: GitErrorCode
                = gitMergeDriverUnregister(name: mergeDriverName)
            
            mergeDriverPointer.deallocate()
            
            XCTAssertOK(mergeDriverUnregisterResult)
        }
        
        
        
        mergeDriverPointer.pointee.version      = gitMergeDriverVersion
        mergeDriverPointer.pointee.initialize   = nil
        mergeDriverPointer.pointee.shutdown     = nil
        mergeDriverPointer.pointee.apply        = nil
        
        let mergeDriverRegisterResult: GitErrorCode
            = gitMergeDriverRegister(
                name:       mergeDriverName,
                driver:     mergeDriverPointer
            )
        
        XCTAssertOK(mergeDriverRegisterResult)
    }
    
    
    
    func testGitMergeDriverSourceOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let mergeDriverPointer = UnsafeMutablePointer<git_merge_driver>
                .allocate(capacity: 1)
            
            let fileName                : String            = "file.txt"
            let mergeDriverName         : String            = "test-driver"
            var annotatedCommitPointer  : OpaquePointer?    = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
                
                let mergeDriverUnregisterResult: GitErrorCode
                    = gitMergeDriverUnregister(name: mergeDriverName)
                
                mergeDriverPointer.deallocate()
                
                XCTAssertOK(mergeDriverUnregisterResult)
            }
            
            
            
            let mergeDriverApplyFN: GitMergeDriverApplyFN =
            {
                _, _, _, _, _, src in
                
                guard let src
                else
                {
                    XCTFail("The source was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                
                
                let repo: OpaquePointer = gitMergeDriverSourceRepo(src: src)
                
                XCTAssertNotEqual(repo, OpaquePointer(bitPattern: 0))
                
                
                
                let ancestorIndexEntry: GitIndexEntry?
                    = gitMergeDriverSourceAncestor(src: src)
                
                XCTAssertNotNil(ancestorIndexEntry)
                XCTAssertNotNil(ancestorIndexEntry?.path)
                
                
                
                let ourIndexEntry: GitIndexEntry?
                    = gitMergeDriverSourceOurs(src: src)
                
                XCTAssertNotNil(ourIndexEntry)
                XCTAssertNotNil(ourIndexEntry?.path)
                
                
                
                let theirIndexEntry: GitIndexEntry?
                    = gitMergeDriverSourceTheirs(src: src)
                
                XCTAssertNotNil(theirIndexEntry)
                XCTAssertNotNil(theirIndexEntry?.path)
                
                
                
                let mergeFileOptions: GitMergeFileOptions?
                    = gitMergeDriverSourceFileOptions(src: src)
                
                XCTAssertNotNil(mergeFileOptions)
                
                
                
                return GitErrorCode.gitPassthrough.rawValue
            }
            
            mergeDriverPointer.pointee.version      = gitMergeDriverVersion
            mergeDriverPointer.pointee.initialize   = nil
            mergeDriverPointer.pointee.shutdown     = nil
            mergeDriverPointer.pointee.apply        = mergeDriverApplyFN
            
            
            
            let mergeDriverRegisterResult: GitErrorCode
                = gitMergeDriverRegister(
                    name:       mergeDriverName,
                    driver:     mergeDriverPointer
                )
            
            XCTAssertOK(mergeDriverRegisterResult)
            
            
            
            let retrievedMergeDriver: UnsafeMutablePointer<git_merge_driver>?
                = gitMergeDriverLookup(name: mergeDriverName)
            
            XCTAssertNotNil(retrievedMergeDriver)
            
            
            
            let gitAttributesContent: String = Repository.gitAttributesContent
                + "\n\(fileName) merge=\(mergeDriverName)\n"
            
            try repository.commit(
                gitAttributesContent,
                toFile:     ".gitattributes",
                message:    "Add merge driver"
            )
            
            
            
            let baseCommitOID: GitOID = try repository.commit(
                "Base content",
                toFile:     fileName,
                message:    "Base commit"
            )
            
            let ourCommitOID: GitOID = try repository.commit(
                "Our content",
                toFile:     fileName,
                message:    "Our commit"
            )
            
            repository.reset(to: baseCommitOID)
            
            let theirCommitOID: GitOID = try repository.commit(
                "Their content",
                toFile:     fileName,
                message:    "Their commit"
            )
            
            repository.reset(to: ourCommitOID)
            
            
            
            let annotatedCommitLookupResult: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     theirCommitOID
                )
            
            XCTAssertOK(annotatedCommitLookupResult)
            XCTAssertNotNil(annotatedCommitPointer)
            
            
            
            var theirHeads: [OpaquePointer?] = [annotatedCommitPointer]
            
            let mergeResult: GitErrorCode = gitMerge(
                repo:           repository.pointer,
                theirHeads:     &theirHeads,
                theirHeadsLen:  theirHeads.count,
                mergeOpts:      nil,
                checkoutOpts:   nil
            )
            
            XCTAssertOK(mergeResult)
        }
    }
    
    
    
    func testGitMergeDriverShutdownFN() throws
    {
        let mergeDriverShutdownFN: GitMergeDriverShutdownFN =
        {
            _ in
        }
        
        mergeDriverShutdownFN(nil)
    }
    
    
    
    func testGitMergeDriverText()
    {
        XCTAssertEqual(gitMergeDriverText, GIT_MERGE_DRIVER_TEXT)
    }
    
    
    
    func testGitMergeDriverUnion()
    {
        XCTAssertEqual(gitMergeDriverUnion, GIT_MERGE_DRIVER_UNION)
    }
    
    
    
    func testGitMergeDriverUnregister() throws
    {
        /// Do not attempt to unregister the built-in `text`, `binary`, and
        /// `union` merge drivers. Although the documentation says it is not
        /// allowed, the unregistration will succeed. Any tests that run after
        /// this one will fail if they depend on a built-in merge driver.
        
        let mergeDriverUnregisterResult: GitErrorCode
            = gitMergeDriverUnregister(name: "non-existent")
        
        XCTAssertEqual(mergeDriverUnregisterResult, .gitENotFound)
    }
    
    
    
    func testGitMergeDriverVersion()
    {
        XCTAssertEqual(Int32(gitMergeDriverVersion), GIT_MERGE_DRIVER_VERSION)
    }
}
