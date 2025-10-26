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



final class VersionTests: XCTestCaseStopOnFail
{
    func testLibgit2Version() throws
    {
        XCTAssertEqual(libgit2Version, LIBGIT2_VERSION)
    }
    
    
    
    func testLibgit2VersionCheck() throws
    {
        let versionsAndCheckResults: [(Int, Int, Int, Bool)] =
        [
            (1, 2, 3,       true),
            (1, 9, 0,       true),
            (1, 9, 1,       true),
            (2, 0, 0,       false),
            (0, 0, 0,       true),
            (1, 9, 2,       false),
            (-1, -1, -1,    true)
        ]
        
        for tuple in versionsAndCheckResults
        {
            let isLessThanCurrentVersion: Bool = libgit2VersionCheck(
                major:      tuple.0,
                minor:      tuple.1,
                revision:   tuple.2
            )
            
            XCTAssertEqual(isLessThanCurrentVersion, tuple.3)
        }
    }
    
    
    
    func testLibgit2VersionMajor() throws
    {
        XCTAssertEqual(Int32(libgit2VersionMajor), LIBGIT2_VERSION_MAJOR)
    }
    
    
    
    func testLibgit2VersionMinor() throws
    {
        XCTAssertEqual(Int32(libgit2VersionMinor), LIBGIT2_VERSION_MINOR)
    }
    
    
    
    func testLibgit2VersionPatch() throws
    {
        XCTAssertEqual(Int32(libgit2VersionPatch), LIBGIT2_VERSION_PATCH)
    }
    
    
    
    func testLibgit2VersionPrerelease() throws
    {
        XCTAssertNil(libgit2VersionPrerelease)
    }
    
    
    
    func testLibgit2VersionNumber() throws
    {
        XCTAssertEqual(libgit2VersionNumber, 1_090_100)
    }
    
    
    
    func testLibgit2SOVersion() throws
    {
        XCTAssertEqual(libgit2SOVersion, LIBGIT2_SOVERSION)
    }
    
    
    
    func testLibgit2VersionRevision() throws
    {
        XCTAssertEqual(Int32(libgit2VersionRevision), LIBGIT2_VERSION_REVISION)
    }
}
