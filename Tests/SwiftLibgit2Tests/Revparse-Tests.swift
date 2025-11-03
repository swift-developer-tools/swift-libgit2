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



final class RevparseTests: XCTestCaseStopOnFail
{
    func testGitRevparse() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstCommitOID: GitOID = try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            var revspec = GitRevspec()
            
            defer
            {
                gitObjectFree(object: revspec.from)
                gitObjectFree(object: revspec.to)
            }
            
            
            
            let revparseResult: GitErrorCode = gitRevparse(
                revspec:    &revspec,
                repo:       repository.pointer,
                spec:       "HEAD~1..HEAD"
            )
            
            XCTAssertOK(revparseResult)
            XCTAssertTrue(revspec.flags.contains(.gitRevspecRange))
            
            guard let fromObjectPointer: OpaquePointer = revspec.from
            else
            {
                XCTFail("The from-object pointer was nil.")
                return
            }
            
            guard let toObjectPointer: OpaquePointer = revspec.to
            else
            {
                XCTFail("The to-object pointer was nil.")
                return
            }
            
            
            
            let fromObjectOID: GitOID? = gitObjectID(obj: fromObjectPointer)
            
            XCTAssertNotNil(fromObjectOID)
            XCTAssertEqual(fromObjectOID, firstCommitOID)
            
            
            
            let toObjectOID: GitOID? = gitObjectID(obj: toObjectPointer)
            
