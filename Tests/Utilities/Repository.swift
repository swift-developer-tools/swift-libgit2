//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import Foundation
import XCTest
@testable import SwiftLibgit2



/// Repository-related testing utilities.
struct Repository
{
    // MARK: - Properties
    
    /// The URL of the repository.
    let url     : URL
    
    /// A pointer to the repository.
    let pointer : OpaquePointer
    
    
    
    // MARK: - createInitialCommit()
    
    /// Create the initial commit on the test repository.
    /// - Parameter repository: The test repository.
    /// - Throws: An `Error` if the document write failed.
    private static func createInitialCommit(
        on repository: Repository
    ) throws
    {
        let testDocumentName: String = "README.md"
        
        let testDocumentURL: URL = repository.url.appending(
            path:           testDocumentName,
            directoryHint:  .notDirectory
        )
        
        let testDocumentContent: String = "# Hello World!"
        
        try testDocumentContent.write(
            to:             testDocumentURL,
            atomically:     true,
            encoding:       .utf8
        )
        
        
        
        var indexPointer: OpaquePointer? = nil
        
        let repositoryIndexResult: Int32 = git_repository_index(
            &indexPointer,
            repository.pointer
        )
        
        XCTAssertOK(
            repositoryIndexResult,
            "repositoryIndexResult"
        )
        
        
        
        let indexAddBypathResult: Int32 = git_index_add_bypath(
            indexPointer,
            testDocumentName
        )
        
        XCTAssertOK(
            indexAddBypathResult,
            "indexAddBypathResult"
        )
        
        
        
        let indexWriteResult: Int32 = git_index_write(indexPointer)
        
        XCTAssertOK(
            indexWriteResult,
            "indexWriteResult"
        )
        
        
        
        var treeOID = git_oid()
        
        let indexWriteTreeResult: Int32 = git_index_write_tree(
            &treeOID,
            indexPointer
        )
        
        XCTAssertOK(
            indexWriteTreeResult,
            "indexWriteTreeResult"
        )
        
        
        
        var treePointer: OpaquePointer? = nil
        
        defer
        {
            if treePointer != nil
            {
                git_tree_free(treePointer)
                treePointer = nil
            }
        }
        
        let treeLookupResult: Int32 = git_tree_lookup(
            &treePointer,
            repository.pointer,
            &treeOID
        )
        
        XCTAssertOK(
            treeLookupResult,
            "treeLookupResult"
        )
        
        
        
        var signaturePointer: UnsafeMutablePointer<git_signature>? = nil
        
        defer
        {
            if signaturePointer != nil
            {
                git_signature_free(signaturePointer)
                signaturePointer = nil
            }
        }
        
        let signatureNowResult: Int32 = git_signature_now(
            &signaturePointer,
            "Test User",
            "test@example.com"
        )
        
        XCTAssertOK(
            signatureNowResult,
            "signatureNowResult"
        )
        
        
        
        var commitOID = git_oid()
        
        let commitCreateResult: Int32 = git_commit_create(
            &commitOID,
            repository.pointer,
            "HEAD",
            signaturePointer,
            signaturePointer,
            nil,
            "Initial commit",
            treePointer,
            0,
            nil
        )
        
        XCTAssertOK(
            commitCreateResult,
            "commitCreateResult"
        )
    }
    
    
    
    // MARK: - createTemporaryDirectory()
    
    /// Create a temporary directory named `SwiftLibgit2Tests`.
    /// - Throws: An `Error` if the directory creation failed.
    /// - Returns: The URL of the temporary directory.
    static func createTemporaryDirectory() throws -> URL
    {
        let temporaryDirectoryURL: URL = FileManager.default.temporaryDirectory
            .appending(path: "SwiftLibgit2Tests", directoryHint: .isDirectory)
            .appendingPathExtension(UUID().uuidString)
        
        try FileManager.default.createDirectory(
            at:                             temporaryDirectoryURL,
            withIntermediateDirectories:    true,
            attributes:                     nil
        )
        
        return temporaryDirectoryURL
    }
    
    
    
    // MARK: - withRepository()
    
    /// Calls the given closure with a `Repository` instance.
    /// - Parameter body: The closure to call.
    /// - Throws: An `Error` if the directory creation failed.
    static func withRepository(
        _ body: (Repository) -> Void
    ) throws
    {
        let _: Int32 = gitLibgit2Init()
        
        defer
        {
            let _: Int32 = gitLibgit2Shutdown()
        }
        
        
        
        let url: URL = try createTemporaryDirectory()
        
        
        
        var repositoryPointer: OpaquePointer? = nil
        
        defer
        {
            if repositoryPointer != nil
            {
                git_repository_free(repositoryPointer)
                repositoryPointer = nil
            }
            
            try? FileManager.default.removeItem(at: url)
        }
        
        
        
        let repositoryInitResult: Int32 = git_repository_init(
            &repositoryPointer,
            url.path,
            0
        )
        
        XCTAssertOK(
            repositoryInitResult,
            "repositoryInitResult"
        )
        
        guard let repositoryPointer: OpaquePointer = repositoryPointer
        else
        {
            XCTFail("Failed to initialize repository.")
            return
        }
        
        let repository = Repository(
            url:        url,
            pointer:    repositoryPointer
        )
        
        
        
        try createInitialCommit(on: repository)
        
        
        
        return body(repository)
    }
}
