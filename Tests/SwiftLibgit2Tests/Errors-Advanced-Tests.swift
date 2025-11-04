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



final class ErrorsAdvancedTests: XCTestCaseStopOnFail
{
    func testGitErrorClear() throws
    {
        gitErrorClear()
    }
    
    
    
    func testGitErrorSetOOM() throws
    {
        gitErrorSetOOM()
    }
    
    
    
    func testGitErrorSet() throws
    {
        let message     : String        = "Failed to open some file"
        let path        : String        = "/path/to/file"
        let code        : Int32         = GitErrorCode.gitUnknown(-123).rawValue
        let errorClass  : GitErrorT     = .gitErrorFileSystem
        
        let errorSetResult: GitErrorCode = path.withCString
        {
            cPath in
            
            return gitErrorSet(
                errorClass:     errorClass,
                fmt:            "\(message): %s (%d)",
                args:           [cPath, code]
            )
        }
        
        XCTAssertOK(errorSetResult)
        
        
        
        var error: GitError? = gitErrorLast()
        
        XCTAssertNotNil(error)
        XCTAssertNotNil(error?.message)
        XCTAssertEqual(error?.message, "\(message): \(path) (\(code))")
        XCTAssertEqual(error?.klass, errorClass)

        
        
        gitErrorClear()
        
        error = gitErrorLast()
        
        XCTAssertNotNil(error)
        XCTAssertNotNil(error?.message)
        XCTAssertEqual(error?.message, "no error")
        XCTAssertEqual(error?.klass, .gitErrorNone)
    }
    
    
    
    func testGitErrorSetStr() throws
    {
        let message     : String        = "Failed to do something"
        let errorClass  : GitErrorT     = .gitErrorFileSystem
        
        let errorSetStrResult: GitErrorCode = gitErrorSetStr(
            errorClass:     errorClass,
            string:         message
        )
        
        XCTAssertOK(errorSetStrResult)
        
        
        
        var error: GitError? = gitErrorLast()
        
        XCTAssertNotNil(error)
        XCTAssertNotNil(error?.message)
        XCTAssertEqual(error?.message, message)
        XCTAssertEqual(error?.klass, errorClass)
        
        
        
        gitErrorClear()
        
        error = gitErrorLast()
        
        XCTAssertNotNil(error)
        XCTAssertNotNil(error?.message)
        XCTAssertEqual(error?.message, "no error")
        XCTAssertEqual(error?.klass, .gitErrorNone)
    }
}
