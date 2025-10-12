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
    ///   - tagName: The tag name.
    ///   - repository: The repository in which to create the tag.
    ///   - message: The tag message.
    /// - Throws: An error if an operation fails.
    static func createAnnotatedTag(
        named       tagName     : String,
        in          repository  : Repository,
        message                 : String
    ) throws
    {
        try Commit.withHEADCommit(in: repository)
        {
            commitPointer in

            return try repository.signature.withCValue
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
                
                XCTAssertOK(GitErrorCode(rawValue: tagCreateResult))
            }
        }
    }
}
