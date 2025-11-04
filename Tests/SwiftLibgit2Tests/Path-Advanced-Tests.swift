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



final class PathTests: XCTestCaseStopOnFail
{
    func testGitPathFS() throws
    {
        XCTAssertEqual(GitPathFS.gitPathFSGeneric.rawValue, GIT_PATH_FS_GENERIC.rawValue)
        XCTAssertEqual(GitPathFS.gitPathFSNTFS.rawValue, GIT_PATH_FS_NTFS.rawValue)
        XCTAssertEqual(GitPathFS.gitPathFSHFS.rawValue, GIT_PATH_FS_HFS.rawValue)
        
        XCTAssertNil(GitPathFS(rawValue: 123))
        
        XCTAssertEqual(GitPathFS.gitPathFSGeneric.cValue(), GIT_PATH_FS_GENERIC)
        XCTAssertEqual(GitPathFS.gitPathFSNTFS.cValue(), GIT_PATH_FS_NTFS)
        XCTAssertEqual(GitPathFS.gitPathFSHFS.cValue(), GIT_PATH_FS_HFS)
        
        XCTAssertEqual(GitPathFS(cValue: GIT_PATH_FS_GENERIC), .gitPathFSGeneric)
        XCTAssertEqual(GitPathFS(cValue: GIT_PATH_FS_NTFS), .gitPathFSNTFS)
        XCTAssertEqual(GitPathFS(cValue: GIT_PATH_FS_HFS), .gitPathFSHFS)
    }
    
    
    
    func testGitPathGitFile() throws
    {
        XCTAssertEqual(GitPathGitFile.gitPathGitFileGitignore.rawValue, GIT_PATH_GITFILE_GITIGNORE.rawValue)
        XCTAssertEqual(GitPathGitFile.gitPathGitFileGitmodules.rawValue, GIT_PATH_GITFILE_GITMODULES.rawValue)
        XCTAssertEqual(GitPathGitFile.gitPathGitFileGitattributes.rawValue, GIT_PATH_GITFILE_GITATTRIBUTES.rawValue)
        
        XCTAssertNil(GitPathGitFile(rawValue: 123))
        
        XCTAssertEqual(GitPathGitFile.gitPathGitFileGitignore.cValue(), GIT_PATH_GITFILE_GITIGNORE)
        XCTAssertEqual(GitPathGitFile.gitPathGitFileGitmodules.cValue(), GIT_PATH_GITFILE_GITMODULES)
        XCTAssertEqual(GitPathGitFile.gitPathGitFileGitattributes.cValue(), GIT_PATH_GITFILE_GITATTRIBUTES)
        
        XCTAssertEqual(GitPathGitFile(cValue: GIT_PATH_GITFILE_GITIGNORE), .gitPathGitFileGitignore)
        XCTAssertEqual(GitPathGitFile(cValue: GIT_PATH_GITFILE_GITMODULES), .gitPathGitFileGitmodules)
        XCTAssertEqual(GitPathGitFile(cValue: GIT_PATH_GITFILE_GITATTRIBUTES), .gitPathGitFileGitattributes)
    }
    
    
    
    func testGitPathIsGitFile() throws
    {
        let pathsTypesAndResults: [(String, GitPathGitFile, Bool)] =
        [
            (".gitignore" ,             .gitPathGitFileGitignore,       true),
            (".gitmodules",             .gitPathGitFileGitmodules,      true),
            (".gitattributes",          .gitPathGitFileGitattributes,   true),
            ("folder/.gitignore",       .gitPathGitFileGitignore,       false),
            ("folder/.gitmodules",      .gitPathGitFileGitmodules,      false),
            ("folder/.gitattributes",   .gitPathGitFileGitattributes,   false),
            ("folder/.gitfile",         .gitPathGitFileGitignore,       false),
            ("folder/.git",             .gitPathGitFileGitignore,       false),
            ("gitignore",               .gitPathGitFileGitignore,       false),
            ("gitmodules" ,             .gitPathGitFileGitignore,       false),
            ("gitattributes",           .gitPathGitFileGitignore,       false),
            (".git",                    .gitPathGitFileGitignore,       false),
            ("git",                     .gitPathGitFileGitattributes,   false)
        ]
        
        for pathTypeAndResult in pathsTypesAndResults
        {
            let path            : String            = pathTypeAndResult.0
            let pathGitFile     : GitPathGitFile    = pathTypeAndResult.1
            let expectedResult  : Bool              = pathTypeAndResult.2
            
            let isGitfile: Bool? = gitPathIsGitFile(
                path:       path,
                pathLen:    path.utf8.count,
                gitFile:    pathGitFile,
                fs:         .gitPathFSGeneric
            )
            
            XCTAssertNotNil(isGitfile)
            XCTAssertEqual(isGitfile, expectedResult)
        }
    }
}
