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



final class AnnotatedCommitTests: XCTestCaseStopOnFail
{
    func testGitAnnotatedCommitFree() throws
    {
        gitAnnotatedCommitFree(commit: nil)
    }
    
    
    
    func testGitAnnotatedCommitFromFetchhead() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
            }
            
            
            
            let annotatedCommitFromFetchheadResult: GitErrorCode
                = gitAnnotatedCommitFromFetchhead(
                    out:            &annotatedCommitPointer,
                    repo:           repository.pointer,
                    branchName:     "main",
                    remoteURL:      "https://github.com/github/gitignore",
                    id:             headOID
                )
            
            XCTAssertOK(annotatedCommitFromFetchheadResult)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let annotatedCommitOID: GitOID?
                = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            XCTAssertNotNil(annotatedCommitOID)
            XCTAssertEqual(headOID, annotatedCommitOID)
        }
    }
    
    
    
    func testGitAnnotatedCommitFromRef() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var headReferencePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeReference(headReferencePointer)
            }
            
            
            
            let referenceLookupResult: Int32 = git_reference_lookup(
                &headReferencePointer,
                repository.pointer,
                "HEAD"
            )
            
            XCTAssertOK(GitErrorCode(rawValue: referenceLookupResult))
            
            guard let headReferencePointer: OpaquePointer = headReferencePointer
            else
            {
                XCTFail("The HEAD reference pointer was nil.")
                return
            }
            
            
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
            }
            
            
            
            let annotatedCommitFromRefResult: GitErrorCode
                = gitAnnotatedCommitFromRef(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    ref:    headReferencePointer
                )
            
            XCTAssertOK(annotatedCommitFromRefResult)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            _ = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            
            
            guard let referenceName: String
                    = gitAnnotatedCommitRef(commit: annotatedCommitPointer)
            else
            {
                XCTFail("The reference name was nil.")
                return
            }
            
            XCTAssertFalse(referenceName.isEmpty)
        }
    }
    
    
    
    func testGitAnnotatedCommitFromRevspec() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
            }
            
            
            
            let annotatedCommitFromRevspecResult: GitErrorCode
                = gitAnnotatedCommitFromRevspec(
                    out:        &annotatedCommitPointer,
                    repo:       repository.pointer,
                    revspec:    "HEAD"
                )
            
            XCTAssertOK(annotatedCommitFromRevspecResult)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            _ = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            
            
            /// The reference name may be `nil` for revspec-created commits.
            _ = gitAnnotatedCommitRef(commit: annotatedCommitPointer)
        }
    }
    
    
    
    func testGitAnnotatedCommitLookup() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
            }
            
            
            
            let annotatedCommitLookupResult: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     headOID
                )
            
            XCTAssertOK(annotatedCommitLookupResult)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let annotatedCommitOID: GitOID?
                = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            XCTAssertNotNil(annotatedCommitOID)
            XCTAssertEqual(headOID, annotatedCommitOID)
        }
    }
}
