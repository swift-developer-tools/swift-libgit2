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
        
        XCTAssertEqual(initResult, 1)
        
        
        
        let shutdownResult: Int32 = gitLibgit2Shutdown()
        
        XCTAssertEqual(shutdownResult, 0)
    }
    
    
    
    // MARK: - testMultipleLibgit2InitShutdown()
    
    func testMultipleLibgit2InitShutdown() throws
    {
        let firstInitResult: Int32 = gitLibgit2Init()

        XCTAssertEqual(firstInitResult, 1)
        
        
        
        let secondInitResult: Int32 = gitLibgit2Init()
        
        XCTAssertEqual(secondInitResult, 2)
        
        
        
        let firstShutdownResult     : Int32     = gitLibgit2Shutdown()
        let secondShutdownResult    : Int32     = gitLibgit2Shutdown()
        
        XCTAssertEqual(firstShutdownResult, 1)
        XCTAssertEqual(secondShutdownResult, 0)
    }
}
