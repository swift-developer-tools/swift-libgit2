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



final class ConfigAdvancedTests: XCTestCaseStopOnFail
{
    func testGitConfigAddBackend() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var configPointer: OpaquePointer? = nil
            
            defer
            {
                gitConfigFree(cfg: configPointer)
            }
            
            
            
            let configNewResult: GitErrorCode
                = gitConfigNew(out: &configPointer)
            
            XCTAssertOK(configNewResult)
            
            guard let configPointer: OpaquePointer = configPointer
            else
            {
                XCTFail("The configuration pointer was nil.")
                return
            }
            
            
            
            var configBackend: UnsafeMutablePointer<git_config_backend>? = nil
            
            let configContent: String =
            """
            [test]
                key1 = value1
                key2 = value2
            """
            
            let configBackendFromStringResult: GitErrorCode
                = gitConfigBackendFromString(
                    out:    &configBackend,
                    cfg:    configContent,
                    len:    configContent.count,
                    opts:   nil
                )
            
            XCTAssertOK(configBackendFromStringResult)
            
            guard let configBackend: UnsafeMutablePointer<git_config_backend>
                    = configBackend
            else
            {
                XCTFail("The configuration backend pointer was nil.")
                return
            }
            
            
            
            let configAddBackendResult: GitErrorCode = gitConfigAddBackend(
                cfg:    configPointer,
                file:   configBackend,
                level:  .gitConfigLevelLocal,
                repo:   repository.pointer,
                force:  false
            )
            
            XCTAssertOK(configAddBackendResult)
        }
    }
    
    
    
    func testGitConfigAddBackendWithForce() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var configPointer: OpaquePointer? = nil
            
            defer
            {
                gitConfigFree(cfg: configPointer)
            }
            
            
            
            let configNewResult: GitErrorCode
                = gitConfigNew(out: &configPointer)
            
            XCTAssertOK(configNewResult)
            
            guard let configPointer: OpaquePointer = configPointer
            else
            {
                XCTFail("The configuration pointer was nil.")
                return
            }
            
            
            
            var firstConfigBackend: UnsafeMutablePointer<git_config_backend>?
                = nil
            
            var secondConfigBackend: UnsafeMutablePointer<git_config_backend>?
                = nil
            
            let firstConfigContent: String =
            """
            [test]
                key = value1
            """
            
            let secondConfigContent: String =
            """
            [test]
                key = value2
            """
            
            
            
            var configBackendFromStringResult: GitErrorCode
                = gitConfigBackendFromString(
                    out:    &firstConfigBackend,
                    cfg:    firstConfigContent,
                    len:    firstConfigContent.count,
                    opts:   nil
                )
            
            XCTAssertOK(configBackendFromStringResult)
            
            guard let firstConfigBackend: UnsafeMutablePointer<git_config_backend>
                    = firstConfigBackend
            else
            {
                XCTFail("The first configuration backend pointer was nil.")
                return
            }
            
            
            
            var configAddBackendResult: GitErrorCode = gitConfigAddBackend(
                cfg:    configPointer,
                file:   firstConfigBackend,
                level:  .gitConfigLevelLocal,
                repo:   repository.pointer,
                force:  false
            )
            
            XCTAssertOK(configAddBackendResult)
            
            
            
            
            configBackendFromStringResult = gitConfigBackendFromString(
                out:    &secondConfigBackend,
                cfg:    secondConfigContent,
                len:    secondConfigContent.count,
                opts:   nil
            )
            
            XCTAssertOK(configBackendFromStringResult)
            
            guard let secondConfigBackend: UnsafeMutablePointer<git_config_backend>
                    = secondConfigBackend
            else
            {
                XCTFail("The second configuration backend pointer was nil.")
                return
            }
            
            
            
            configAddBackendResult = gitConfigAddBackend(
                cfg:    configPointer,
                file:   secondConfigBackend,
                level:  .gitConfigLevelLocal,
                repo:   repository.pointer,
                force:  true
            )
            
            XCTAssertOK(configAddBackendResult)
        }
    }
    
    
    
    func testGitConfigBackendFromString() throws
    {
        let configContent: String =
        """
        [core]
            repositoryformatversion = 0
            filemode = true
        [user]
            name = \(Repository.commitAuthorName)
            email = \(Repository.commitAuthorEmail)
        """
        
        openConfigBackend(
            type:       .string(configContent),
            options:    nil
        )
    }
    
    
    
    func testGitConfigBackendFromStringWithOptions() throws
    {
        let configContent: String =
        """
        [section]
            key1 = value1
            key2 = value2
        """
        
        openConfigBackend(
            type:       .string(configContent),
            options:    GitConfigBackendMemoryOptions()
        )
    }
    
    
    
    func testGitConfigBackendFromValues() throws
    {
        let values: [String] =
        [
            "core.filemode = true",
            "user.name = \(Repository.commitAuthorName)",
            "user.email = \(Repository.commitAuthorEmail)"
        ]
        
        openConfigBackend(
            type:       .values(values),
            options:    nil
        )
    }
    
    
    
    func testGitConfigBackendFromValuesWithOptions() throws
    {
        let values: [String] =
        [
            "remote.origin.url = https://example.com/repo.git",
            "remote.origin.fetch = +refs/heads/*:refs/remotes/origin/*"
        ]
        
        openConfigBackend(
            type:       .values(values),
            options:    GitConfigBackendMemoryOptions()
        )
    }
    
    
    
    func testGitConfigBackendMemoryOptions() throws
    {
        let configBackendMemoryOptions = GitConfigBackendMemoryOptions()
        
        XCTAssertEqual(configBackendMemoryOptions.version, gitConfigBackendMemoryOptionsVersion)
        XCTAssertEqual(configBackendMemoryOptions.backendType, "in-memory")
        XCTAssertNil(configBackendMemoryOptions.originPath)
        
        configBackendMemoryOptions.withCValue
        {
            cConfigBackendMemoryOptions in
            
            XCTAssertEqual(cConfigBackendMemoryOptions.pointee.version, gitConfigBackendMemoryOptionsVersion)
            XCTAssertEqual(String(optionalCString: cConfigBackendMemoryOptions.pointee.backend_type), "in-memory")
            XCTAssertNil(cConfigBackendMemoryOptions.pointee.origin_path)
        }
    }
    
    
    
    func testGitConfigBackendMemoryOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitConfigBackendMemoryOptionsVersion), GIT_CONFIG_BACKEND_MEMORY_OPTIONS_VERSION)
    }
    
    
    
    func testGitConfigBackendVersion() throws
    {
        XCTAssertEqual(Int32(gitConfigBackendVersion), GIT_CONFIG_BACKEND_VERSION)
    }
    
    
    
    func testGitConfigInitBackend() throws
    {
        var configBackend = git_config_backend()
        
        let configInitBackendResult: GitErrorCode = gitConfigInitBackend(
            backend:    &configBackend,
            version:    gitConfigBackendVersion
        )
        
        XCTAssertOK(configInitBackendResult)
    }
}



