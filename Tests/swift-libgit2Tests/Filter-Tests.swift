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



final class FilterTests: XCTestCaseStopOnFail
{
    func testGitFilterFlagT() throws
    {
        XCTAssertEqual(GitFilterFlagT.gitFilterDefault.rawValue, GIT_FILTER_DEFAULT.rawValue)
        XCTAssertEqual(GitFilterFlagT.gitFilterAllowUnsafe.rawValue, GIT_FILTER_ALLOW_UNSAFE.rawValue)
        XCTAssertEqual(GitFilterFlagT.gitFilterNoSystemAttributes.rawValue, GIT_FILTER_NO_SYSTEM_ATTRIBUTES.rawValue)
        XCTAssertEqual(GitFilterFlagT.gitFilterAttributesFromHEAD.rawValue, GIT_FILTER_ATTRIBUTES_FROM_HEAD.rawValue)
        XCTAssertEqual(GitFilterFlagT.gitFilterAttributesFromCommit.rawValue, GIT_FILTER_ATTRIBUTES_FROM_COMMIT.rawValue)
        
        XCTAssertEqual(GitFilterFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitFilterFlagT.gitFilterDefault.cValue(), GIT_FILTER_DEFAULT)
        XCTAssertEqual(GitFilterFlagT.gitFilterAllowUnsafe.cValue(), GIT_FILTER_ALLOW_UNSAFE)
        XCTAssertEqual(GitFilterFlagT.gitFilterNoSystemAttributes.cValue(), GIT_FILTER_NO_SYSTEM_ATTRIBUTES)
        XCTAssertEqual(GitFilterFlagT.gitFilterAttributesFromHEAD.cValue(), GIT_FILTER_ATTRIBUTES_FROM_HEAD)
        XCTAssertEqual(GitFilterFlagT.gitFilterAttributesFromCommit.cValue(), GIT_FILTER_ATTRIBUTES_FROM_COMMIT)
        
        
        
        let flags: GitFilterFlagT =
        [
            .gitFilterNoSystemAttributes,
            .gitFilterAttributesFromHEAD
        ]
        
        XCTAssertTrue(flags.contains(.gitFilterNoSystemAttributes))
        XCTAssertTrue(flags.contains(.gitFilterAttributesFromHEAD))
        XCTAssertFalse(flags.contains(.gitFilterAllowUnsafe))
    }
    
    
    
    func testGitFilterListApplyToBlob() throws
    {
        try testGitFilterListApplyFlow(type: .blob)
    }
    
    
    
    func testGitFilterListApplyToBuffer() throws
    {
        try testGitFilterListApplyFlow(type: .buffer)
    }
    
    
    
    func testGitFilterListApplyToFile() throws
    {
        try testGitFilterListApplyFlow(type: .file)
    }
    
    
    
    func testGitFilterListLoadAndContains() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobPointer         : OpaquePointer?    = nil
            var filterListPointer   : OpaquePointer?    = nil
            
            defer
            {
                Free.freeBlob(blobPointer)
                Free.freeFilterList(filterListPointer)
            }
            
            
            
            try createWorkingDirectoryBlob(
                &blobPointer,
                in: repository
            )
            
            
            
            let filterListLoadResult: GitErrorCode = gitFilterListLoad(
                filters:    &filterListPointer,
                repo:       repository.pointer,
                blob:       blobPointer,
                path:       Self.fileName,
                mode:       .gitFilterToWorktree,
                flags:      .gitFilterDefault
            )
            
            XCTAssertOK(filterListLoadResult)
            XCTAssertNotNil(filterListPointer)
            
            
            
            filterListPointer = nil
            
            
            
            var filterOptions = GitFilterOptions()
            
            filterOptions.flags = .gitFilterNoSystemAttributes
            
            
            
            let filterListLoadResultExt: GitErrorCode = gitFilterListLoadExt(
                filters:    &filterListPointer,
                repo:       repository.pointer,
                blob:       blobPointer,
                path:       Self.fileName,
                mode:       .gitFilterToODB,
                opts:       filterOptions
            )
            
            XCTAssertOK(filterListLoadResultExt)
            XCTAssertNotNil(filterListPointer)
            
            
            
            let filterListContainsCRLF: Bool = gitFilterListContains(
                filters:    filterListPointer,
                name:       "crlf"
            )
            
            /// The `crlf` filter should be present for text files.
            XCTAssertTrue(filterListContainsCRLF)
            
            
            
            let filterListContainsIndent: Bool = gitFilterListContains(
                filters:    filterListPointer,
                name:       "indent"
            )
            
