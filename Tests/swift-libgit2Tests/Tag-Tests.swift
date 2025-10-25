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



final class TagTests: XCTestCaseStopOnFail
{
    func testGitTagAnnotationCreate() throws
    {
        try withTag(type: .annotated)
        {
            _, _ in
        }
    }
    
    
    
    func testGitTagCreate() throws
    {
        try withTag
        {
            _, _ in
        }
    }
    
    
    
    func testGitTagCreateFromBuffer() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            guard let headOIDString: String = gitOIDToStrS(oid: headOID)
            else
            {
                XCTFail("The HEAD OID string was nil.")
                return
            }
            
            
            
            let tagData: String =
            """
            object \(headOIDString)
            type commit
            tag \(Self.tagName)
            tagger \(repository.signature.name) <\(repository.signature.email)> 946684800 +0000
            
            \(Self.tagMessage)
            """
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                var tagOID = GitOID()
                
                let tagCreateFromBufferResult: GitErrorCode
                = gitTagCreateFromBuffer(
                    oid:        &tagOID,
                    repo:       repository.pointer,
                    buffer:     tagData,
                    force:      true
                )
                
                XCTAssertOK(tagCreateFromBufferResult)
                XCTAssertNotZeroOID(tagOID)
            }
        }
    }
    
    
    
    func testGitTagCreateLightweight() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                var tagOID = GitOID()
                
                let tagCreateLightweightResult: GitErrorCode
                    = gitTagCreateLightweight(
                        oid:        &tagOID,
                        repo:       repository.pointer,
                        tagName:    Self.tagName,
                        target:     commitPointer,
                        force:      true
                    )
                
                XCTAssertOK(tagCreateLightweightResult)
                XCTAssertNotZeroOID(tagOID)
            }
        }
    }
    
    
    
    func testGitTagDelete() throws
    {
        try withTag
        {
            repository, _ in
            
            let tagDeleteResult: GitErrorCode = gitTagDelete(
                repo:       repository.pointer,
                tagName:    Self.tagName
            )
            
            XCTAssertOK(tagDeleteResult)
        }
    }
    
    
    
    func testGitTagDup() throws
    {
        try withTag
        {
            _, tagPointer in
            
            var duplicatedPointer: OpaquePointer? = nil
            
            defer
            {
                gitTagFree(tag: duplicatedPointer)
            }
            
            
            
            let tagDupResult: GitErrorCode = gitTagDup(
                out:        &duplicatedPointer,
                source:     tagPointer
            )
            
            XCTAssertOK(tagDupResult)
            XCTAssertNotNil(duplicatedPointer)
            XCTAssertEqual(duplicatedPointer, tagPointer)
        }
    }
    
    
    
    func testGitTagForEach() throws
    {
        try withTag
        {
            repository, tagPointer in
            
            var callbackData = CallbackData()
            
            let tagForEachCB: GitTagForEachCB =
            {
                name, oid, payload in
                
                guard
                    let payload : UnsafeMutableRawPointer           = payload,
                    let oid     : UnsafeMutablePointer<git_oid>     = oid
                else
                {
                    XCTFail("All or some callback parameters were nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount    += 1
                payloadPointer.pointee.tagOID       = GitOID(cValue: oid.pointee)
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let tagForEachResult: GitErrorCode = gitTagForEach(
                    repo:       repository.pointer,
                    callback:   tagForEachCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(tagForEachResult)
            }
            
            XCTAssertEqual(callbackData.callCount, 1)
            XCTAssertNotZeroOID(callbackData.tagOID)
            
            
            
            let tagOID: GitOID? = gitTagID(tag: tagPointer)
            
            XCTAssertNotNil(tagOID)
            XCTAssertNotZeroOID(tagOID)
            XCTAssertEqual(tagOID, callbackData.tagOID)
        }
    }
    
    
    
    func testGitTagFree() throws
    {
        gitTagFree(tag: nil)
    }
    
    
    
    func testGitTagID() throws
    {
        try withTag
        {
            repository, tagPointer in
            
            let tagOID: GitOID? = gitTagID(tag: tagPointer)
            
            XCTAssertNotNil(tagOID)
            XCTAssertNotZeroOID(tagOID)
        }
    }
    
    
    
    func testGitTagList() throws
    {
        try withTag
        {
            repository, _ in
            
            var tagNames: [String] = []
            
            let tagListResult: GitErrorCode = gitTagList(
                tagNames:   &tagNames,
                repo:       repository.pointer
            )
            
            XCTAssertOK(tagListResult)
            XCTAssertEqual(tagNames.count, 1)
            XCTAssertEqual(tagNames[0], Self.tagName)
        }
    }
    
    
    
    func testGitTagListMatch() throws
    {
        try withTag
        {
            repository, _ in
            
            var tagNames: [String] = []
            
            let tagListMatchResult: GitErrorCode = gitTagListMatch(
                tagNames:   &tagNames,
                pattern:    "",
                repo:       repository.pointer
            )
            
            XCTAssertOK(tagListMatchResult)
            XCTAssertEqual(tagNames.count, 1)
            XCTAssertEqual(tagNames[0], Self.tagName)
        }
    }
    
    
    
    func testGitTagLookupPrefix() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var tagOID = GitOID()
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let tagCreateResult: GitErrorCode = gitTagCreate(
                    oid:        &tagOID,
                    repo:       repository.pointer,
                    tagName:    Self.tagName,
                    target:     commitPointer,
                    tagger:     repository.signature,
                    message:    Self.tagMessage,
                    force:      true
                )
                
                XCTAssertOK(tagCreateResult)
                XCTAssertNotZeroOID(tagOID)
            }
            
            
            
            var tagPointer: OpaquePointer? = nil
            
            defer
            {
                gitTagFree(tag: tagPointer)
            }
            
            
            
            let tagLookupPrefixResult: GitErrorCode = gitTagLookupPrefix(
                out:    &tagPointer,
                repo:   repository.pointer,
                id:     tagOID,
                len:    7
            )
            
            XCTAssertOK(tagLookupPrefixResult)
            XCTAssertNotNil(tagPointer)
        }
    }
    
    
    
    func testGitTagMessage() throws
    {
        try withTag
        {
            _, tagPointer in
            
            let tagMessage: String? = gitTagMessage(tag: tagPointer)
            
            XCTAssertNotNil(tagMessage)
            XCTAssertEqual(tagMessage, Self.tagMessage)
        }
    }
    
    
    
    func testGitTagName() throws
    {
        try withTag
        {
            _, tagPointer in
            
            let tagName: String? = gitTagName(tag: tagPointer)
            
            XCTAssertNotNil(tagName)
            XCTAssertEqual(tagName, Self.tagName)
        }
    }
    
    
    
    func testGitTaghNameIsValid() throws
    {
        let tagNamesAndResults: [String : Bool] =
        [
            "v1.2.3"        : true,
            "-v1.2.3"       : false,
            "~v1.2.3"       : false,
            "^v1.2.2"       : false,
            "v1:2:3"        : false,
            "1.2.3"         : true,
            "v1.2.3?"       : false,
            "[v1.2.3]"      : false,
            "v1*2*3"        : false,
            "v1..2..3"      : false,
            "0.0.0"         : true,
            "v1...2...3"    : false,
            "@{v1.2.3}"     : false
        ]
        
        for (tagName, validityResult) in tagNamesAndResults
        {
            var isValid: Bool = !validityResult
            
            let tagNameIsValidResult: GitErrorCode = gitTagNameIsValid(
                valid:  &isValid,
                name:   tagName
            )
            
            XCTAssertOK(tagNameIsValidResult)
            XCTAssertEqual(isValid, validityResult)
        }
    }
    
    
    
    func testGitTagOwner() throws
    {
        try withTag
        {
            repository, tagPointer in
            
            let ownerPointer: OpaquePointer
                = gitTagOwner(tag: tagPointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
        }
    }
    
    
    
    func testGitTagPeel() throws
    {
        try withTag
        {
            _, tagPointer in
            
            var objectPointer: OpaquePointer? = nil
            
            defer
            {
                gitObjectFree(object: objectPointer)
            }
            
            
            
            let tagPeelResult: GitErrorCode = gitTagPeel(
                out:    &objectPointer,
                tag:    tagPointer
            )
            
            XCTAssertOK(tagPeelResult)
            
            guard let objectPointer: OpaquePointer = objectPointer
            else
            {
                XCTFail("The object pointer was nil.")
                return
            }
            
            
            
            let objectType: GitObjectT?
                = gitObjectType(obj: objectPointer)
            
            XCTAssertNotNil(objectType)
            XCTAssertEqual(objectType, .gitObjectCommit)
        }
    }
    
    
    
    func testGitTagTagger() throws
    {
        try withTag
        {
            repository, tagPointer in
            
            let tagTagger: GitSignature? = gitTagTagger(tag: tagPointer)
            
            XCTAssertNotNil(tagTagger)
            XCTAssertEqual(tagTagger?.name, repository.signature.name)
            XCTAssertEqual(tagTagger?.email, repository.signature.email)
        }
    }
    
    
    
    func testGitTagTargetID() throws
    {
        try withTag
        {
            repository, tagPointer in
        
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let tagTargetOID: GitOID? = gitTagTargetID(tag: tagPointer)
            
            XCTAssertNotNil(tagTargetOID)
            XCTAssertEqual(tagTargetOID, headOID)
        }
    }
    
    
    
    func testGitTagTargetType() throws
    {
        try withTag
        {
            repository, tagPointer in
            
            let tagTargetType: GitObjectT? = gitTagTargetType(tag: tagPointer)
            
            XCTAssertNotNil(tagTargetType)
            XCTAssertEqual(tagTargetType, .gitObjectCommit)
        }
    }
}



