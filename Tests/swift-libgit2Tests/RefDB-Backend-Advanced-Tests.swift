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



final class RefDBBackendAdvancedTests: XCTestCaseStopOnFail
{
    func testGitRefDBBackendFS() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var backendPointer: UnsafeMutablePointer<git_refdb_backend>? = nil
            
            defer
            {
                if backendPointer != nil
                {
                    backendPointer?.pointee.free(backendPointer)
                }
            }
            
            
            
            let refDBBackendFSResult: GitErrorCode = gitRefDBBackendFS(
                backendOut:     &backendPointer,
                repo:           repository.pointer
            )
            
            XCTAssertOK(refDBBackendFSResult)
            XCTAssertNotNil(backendPointer)
        }
    }
    
    
    
    func testGitRefDBBackendVersion() throws
    {
        XCTAssertEqual(Int32(gitRefDBBackendVersion), GIT_REFDB_BACKEND_VERSION)
    }
    
    
    
    func testGitRefDBInitBackend() throws
    {
        var refDBBackend = git_refdb_backend()
        
        let refDBInitBackendResult: GitErrorCode = gitRefDBInitBackend(
            opts:       &refDBBackend,
            version:    gitRefDBBackendVersion
        )
        
        XCTAssertOK(refDBInitBackendResult)
    }
    
    
    
    func testGitRefDBSetBackend() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var backendOwnershipTransferred: Bool = false
            
            var refDBPointer    : OpaquePointer?                            = nil
            var backendPointer  : UnsafeMutablePointer<git_refdb_backend>?  = nil
            
            defer
            {
                gitRefDBFree(refDB: refDBPointer)
                
                if
                    !backendOwnershipTransferred,
                    backendPointer != nil
                {
                    backendPointer?.pointee.free(backendPointer)
                }
            }
            
            
            
            let refDBBackendFSResult: GitErrorCode = gitRefDBBackendFS(
                backendOut:     &backendPointer,
                repo:           repository.pointer
            )
            
            XCTAssertOK(refDBBackendFSResult)
            
            guard let backendPointer: UnsafeMutablePointer<git_refdb_backend>
                    = backendPointer
            else
            {
                XCTFail("The reference database backend pointer was nil.")
                return
            }
            
            
            
            let refDBNewResult: GitErrorCode = gitRefDBNew(
                out:    &refDBPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(refDBNewResult)
            
            guard let refDBPointer: OpaquePointer = refDBPointer
            else
            {
                XCTFail("The reference database pointer was nil.")
                return
            }
            
            
            
            let refDBSetBackendResult: GitErrorCode = gitRefDBSetBackend(
                refDB:      refDBPointer,
                backend:    backendPointer
            )
            
            XCTAssertOK(refDBSetBackendResult)
            
            backendOwnershipTransferred = true
        }
    }
}