            XCTAssertNotNil(toObjectOID)
            XCTAssertEqual(toObjectOID, secondCommitOID)
        }
    }
    
    
    
    func testGitRevparseExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let commitOID: GitOID = try repository.commit(
                "Test content",
                toFile:     "test.txt",
                message:    "Test commit"
            )
            
            
            
            var objectPointer   : OpaquePointer?    = nil
            var refPointer      : OpaquePointer?    = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
                gitReferenceFree(ref: refPointer)
            }
            
            
            
            let revparseExtResult: GitErrorCode = gitRevparseExt(
                objectOut:      &objectPointer,
                referenceOut:   &refPointer,
                repo:           repository.pointer,
                spec:           "HEAD"
            )
            
            XCTAssertOK(revparseExtResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            guard let refPointer: OpaquePointer = refPointer
            else
            {
                XCTFail("The reference pointer was nil.")
                return
            }
            
            
            let objectOID: GitOID? = gitObjectID(obj: objectPointer)
            
            XCTAssertNotNil(objectOID)
            XCTAssertEqual(objectOID, commitOID)
            
            
            
            let refName: String? = gitReferenceName(ref: refPointer)
            
            XCTAssertNotNil(refName)
        }
    }
    
    
    
    func testGitRevparseExtWithOIDString() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let commitOID: GitOID = try repository.commit(
                "Test content",
                toFile:     "test.txt",
                message:    "Test commit"
            )
            
            guard let commitOIDString: String = gitOIDToStrS(oid: commitOID)
            else
            {
                XCTFail("The commit OID string was nil.")
                return
            }
            
            
            
            var objectPointer   : OpaquePointer?    = nil
            var refPointer      : OpaquePointer?    = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
                gitReferenceFree(ref: refPointer)
            }
            
            
            
            let revparseExtResult: GitErrorCode = gitRevparseExt(
                objectOut:      &objectPointer,
                referenceOut:   &refPointer,
                repo:           repository.pointer,
                spec:           commitOIDString
            )
            
            XCTAssertOK(revparseExtResult)
            XCTAssertNil(refPointer)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            let objectOID: GitOID? = gitObjectID(obj: objectPointer)
            
            XCTAssertNotNil(objectOID)
            XCTAssertEqual(objectOID, commitOID)
        }
    }
    
    
    
    func testGitRevparseSingle() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let commitOID: GitOID = try repository.commit(
                "Test content",
                toFile:     "test.txt",
                message:    "Test commit"
            )
            
            
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let revparseSingleResult: GitErrorCode = gitRevparseSingle(
                out:    &objectPointer,
                repo:   repository.pointer,
                spec:   "HEAD"
            )
            
            XCTAssertOK(revparseSingleResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            let objectOID: GitOID? = gitObjectID(obj: objectPointer)
            
            XCTAssertNotNil(objectOID)
            XCTAssertEqual(objectOID, commitOID)
        }
    }
    
    
    
    func testGitRevparseSingleObject() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let commitOID: GitOID = try repository.commit(
                "Test content",
                toFile:     "test.txt",
                message:    "Test commit"
            )
            
            
            
            var revspec = GitRevspec()
            
            defer
            {
                gitObjectFree(object: revspec.from)
                gitObjectFree(object: revspec.to)
            }
            
            
            
            let revparseResult: GitErrorCode = gitRevparse(
                revspec:    &revspec,
                repo:       repository.pointer,
                spec:       "HEAD"
            )
            
            XCTAssertOK(revparseResult)
            XCTAssertTrue(revspec.flags.contains(.gitRevspecSingle))
            XCTAssertNil(revspec.to)
            
            guard let fromObjectPointer: OpaquePointer = revspec.from
            else
            {
                XCTFail("The from-object pointer was nil.")
                return
            }
            
            
            
            let fromObjectOID: GitOID? = gitObjectID(obj: fromObjectPointer)
            
            XCTAssertNotNil(fromObjectOID)
            XCTAssertEqual(fromObjectOID, commitOID)
        }
    }
    
    
    
    func testGitRevparseSingleWithInvalidSpec() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.commit(
                "Test content",
                toFile:     "test.txt",
                message:    "Test commit"
            )
            
            
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let revparseSingleResult: GitErrorCode = gitRevparseSingle(
                out:    &objectPointer,
                repo:   repository.pointer,
                spec:   "helloworld"
            )
            
            XCTAssertNotOK(revparseSingleResult)
            XCTAssertNil(objectPointer)
        }
    }
    
    
    
    func testGitRevparseSingleWithRevisionSpec() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let revparseSingleResult: GitErrorCode = gitRevparseSingle(
                out:    &objectPointer,
                repo:   repository.pointer,
                spec:   "HEAD~0"
            )
            
            XCTAssertOK(revparseSingleResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            let objectOID: GitOID? = gitObjectID(obj: objectPointer)
            
            XCTAssertNotNil(objectOID)
            XCTAssertEqual(objectOID, secondCommitOID)
        }
    }
    
    
    
    func testGitRevspec() throws
    {
        let revspec = GitRevspec()
        
        XCTAssertNil(revspec.from)
        XCTAssertNil(revspec.to)
        XCTAssertEqual(revspec.flags, [])
        
        revspec.withCValue
        {
            cRevspec in
            
            XCTAssertNil(cRevspec.pointee.from)
            XCTAssertNil(cRevspec.pointee.to)
            XCTAssertEqual(GitRevspecT(rawValue: cRevspec.pointee.flags), [])
        }
    }
    
    
    
    func testGitRevspecT() throws
    {
        XCTAssertEqual(GitRevspecT.gitRevspecSingle.rawValue, GIT_REVSPEC_SINGLE.rawValue)
        XCTAssertEqual(GitRevspecT.gitRevspecRange.rawValue, GIT_REVSPEC_RANGE.rawValue)
        XCTAssertEqual(GitRevspecT.gitRevspecMergeBase.rawValue, GIT_REVSPEC_MERGE_BASE.rawValue)
        
        XCTAssertEqual(GitRevspecT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitRevspecT.gitRevspecSingle.cValue(), GIT_REVSPEC_SINGLE)
        XCTAssertEqual(GitRevspecT.gitRevspecRange.cValue(), GIT_REVSPEC_RANGE)
        XCTAssertEqual(GitRevspecT.gitRevspecMergeBase.cValue(), GIT_REVSPEC_MERGE_BASE)
        
        XCTAssertEqual(GitRevspecT(cValue: GIT_REVSPEC_SINGLE), .gitRevspecSingle)
        XCTAssertEqual(GitRevspecT(cValue: GIT_REVSPEC_RANGE), .gitRevspecRange)
        XCTAssertEqual(GitRevspecT(cValue: GIT_REVSPEC_MERGE_BASE), .gitRevspecMergeBase)
        
        
        
        let flags: GitRevspecT =
        [
            .gitRevspecSingle,
            .gitRevspecRange
        ]
        
        XCTAssertTrue(flags.contains(.gitRevspecSingle))
        XCTAssertTrue(flags.contains(.gitRevspecRange))
        XCTAssertFalse(flags.contains(.gitRevspecMergeBase))
    }
}
