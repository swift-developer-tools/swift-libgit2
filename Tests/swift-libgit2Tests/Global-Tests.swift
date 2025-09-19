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



final class GlobalTests: XCTestCaseStopOnFail
{
    // MARK: - testLibgit2InitAndShutdown()
    
    func testLibgit2InitAndShutdown() throws
    {
        let initResult: Int32 = gitLibgit2Init()
        
        /// `XCTestCaseStopOnFail` also initialized libgit2 before this test case began.
        XCTAssertEqual(initResult, 2)
        
        
        
        let shutdownResult: Int32 = gitLibgit2Shutdown()
        
        /// `XCTestCaseStopOnFail` will shut down libgit2 after this test case ends.
        XCTAssertEqual(shutdownResult, 1)
    }
    
    
    
    // MARK: - testMultipleLibgit2InitShutdown()
    
    func testMultipleLibgit2InitShutdown() throws
    {
        let firstInitResult: Int32 = gitLibgit2Init()

        /// `XCTestCaseStopOnFail` also initialized libgit2 before this test case began.
        XCTAssertEqual(firstInitResult, 2)
        
        
        
        let secondInitResult: Int32 = gitLibgit2Init()
        
        XCTAssertEqual(secondInitResult, 3)
        
        
        
        let firstShutdownResult     : Int32     = gitLibgit2Shutdown()
        let secondShutdownResult    : Int32     = gitLibgit2Shutdown()
        
        XCTAssertEqual(firstShutdownResult, 2)
        
        /// `XCTestCaseStopOnFail` will shut down libgit2 after this test case ends.
        XCTAssertEqual(secondShutdownResult, 1)
    }
}
