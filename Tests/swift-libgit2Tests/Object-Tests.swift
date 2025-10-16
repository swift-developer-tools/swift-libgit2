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



final class ObjectTests: XCTestCaseStopOnFail
{
    func testGitObjectDup() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var sourceObjectPointer     : OpaquePointer?    = nil
            var duplicatedObjectPointer : OpaquePointer?    = nil
            
            defer
            {
                gitObjectFree(object: sourceObjectPointer)
                gitObjectFree(object: duplicatedObjectPointer)
            }
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let objectLookupResult: GitErrorCode = gitObjectLookup(
                object:     &sourceObjectPointer,
                repo:       repository.pointer,
                id:         headOID,
                type:       .gitObjectCommit
            )
            
            XCTAssertOK(objectLookupResult)
            
            guard let sourceObjectPointer: OpaquePointer = sourceObjectPointer
            else
            {
                XCTFail("The source object pointer was nil.")
                return
            }
            
            
            
            let objectDupResult: GitErrorCode = gitObjectDup(
                dest:       &duplicatedObjectPointer,
                source:     sourceObjectPointer
            )
            
            XCTAssertOK(objectDupResult)
            
            guard let duplicatedObjectPointer: OpaquePointer
                    = duplicatedObjectPointer
            else
            {
                XCTFail("The duplicated object pointer was nil.")
                return
            }
            
            
            
            let sourceOID       : GitOID    = gitObjectID(obj: sourceObjectPointer)
            let duplicatedOID   : GitOID    = gitObjectID(obj: duplicatedObjectPointer)
            
            XCTAssertEqual(sourceOID, duplicatedOID)
            
            
            
            let sourceType      : GitObjectT?   = gitObjectType(obj: sourceObjectPointer)
            let duplicatedType  : GitObjectT?   = gitObjectType(obj: duplicatedObjectPointer)
            
