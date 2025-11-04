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



final class RepositoryAdvancedTests: XCTestCaseStopOnFail
{
    func testGitRepositoryCleanup() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoCleanupResult: GitErrorCode
                = gitRepositoryCleanup(repo: repository.pointer)
            
            XCTAssertOK(repoCleanupResult)
        }
    }
    
    
    
    func testGitRepositoryNew() throws
    {
        var repoPointer: OpaquePointer? = nil
        
        defer
        {
            gitRepositoryFree(repo: repoPointer)
        }
        
        
        
        let repoNewResult: GitErrorCode = gitRepositoryNew(out: &repoPointer)
        
        XCTAssertOK(repoNewResult)
        XCTAssertNotNil(repoPointer)
    }
    
    
    
    func testGitRepositoryReinitFileSystem() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoReinitFileSystemResult: GitErrorCode
                = gitRepositoryReinitFileSystem(
                    repo:               repository.pointer,
                    recurseSubmodules:  true
                )
            
            XCTAssertOK(repoReinitFileSystemResult)
        }
    }
    
    
    
    func testGitRepositorySetBare() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var isRepoBare: Bool
                = gitRepositoryIsBare(repo: repository.pointer)
            
            XCTAssertFalse(isRepoBare)
            
            
            
            let repoSetBareResult: GitErrorCode
                = gitRepositorySetBare(repo: repository.pointer)
            
            XCTAssertOK(repoSetBareResult)
            
            
            
            isRepoBare = gitRepositoryIsBare(repo: repository.pointer)
            
            XCTAssertTrue(isRepoBare)
        }
    }
    
    
    
    func testGitRepositorySetConfig() throws
    {
        try Repository.withConfig
        {
            repository, configPointer in
            
            let repoSetConfigResult: GitErrorCode = gitRepositorySetConfig(
                repo:       repository.pointer,
                config:     configPointer
            )
            
            XCTAssertOK(repoSetConfigResult)
        }
    }
    
    
    
    func testGitRepositorySetIndex() throws
    {
        try Repository.withIndex
        {
            repository, indexPointer in
            
            let repoSetIndexResult: GitErrorCode = gitRepositorySetIndex(
                repo:   repository.pointer,
                index:  indexPointer
            )
            
            XCTAssertOK(repoSetIndexResult)
        }
    }
    
    
    
    func testGitRepositorySetODB() throws
    {
        try Repository.withODB
        {
            repository, odbPointer in
            
            let repoSetODBResult: GitErrorCode = gitRepositorySetODB(
                repo:   repository.pointer,
                odb:    odbPointer
            )
            
            XCTAssertOK(repoSetODBResult)
        }
    }
    
    
    
    func testGitRepositorySetRefDB() throws
    {
        try Repository.withRefDB
        {
            repository, refDBPointer in
            
            let repoSetRefDBResult: GitErrorCode = gitRepositorySetRefDB(
                repo:   repository.pointer,
                refDB:  refDBPointer
            )
            
            XCTAssertOK(repoSetRefDBResult)
        }
    }
    
    
    
    func testGitRepositorySubmoduleCacheAll() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoSubmoduleCacheAllResult: GitErrorCode
                = gitRepositorySubmoduleCacheAll(repo: repository.pointer)
            
            XCTAssertOK(repoSubmoduleCacheAllResult)
        }
    }
    
    
    
    func testGitRepositorySubmoduleCacheClear() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let repoSubmoduleCacheClearResult: GitErrorCode
                = gitRepositorySubmoduleCacheClear(repo: repository.pointer)
            
            XCTAssertOK(repoSubmoduleCacheClearResult)
        }
    }
}
