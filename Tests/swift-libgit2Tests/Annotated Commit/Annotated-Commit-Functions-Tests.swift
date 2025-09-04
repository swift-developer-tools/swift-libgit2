//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import XCTest
@testable import SwiftLibgit2



final class AnnotatedCommitFunctionsTests: XCTestCaseStopOnFail
{
    // MARK: - testGitAnnotatedCommitFromFetchhead()
    
    func testGitAnnotatedCommitFromFetchhead() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var headOID: git_oid = OID.getHEADCommitOID(from: repository)
            
            
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                if annotatedCommitPointer != nil
                {
                    gitAnnotatedCommitFree(commit: annotatedCommitPointer!)
                    annotatedCommitPointer = nil
                }
            }
            
            
            
            let annotatedCommitFromFetchheadResult: Int32 = gitAnnotatedCommitFromFetchhead(
                out:            &annotatedCommitPointer,
                repo:           repository.pointer,
                branchName:     "main",
                remoteURL:      "https://github.com/github/gitignore",
                id:             &headOID
            )
            
            XCTAssertOK(
                annotatedCommitFromFetchheadResult,
                "annotatedCommitFromFetchheadResult"
            )
            
            guard let annotatedCommitPointer: OpaquePointer = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let annotatedCommitOIDPointer: UnsafePointer<git_oid> = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            OID.assertOIDsEqual(
                &headOID,
                annotatedCommitOIDPointer
            )
        }
    }
    
    
    
    // MARK: - testGitAnnotatedCommitFromRef()
    
    func testGitAnnotatedCommitFromRef() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var headReferencePointer: OpaquePointer? = nil
            
            defer
            {
                if headReferencePointer != nil
                {
                    git_reference_free(headReferencePointer!)
                    headReferencePointer = nil
                }
            }
            
            
            
            let referenceLookupResult: Int32 = git_reference_lookup(
                &headReferencePointer,
                repository.pointer,
                "HEAD"
            )
            
            XCTAssertOK(
                referenceLookupResult,
                "referenceLookupResult"
            )
            
            guard let headReferencePointer: OpaquePointer = headReferencePointer
            else
            {
                XCTFail("The HEAD reference pointer was nil.")
                return
            }
            
            
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                if annotatedCommitPointer != nil
                {
                    gitAnnotatedCommitFree(commit: annotatedCommitPointer!)
                    annotatedCommitPointer = nil
                }
            }
            
            
            
            let annotatedCommitFromRefResult: Int32 = gitAnnotatedCommitFromRef(
                out:    &annotatedCommitPointer,
                repo:   repository.pointer,
                ref:    headReferencePointer
            )
            
            XCTAssertOK(
                annotatedCommitFromRefResult,
                "annotatedCommitFromRefResult"
            )
            
            guard let annotatedCommitPointer: OpaquePointer = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let _: UnsafePointer<git_oid> = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            
            
            let referenceNamePointer: UnsafePointer<CChar>? = gitAnnotatedCommitRef(commit: annotatedCommitPointer)
            
            guard let referenceNamePointer: UnsafePointer<CChar> = referenceNamePointer
            else
            {
                XCTFail("The reference name pointer was nil.")
                return
            }
            
            
            
            let referenceNameString = String(cString: referenceNamePointer)
            
            XCTAssertFalse(
                referenceNameString.isEmpty,
                "The reference name was empty."
            )
        }
    }
    
    
    
    // MARK: - testGitAnnotatedCommitFromRevspec()
    
    func testGitAnnotatedCommitFromRevspec() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                if annotatedCommitPointer != nil
                {
                    gitAnnotatedCommitFree(commit: annotatedCommitPointer!)
                    annotatedCommitPointer = nil
                }
            }
            
            
            
            let annotatedCommitFromRevspecResult: Int32 = gitAnnotatedCommitFromRevspec(
                out:        &annotatedCommitPointer,
                repo:       repository.pointer,
                revspec:    "HEAD"
            )
            
            XCTAssertOK(
                annotatedCommitFromRevspecResult,
                "annotatedCommitFromRevspecResult"
            )
            
            guard let annotatedCommitPointer: OpaquePointer = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let _: UnsafePointer<git_oid> = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            
            
            /// The reference name may be `nil` for revspec-created commits.
            let _: UnsafePointer<CChar>? = gitAnnotatedCommitRef(commit: annotatedCommitPointer)
        }
    }
    
    
    
    // MARK: - testGitAnnotatedCommitLookup()
    
    func testGitAnnotatedCommitLookup() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var headOID: git_oid = OID.getHEADCommitOID(from: repository)
            
            
            
            var annotatedCommitPointer: OpaquePointer? = nil
            
            defer
            {
                if annotatedCommitPointer != nil
                {
                    gitAnnotatedCommitFree(commit: annotatedCommitPointer!)
                    annotatedCommitPointer = nil
                }
            }
            
            
            
            let annotatedCommitLookupResult: Int32 = gitAnnotatedCommitLookup(
                out:    &annotatedCommitPointer,
                repo:   repository.pointer,
                id:     &headOID
            )
            
            XCTAssertOK(
                annotatedCommitLookupResult,
                "annotatedCommitLookupResult"
            )
            
            guard let annotatedCommitPointer: OpaquePointer = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            let annotatedCommitOIDPointer: UnsafePointer<git_oid> = gitAnnotatedCommitID(commit: annotatedCommitPointer)
            
            OID.assertOIDsEqual(
                &headOID,
                annotatedCommitOIDPointer
            )
        }
    }
}