            XCTAssertNotNil(sourceType)
            XCTAssertNotNil(duplicatedType)
            XCTAssertEqual(sourceType, duplicatedType)
        }
    }
    
    
    
    func testGitObjectFree() throws
    {
        gitObjectFree(object: nil)
    }
    
    
    
    func testGitObjectLookupAndGetters() throws
    {
        try testGitCommitLookup(type: .gitObjectAny)
        try testGitCommitLookup(type: .gitObjectInvalid)
        try testGitCommitLookup(type: .gitObjectCommit)
        try testGitCommitLookup(type: .gitObjectTree)
        try testGitCommitLookup(type: .gitObjectBlob)
        try testGitCommitLookup(type: .gitObjectTag)
    }
    
    
    
    func testGitObjectLookupPrefixAndShortID() throws
    {
        try testGitCommitLookupPrefix(type: .gitObjectAny)
        try testGitCommitLookupPrefix(type: .gitObjectInvalid)
        try testGitCommitLookupPrefix(type: .gitObjectCommit)
        try testGitCommitLookupPrefix(type: .gitObjectTree)
        try testGitCommitLookupPrefix(type: .gitObjectBlob)
        try testGitCommitLookupPrefix(type: .gitObjectTag)
    }
    
    
    
    func testGitObjectLookupByPath() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let directoryName   : String    = "subdirectory"
            let filePath        : String    = directoryName + "/file.txt"
            
            try repository.createDirectory(at: directoryName)
            
            try repository.commit(
                "File content",
                toFile:     filePath,
                message:    "Add file"
            )
            
            
            
            var treeishPointer  : OpaquePointer?    = nil
            var objectPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitObjectFree(object: treeishPointer)
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let objectLookupResult: GitErrorCode = gitObjectLookup(
                object:     &treeishPointer,
                repo:       repository.pointer,
                id:         headOID,
                type:       .gitObjectCommit
            )
            
            XCTAssertOK(objectLookupResult)
            
            guard let treeishPointer: OpaquePointer = treeishPointer
            else
            {
                XCTFail("The treeish pointer was nil.")
                return
            }
            
            
            
            let objectLookupByPathResult: GitErrorCode = gitObjectLookupByPath(
                out:        &objectPointer,
                treeish:    treeishPointer,
                path:       filePath,
                type:       .gitObjectBlob
            )
            
            XCTAssertOK(objectLookupByPathResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            let objectType: GitObjectT? = gitObjectType(obj: objectPointer)
            
            XCTAssertEqual(objectType, .gitObjectBlob)
        }
    }
    
    
    func testGitObjectPeel() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var objectPointer       : OpaquePointer?    = nil
            var peeledObjectPointer : OpaquePointer?    = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
                gitObjectFree(object: peeledObjectPointer)
            }
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let objectLookupResult: GitErrorCode = gitObjectLookup(
                object:     &objectPointer,
                repo:       repository.pointer,
                id:         headOID,
                type:       .gitObjectCommit
            )
            
            XCTAssertOK(objectLookupResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            let objectPeelResult: GitErrorCode = gitObjectPeel(
                peeled:         &peeledObjectPointer,
                object:         objectPointer,
                targetType:     .gitObjectTree
            )
            
            XCTAssertOK(objectPeelResult)
            
            guard let peeledObjectPointer: OpaquePointer = peeledObjectPointer
            else
            {
                XCTFail("The peeled object pointer was nil.")
                return
            }
            
            
            
            let peeledObjectType: GitObjectT?
                = gitObjectType(obj: peeledObjectPointer)
            
            XCTAssertEqual(peeledObjectType, .gitObjectTree)
        }
    }
    
    
    
    func testGitObjectRawContentIsValid() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let blobData = Data("Blob content".utf8)
            
            var isBlobValid: Bool = false
            
            let blobContentIsValidResult: GitErrorCode
                = gitObjectRawContentIsValid(
                    valid:          &isBlobValid,
                    buf:            blobData,
                    len:            blobData.count,
                    objectType:     .gitObjectBlob
                )
            
            XCTAssertOK(blobContentIsValidResult)
            XCTAssertTrue(isBlobValid)
            
            
            
            let validCommitContent: String =
            """
            tree 0123456789012345678901234567890123456789
            author Someone <someone@example.com> 1234567890 +0000
            committer Someone <someone@example.com> 1234567890 +0000
            
            Hello World!
            """
            
            let validCommitData = Data(validCommitContent.utf8)
            
            var isCommitValid: Bool = false
            
            var commitContentIsValidResult: GitErrorCode
                = gitObjectRawContentIsValid(
                    valid:          &isCommitValid,
                    buf:            validCommitData,
                    len:            validCommitData.count,
                    objectType:     .gitObjectCommit
                )
            
            XCTAssertOK(commitContentIsValidResult)
            XCTAssertTrue(isCommitValid)
            
            
            
            isCommitValid = true
            
            let invalidCommitData = Data("Invalid commit".utf8)
            
            commitContentIsValidResult = gitObjectRawContentIsValid(
                valid:          &isCommitValid,
                buf:            invalidCommitData,
                len:            invalidCommitData.count,
                objectType:     .gitObjectCommit
            )
            
            XCTAssertOK(commitContentIsValidResult)
            XCTAssertFalse(isCommitValid)
        }
    }
    
    
    
    func testGitObjectSizeMax() throws
    {
        XCTAssertEqual(gitObjectSizeMax, UInt64.max)
    }
    
    
    
    func testGitObjectT() throws
    {
        XCTAssertEqual(GitObjectT.gitObjectAny.rawValue, GIT_OBJECT_ANY.rawValue)
        XCTAssertEqual(GitObjectT.gitObjectInvalid.rawValue, GIT_OBJECT_INVALID.rawValue)
        XCTAssertEqual(GitObjectT.gitObjectCommit.rawValue, GIT_OBJECT_COMMIT.rawValue)
        XCTAssertEqual(GitObjectT.gitObjectTree.rawValue, GIT_OBJECT_TREE.rawValue)
        XCTAssertEqual(GitObjectT.gitObjectBlob.rawValue, GIT_OBJECT_BLOB.rawValue)
        XCTAssertEqual(GitObjectT.gitObjectTag.rawValue, GIT_OBJECT_TAG.rawValue)
        
        XCTAssertNil(GitObjectT(rawValue: 123))
        
        XCTAssertEqual(GitObjectT.gitObjectAny.cValue(), GIT_OBJECT_ANY)
        XCTAssertEqual(GitObjectT.gitObjectInvalid.cValue(), GIT_OBJECT_INVALID)
        XCTAssertEqual(GitObjectT.gitObjectCommit.cValue(), GIT_OBJECT_COMMIT)
        XCTAssertEqual(GitObjectT.gitObjectTree.cValue(), GIT_OBJECT_TREE)
        XCTAssertEqual(GitObjectT.gitObjectBlob.cValue(), GIT_OBJECT_BLOB)
        XCTAssertEqual(GitObjectT.gitObjectTag.cValue(), GIT_OBJECT_TAG)
        
        XCTAssertEqual(GitObjectT(cValue: GIT_OBJECT_ANY), .gitObjectAny)
        XCTAssertEqual(GitObjectT(cValue: GIT_OBJECT_INVALID), .gitObjectInvalid)
        XCTAssertEqual(GitObjectT(cValue: GIT_OBJECT_COMMIT), .gitObjectCommit)
        XCTAssertEqual(GitObjectT(cValue: GIT_OBJECT_TREE), .gitObjectTree)
        XCTAssertEqual(GitObjectT(cValue: GIT_OBJECT_BLOB), .gitObjectBlob)
        XCTAssertEqual(GitObjectT(cValue: GIT_OBJECT_TAG), .gitObjectTag)
    }
    
    
    
    func testGitObjectTypeAndStringConversion() throws
    {
        let testCases: [(GitObjectT, String)] =
        [
            (.gitObjectCommit,  "commit"),
            (.gitObjectTree,    "tree"),
            (.gitObjectBlob,    "blob"),
            (.gitObjectTag,     "tag")
        ]
        
        for (type, string) in testCases
        {
            let typeString: String? = gitObjectType2String(type: type)
            
            XCTAssertNotNil(typeString)
            XCTAssertEqual(typeString, string)
            
            
            
            let objectType: GitObjectT? = gitObjectString2Type(str: string)
            
            XCTAssertNotNil(objectType)
            XCTAssertEqual(objectType, type)
        }
        
        
        
        let invalidType: GitObjectT? = gitObjectString2Type(str: "invalid")
        
        XCTAssertEqual(invalidType, .gitObjectInvalid)
    }
}



