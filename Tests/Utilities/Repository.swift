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
/// The repository created by ``Repository/withRepository(_:)`` contains various files used
/// to test bindings.
struct Repository
{
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
    
    
    
    /// Creates a commit with the given content and message.
    /// - Parameters:
    ///   - path: The path to the file to modify. This will be appended to the repository's URL.
    ///   - content: The new content of the file.
    ///   - append: Whether the new content should be appended to the existing content.
    ///   - message: The commit message.
    /// - Returns: The ID of the created commit.
    /// - Throws: An `Error` if the file write operation failed, or an `NSError` if the tree
    /// initialization failed.
    @discardableResult
    func createCommit(
        path    : String,
        content : String,
        append  : Bool      = false,
        message : String
    ) throws -> GitOID
    {
        try modifyFile(
            path:       path,
            content:    content,
            append:     append
        )
        
        
        
        var indexPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeIndex(indexPointer)
        }
        
        
        
        let repositoryIndexResult: Int32 = git_repository_index(
            &indexPointer,
            pointer
        )
        
        XCTAssertOK(repositoryIndexResult)
        
        
        
        let indexAddBypathResult: Int32 = git_index_add_bypath(
            indexPointer,
            path
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
            Free.freeTree(treePointer)
        }
        
        
        
        let treeLookupResult: Int32 = git_tree_lookup(
            &treePointer,
            pointer,
            &treeOID
        )
        
        XCTAssertOK(treeLookupResult)
        
        guard let treePointer: OpaquePointer = treePointer
        else
        {
            throw NSError.create(
                code:       Int(GIT_EUSER.rawValue),
                message:    "The tree pointer was nil."
            )
        }
        
        
        
        var signature = GitSignature()
        
        let signatureNowResult: Int32 = gitSignatureNow(
            out:    &signature,
            name:   "Test User",
            email:  "test@example.com"
        )
        
        XCTAssertOK(signatureNowResult)
        
        
        
        var headCommitPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeCommit(headCommitPointer)
        }
        
        
        
        // TODO: Remove once `git_reference_name_to_id()` has a binding.
        var cHeadOID = git_oid()
        
        /// Get the current HEAD commit as the parent commit, if it exists.
        let referenceToNameToIDResult: Int32 = git_reference_name_to_id(
            &cHeadOID,
            pointer,
            "HEAD"
        )
        
        if referenceToNameToIDResult == GIT_OK.rawValue
        {
            let commitLookupResult: Int32 = gitCommitLookup(
                commit:     &headCommitPointer,
                repo:       pointer,
                id:         GitOID(cValue: cHeadOID)
            )
            
            XCTAssertOK(commitLookupResult)
        }
        
        
        
        var parentCommitPointers: [OpaquePointer?] = []
        
        if headCommitPointer != nil
        {
            parentCommitPointers = [headCommitPointer]
        }
        
        
        
        var commitOID = GitOID()
        
        let commitCreateResult: Int32 = gitCommitCreate(
            id:                 &commitOID,
            repo:               pointer,
            updateRef:          "HEAD",
            author:             signature,
            committer:          signature,
            messageEncoding:    nil,
            message:            message,
            tree:               treePointer,
            parentCount:        parentCommitPointers.count,
            parents:            &parentCommitPointers
        )
        
        XCTAssertOK(commitCreateResult)
        
        
        
        return commitOID
    }
    
    
    
    /// Resets to the given commit.
    /// - Parameters:
    ///   - commitOID: The ID of the commit.
    ///   - resetType: The reset type.
    func resetToCommit(
        commitOID   : GitOID,
        resetType   : git_reset_t
    )
    {
        var commitPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeCommit(commitPointer)
        }
        
        
        
        let commitLookupResult: Int32 = gitCommitLookup(
            commit:     &commitPointer,
            repo:       pointer,
            id:         commitOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        
        
        let resetResult: Int32 = git_reset(
            pointer,
            commitPointer,
            resetType,
            nil
        )
        
        XCTAssertOK(resetResult)
    }
    
    
    
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
}



// MARK: - Extensions

/// Static methods related to ``Repository/withRepository(_:)``.
extension Repository
{
    /// Creates blame data in the given repository.
    /// - Parameter repository: The repository.
    /// - Throws: An `Error` if the file write operation failed.
    private static func createBlameData(
        in repository: Repository
    ) throws
    {
        let initialContent: String =
        """
        1: Initial content
        2: More content
        3: Even more content
        """
        
        try repository.createCommit(
            path:       blameFileName,
            content:    initialContent,
            message:    "Add blame file"
        )
        
        
        
        let modifiedContent: String =
        """
        1: Initial content
        2: Modified in second commit
        3: Even more content
        4: Added in second commit
        """
        
        try repository.createCommit(
            path:       blameFileName,
            content:    modifiedContent,
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
        
        try repository.createCommit(
            path:       blameFileName,
            content:    finalContent,
            message:    "Final blame file update"
        )
    }
    
    
    
    /// Creates a temporary directory with the given name.
    /// - Parameter directoryName: The name of the directory.
    /// - Returns: The URL of the temporary directory.
    /// - Throws: An `Error` if the directory creation failed.
    static func createTemporaryDirectory(
        named directoryName: String
    ) throws -> URL
    {
        let temporaryDirectoryURL: URL = FileManager.default.temporaryDirectory
            .appending(path: directoryName, directoryHint: .isDirectory)
            .appendingPathExtension(UUID().uuidString)
        
        try FileManager.default.createDirectory(
            at:                             temporaryDirectoryURL,
            withIntermediateDirectories:    true,
            attributes:                     nil
        )
        
        return temporaryDirectoryURL
    }
    
    
    
    /// Calls the given closure with a `Repository` instance.
    /// - Parameter body: The closure to call.
    /// - Throws: An `Error` if the directory creation failed.
    static func withRepository(
        _ body: (Repository) throws -> Void
    ) throws
    {
        var repositoryPointer   : OpaquePointer?    = nil
        let url                 : URL               = try createTemporaryDirectory(named: "SwiftLibgit2Tests")
        
        defer
        {
            Free.freeRepository(repositoryPointer)
            
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
        
        
        
        try repository.createCommit(
            path:       readmeFileName,
            content:    readmeFileContent,
            message:    "Initial commit"
        )
        
        
        
        
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
        
        for (filename, content) in gitattributesFiles
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
