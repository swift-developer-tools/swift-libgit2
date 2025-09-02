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



final class GlobalFunctionsTests: XCTestCase
{
    /// Test initializing and shutting down the global libgit2 state.
    func testLibgit2InitAndShutdown() throws
    {
        let initResult: Int32 = gitLibgit2Init()
        
        XCTAssertGreaterThan(
            initResult,
            0,
            "The init should return a non-zero positive reference count."
        )
        
        
        
        let shutdownResult: Int32 = gitLibgit2Shutdown()
        
        XCTAssertGreaterThanOrEqual(
            shutdownResult,
            0,
            "The shutdown should succeed."
        )
    }
    
    
    
    /// Test initializing and shutting down multiple global libgit2 states.
    func testMultipleLibgit2InitShutdown() throws
    {
        let firstInitResult     : Int32     = gitLibgit2Init()
        let secondInitResult    : Int32     = gitLibgit2Init()
        
        XCTAssertEqual(
            secondInitResult,
            firstInitResult + 1,
            "The second init should increment the reference count."
        )
        
        
        
        let firstShutdownResult     : Int32     = gitLibgit2Shutdown()
        let secondShutdownResult    : Int32     = gitLibgit2Shutdown()
        
        XCTAssertGreaterThanOrEqual(
            firstShutdownResult,
            0,
            "The first shutdown should succeed."
        )
        
        XCTAssertGreaterThanOrEqual(
            secondShutdownResult,
            0,
            "The second shutdown should succeed."
        )
    }
}
