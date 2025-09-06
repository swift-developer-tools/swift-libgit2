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
///
/// The repository is created with a single `README.md` file which says`# Hello World!`.
/// When running tests designed to check file content, prefer use of the `README.md` file.
///
/// Apart from the `README.md` file, various files are created to interact with other repository features,
/// such as the files created in ``withRepository(_:)`` to interact with `.gitattributes`.
struct Repository
{
    // MARK: - Properties
    
    /// The URL of the repository.
    let url     : URL
    
    /// A pointer to the repository.
    let pointer : OpaquePointer
    
    
    
    static let originalFileName     : String    = "README.md"
    static let originalFileContent  : String    = "# Hello World!"
    
    static let gitattributesFiles: [(String, String)] =
    [
        ("test.txt",        "This is a text file\n"),
        ("data.bin",        "Binary data"),
        ("file.special",    "Special file"),
        ("negative.false",  "File with false attribute")
    ]
    
    
    
    // MARK: - createInitialCommit()
    
    /// Create the initial commit on the test repository.
    /// - Parameter repository: The test repository.
    /// - Throws: An `Error` if the file write operation failed.
    private static func createInitialCommit(
        on repository: Repository
    ) throws
    {
        let fileURL: URL = repository.url.appending(
            path:           originalFileName,
            directoryHint:  .notDirectory
        )
        
        try originalFileContent.atomicWrite(to: fileURL)
        
        
        
        var indexPointer: OpaquePointer? = nil
        
        let repositoryIndexResult: Int32 = git_repository_index(
            &indexPointer,
            repository.pointer
        )
        
        XCTAssertOK(repositoryIndexResult)
        
        
        
        let indexAddBypathResult: Int32 = git_index_add_bypath(
            indexPointer,
            originalFileName
        )
        
        XCTAssertOK(indexAddBypathResult)
        
        
        
        let indexWriteResult: Int32 = git_index_write(indexPointer)
        
        XCTAssertOK(indexWriteResult)
        
        
        
        var treeOID = git_oid()
        
        let indexWriteTreeResult: Int32 = git_index_write_tree(
            &treeOID,
            indexPointer
        )
        
        XCTAssertOK(indexWriteTreeResult)
        
        
        
        var treePointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeTreePointer(&treePointer)
        }
        
        let treeLookupResult: Int32 = git_tree_lookup(
            &treePointer,
            repository.pointer,
            &treeOID
        )
        
        XCTAssertOK(treeLookupResult)
        
        
        
        var signaturePointer: UnsafeMutablePointer<git_signature>? = nil
        
        defer
        {
            Free.freeSignaturePointer(&signaturePointer)
        }
        
        let signatureNowResult: Int32 = git_signature_now(
            &signaturePointer,
            "Test User",
            "test@example.com"
        )
        
        XCTAssertOK(signatureNowResult)
        
        
        
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
        
        XCTAssertOK(commitCreateResult)
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
        _ body: (Repository) throws -> Void
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
            Free.freeRepositoryPointer(&repositoryPointer)
            
            try? FileManager.default.removeItem(at: url)
        }
        
        
        
        let repositoryInitResult: Int32 = git_repository_init(
            &repositoryPointer,
            url.path,
            0
        )
        
        XCTAssertOK(repositoryInitResult)
        
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
        
        
        
        
        let gitattributesContent: String =
        """
        *.txt text eol=lf
        *.bin binary
        *.special custom=customvalue
        *.false -text
        *.macro attr1 attr2=value
        """
        
        let gitattributesURL: URL = repository.url.appending(
            path:           ".gitattributes",
            directoryHint:  .notDirectory
        )
        
        try gitattributesContent.atomicWrite(to: gitattributesURL)
        
        for (filename, content) in Repository.gitattributesFiles
        {
            let fileURL: URL = repository.url.appending(
                path:           filename,
                directoryHint:  .notDirectory
            )
            
            try content.atomicWrite(to: fileURL)
        }
        
        
        
        return try body(repository)
    }
}
