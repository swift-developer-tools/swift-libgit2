//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import XCTest



/// Stop an `XCTest` case as soon as a failure occurs.
class XCTestCaseStopOnFail: XCTestCase
{
    override func setUp()
    {
        super.setUp()
        continueAfterFailure = false
    }
}
