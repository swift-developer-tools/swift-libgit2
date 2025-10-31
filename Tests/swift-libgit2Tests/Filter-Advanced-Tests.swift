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



final class FilterAdvancedTests: XCTestCaseStopOnFail
{
    func testGitFilterApplyFN() throws
    {
        let filterApplyFN: GitFilterApplyFN =
        {
            _, _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let filterApplyFNResult: Int32 = filterApplyFN(
            nil,
            nil,
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: filterApplyFNResult))
    }
    
    
    
    func testGitFilterCheckFN() throws
    {
        let filterCheckFN: GitFilterCheckFN =
        {
            _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let filterCheckFNResult: Int32 = filterCheckFN(
            nil,
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: filterCheckFNResult))
    }
    
    
    
    func testGitFilterCleanupFN() throws
    {
        let filterCleanupFN: GitFilterCleanupFN =
        {
            _, _ in
        }
        
        filterCleanupFN(
            nil,
            nil
        )
    }
    
    
    
    func testGitFilterCRLF() throws
    {
        XCTAssertEqual(gitFilterCRLF, GIT_FILTER_CRLF)
    }
    
    
    
    func testGitFilterCRLFPriority() throws
    {
        XCTAssertEqual(gitFilterCRLFPriority, GIT_FILTER_CRLF_PRIORITY)
    }
    
    
    
    func testGitFilterDriverPriority() throws
    {
        XCTAssertEqual(gitFilterDriverPriority, GIT_FILTER_DRIVER_PRIORITY)
    }
    
    
    
    func testGitFilterIdent() throws
    {
        XCTAssertEqual(gitFilterIdent, GIT_FILTER_IDENT)
    }
    
    
    
    func testGitFilterIdentPriority() throws
    {
        XCTAssertEqual(gitFilterIdentPriority, GIT_FILTER_IDENT_PRIORITY)
    }
    
    
    
    func testGitFilterInit() throws
    {
        var filter = git_filter()
        
        let filterInitResult: GitErrorCode = gitFilterInit(
            filter:     &filter,
            version:    gitFilterVersion
        )
        
        XCTAssertOK(filterInitResult)
    }
    
    
    