            /// The `indent` filter is generally not configured.
            XCTAssertFalse(filterListContainsIndent)
        }
    }
    
    
    
    func testGitFilterListStreamBlob() throws
    {
        try testGitFilterListStreamFlow(type: .blob)
    }
    
    
    
    func testGitFilterListStreamBuffer() throws
    {
        try testGitFilterListStreamFlow(type: .buffer)
    }
    
    
    
    func testGitFilterListStreamFile() throws
    {
        try testGitFilterListStreamFlow(type: .file)
    }
    
    
    
    func testGitFilterModeT() throws
    {
        XCTAssertEqual(GitFilterModeT.gitFilterToWorktree.cValue(), GIT_FILTER_TO_WORKTREE)
        XCTAssertEqual(GitFilterModeT.gitFilterToWorktree.cValue(), GIT_FILTER_SMUDGE)
        XCTAssertEqual(GitFilterModeT.gitFilterToODB.cValue(), GIT_FILTER_TO_ODB)
        XCTAssertEqual(GitFilterModeT.gitFilterToODB.cValue(), GIT_FILTER_CLEAN)
        
        XCTAssertNil(GitFilterModeT(rawValue: 123))
        
        XCTAssertEqual(GitFilterModeT(cValue: GIT_FILTER_TO_WORKTREE), .gitFilterToWorktree)
        XCTAssertEqual(GitFilterModeT(cValue: GIT_FILTER_SMUDGE), .gitFilterToWorktree)
        XCTAssertEqual(GitFilterModeT(cValue: GIT_FILTER_TO_ODB), .gitFilterToODB)
        XCTAssertEqual(GitFilterModeT(cValue: GIT_FILTER_CLEAN), .gitFilterToODB)
    }
    
    
    
    func testGitFilterOptions() throws
    {
        let filterOptions = GitFilterOptions()
        
        XCTAssertEqual(filterOptions.version, gitFilterOptionsVersion)
        XCTAssertEqual(filterOptions.flags, [])
        XCTAssertNil(filterOptions.commitID)
        XCTAssertZeroOID(filterOptions.attrCommitID)
        
        XCTAssertEqual(gitFilterOptionsVersion, UInt32(GIT_FILTER_OPTIONS_VERSION))
        
        filterOptions.withCValue
        {
            cFilterOptions in
            
            XCTAssertEqual(cFilterOptions.pointee.version, gitAttrOptionsVersion)
            XCTAssertEqual(cFilterOptions.pointee.flags, 0)
            XCTAssertNil(cFilterOptions.pointee.commit_id)
            XCTAssertZeroOID(GitOID(cValue: cFilterOptions.pointee.attr_commit_id))
        }
    }
}



// MARK: - Extensions

extension FilterTests
{
    private static let fileName     : String    = "test.txt"
    private static let fileContent  : String    = "Line 1\nLine 2\nLine 3\n"
    
    
    
    private enum FilerListType
    {
        case blob
        case buffer
        case file
    }
    
    
    
    /// Creates a blob from the working directory of the given repository.
    /// - Parameters:
    ///   - blobPointer: A pointer to the blob. The underlying type must be `git_blob`.
    ///   - repository: The repository in which to create the blob.
    /// - Returns: The `URL` of the created blob.
    /// - Throws: An error if the file read or write operations failed.
    @discardableResult
    private func createWorkingDirectoryBlob(
        _   blobPointer : UnsafeMutablePointer<OpaquePointer?>,
        in  repository  : Repository
    ) throws -> URL
    {
        let fileURL: URL = try repository.modifyFile(
            path:       Self.fileName,
            content:    Self.fileContent
        )
        
        
        
        let blobOID: GitOID = Blob.createBlob(
            in:     repository,
            from:   .workingDirectory
        )
        
        
        
        let blobLookupResult: GitErrorCode = gitBlobLookup(
            blob:   blobPointer,
            repo:   repository.pointer,
            id:     blobOID
        )
        
        XCTAssertOK(blobLookupResult)
        XCTAssertNotNil(blobPointer)
        
        
        
        return fileURL
    }
    
    
    
