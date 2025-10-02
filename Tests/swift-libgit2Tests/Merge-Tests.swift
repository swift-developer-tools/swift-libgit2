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



final class MergeTests: XCTestCaseStopOnFail
{
    func testGitMergeOptions() throws
    {
        let mergeOptions = GitMergeOptions()
        
        XCTAssertEqual(mergeOptions.version, gitMergeOptionsVersion)
        XCTAssertEqual(mergeOptions.flags, .gitMergeFindRenames)
        XCTAssertEqual(mergeOptions.renameThreshold, 50)
        XCTAssertEqual(mergeOptions.targetLimit, 200)
        XCTAssertNil(mergeOptions.metric)
        XCTAssertEqual(mergeOptions.recursionLimit, 0)
        XCTAssertNil(mergeOptions.defaultDriver)
        XCTAssertEqual(mergeOptions.fileFavor, .gitMergeFileFavorNormal)
        XCTAssertEqual(mergeOptions.fileFlags, .gitMergeFileDefault)
        
        XCTAssertEqual(gitMergeOptionsVersion, UInt32(GIT_MERGE_OPTIONS_VERSION))
        
        try mergeOptions.withCValue
        {
            cMergeOptions in
            
            XCTAssertEqual(cMergeOptions.pointee.version, gitMergeOptionsVersion)
            XCTAssertEqual(GitMergeFlagT(rawValue: cMergeOptions.pointee.flags), .gitMergeFindRenames)
            XCTAssertEqual(cMergeOptions.pointee.rename_threshold, 50)
            XCTAssertEqual(cMergeOptions.pointee.target_limit, 200)
            XCTAssertNil(cMergeOptions.pointee.metric)
            XCTAssertEqual(cMergeOptions.pointee.recursion_limit, 0)
            XCTAssertNil(cMergeOptions.pointee.default_driver)
            XCTAssertEqual(GitMergeFileFavorT(cValue: cMergeOptions.pointee.file_favor), .gitMergeFileFavorNormal)
            XCTAssertEqual(GitMergeFileFlagT(rawValue: cMergeOptions.pointee.file_flags), .gitMergeFileDefault)
        }
    }
}