    func testGitFilterInitFN() throws
    {
        let filterInitFN: GitFilterInitFN =
        {
            _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let filterInitFNResult: Int32 = filterInitFN(nil)
        
        XCTAssertOK(GitErrorCode(rawValue: filterInitFNResult))
    }
    
    
    
    func testGitFilterListLength() throws
    {
        try withFilterList
        {
            filterListPointer in
            
            let length: Int = gitFilterListLength(fl: filterListPointer)
            
            XCTAssertEqual(length, 0)
        }
    }
    
    
    
    func testGitFilterListNew() throws
    {
        try withFilterList
        {
            _ in
        }
    }
    
    
    
    func testGitFilterListPush() throws
    {
        try withFilterList(free: false)
        {
            filterListPointer in
            
            let filterName: String = "test-filter"
            
            let filterPointer = UnsafeMutablePointer<git_filter>
                .allocate(capacity: 1)
            
            defer
            {
                let filterUnregisterResult: GitErrorCode
                    = gitFilterUnregister(name: filterName)
                
                filterPointer.deallocate()
                
                XCTAssertOK(filterUnregisterResult)
            }
            
            
            
            let filterInitResult: GitErrorCode = gitFilterInit(
                filter:     filterPointer,
                version:    gitFilterVersion
            )
            
            XCTAssertOK(filterInitResult)
            
            
            
            let filterRegisterResult: GitErrorCode = gitFilterRegister(
                name:       filterName,
                filter:     filterPointer,
                priority:   gitFilterDriverPriority
            )
            
            XCTAssertOK(filterRegisterResult)
            
            
            
            let filterListPushResult: GitErrorCode = gitFilterListPush(
                fl:         filterListPointer,
                filter:     filterPointer,
                payload:    nil
            )
            
            if !isOK(filterListPushResult)
            {
                /// Ownership of the memory transfers to libgit2 after
                /// registering the filter. Free the memory manually if the
                /// memory was allocated, but the push operation failed.
                gitFilterListFree(filters: filterListPointer)
            }
            
            XCTAssertOK(filterListPushResult)
            
            
            
            let length: Int = gitFilterListLength(fl: filterListPointer)
            
            XCTAssertEqual(length, 1)
        }
    }
    
    
    
    func testGitFilterLookup() throws
    {
        let crlfFilter: UnsafeMutablePointer<git_filter>?
            = gitFilterLookup(name: gitFilterCRLF)
        
        XCTAssertNotNil(crlfFilter)
        
        
        
        let identFilter: UnsafeMutablePointer<git_filter>?
            = gitFilterLookup(name: gitFilterIdent)
        
        XCTAssertNotNil(identFilter)
        
        
        
        let invalidFilter: UnsafeMutablePointer<git_filter>?
            = gitFilterLookup(name: "invalid")
        
        XCTAssertNil(invalidFilter)
    }
    
    
    
    func testGitFilterShutdownFN() throws
    {
        let filterShutdownFN: GitFilterShutdownFN =
        {
            _ in
        }
        
        filterShutdownFN(nil)
    }
    
    
    
    func testGitFilterRegister() throws
    {
        let filterName: String = "test-filter"
        
        let filterPointer = UnsafeMutablePointer<git_filter>
            .allocate(capacity: 1)
        
        defer
        {
            let filterUnregisterResult: GitErrorCode
                = gitFilterUnregister(name: filterName)
            
            filterPointer.deallocate()
            
            XCTAssertOK(filterUnregisterResult)
        }
        
        
        
        "*".withCString
        {
            cAttributes in
            
            filterPointer.pointee.attributes = cAttributes
            
            let filterRegisterResult: GitErrorCode = gitFilterRegister(
                name:       filterName,
                filter:     filterPointer,
                priority:   gitFilterDriverPriority + 100
            )
            
            XCTAssertOK(filterRegisterResult)
        }
    }
    
    
    
    func testGitFilterSourceOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let filterPointer = UnsafeMutablePointer<git_filter>
                .allocate(capacity: 1)
            
            let fileName            : String            = "file.txt"
            let filterName          : String            = "test-filter"
            var blobPointer         : OpaquePointer?    = nil
            var filterListPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitBlobFree(blob: blobPointer)
                gitFilterListFree(filters: filterListPointer)
                
                let filterUnregisterResult: GitErrorCode
                    = gitFilterUnregister(name: filterName)
                
                filterPointer.deallocate()
                
                XCTAssertOK(filterUnregisterResult)
            }
            
            
            
            try repository.modifyFile(
                at:     fileName,
                with:   "File content"
            )
            
            let blobOID: GitOID = Blob.createBlob(
                in:     repository,
                from:   .workingDirectory
            )
            
            let blobLookupResult: GitErrorCode = gitBlobLookup(
                blob:   &blobPointer,
                repo:   repository.pointer,
                id:     blobOID
            )
            
            XCTAssertOK(blobLookupResult)
            XCTAssertNotNil(blobPointer)
            
            guard let blobPointer: OpaquePointer = blobPointer
            else
            {
                XCTFail("The blob pointer was nil.")
                return
            }
            
            
            
            let filterInitResult: GitErrorCode = gitFilterInit(
                filter:     filterPointer,
                version:    gitFilterVersion
            )
            
            XCTAssertOK(filterInitResult)
            XCTAssertNotNil(filterPointer)
            
            
            
