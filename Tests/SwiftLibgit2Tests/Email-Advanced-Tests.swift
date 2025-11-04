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



final class EmailAdvancedTests: XCTestCaseStopOnFail
{
    func testGitEmailCreateFromDiff() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Diff.withTreeToWorkdirDiff(in: repository)
            {
                diffPointer in
                
                var emailCreateOptions = GitEmailCreateOptions()
                
                emailCreateOptions.flags            = .gitEmailCreateOmitNumbers
                emailCreateOptions.subjectPrefix    = ""
                
                
                
                var emailPatch = Data()
                
                let emailCreateFromDiffResult: GitErrorCode
                    = gitEmailCreateFromDiff(
                        out:            &emailPatch,
                        diff:           diffPointer,
                        patchIdx:       0,
                        patchCount:     1,
                        commitID:       repository.headOID,
                        summary:        "Email from diff",
                        body:           nil,
                        author:         repository.signature,
                        opts:           emailCreateOptions
                    )
                
                XCTAssertOK(emailCreateFromDiffResult)
                XCTAssertGreaterThan(emailPatch.count, 0)
            }
        }
    }
}
