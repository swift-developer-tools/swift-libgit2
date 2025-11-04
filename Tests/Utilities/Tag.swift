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



/// Tag-related test utilities.
enum Tag
{
    enum TagCreationType
    {
        case standard
        case annotated
        case buffer(content: String)
        case lightweight
    }
    
    
    
    /// Creates a tag in the given repository.
    /// - Parameters:
    ///   - type: The type of tag to create.
    ///   - tagName: The tag name to use.
    ///   - repository: The repository in which to create the tag.
    ///   - tagMessage: The tag message to use.
    ///   - force: Whether to overwrite an existing tag.
    /// - Returns: The ID of the created tag.
    /// - Throws: An error if an operation fails.
    @discardableResult
    static func createTag(
        type                    : TagCreationType   = .standard,
        named       tagName     : String,
        in          repository  : Repository,
        message     tagMessage  : String,
        force                   : Bool              = false
    ) throws -> GitOID
    {
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
                        tagName:    tagName,
                        target:     commitPointer,
                        tagger:     repository.signature,
                        message:    tagMessage,
                        force:      force
                    )
                    
                case .annotated:
                    
                    tagCreateResult = gitTagAnnotationCreate(
                        oid:        &tagOID,
                        repo:       repository.pointer,
                        tagName:    tagName,
                        target:     commitPointer,
                        tagger:     repository.signature,
                        message:    tagMessage
                    )
                    
                case .buffer(let content):
                    
                    tagCreateResult = gitTagCreateFromBuffer(
                        oid:        &tagOID,
                        repo:       repository.pointer,
                        buffer:     content,
                        force:      force
                    )
                    
                case .lightweight:
                    
                    tagCreateResult = gitTagCreateLightweight(
                        oid:        &tagOID,
                        repo:       repository.pointer,
                        tagName:    tagName,
                        target:     commitPointer,
                        force:      force
                    )
            }
            
            XCTAssertOK(tagCreateResult)
            XCTAssertNotZeroOID(tagOID)
        }
        
        return tagOID
    }
}