    /// Tests filter list application for the given type.
    /// - Parameter type: The type of filter list application to test.
    /// - Throws: An error if the file read or write operations failed.
    private func testGitFilterListApplyFlow(
        type: FilerListType
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var blobPointer         : OpaquePointer?    = nil
            var filterListPointer   : OpaquePointer?    = nil
            var buffer              : GitBuf            = GitBuf()
            
            defer
            {
                Free.freeBlob(blobPointer)
                Free.freeFilterList(filterListPointer)
                XCTAssertOK(gitBufDispose(buffer: &buffer))
            }
            
            
            
            let fileURL: URL = try createWorkingDirectoryBlob(
                &blobPointer,
                in: repository
            )
            
            guard let blobPointer: OpaquePointer = blobPointer
            else
            {
                XCTFail("The blob pointer was nil.")
                return
            }
            
            
            
            let filterListLoadResult: GitErrorCode = gitFilterListLoad(
                filters:    &filterListPointer,
                repo:       repository.pointer,
                blob:       blobPointer,
                path:       Self.fileName,
                mode:       .gitFilterToWorktree,
                flags:      .gitFilterDefault
            )
            
            XCTAssertOK(filterListLoadResult)
            XCTAssertNotNil(filterListPointer)
            
            
            var filterListApplyResult: GitErrorCode
            
            switch type
            {
                case .blob:
                    
                    filterListApplyResult = gitFilterListApplyToBlob(
                        out:        &buffer,
                        filters:    filterListPointer,
                        blob:       blobPointer
                    )
                    
                case .buffer:
                    
                    let inputData = Data(Self.fileContent.utf8)
                    
                    filterListApplyResult = gitFilterListApplyToBuffer(
                        out:        &buffer,
                        filters:    filterListPointer,
                        in:         inputData,
                        inLen:      inputData.count
                    )
                    
                case .file:
                    
                    filterListApplyResult = gitFilterListApplyToFile(
                        out:        &buffer,
                        filters:    filterListPointer,
                        repo:       repository.pointer,
                        path:       fileURL.path()
                    )
            }
            
            XCTAssertOK(filterListApplyResult)
            XCTAssertNotNil(buffer.ptr)
            XCTAssertGreaterThan(buffer.size, 0)
        }
    }
    
    
    
    /// Tests filter list streaming for the given type.
    /// - Parameter type: The type of filter list streaming to test.
    /// - Throws: An error if the file read or write operations failed.
    private func testGitFilterListStreamFlow(
        type: FilerListType
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var streamPointer       : UnsafeMutablePointer<git_writestream>?    = nil
            var blobPointer         : OpaquePointer?                            = nil
            var filterListPointer   : OpaquePointer?                            = nil
            
            defer
            {
                Free.freeBlob(blobPointer)
                Free.freeFilterList(filterListPointer)
                
                if let free: (UnsafeMutablePointer<git_writestream>?) -> Void
                    = streamPointer?.pointee.free
                {
                    free(streamPointer)
                }
            }
            
            
            
            let fileURL: URL = try createWorkingDirectoryBlob(
                &blobPointer,
                in: repository
            )
            
            guard let blobPointer: OpaquePointer = blobPointer
            else
            {
                XCTFail("The blob pointer was nil.")
                return
            }
            
            
            
            let filterListLoadResult: GitErrorCode = gitFilterListLoad(
                filters:    &filterListPointer,
                repo:       repository.pointer,
                blob:       nil,
                path:       Self.fileName,
                mode:       .gitFilterToODB,
                flags:      .gitFilterDefault
            )
            
            XCTAssertOK(filterListLoadResult)
            XCTAssertNotNil(filterListPointer)
            
            
            
            let blobCreateFromStreamResult: GitErrorCode = gitBlobCreateFromStream(
                out:        &streamPointer,
                repo:       repository.pointer,
                hintPath:   nil
            )
            
            XCTAssertOK(blobCreateFromStreamResult)
            
            guard let streamPointer: UnsafeMutablePointer<git_writestream> = streamPointer
            else
            {
                XCTFail("The stream pointer was nil.")
                return
            }
            
            
            
            var filterListStreamResult: GitErrorCode
            
            switch type
            {
                case .blob:
                    
                    filterListStreamResult = gitFilterListStreamBlob(
                        filters:    filterListPointer,
                        blob:       blobPointer,
                        target:     streamPointer
                    )
                    
                case .buffer:
                    
                    let inputData = Data(Self.fileContent.utf8)
                    
                    filterListStreamResult = gitFilterListStreamBuffer(
                        filters:    filterListPointer,
                        buffer:     inputData,
                        len:        inputData.count,
                        target:     streamPointer
                    )
                    
                case .file:
                    
                    filterListStreamResult = gitFilterListStreamFile(
                        filters:    filterListPointer,
                        repo:       repository.pointer,
                        path:       fileURL.path(),
                        target:     streamPointer
                    )
            }
            
            XCTAssertOK(filterListStreamResult)
        }
    }
}
