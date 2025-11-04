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



final class DescribeTests: XCTestCaseStopOnFail
{
    func testGitDescribeCommitAndFormat() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Tag.createTag(
                named:      "v1.0.0",
                in:         repository,
                message:    "Hello World!"
            )
            
            try repository.commit(
                "New feature",
                toFile:     "feature.txt",
                message:    "Add feature"
            )
            
            
            
            var describeResultPointer: OpaquePointer? = nil
            
            defer
            {
                gitDescribeResultFree(result: describeResultPointer)
            }
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let describeCommitResult: GitErrorCode = gitDescribeCommit(
                    result:         &describeResultPointer,
                    committish:     commitPointer,
                    opts:           nil
                )
                
                XCTAssertOK(describeCommitResult)
            }
            
            guard let describeResultPointer
            else
            {
                XCTFail("The describe result pointer was nil.")
                return
            }
            
            
            
            var description: String? = nil
            
            let describeFormatResult: GitErrorCode = gitDescribeFormat(
                out:        &description,
                result:     describeResultPointer,
                opts:       nil
            )
            
            XCTAssertOK(describeFormatResult)
            XCTAssertNotNil(description)
            XCTAssertGreaterThan(description?.count ?? 0, 0)
        }
    }
    
    
    
    func testGitDescribeCommitAndFormatWithOptions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Tag.createTag(
                named:      "v1.0.0",
                in:         repository,
                message:    "Hello World!"
            )
            
            try repository.commit(
                "New feature",
                toFile:     "feature.txt",
                message:    "Add feature"
            )
            
            
            
            var describeResultPointer: OpaquePointer? = nil
            
            defer
            {
                gitDescribeResultFree(result: describeResultPointer)
            }
            
            
            
            var describeOptions = GitDescribeOptions()
            
            describeOptions.describeStrategy    = .gitDescribeTags
            describeOptions.maxCandidatesTags   = 5
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                let describeCommitResult: GitErrorCode = gitDescribeCommit(
                    result:         &describeResultPointer,
                    committish:     commitPointer,
                    opts:           describeOptions
                )
                
                XCTAssertOK(describeCommitResult)
            }
            
            guard let describeResultPointer
            else
            {
                XCTFail("The describe result pointer was nil.")
                return
            }
            
            
            
            var describeFormatOptions = GitDescribeFormatOptions()
            
            describeFormatOptions.abbreviatedSize       = 10
            describeFormatOptions.alwaysUseLongFormat   = true
            describeFormatOptions.dirtySuffix           = "-modified"
            
            
            
            var description: String? = nil
            
            let describeFormatResult: GitErrorCode = gitDescribeFormat(
                out:        &description,
                result:     describeResultPointer,
                opts:       describeFormatOptions
            )
            
            XCTAssertOK(describeFormatResult)
            XCTAssertNotNil(description)
            XCTAssertGreaterThan(description?.count ?? 0, 0)
        }
    }
    
    
    
    func testGitDescribeDefaultAbbreviatedSize() throws
    {
        XCTAssertEqual(Int32(gitDescribeDefaultAbbreviatedSize), GIT_DESCRIBE_DEFAULT_ABBREVIATED_SIZE)
    }
    
    
    
    func testGitDescribeDefaultMaxCandidatesTags() throws
    {
        XCTAssertEqual(Int32(gitDescribeDefaultMaxCandidatesTags), GIT_DESCRIBE_DEFAULT_MAX_CANDIDATES_TAGS)
    }
    
    
    
    func testGitDescribeFormatOptions() throws
    {
        let describeFormatOptions = GitDescribeFormatOptions()
        
        XCTAssertEqual(describeFormatOptions.version, gitDescribeFormatOptionsVersion)
        XCTAssertEqual(describeFormatOptions.abbreviatedSize, gitDescribeDefaultAbbreviatedSize)
        XCTAssertFalse(describeFormatOptions.alwaysUseLongFormat)
        XCTAssertNil(describeFormatOptions.dirtySuffix)
        
        try describeFormatOptions.withCValue
        {
            cDescribeFormatOptions in
            
            XCTAssertEqual(cDescribeFormatOptions.pointee.version, gitDescribeFormatOptionsVersion)
            XCTAssertEqual(cDescribeFormatOptions.pointee.abbreviated_size, gitDescribeDefaultAbbreviatedSize)
            XCTAssertFalse(Bool(cDescribeFormatOptions.pointee.always_use_long_format))
            XCTAssertNil(cDescribeFormatOptions.pointee.dirty_suffix)
        }
    }
    
    
    
    func testGitDescribeFormatOptionsInit() throws
    {
        var describeFormatOptions = git_describe_format_options()
        
        let describeFormatOptionsInitResult: GitErrorCode
            = gitDescribeFormatOptionsInit(
                opts:       &describeFormatOptions,
                version:    gitDescribeFormatOptionsVersion
            )
        
        XCTAssertOK(describeFormatOptionsInitResult)
    }
    
    
    
    func testGitDescribeFormatOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitDescribeFormatOptionsVersion), GIT_DESCRIBE_FORMAT_OPTIONS_VERSION)
    }
    
    
    
    func testGitDescribeFree() throws
    {
        gitDescribeResultFree(result: nil)
    }
    
    
    
    func testGitDescribeOptions() throws
    {
        let describeOptions = GitDescribeOptions()
        
        XCTAssertEqual(describeOptions.version, gitDescribeOptionsVersion)
        XCTAssertEqual(describeOptions.maxCandidatesTags, gitDescribeDefaultMaxCandidatesTags)
        XCTAssertEqual(describeOptions.describeStrategy, .gitDescribeDefault)
        XCTAssertNil(describeOptions.pattern)
        XCTAssertFalse(describeOptions.onlyFollowFirstParent)
        XCTAssertFalse(describeOptions.showCommitOIDAsFallback)
        
        try describeOptions.withCValue
        {
            cDescribeOptions in
            
            XCTAssertEqual(cDescribeOptions.pointee.version, gitDescribeOptionsVersion)
            XCTAssertEqual(cDescribeOptions.pointee.max_candidates_tags, gitDescribeDefaultMaxCandidatesTags)
            XCTAssertEqual(GitDescribeStrategyT(rawValue: cDescribeOptions.pointee.describe_strategy), .gitDescribeDefault)
            XCTAssertNil(cDescribeOptions.pointee.pattern)
            XCTAssertFalse(Bool(cDescribeOptions.pointee.only_follow_first_parent))
            XCTAssertFalse(Bool(cDescribeOptions.pointee.show_commit_oid_as_fallback))
        }
    }
    
    
    
    func testGitDescribeOptionsInit() throws
    {
        var describeOptions = git_describe_options()
        
        let describeOptionsInitResult: GitErrorCode = gitDescribeOptionsInit(
            opts:       &describeOptions,
            version:    gitDescribeOptionsVersion
        )
        
        XCTAssertOK(describeOptionsInitResult)
    }
    
    
    
    func testGitDescibeOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitDescribeOptionsVersion), GIT_DESCRIBE_OPTIONS_VERSION)
    }
    
    
    
    func testGitDescribeStrategyT() throws
    {
        XCTAssertEqual(GitDescribeStrategyT.gitDescribeDefault.rawValue, GIT_DESCRIBE_DEFAULT.rawValue)
        XCTAssertEqual(GitDescribeStrategyT.gitDescribeTags.rawValue, GIT_DESCRIBE_TAGS.rawValue)
        XCTAssertEqual(GitDescribeStrategyT.gitDescribeAll.rawValue, GIT_DESCRIBE_ALL.rawValue)
        
        XCTAssertNil(GitDescribeStrategyT(rawValue: 123))
        
        XCTAssertEqual(GitDescribeStrategyT.gitDescribeDefault.cValue(), GIT_DESCRIBE_DEFAULT)
        XCTAssertEqual(GitDescribeStrategyT.gitDescribeTags.cValue(), GIT_DESCRIBE_TAGS)
        XCTAssertEqual(GitDescribeStrategyT.gitDescribeAll.cValue(), GIT_DESCRIBE_ALL)
        
        XCTAssertEqual(GitDescribeStrategyT(cValue: GIT_DESCRIBE_DEFAULT), .gitDescribeDefault)
        XCTAssertEqual(GitDescribeStrategyT(cValue: GIT_DESCRIBE_TAGS), .gitDescribeTags)
        XCTAssertEqual(GitDescribeStrategyT(cValue: GIT_DESCRIBE_ALL), .gitDescribeAll)
    }
    
    
    
    func testGitDescribeWorkdir() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Tag.createTag(
                named:      "v1.0.0",
                in:         repository,
                message:    "Hello World!"
            )
            
            try repository.modifyFile(
                at:     "dirty.txt",
                with:   "Uncommitted changes"
            )
            
            
            
            var describeResultPointer: OpaquePointer? = nil
            
            defer
            {
                gitDescribeResultFree(result: describeResultPointer)
            }
            
            
            
            let describeWorkdirResult: GitErrorCode = gitDescribeWorkdir(
                out:    &describeResultPointer,
                repo:   repository.pointer,
                opts:   nil
            )
            
            XCTAssertOK(describeWorkdirResult)
            XCTAssertNotNil(describeResultPointer)
        }
    }
    
    
    
    func testGitDescribeWorkdirWithOptions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Tag.createTag(
                named:      "v1.0.0",
                in:         repository,
                message:    "Hello World!"
            )
            
            try repository.modifyFile(
                at:     "dirty.txt",
                with:   "Uncommitted changes"
            )
            
            
            
            var describeResultPointer: OpaquePointer? = nil
            
            defer
            {
                gitDescribeResultFree(result: describeResultPointer)
            }
            
            
            
            var describeOptions = GitDescribeOptions()
            
            describeOptions.describeStrategy        = .gitDescribeDefault
            describeOptions.onlyFollowFirstParent   = true
            
            
            
            let describeWorkdirResult: GitErrorCode = gitDescribeWorkdir(
                out:    &describeResultPointer,
                repo:   repository.pointer,
                opts:   describeOptions
            )
            
            XCTAssertOK(describeWorkdirResult)
            XCTAssertNotNil(describeResultPointer)
        }
    }
}
