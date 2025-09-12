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
/// ## Discussion
///
/// The repository created by ``withRepository(_:)`` contains various files used to test bindings.
struct Repository
{
    // MARK: - Properties
    
    /// The URL of the repository.
    let url     : URL
    
    /// A pointer to the repository.
    let pointer : OpaquePointer
    
    
    
    static let readmeFileName       : String    = "README.md"
    static let readmeFileContent    : String    = "# Hello World!"
    static let blameFileName        : String    = "blame.txt"
    
    static let gitattributesFiles: [(String, String)] =
    [
        ("test.txt",        "This is a text file\n"),
        ("data.bin",        "Binary data"),
        ("file.special",    "Special file"),
        ("negative.false",  "File with false attribute")
    ]
    
    
    
    // MARK: - modifyFile()
    
    /// Modifies the content of a file.
    /// - Parameters:
    ///   - path: The path to the file to modify. This will be appended to the repository's URL.
    ///   - content: The new content of the file.
    ///   - append: Whether the new content should be appended to the existing content.
    ///   - directoryHint: A hint to URL file APIs for handling paths that may reference directories.
    /// - Returns: The URL to which the content was written.
    /// - Throws: An `Error` if the file read or write operations failed.
    @discardableResult
    func modifyFile(
        path            : String,
        content         : String,
        append          : Bool                  = false,
        directoryHint   : URL.DirectoryHint     = .notDirectory
    ) throws -> URL
    {
        let fileURL: URL = url.appending(
            path:           path,
            directoryHint:  directoryHint
        )
        
        var writeContent: String = content
        
        if append
        {
            let existingContent = try String(contentsOf: fileURL)
            writeContent += existingContent
        }
        
        try writeContent.atomicWrite(to: fileURL)
        
        return fileURL
    }
    
    
    
    // MARK: - verifyFileContent()
    
    /// Verifies the content of a file.
    /// - Parameters:
    ///   - path: The path to the file whose content should be verified. This will be appended to the
    ///   repository's URL.
    ///   - content: The expected content of the file.
    ///   - directoryHint: A hint to URL file APIs for handling paths that may reference directories.
    /// - Throws: An `Error` if the file read operation failed.
    func verifyFileContent(
        path            : String,
        content         : String,
        directoryHint   : URL.DirectoryHint     = .notDirectory
    ) throws
    {
        let fileURL: URL = url.appending(
            path:           path,
            directoryHint:  directoryHint
        )
        
        let actualContent = try String(contentsOf: fileURL)
        
        XCTAssertEqual(actualContent, content)
    }
    
    
    
    // MARK: - commitFile()
    
    /// Commits a file in the given repository.
    /// - Parameters:
    ///   - repository: The repository in which the file exists.
    ///   - fileName: The name of the file.
    ///   - message: The commit message.
    private static func commitFile(
        in repository   : Repository,
        fileName        : String,
        message         : String
    )
    {
        var indexPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeIndex(&indexPointer)
        }
        
        
        
        let repositoryIndexResult: Int32 = git_repository_index(
            &indexPointer,
            repository.pointer
        )
        
        XCTAssertOK(repositoryIndexResult)
        
        
        
        let indexAddBypathResult: Int32 = git_index_add_bypath(
            indexPointer,
            fileName
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
            Free.freeTree(&treePointer)
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
            Free.freeSignature(&signaturePointer)
        }
        
        
        
        let signatureNowResult: Int32 = git_signature_now(
            &signaturePointer,
            "Test User",
            "test@example.com"
        )
        
        XCTAssertOK(signatureNowResult)
        
        
        
        var headOID = git_oid()
        
        var headCommitPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeCommit(&headCommitPointer)
        }
        
        
        
        /// Get the current HEAD commit as the parent commit, if it exists.
        let referenceToNameResult: Int32 = git_reference_name_to_id(
            &headOID,
            repository.pointer,
            "HEAD"
        )
        
        if referenceToNameResult == GIT_OK.rawValue
        {
            let commitLookupResult: Int32 = git_commit_lookup(
                &headCommitPointer,
                repository.pointer,
                &headOID
            )
            
            XCTAssertOK(commitLookupResult)
        }
        
        
        
        var parentCommitPointers: [OpaquePointer?] = []
        
        if headCommitPointer != nil
        {
            parentCommitPointers = [headCommitPointer]
        }
        
        
        
        var commitOID = git_oid()
        
        let commitCreateResult: Int32 = git_commit_create(
            &commitOID,
            repository.pointer,
            "HEAD",
            signaturePointer,
            signaturePointer,
            nil,
            message,
            treePointer,
            parentCommitPointers.count,
            &parentCommitPointers
        )
        
        XCTAssertOK(commitCreateResult)
    }
    
    
    
    // MARK: - createInitialCommit()
    
    /// Creates the initial commit on the given repository.
    /// - Parameter repository: The repository in which to create the commit.
    /// - Throws: An `Error` if the file write operation failed.
    private static func createInitialCommit(
        in repository: Repository
    ) throws
    {
        let fileURL: URL = repository.url.appending(
            path:           readmeFileName,
            directoryHint:  .notDirectory
        )
        
        try readmeFileContent.atomicWrite(to: fileURL)
        
        commitFile(
            in:         repository,
            fileName:   readmeFileName,
            message:    "Initial commit"
        )
    }
    
    
    
    /// Creates blame data in the given repository.
    /// - Parameter repository: The repository.
    /// - Throws: An `Error` if the file write operation failed.
    private static func createBlameData(
        in repository: Repository
    ) throws
    {
        let fileURL: URL = repository.url.appending(
            path:           blameFileName,
            directoryHint:  .notDirectory
        )
        
        
        
        let initialContent: String =
        """
        1: Initial content
        2: More content
        3: Even more content
        """
        
        try initialContent.atomicWrite(to: fileURL)
        
        commitFile(
            in:         repository,
            fileName:   blameFileName,
            message:    "Add blame file"
        )
        
        
        
        let modifiedContent: String =
        """
        1: Initial content
        2: Modified in second commit
        3: Even more content
        4: Added in second commit
        """
        
        try modifiedContent.atomicWrite(to: fileURL)
        
        commitFile(
            in:         repository,
            fileName:   blameFileName,
            message:    "Modify blame file"
        )
        
        
        
        let finalContent: String =
        """
        1: Initial content
        2: Modified in second commit
        3: Modified in third commit
        4: Added in second commit
        5: Added in third commit
        """
        
        try finalContent.atomicWrite(to: fileURL)
        
        commitFile(
            in:         repository,
            fileName:   blameFileName,
            message:    "Final blame file update"
        )
    }
    
    
    
    // MARK: - createTemporaryDirectory()
    
    /// Creates a temporary directory named `SwiftLibgit2Tests`.
    /// - Throws: An `Error` if the directory creation failed.
    /// - Returns: The URL of the temporary directory.
    private static func createTemporaryDirectory() throws -> URL
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
            Free.freeRepository(&repositoryPointer)
            
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
        
        
        
        try createInitialCommit(in: repository)
        
        
        
        
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
        
        
        
        try createBlameData(in: repository)
        
        
        
        return try body(repository)
    }
}