            let filterCheckFN: GitFilterCheckFN =
            {
                _, _, src, _ in
                
                guard let src: OpaquePointer = src
                else
                {
                    XCTFail("The source was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                
                
                let repo: OpaquePointer = gitFilterSourceRepo(src: src)
                
                XCTAssertNotEqual(repo, OpaquePointer(bitPattern: 0))
                
                
                
                let path: String? = gitFilterSourcePath(src: src)
                
                XCTAssertNotNil(path)
                XCTAssertFalse(path?.isEmpty ?? true)
                
                
                
                let fileMode: GitFileModeT? = gitFilterSourceFileMode(src: src)
                
                XCTAssertNotNil(fileMode)
                
                
                
                let oid: GitOID? = gitFilterSourceID(src: src)
                
                XCTAssertNotNil(oid)
                XCTAssertNotZeroOID(oid)
                
                
                
                let filterMode: GitFilterModeT? = gitFilterSourceMode(src: src)
                
                XCTAssertNotNil(filterMode)
                
                
                
                let filterFlag: GitFilterFlagT?
                    = gitFilterSourceFlags(src: src)
                
                XCTAssertNotNil(filterFlag)
                
                
                
                return GitErrorCode.gitPassthrough.rawValue
            }
            
            filterPointer.pointee.check = filterCheckFN
            
            
            
            "*".withCString
            {
                cAttributes in
                
                filterPointer.pointee.attributes = cAttributes
                
                let filterRegisterResult: GitErrorCode = gitFilterRegister(
                    name:       filterName,
                    filter:     filterPointer,
                    priority:   gitFilterDriverPriority + 100
                )
                
                XCTAssertOK(filterRegisterResult)
            }
            
            
            
            let retrievedFilter: UnsafeMutablePointer<git_filter>?
                = gitFilterLookup(name: filterName)
            
            XCTAssertNotNil(retrievedFilter)
            
            
            
            let filterListLoadResult: GitErrorCode = gitFilterListLoad(
                filters:    &filterListPointer,
                repo:       repository.pointer,
                blob:       blobPointer,
                path:       fileName,
                mode:       .gitFilterToWorktree,
                flags:      .gitFilterDefault
            )
            
            XCTAssertOK(filterListLoadResult)
            XCTAssertNotNil(filterListPointer)
        }
    }
    
    
    
    func testGitFilterStreamFN() throws
    {
        let filterStreamFN: GitFilterStreamFN =
        {
            _, _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let filterStreamFNResult: Int32 = filterStreamFN(
            nil,
            nil,
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: filterStreamFNResult))
    }
    
    
    
    func testGitFilterUnregister() throws
    {
        let filterNames: [String] =
        [
            gitFilterCRLF,
            gitFilterIdent,
            "non-existent"
        ]
        
        for filterName in filterNames
        {
            let filterUnregisterResult: GitErrorCode
                = gitFilterUnregister(name: filterName)
            
            XCTAssertNotOK(filterUnregisterResult)
        }
    }
    
    
    
    func testGitFilterVersion() throws
    {
        XCTAssertEqual(Int32(gitFilterVersion), GIT_FILTER_VERSION)
    }
}



// MARK: - Extensions

private extension FilterAdvancedTests
{
    /// Calls the given closure with a pointer to a filter list.
    /// - Parameters:
    ///   - free: Whether to free the filter list.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withFilterList(
        free    : Bool = true,
        _ body  : (OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var filterListPointer: OpaquePointer? = nil
            
            defer
            {
                if free
                {
                    gitFilterListFree(filters: filterListPointer)
                }
            }
            
            
            
            let filterListNewResult: GitErrorCode = gitFilterListNew(
                out:        &filterListPointer,
                repo:       repository.pointer,
                mode:       .gitFilterToWorktree,
                options:    .gitFilterDefault
            )
            
            XCTAssertOK(filterListNewResult)
            
            guard let filterListPointer: OpaquePointer = filterListPointer
            else
            {
                XCTFail("The filter list pointer was nil.")
                return
            }
            
            
            
            try body(filterListPointer)
        }
    }
}
