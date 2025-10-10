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
        
        try proxyOptions.withCValue
        {
            cProxyOptions in
            
            XCTAssertEqual(cProxyOptions.pointee.version, gitProxyOptionsVersion)
            XCTAssertEqual(GitProxyT(cValue: cProxyOptions.pointee.type), .gitProxyNone)
            XCTAssertNil(cProxyOptions.pointee.url)
            XCTAssertNil(cProxyOptions.pointee.credentials)
            XCTAssertNil(cProxyOptions.pointee.certificate_check)
            XCTAssertNil(cProxyOptions.pointee.payload)
        }
    }
    
    
    
    func testGitProxyOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitProxyOptionsVersion), GIT_PROXY_OPTIONS_VERSION)
    }
    
    
    
    func testGitProxyT() throws
    {
        XCTAssertEqual(GitProxyT.gitProxyNone.rawValue, GIT_PROXY_NONE.rawValue)
        XCTAssertEqual(GitProxyT.gitProxyAuto.rawValue, GIT_PROXY_AUTO.rawValue)
        XCTAssertEqual(GitProxyT.gitProxySpecified.rawValue, GIT_PROXY_SPECIFIED.rawValue)
        XCTAssertNil(GitProxyT(rawValue: 123))
        
        XCTAssertEqual(GitProxyT.gitProxyNone.cValue(), GIT_PROXY_NONE)
        XCTAssertEqual(GitProxyT.gitProxyAuto.cValue(), GIT_PROXY_AUTO)
        XCTAssertEqual(GitProxyT.gitProxySpecified.cValue(), GIT_PROXY_SPECIFIED)
        
        XCTAssertEqual(GitProxyT(cValue: GIT_PROXY_NONE), .gitProxyNone)
        XCTAssertEqual(GitProxyT(cValue: GIT_PROXY_AUTO), .gitProxyAuto)
        XCTAssertEqual(GitProxyT(cValue: GIT_PROXY_SPECIFIED), .gitProxySpecified)
    }
}
