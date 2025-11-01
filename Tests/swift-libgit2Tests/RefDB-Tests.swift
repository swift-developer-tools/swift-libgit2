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



final class RefDBTests: XCTestCaseStopOnFail
{
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
    
    
    
    func testGitRefDBOpenAndCompress() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var refDBPointer: OpaquePointer? = nil
            
            defer
            {
                gitRefDBFree(refDB: refDBPointer)
            }
            
            
            
            let refDBOpenResult: GitErrorCode = gitRefDBOpen(
                out:    &refDBPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(refDBOpenResult)
            
            guard let refDBPointer: OpaquePointer = refDBPointer
            else
            {
                XCTFail("The reference database pointer was nil.")
                return
            }
            
            
            
            let refDBCompressResult: GitErrorCode
                = gitRefDBCompress(out: refDBPointer)
            
            XCTAssertOK(refDBCompressResult)
        }
    }
}
