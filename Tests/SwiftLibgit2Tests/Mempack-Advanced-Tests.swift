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



final class MempackTests: XCTestCaseStopOnFail
{
    func testGitMempackDump() throws
    {
        try withMempack(write: true)
        {
            repository, _, backendPointer in
            
            var objectCount: Int = -1
            
            let mempackObjectCountResult: GitErrorCode
                = gitMempackObjectCount(
                    count:      &objectCount,
                    backend:    backendPointer
                )
            
            XCTAssertOK(mempackObjectCountResult)
            XCTAssertEqual(objectCount, 1)
            
            
            
            var packData = Data()
            
            let mempackDumpResult: GitErrorCode = gitMempackDump(
                pack:       &packData,
                repo:       repository.pointer,
                backend:    backendPointer
            )
            
            XCTAssertOK(mempackDumpResult)
            XCTAssertGreaterThan(packData.count, 0)
        }
    }
    
    
    
    func testGitMempackNew() throws
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
            
            
            
            let mempackNewResult: GitErrorCode
                = gitMempackNew(out: &backendPointer)
            
            XCTAssertOK(mempackNewResult)
            XCTAssertNotNil(backendPointer)
        }
    }
    
    
    
    func testGitMempackObjectCount() throws
    {
        try withMempack(write: false)
        {
            _, _, backendPointer in
            
            var objectCount: Int = -1
            
            let mempackObjectCountResult: GitErrorCode
                = gitMempackObjectCount(
                    count:      &objectCount,
                    backend:    backendPointer
                )
            
            XCTAssertOK(mempackObjectCountResult)
            XCTAssertEqual(objectCount, 0)
        }
    }
    
    
    
    func testGitMempackReset() throws
    {
        try withMempack(write: true)
        {
            _, _, backendPointer in
            
            var objectCount: Int = -1
            
            var mempackObjectCountResult: GitErrorCode
                = gitMempackObjectCount(
                    count:      &objectCount,
                    backend:    backendPointer
                )
            
            XCTAssertOK(mempackObjectCountResult)
            XCTAssertEqual(objectCount, 1)
            
            
            
            let mempackResultResult: GitErrorCode
                = gitMempackReset(backend: backendPointer)
            
            XCTAssertOK(mempackResultResult)
            
            
            
            mempackObjectCountResult = gitMempackObjectCount(
                count:      &objectCount,
                backend:    backendPointer
            )
            
            XCTAssertOK(mempackObjectCountResult)
            XCTAssertEqual(objectCount, 0)
        }
    }
    
    
    
    func testGitMempackWriteThinPack() throws
    {
        try withMempack(write: true)
        {
            repository, _, backendPointer in
            
            var packbuilderPointer: OpaquePointer? = nil
            
            defer
            {
                gitPackbuilderFree(pb: packbuilderPointer)
            }
            
            
            
            let packbuilderNewResult: GitErrorCode = gitPackbuilderNew(
                out:    &packbuilderPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(packbuilderNewResult)
            
            guard let packbuilderPointer: OpaquePointer = packbuilderPointer
            else
            {
                XCTFail("The packbuilder pointer was nil.")
                return
            }
            
            
            
            let mempackWriteThinPackResult: GitErrorCode
                = gitMempackWriteThinPack(
                    backend:    backendPointer,
                    pb:         packbuilderPointer
                )
            
            XCTAssertOK(mempackWriteThinPackResult)
        }
    }
}



// MARK: - Extensions

private extension MempackTests
{
    /// Calls the given closure with a ``Repository`` instance, a pointer to an
    /// object database, and a mutable pointer to an object database backend.
    /// - Parameters:
    ///   - write: Whether to write to the object database.
    ///   - body: The closure to call.
    /// - Throws: An error of an operation fails.
    func withMempack(
        write   : Bool,
        _ body  : (
            Repository, OpaquePointer, UnsafeMutablePointer<git_odb_backend>
        ) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var odbPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBFree(db: odbPointer)
            }
            
            
            
            let repoODBResult: GitErrorCode = gitRepositoryODB(
                out:    &odbPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoODBResult)
            
            guard let odbPointer: OpaquePointer = odbPointer
            else
            {
                XCTFail("The ODB pointer was nil.")
                return
            }
            
            
            
            var backendOwnershipTransferred : Bool = false
            
            var backendPointer: UnsafeMutablePointer<git_odb_backend>? = nil
            
            defer
            {
                if
                    !backendOwnershipTransferred,
                    backendPointer != nil
                {
                    backendPointer?.pointee.free(backendPointer)
                }
            }
            
            
            
            let mempackNewResult: GitErrorCode
                = gitMempackNew(out: &backendPointer)
            
            XCTAssertOK(mempackNewResult)
            
            guard let backendPointer: UnsafeMutablePointer<git_odb_backend>
                    = backendPointer
            else
            {
                XCTFail("The backend pointer was nil.")
                return
            }
            
            
            
            let odbAddBackendResult: GitErrorCode = gitODBAddBackend(
                odb:        odbPointer,
                backend:    backendPointer,
                priority:   999
            )
            
            XCTAssertOK(odbAddBackendResult)
            
            backendOwnershipTransferred = true
            
            
            
            if write
            {
                let blobData    = Data("Blob content".utf8)
                var blobOID     = GitOID()
                
                let odbWriteResult: GitErrorCode = gitODBWrite(
                    out:    &blobOID,
                    odb:    odbPointer,
                    data:   blobData,
                    len:    blobData.count,
                    type:   .gitObjectBlob
                )
                
                XCTAssertOK(odbWriteResult)
                XCTAssertNotZeroOID(blobOID)
            }
            
            
            
            try body(
                repository,
                odbPointer,
                backendPointer
            )
        }
    }
}
