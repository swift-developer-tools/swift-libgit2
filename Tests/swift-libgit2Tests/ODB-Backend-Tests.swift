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



final class ODBBackendTests: XCTestCaseStopOnFail
{
    func testGitODBBackendLoose() throws
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
            
            
            
            let objectsDirectoryURL: URL = repository.url.appending(
                path:           ".git/objects",
                directoryHint:  .isDirectory
            )
            
            
            
            var odbBackendLooseResult: GitErrorCode = gitODBBackendLoose(
                out:                &backendPointer,
                objectsDir:         objectsDirectoryURL.path(),
                compressionLevel:   -1,
                doFSync:            false,
                dirMode:            0,
                fileMode:           0
            )
            
            XCTAssertOK(odbBackendLooseResult)
            XCTAssertNotNil(backendPointer)
            
            
            
            var backendFsyncPointer: UnsafeMutablePointer<git_odb_backend>?
                = nil
            
            defer
            {
                if backendFsyncPointer != nil
                {
                    backendFsyncPointer?.pointee.free(backendFsyncPointer)
                }
            }
            
            
            
            odbBackendLooseResult = gitODBBackendLoose(
                out:                &backendFsyncPointer,
                objectsDir:         objectsDirectoryURL.path(),
                compressionLevel:   9,
                doFSync:            true,
                dirMode:            0o755,
                fileMode:           0o644
            )
            
            XCTAssertOK(odbBackendLooseResult)
            XCTAssertNotNil(backendFsyncPointer)
        }
    }
    
    
    
    func testGitODBBackendLooseFlagT() throws
    {
        XCTAssertEqual(GitODBBackendLooseFlagT.gitODBBackendLooseFSync.rawValue, GIT_ODB_BACKEND_LOOSE_FSYNC.rawValue)
        
        XCTAssertEqual(GitODBBackendLooseFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitODBBackendLooseFlagT.gitODBBackendLooseFSync.cValue(), GIT_ODB_BACKEND_LOOSE_FSYNC)
        
        XCTAssertEqual(GitODBBackendLooseFlagT(cValue: GIT_ODB_BACKEND_LOOSE_FSYNC).cValue(), GIT_ODB_BACKEND_LOOSE_FSYNC)
        
        
        
        let flags: GitODBBackendLooseFlagT =
        [
            .gitODBBackendLooseFSync
        ]
        
        XCTAssertTrue(flags.contains(.gitODBBackendLooseFSync))
    }
    
    
    
    func testGitODBBackendLooseOptions() throws
    {
        let backendLooseOptions = GitODBBackendLooseOptions()
        
        XCTAssertEqual(backendLooseOptions.version, gitODBOptionsVersion)
        XCTAssertEqual(backendLooseOptions.oidType, .gitOIDSHA1)
        
        let cBackendLooseOptions: git_odb_backend_loose_options
            = backendLooseOptions.cValue()
        
        XCTAssertEqual(cBackendLooseOptions.version, gitODBOptionsVersion)
        XCTAssertEqual(GitOIDT(cValue: cBackendLooseOptions.oid_type), .gitOIDSHA1)
    }
    
    
    
    func testGitODBBackendLooseOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitODBBackendLooseOptionsVersion), GIT_ODB_BACKEND_LOOSE_OPTIONS_VERSION)
    }
    
    
    
    func testGitODBBackendOnePack() throws
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
            
            
            
            let packDirectoryURL: URL = repository.url.appending(
                path:           "pack",
                directoryHint:  .isDirectory
            )
            
            let packfileURLs: [URL]?
                = try? FileManager.default.contentsOfDirectory(
                    at:                             packDirectoryURL,
                    includingPropertiesForKeys:     nil
                )
            
            guard let packfileURLs: [URL] = packfileURLs
            else
            {
                /// Packfiles may not exist in the repository.
                return
            }
            
            
            
            let indexFileURL: URL?
                = packfileURLs.first(where: { $0.pathExtension == ".idx" })
            
            guard let indexFileURL: URL = indexFileURL
            else
            {
                /// Packfiles may not exist in the repository.
                return
            }
            
            
            
            let odbBackendOnePackResult: GitErrorCode = gitODBBackendOnePack(
                out:        &backendPointer,
                indexFile:  indexFileURL.path()
            )
            
            XCTAssertOK(odbBackendOnePackResult)
            XCTAssertNotNil(backendPointer)
        }
    }
    
    
    
    func testGitODBBackendPack() throws
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
            
            
            
            let objectsDirectoryURL: URL = repository.url.appending(
                path:           ".git/objects",
                directoryHint:  .isDirectory
            )
            
            
            
            let odbBackendPackResult: GitErrorCode = gitODBBackendPack(
                out:            &backendPointer,
                objectsDir:     objectsDirectoryURL.path()
            )
            
            XCTAssertOK(odbBackendPackResult)
            XCTAssertNotNil(backendPointer)
        }
    }
    
    
    
    func testGitODBBackendPackOptions() throws
    {
        let backendPackOptions = GitODBBackendPackOptions()
        
        XCTAssertEqual(backendPackOptions.version, gitODBOptionsVersion)
        XCTAssertEqual(backendPackOptions.oidType, .gitOIDSHA1)
        
        let cBackendPackOptions: git_odb_backend_pack_options
            = backendPackOptions.cValue()
        
        XCTAssertEqual(cBackendPackOptions.version, gitODBOptionsVersion)
        XCTAssertEqual(GitOIDT(cValue: cBackendPackOptions.oid_type), .gitOIDSHA1)
    }
    
    
    
    func testGitODBBackendPackOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitODBBackendPackOptionsVersion), GIT_ODB_BACKEND_PACK_OPTIONS_VERSION)
    }
    
    
    
    func testGitODBStreamT() throws
    {
        XCTAssertEqual(GitODBStreamT.gitStreamRDOnly.rawValue, GIT_STREAM_RDONLY.rawValue)
        XCTAssertEqual(GitODBStreamT.gitStreamWROnly.rawValue, GIT_STREAM_WRONLY.rawValue)
        XCTAssertEqual(GitODBStreamT.gitStreamRW.rawValue, GIT_STREAM_RW.rawValue)
        
        XCTAssertNil(GitAttrValueT(rawValue: 123))
        
        XCTAssertEqual(GitODBStreamT.gitStreamRDOnly.cValue(), GIT_STREAM_RDONLY)
        XCTAssertEqual(GitODBStreamT.gitStreamWROnly.cValue(), GIT_STREAM_WRONLY)
        XCTAssertEqual(GitODBStreamT.gitStreamRW.cValue(), GIT_STREAM_RW)
        
        XCTAssertEqual(GitODBStreamT(cValue: GIT_STREAM_RDONLY), .gitStreamRDOnly)
        XCTAssertEqual(GitODBStreamT(cValue: GIT_STREAM_WRONLY), .gitStreamWROnly)
        XCTAssertEqual(GitODBStreamT(cValue: GIT_STREAM_RW), .gitStreamRW)
    }
}