// MARK: - Extensions

extension ObjectTests
{
    /// Tests looking up an object of the given type and validating its
    /// properties.
    /// - Parameter type: The type of object to look up.
    /// - Throws: An error if an operation fails.
    private func testGitCommitLookup(
        type: GitObjectT
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let objectLookupResult: GitErrorCode = gitObjectLookup(
                object:     &objectPointer,
                repo:       repository.pointer,
                id:         headOID,
                type:       type
            )
            
            if
                type == .gitObjectAny
                || type == .gitObjectCommit
            {
                XCTAssertOK(objectLookupResult)
            }
            else
            {
                XCTAssertNotOK(objectLookupResult)
                XCTAssertNil(objectPointer)
                return
            }
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            let objectOID: GitOID = gitObjectID(obj: objectPointer)
            
            XCTAssertEqual(objectOID, headOID)
            
            
            
            guard let objectType: GitObjectT = gitObjectType(obj: objectPointer)
            else
            {
                XCTFail("The object type was nil.")
                return
            }
            
            XCTAssertEqual(objectType, .gitObjectCommit)
            
            
            
            let objectOwner: OpaquePointer = gitObjectOwner(obj: objectPointer)
            
            XCTAssertEqual(objectOwner, repository.pointer)
        }
    }
    
    
    
    /// Tests looking up an object of the given type and prefix length.
    /// - Parameters:
    ///   - type: The type of object to look up.
    ///   - prefixLength: The prefix length to use.
    /// - Throws: An error if an operation fails.
    private func testGitCommitLookupPrefix(
        type            : GitObjectT,
        prefixLength    : Int           = 7
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let prefixLength: Int = 7
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            guard let headOIDString: String = gitOIDToStrS(oid: headOID)
            else
            {
                XCTFail("The HEAD OID string was nil.")
                return
            }
            
            
            
            let headOIDStringPrefix = String(headOIDString.prefix(prefixLength))
            
            let objectLookupPrefixResult: GitErrorCode = gitObjectLookupPrefix(
                objectOut:   &objectPointer,
                repo:       repository.pointer,
                id:         headOID,
                len:        prefixLength,
                type:       type
            )
            
            if
                type == .gitObjectAny
                || type == .gitObjectCommit
            {
                XCTAssertOK(objectLookupPrefixResult)
            }
            else
            {
                XCTAssertNotOK(objectLookupPrefixResult)
                XCTAssertNil(objectPointer)
                return
            }
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            var shortOID = Data()
            
            let objectShortIDResult: GitErrorCode = gitObjectShortID(
                out:    &shortOID,
                obj:    objectPointer
            )
            
            XCTAssertOK(objectShortIDResult)
            XCTAssertEqual(shortOID, headOIDStringPrefix)
        }
    }
}
