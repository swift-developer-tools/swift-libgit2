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



final class TraceTests: XCTestCaseStopOnFail
{
    func testGitTraceLevelT() throws
    {
        XCTAssertEqual(GitTraceLevelT.gitTraceNone.rawValue, GIT_TRACE_NONE.rawValue)
        XCTAssertEqual(GitTraceLevelT.gitTraceFatal.rawValue, GIT_TRACE_FATAL.rawValue)
        XCTAssertEqual(GitTraceLevelT.gitTraceError.rawValue, GIT_TRACE_ERROR.rawValue)
        XCTAssertEqual(GitTraceLevelT.gitTraceWarn.rawValue, GIT_TRACE_WARN.rawValue)
        XCTAssertEqual(GitTraceLevelT.gitTraceInfo.rawValue, GIT_TRACE_INFO.rawValue)
        XCTAssertEqual(GitTraceLevelT.gitTraceDebug.rawValue, GIT_TRACE_DEBUG.rawValue)
        XCTAssertEqual(GitTraceLevelT.gitTraceTrace.rawValue, GIT_TRACE_TRACE.rawValue)
        
        XCTAssertNil(GitTraceLevelT(rawValue: 123))
        
        XCTAssertEqual(GitTraceLevelT.gitTraceNone.cValue(), GIT_TRACE_NONE)
        XCTAssertEqual(GitTraceLevelT.gitTraceFatal.cValue(), GIT_TRACE_FATAL)
        XCTAssertEqual(GitTraceLevelT.gitTraceError.cValue(), GIT_TRACE_ERROR)
        XCTAssertEqual(GitTraceLevelT.gitTraceWarn.cValue(), GIT_TRACE_WARN)
        XCTAssertEqual(GitTraceLevelT.gitTraceInfo.cValue(), GIT_TRACE_INFO)
        XCTAssertEqual(GitTraceLevelT.gitTraceDebug.cValue(), GIT_TRACE_DEBUG)
        XCTAssertEqual(GitTraceLevelT.gitTraceTrace.cValue(), GIT_TRACE_TRACE)
        
        XCTAssertEqual(GitTraceLevelT(cValue: GIT_TRACE_NONE), .gitTraceNone)
        XCTAssertEqual(GitTraceLevelT(cValue: GIT_TRACE_FATAL), .gitTraceFatal)
        XCTAssertEqual(GitTraceLevelT(cValue: GIT_TRACE_ERROR), .gitTraceError)
        XCTAssertEqual(GitTraceLevelT(cValue: GIT_TRACE_WARN), .gitTraceWarn)
        XCTAssertEqual(GitTraceLevelT(cValue: GIT_TRACE_INFO), .gitTraceInfo)
        XCTAssertEqual(GitTraceLevelT(cValue: GIT_TRACE_DEBUG), .gitTraceDebug)
        XCTAssertEqual(GitTraceLevelT(cValue: GIT_TRACE_TRACE), .gitTraceTrace)
    }
    
    
    
    func testGitTraceSet() throws
    {
        let traceCB: GitTraceCB =
        {
            level, message in
            
            guard GitTraceLevelT(cValue: level) != nil
            else
            {
                XCTFail("The trace level was nil.")
                return
            }
        }
        
        
        var traceSetResult: GitErrorCode = gitTraceSet(
            level:  .gitTraceTrace,
            cb:     traceCB
        )
        
        XCTAssertOK(traceSetResult)
        
        
        
        traceSetResult = gitTraceSet(
            level:  .gitTraceNone,
            cb:     traceCB
        )
        
        XCTAssertOK(traceSetResult)
    }
}
