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
    }
}
