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



final class RemoteTests: XCTestCaseStopOnFail
{
    func testGitFetchOptions() throws
    {
        let fetchOptions = GitFetchOptions()
        
        XCTAssertEqual(fetchOptions.version, gitFetchOptionsVersion)
        XCTAssertNil(fetchOptions.callbacks)
        XCTAssertEqual(fetchOptions.prune, .gitFetchPruneUnspecified)
        XCTAssertEqual(fetchOptions.updateFetchHEAD, .gitRemoteUpdateFetchHEAD)
        XCTAssertEqual(fetchOptions.downloadTags, .gitRemoteDownloadTagsAuto)
        XCTAssertNil(fetchOptions.proxyOpts)
        XCTAssertEqual(fetchOptions.depth, .gitFetchDepthFull)
        XCTAssertEqual(fetchOptions.followRedirects, .gitRemoteRedirectNone)
        XCTAssertEqual(fetchOptions.customHeaders, [])
        
        XCTAssertEqual(gitFetchOptionsVersion, UInt32(GIT_FETCH_OPTIONS_VERSION))
    }
}

