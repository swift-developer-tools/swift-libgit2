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
        var signature = GitSignature()
        
        let signatureNowResult: Int32 = gitSignatureNow(
            out:    &signature,
            name:   Repository.commitAuthorName,
            email:  Repository.commitAuthorEmail
        )
        
        XCTAssertOK(signatureNowResult)
        
        
        
        try Commit.withHEADCommit(in: repository)
        {
            commitPointer in

            return signature.withCValue
            {
                cSignature in
                
                // TODO: Replace once `git_tag_create()` has a binding.
                var tagOID = git_oid()
                
                let tagCreateResult: Int32 = git_tag_create(
                    &tagOID,
                    repository.pointer,
                    tagName,
                    commitPointer,
                    cSignature,
                    message,
                    0
                )
                
                XCTAssertOK(tagCreateResult)
            }
        }
    }
}