// MARK: - Extensions

private extension ConfigAdvancedTests
{
    enum OpenBackendType
    {
        case string(String)
        case values([String])
    }
    
    
    
    /// Tests opening a configuration backend from the given configuration.
    /// - Parameters:
    ///   - type: The type of configuration to parse.
    ///   - options: The in-memory configuration backend options to use.
    func openConfigBackend(
        type    : OpenBackendType,
        options : GitConfigBackendMemoryOptions?
    )
    {
        var configBackend: UnsafeMutablePointer<git_config_backend>? = nil
        
        defer
        {
            if configBackend != nil
            {
                configBackend?.pointee.free(configBackend)
            }
        }
        
        
        
        switch type
        {
            case .string(let string):
                
                let configBackendFromStringResult: GitErrorCode
                    = gitConfigBackendFromString(
                        out:    &configBackend,
                        cfg:    string,
                        len:    string.count,
                        opts:   options
                    )
                
                XCTAssertOK(configBackendFromStringResult)
                
            case .values(let values):
                
                let configBackendFromValuesResult: GitErrorCode
                    = gitConfigBackendFromValues(
                        out:        &configBackend,
                        values:     values,
                        len:        values.count,
                        opts:       options
                    )
                
                XCTAssertOK(configBackendFromValuesResult)
        }

        guard let configBackend: UnsafeMutablePointer<git_config_backend>
                = configBackend
        else
        {
            XCTFail("The configuration backend pointer was nil.")
            return
        }
        
        guard let open: GitConfigBackend.Open = configBackend.pointee.open
        else
        {
            XCTFail("The configuration backend open function was nil.")
            return
        }
        
        
        
        let openBackendResult: Int32 = open(
            configBackend,
            GitConfigLevelT.gitConfigLevelLocal.cValue(),
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: openBackendResult))
    }
}
