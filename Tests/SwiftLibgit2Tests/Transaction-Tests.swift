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



final class TransactionTests: XCTestCaseStopOnFail
{
    func testGitTransactionCommit() throws
    {
        try withTransaction
        {
            _, transactionPointer in
            
            let commitResult: GitErrorCode
                = gitTransactionCommit(tx: transactionPointer)
            
            XCTAssertOK(commitResult)
        }
    }
    
    
    
    func testGitTransactionFree() throws
    {
        gitTransactionFree(tx: nil)
    }
    
    
    
    func testGitTransactionLockRef() throws
    {
        try withTransaction
        {
            _, transactionPointer in
            
            let lockRefResult: GitErrorCode = gitTransactionLockRef(
                tx:         transactionPointer,
                refName:    "HEAD"
            )
            
            XCTAssertOK(lockRefResult)
        }
    }
    
    
    
    func testGitTransactionNew() throws
    {
        try withTransaction
        {
            _, _ in
        }
    }
    
    
    
    func testGitTransactionRemove() throws
    {
        try withTransaction
        {
            repository, transactionPointer in
            
            let branchName      : String    = "feature"
            let branchFullName  : String    = "refs/heads/\(branchName)"
            
            try Branch.createLocalBranch(
                named:      branchName,
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            let lockRefResult: GitErrorCode = gitTransactionLockRef(
                tx:         transactionPointer,
                refName:    branchFullName
            )
            
            XCTAssertOK(lockRefResult)
            
            
            
            let removeResult: GitErrorCode = gitTransactionRemove(
                tx:         transactionPointer,
                refName:    branchFullName
            )
            
            XCTAssertOK(removeResult)
            
            
            
            let commitResult: GitErrorCode
                = gitTransactionCommit(tx: transactionPointer)
            
            XCTAssertOK(commitResult)
            
            
            
            var branchPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: branchPointer)
            }
            
            
            
            let refLookupResult: GitErrorCode = gitReferenceLookup(
                out:    &branchPointer,
                repo:   repository.pointer,
                name:   branchFullName
            )
            
            XCTAssertNotOK(refLookupResult)
            XCTAssertNil(branchPointer)
        }
    }
    
    
    
    func testGitTransactionSetReflog() throws
    {
        try withTransaction
        {
            repository, transactionPointer in
            
            var reflogPointer: OpaquePointer? = nil
            
            defer
            {
                gitReflogFree(reflog: reflogPointer)
            }
            
            
            
            let refName: String = "HEAD"
            
            let reflogReadResult: GitErrorCode = gitReflogRead(
                out:    &reflogPointer,
                repo:   repository.pointer,
                name:   refName
            )
            
            XCTAssertOK(reflogReadResult)
            
            guard let reflogPointer
            else
            {
                XCTFail("The reflog pointer was nil.")
                return
            }
            
            
            
            let lockRefResult: GitErrorCode = gitTransactionLockRef(
                tx:         transactionPointer,
                refName:    refName
            )
            
            XCTAssertOK(lockRefResult)
            
            
            
            let setReflogResult: GitErrorCode = gitTransactionSetReflog(
                tx:         transactionPointer,
                refName:    refName,
                reflog:     reflogPointer
            )
            
            XCTAssertOK(setReflogResult)
            
            
            
            let commitResult: GitErrorCode
                = gitTransactionCommit(tx: transactionPointer)
            
            XCTAssertOK(commitResult)
        }
    }
    
        
        
    func testGitTransactionSetSymbolicTarget() throws
    {
        try withTransaction
        {
            repository, transactionPointer in
            
            let branchName      : String    = "feature"
            let branchFullName  : String    = "refs/heads/\(branchName)"
            
            try Branch.createLocalBranch(
                named:      branchName,
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            
            
            let repoSetHEADResult: GitErrorCode = gitRepositorySetHEAD(
                repo:       repository.pointer,
                refName:    branchFullName
            )
            
            XCTAssertOK(repoSetHEADResult)
            
            
            
            let refName: String = "HEAD"
            
            let lockRefResult: GitErrorCode = gitTransactionLockRef(
                tx:         transactionPointer,
                refName:    refName
            )
            
            XCTAssertOK(lockRefResult)
            
            
            
            let setSymbolicTargetResult: GitErrorCode
                = gitTransactionSetSymbolicTarget(
                    tx:         transactionPointer,
                    refName:    refName,
                    target:     branchFullName,
                    sig:        nil,
                    msg:        "Update via transaction"
                )
            
            XCTAssertOK(setSymbolicTargetResult)
            
            
            
            let commitResult: GitErrorCode
                = gitTransactionCommit(tx: transactionPointer)
            
            XCTAssertOK(commitResult)
            
            
            
            var headPointer: OpaquePointer? = nil
            
            defer
            {
                gitReferenceFree(ref: headPointer)
            }
            
            
            
            let refLookupResult: GitErrorCode = gitReferenceLookup(
                out:    &headPointer,
                repo:   repository.pointer,
                name:   "HEAD"
            )
            
            XCTAssertOK(refLookupResult)
            
            guard let headPointer
            else
            {
                XCTFail("The HEAD pointer was nil.")
                return
            }
            
            
            
            let refType: GitReferenceT? = gitReferenceType(ref: headPointer)
            
            XCTAssertNotNil(refType)
            XCTAssertEqual(refType, .gitReferenceSymbolic)
            
            
            let refSymbolicTarget: String?
                = gitReferenceSymbolicTarget(ref: headPointer)
            
            XCTAssertNotNil(refSymbolicTarget)
            XCTAssertEqual(refSymbolicTarget, branchFullName)
        }
    }
    
    
    
    func testGitTransactionSetTarget() throws
    {
        try withTransaction
        {
            repository, transactionPointer in
            
            let refName: String = "HEAD"
            
            let lockRefResult: GitErrorCode
                = gitTransactionLockRef(
                    tx:         transactionPointer,
                    refName:    refName
                )
            
            XCTAssertOK(lockRefResult)
            
            
            
            let commitOID: GitOID = try repository.commit(
                "Test content",
                toFile:     "test.txt",
                message:    "Add test content"
            )
            
            
            
            let setTargetResult: GitErrorCode = gitTransactionSetTarget(
                tx:         transactionPointer,
                refName:    refName,
                target:     commitOID,
                sig:        nil,
                msg:        "Update via transaction"
            )
            
            XCTAssertOK(setTargetResult)
            
            
            
            let commitResult: GitErrorCode
                = gitTransactionCommit(tx: transactionPointer)
            
            XCTAssertOK(commitResult)
            XCTAssertEqual(commitOID, repository.headOID)
        }
    }
}



// MARK: - Extensions

private extension TransactionTests
{
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a transaction.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withTransaction(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var transactionPointer: OpaquePointer? = nil
            
            defer
            {
                gitTransactionFree(tx: transactionPointer)
            }
            
            
            
            let transactionNewResult: GitErrorCode = gitTransactionNew(
                out:    &transactionPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(transactionNewResult)
            
            guard let transactionPointer
            else
            {
                XCTFail("The transaction pointer was nil.")
                return
            }
            
            
            
            try body(
                repository,
                transactionPointer
            )
        }
    }
}
