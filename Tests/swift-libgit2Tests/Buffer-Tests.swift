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



final class BufferTests: XCTestCaseStopOnFail
{
    func testGitBufDispose() throws
    {
        var buffer = git_buf()
        
        gitBufDispose(buffer: &buffer)
        gitBufDispose(buffer: &buffer)
        gitBufDispose(buffer: nil)
    }
}
