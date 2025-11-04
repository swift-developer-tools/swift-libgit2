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



final class RefDBTests: XCTestCaseStopOnFail
{
    func testGitRefDBCompress() throws
    {
        try Repository.withRefDB
        {
            _, refDBPointer in
            
            let refDBCompressResult: GitErrorCode
                = gitRefDBCompress(out: refDBPointer)
            
            XCTAssertOK(refDBCompressResult)
        }
    }
    
    
    
    func testGitRefDBFree() throws
    {
        gitRefDBFree(refDB: nil)
    }
    
    
    
    func testGitRefDBNew() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var refDBPointer: OpaquePointer? = nil
            
            defer
            {
                gitRefDBFree(refDB: refDBPointer)
            }
            
            
            
            let refDBNewResult: GitErrorCode = gitRefDBNew(
                out:    &refDBPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(refDBNewResult)
            XCTAssertNotNil(refDBPointer)
        }
    }
    
    
    
    func testGitRefDBOpen() throws
    {
        try Repository.withRefDB
        {
            _, _ in
        }
    }
}
