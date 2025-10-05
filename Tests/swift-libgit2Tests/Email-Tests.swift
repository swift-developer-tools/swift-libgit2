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



final class EmailTests: XCTestCaseStopOnFail
{
    func testEmailCreateFlagsT() throws
    {
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateDefault.rawValue, GIT_EMAIL_CREATE_DEFAULT.rawValue)
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateOmitNumbers.rawValue, GIT_EMAIL_CREATE_OMIT_NUMBERS.rawValue)
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateAlwaysNumber.rawValue, GIT_EMAIL_CREATE_ALWAYS_NUMBER.rawValue)
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateNoRenames.rawValue, GIT_EMAIL_CREATE_NO_RENAMES.rawValue)
        
        XCTAssertEqual(GitEmailCreateFlagsT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateDefault.cValue(), GIT_EMAIL_CREATE_DEFAULT)
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateOmitNumbers.cValue(), GIT_EMAIL_CREATE_OMIT_NUMBERS)
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateAlwaysNumber.cValue(), GIT_EMAIL_CREATE_ALWAYS_NUMBER)
        XCTAssertEqual(GitEmailCreateFlagsT.gitEmailCreateNoRenames.cValue(), GIT_EMAIL_CREATE_NO_RENAMES)
        
        
        
        let flags: GitEmailCreateFlagsT =
        [
            .gitEmailCreateOmitNumbers,
            .gitEmailCreateAlwaysNumber
        ]
        
        XCTAssertTrue(flags.contains(.gitEmailCreateOmitNumbers))
        XCTAssertTrue(flags.contains(.gitEmailCreateAlwaysNumber))
        XCTAssertFalse(flags.contains(.gitEmailCreateNoRenames))
    }
    
    
    
    func testGitEmailCreateFromCommit() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var buffer = GitBuf()
            
            defer
            {
                XCTAssertOK(gitBufDispose(buffer: &buffer))
            }
            
            
            
            var emailCreateOptions = GitEmailCreateOptions()
            
            emailCreateOptions.flags            = .gitEmailCreateOmitNumbers
            emailCreateOptions.subjectPrefix    = ""
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let emailCreateFromCommitResult: GitErrorCode = gitEmailCreateFromCommit(
                    out:        &buffer,
                    commit:     commitPointer,
                    opts:       emailCreateOptions
                )
                
                XCTAssertOK(emailCreateFromCommitResult)
            }
            
            XCTAssertNotNil(buffer.ptr)
            XCTAssertGreaterThan(buffer.size, 0)
        }
    }
    
    
    
    func testGitEmailCreateOptions() throws
    {
        let emailCreateOptions = GitEmailCreateOptions()
        
        XCTAssertEqual(emailCreateOptions.version, gitEmailCreateOptionsVersion)
        XCTAssertEqual(emailCreateOptions.flags, .gitEmailCreateDefault)
        XCTAssertNotNil(emailCreateOptions.diffOpts)
        XCTAssertNotNil(emailCreateOptions.diffFindOpts)
        XCTAssertEqual(emailCreateOptions.subjectPrefix, "PATCH")
        XCTAssertEqual(emailCreateOptions.startNumber, 1)
        XCTAssertEqual(emailCreateOptions.rerollNumber, 0)
        
        XCTAssertEqual(gitEmailCreateOptionsVersion, UInt32(GIT_EMAIL_CREATE_OPTIONS_VERSION))
        
        try emailCreateOptions.withCValue
        {
            cEmailCreateOptions in
            
            XCTAssertEqual(cEmailCreateOptions.pointee.version, gitEmailCreateOptionsVersion)
            XCTAssertEqual(GitEmailCreateFlagsT(rawValue: cEmailCreateOptions.pointee.flags), .gitEmailCreateDefault)
            XCTAssertNotNil(cEmailCreateOptions.pointee.diff_opts)
            XCTAssertNotNil(cEmailCreateOptions.pointee.diff_find_opts)
            XCTAssertEqual(String(optionalCString: cEmailCreateOptions.pointee.subject_prefix), "PATCH")
            XCTAssertEqual(cEmailCreateOptions.pointee.start_number, 1)
            XCTAssertEqual(cEmailCreateOptions.pointee.reroll_number, 0)
        }
    }
}
