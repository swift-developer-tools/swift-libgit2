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



final class IgnoreTests: XCTestCaseStopOnFail
{
    func testGitIgnoreAddRuleAndPathIsIgnored() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let ignoreAddRuleResult: GitErrorCode = gitIgnoreAddRule(
                repo:   repository.pointer,
                rules:  "*.log\ntemp_*\n"
            )
            
            XCTAssertOK(ignoreAddRuleResult)
            
            
            
            var isIgnored: Bool = false
            
            let isLogIgnoredResult: GitErrorCode = gitIgnorePathIsIgnored(
                ignored:    &isIgnored,
                repo:       repository.pointer,
                path:       "debug.log"
            )
            
            XCTAssertOK(isLogIgnoredResult)
            XCTAssertTrue(isIgnored)
            
            
            
            isIgnored = false
            
            let isTempIgnoredResult: GitErrorCode = gitIgnorePathIsIgnored(
                ignored:    &isIgnored,
                repo:       repository.pointer,
                path:       "temp_file.txt"
            )
            
            XCTAssertOK(isTempIgnoredResult)
            XCTAssertTrue(isIgnored)
            
            
            
            isIgnored = true
            
            let isRegularIgnoredResult: GitErrorCode = gitIgnorePathIsIgnored(
                ignored:    &isIgnored,
                repo:       repository.pointer,
                path:       "regular.txt"
            )
            
            XCTAssertOK(isRegularIgnoredResult)
            XCTAssertFalse(isIgnored)
        }
    }
    
    
    
    func testGitIgnoreClearInternalRules() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let ignoreAddRuleResult: GitErrorCode = gitIgnoreAddRule(
                repo:   repository.pointer,
                rules:  "*.tmp\n"
            )
            
            XCTAssertOK(ignoreAddRuleResult)
            
            
            
            var isIgnored: Bool = false
            
            let isIgnoredBeforeClearResult: GitErrorCode = gitIgnorePathIsIgnored(
                ignored:    &isIgnored,
                repo:       repository.pointer,
                path:       "file.tmp"
            )
            
            XCTAssertOK(isIgnoredBeforeClearResult)
            XCTAssertTrue(isIgnored)
            
            
            
            let ignoreClearInternalRulesResult: GitErrorCode
                = gitIgnoreClearInternalRules(repo: repository.pointer)
            
            XCTAssertOK(ignoreClearInternalRulesResult)
            
            
            
            isIgnored = true
            
            let isIgnoredAfterClearResult: GitErrorCode = gitIgnorePathIsIgnored(
                ignored:    &isIgnored,
                repo:       repository.pointer,
                path:       "file.tmp"
            )
            
            XCTAssertOK(isIgnoredAfterClearResult)
            XCTAssertFalse(isIgnored)
        }
    }
    
    
    
    func testGitIgnorePathIsIgnoredWithGitignoreFile() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let gitignoreContent: String =
            """
            *.txt
            folder/
            """
            
            let gitignoreURL: URL = repository.url.appending(
                path:           ".gitignore",
                directoryHint:  .notDirectory
            )
            
            try gitignoreContent.atomicWrite(to: gitignoreURL)
            
            
            
            var isIgnored: Bool = false
            
            let isFolderIgnoredResult: GitErrorCode = gitIgnorePathIsIgnored(
                ignored:    &isIgnored,
                repo:       repository.pointer,
                path:       "folder/file.txt"
            )
            
            XCTAssertOK(isFolderIgnoredResult)
            XCTAssertTrue(isIgnored)
            
            
            
            isIgnored = true
            
            let isOtherIgnoredResult: GitErrorCode = gitIgnorePathIsIgnored(
                ignored:    &isIgnored,
                repo:       repository.pointer,
                path:       "file.swift"
            )
            
            XCTAssertOK(isOtherIgnoredResult)
            XCTAssertFalse(isIgnored)
        }
    }
}
