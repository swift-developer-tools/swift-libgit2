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



final class ODBBackendAdvancedTests: XCTestCaseStopOnFail
{
    func testGitODBBackendDataAlloc() throws
    {
        try testDataAllocationFlow(type: .alloc)
    }
    
    
    
    func testGitODBBackendDataFree() throws
    {
        gitODBBackendDataFree(
            backend:    nil,
            data:       nil
        )
        
        gitODBBackendDataFree(
            backend:    nil,
            data:       UnsafeMutableRawPointer(bitPattern: 0)
        )
        
        gitODBBackendDataFree(
            backend:    nil,
            data:       UnsafeMutableRawPointer(bitPattern: 0x1)
        )
    }
    
    
    
    func testGitODBBackendDataMalloc() throws
    {
        try testDataAllocationFlow(type: .malloc)
    }
    
    
    
    func testGitODBBackendVersion() throws
    {
        XCTAssertEqual(Int32(gitODBBackendVersion), GIT_ODB_BACKEND_VERSION)
    }
    
    
    
    func testGitODBInitBackend() throws
    {
        var odbBackend = git_odb_backend()
        
        let odbInitBackendResult: GitErrorCode = gitODBInitBackend(
            backend:    &odbBackend,
            version:    gitODBBackendVersion
        )
        
        XCTAssertOK(odbInitBackendResult)
    }
}



// MARK: - Extensions

private extension ODBBackendAdvancedTests
{
    enum AllocationType
    {
        case alloc
        case malloc
    }
    
    
    
    /// Tests the object database data allocation flow.
    /// - Parameter type: The type of allocation to perform.
    /// - Throws: An error if an operation fails.
    func testDataAllocationFlow(
        type: AllocationType
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var backendPointer: UnsafeMutablePointer<git_odb_backend>? = nil
            
            defer
            {
                if backendPointer != nil
                {
                    backendPointer?.pointee.free(backendPointer)
                }
            }
            
            
            
            let odbBackendLooseResult: GitErrorCode = gitODBBackendLoose(
                out:                &backendPointer,
                objectsDir:         repository.objectsURL.path(),
                compressionLevel:   -1,
                doFSync:            false,
                dirMode:            0,
                fileMode:           0
            )
            
            XCTAssertOK(odbBackendLooseResult)
            
            guard let backendPointer
            else
            {
                XCTFail("The ODB backend pointer was nil.")
                return
            }
            
            
            
            let allocatedData: UnsafeMutableRawPointer?
            
            switch type
            {
                case .alloc:
                    
                    allocatedData = gitODBBackendDataAlloc(
                        backend:    backendPointer,
                        len:        64
                    )
                case .malloc:
                    
                    allocatedData = gitODBBackendDataMalloc(
                        backend:    backendPointer,
                        len:        64
                    )
            }
            
            XCTAssertNotNil(allocatedData)
            
            
            
            gitODBBackendDataFree(
                backend:    backendPointer,
                data:       allocatedData
            )
        }
    }
}
