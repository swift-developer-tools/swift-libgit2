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



final class ProxyTests: XCTestCaseStopOnFail
{
    func testGitProxyOptions() throws
    {
        let proxyOptions = GitProxyOptions()
        
        XCTAssertEqual(proxyOptions.version, gitProxyOptionsVersion)
        XCTAssertEqual(proxyOptions.type, .gitProxyNone)
        XCTAssertNil(proxyOptions.url)
        XCTAssertNil(proxyOptions.credentials)
        XCTAssertNil(proxyOptions.certificateCheck)
        XCTAssertNil(proxyOptions.payload)
        
        XCTAssertEqual(gitProxyOptionsVersion, UInt32(GIT_PROXY_OPTIONS_VERSION))
    }
    
    
    
    func testGitProxyT() throws
    {
        XCTAssertEqual(GitProxyT.gitProxyNone.rawValue, GIT_PROXY_NONE.rawValue)
        XCTAssertEqual(GitProxyT.gitProxyAuto.rawValue, GIT_PROXY_AUTO.rawValue)
        XCTAssertEqual(GitProxyT.gitProxySpecified.rawValue, GIT_PROXY_SPECIFIED.rawValue)
        XCTAssertNil(GitProxyT(rawValue: 123))
        
        XCTAssertEqual(GitProxyT.gitProxyNone.cValue, GIT_PROXY_NONE)
        XCTAssertEqual(GitProxyT.gitProxyAuto.cValue, GIT_PROXY_AUTO)
        XCTAssertEqual(GitProxyT.gitProxySpecified.cValue, GIT_PROXY_SPECIFIED)
        
        XCTAssertEqual(GitProxyT(cValue: GIT_PROXY_NONE), .gitProxyNone)
        XCTAssertEqual(GitProxyT(cValue: GIT_PROXY_AUTO), .gitProxyAuto)
        XCTAssertEqual(GitProxyT(cValue: GIT_PROXY_SPECIFIED), .gitProxySpecified)
    }
}
