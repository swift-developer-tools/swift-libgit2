//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import XCTest
@testable import SwiftLibgit2



/// Stops an `XCTestCase` as soon as an assertion fails.
///
/// ## Discussion
///
/// This class initializes and shuts down libgit2, so test cases do not need
/// to handle that. This ensures that all tests cases run in an environment in
/// which libgit2 has been initialized. Any behavior of the library prior to
/// libgit2 being initialized is untested and is considered undefined behavior.
class XCTestCaseStopOnFail: XCTestCase
{
    /// Provides an opportunity to customize initial state before a test case
    /// begins.
    override class func setUp()
    {
        super.setUp()
        
        _ = gitLibgit2Init()
    }
    
    
    
    /// Provides an opportunity to perform cleanup after a test case ends.
    override class func tearDown()
    {
        _ = gitLibgit2Shutdown()
        
        super.tearDown()
    }
    
    
    
    /// Provides an opportunity to reset state before calling each test method
    /// in a test case.
    override func setUp()
    {
        super.setUp()
        
        continueAfterFailure = false
    }
}
