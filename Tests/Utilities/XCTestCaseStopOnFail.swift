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



/// Stops an `XCTest` case as soon as a failure occurs.
///
/// ## Discussion
///
/// This class initializes and shuts down libgit2, so test cases do not need to handle that.
/// This ensures that all tests cases run in an environment in which libgit2 has been initialized.
/// Any behavior of the library prior to its being initialized is untested and is considered undefined behavior.
class XCTestCaseStopOnFail: XCTestCase
{
    /// Provides an opportunity to customize initial state before a test case begins.
    override func setUp()
    {
        super.setUp()
        continueAfterFailure = false
        
        _ = gitLibgit2Init()
    }
    
    
    
    /// Provides an opportunity to perform cleanup after a test case ends.
    override func tearDown()
    {
        _ = gitLibgit2Shutdown()
    }
}