// MARK: - Extensions

private extension TagTests
{
    static let tagName      : String    = "v1.2.3"
    static let tagMessage   : String    = "Hello World!"
    
    
    
    struct CallbackData
    {
        var callCount   : Int       = 0
        var tagOID      : GitOID    = GitOID()
    }
    
    
    
    enum TagCreationType
    {
        case standard
        case annotated
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a tag that points to HEAD.
    /// - Parameters:
    ///   - type: How to create the tag.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withTag(
        type    : TagCreationType = .standard,
        _ body  : (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var tagOID = GitOID()
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let tagCreateResult: GitErrorCode
                
                switch type
                {
                    case .standard:
                        
                        tagCreateResult = gitTagCreate(
                            oid:        &tagOID,
                            repo:       repository.pointer,
                            tagName:    Self.tagName,
                            target:     commitPointer,
                            tagger:     repository.signature,
                            message:    Self.tagMessage,
                            force:      true
                        )
                        
                    case .annotated:
                        
                        tagCreateResult = gitTagAnnotationCreate(
                            oid:        &tagOID,
                            repo:       repository.pointer,
                            tagName:    Self.tagName,
                            target:     commitPointer,
                            tagger:     repository.signature,
                            message:    Self.tagMessage
                        )
                }
                
                XCTAssertOK(tagCreateResult)
                XCTAssertNotZeroOID(tagOID)
            }
            
            
            
            var tagPointer: OpaquePointer? = nil
            
            defer
            {
                gitTagFree(tag: tagPointer)
            }
            
            
            
            let tagLookupResult: GitErrorCode = gitTagLookup(
                out:    &tagPointer,
                repo:   repository.pointer,
                id:     tagOID
            )
            
            XCTAssertOK(tagLookupResult)
            
            guard let tagPointer: OpaquePointer = tagPointer
            else
            {
                XCTFail("The tag pointer was nil.")
                return
            }
            
            
            
            try body(
                repository,
                tagPointer
            )
        }
    }
}
