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



final class OpenSSLAdvancedTests: XCTestCaseStopOnFail
{
    func testGitOpenSSLSetLocking() throws
    {
        let openSSLSetLockingResult: GitErrorCode = gitOpenSSLSetLocking()
        
        XCTAssertOK(openSSLSetLockingResult)
    }
}
