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



/// Tag-related testing utilities.
enum Tag
{
    /// Creates an annotated tag in the repository.
    /// - Parameters:
    ///   - repository: The repository in which to create the tag.
    ///   - tagName: The tag name.
    ///   - message: The tag message.
    /// - Throws: An `Error` if the tag creation failed.
    static func createAnnotatedTag(
        in repository   : Repository,
        tagName         : String,
        message         : String
    ) throws
    {
        let headOID: GitOID = OID.getHEADCommitOID(in: repository)
        
        
        
        var commitPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeCommit(commitPointer)
        }
        
        
        
        let commitLookupResult: Int32 = gitCommitLookup(
            commit:     &commitPointer,
            repo:       repository.pointer,
            id:         headOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        guard let commitPointer: OpaquePointer = commitPointer
        else
        {
            XCTFail("The commit pointer was nil.")
            return
        }
        
        
        
        var signature = GitSignature()
        
        let signatureNowResult: Int32 = gitSignatureNow(
            out:    &signature,
            name:   Repository.commitAuthorName,
            email:  Repository.commitAuthorEmail
        )
        
        XCTAssertOK(signatureNowResult)
        
        
        
        // TODO: Replace once `git_tag_create()` has a binding.
        var tagOID = git_oid()
        
        let tagCreateResult: Int32 = signature.withCValue
        {
            cSignature in
            
            return git_tag_create(
                &tagOID,
                repository.pointer,
                tagName,
                commitPointer,
                cSignature,
                message,
                0
            )
        }
        
        XCTAssertOK(tagCreateResult)
    }
}
