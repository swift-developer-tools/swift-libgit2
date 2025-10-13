//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation
import XCTest
@testable import SwiftLibgit2



/// Repository-related testing utilities.
struct Repository
{
    /// The URL of the repository.
    let url         : URL
    
    /// A pointer to the repository.
    let pointer     : OpaquePointer
    
    /// The default signature using ``commitAuthorName`` and
    /// ``commitAuthorEmail``.
    let signature   : GitSignature
    
    
    
    static let commitAuthorName     : String    = "Test User"
    static let commitAuthorEmail    : String    = "test@example.com"
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
    
    
    
    /// Creates a new ``Repository`` instance from the given URL and pointer.
    /// - Parameters:
    ///   - url: The URL of the repository.
    ///   - pointer: A pointer to the repository.
    init(
        url     : URL,
        pointer : OpaquePointer
    )
    {
        self.url        = url
        self.pointer    = pointer
        
        var signature = GitSignature()
        
        let signatureNowResult: GitErrorCode = gitSignatureNow(
            out:    &signature,
            name:   Repository.commitAuthorName,
            email:  Repository.commitAuthorEmail
        )
        
        XCTAssertOK(signatureNowResult)
        
        self.signature = signature
    }
    
    
    
    /// The URL to the configuration file.
    var configURL: URL
    {
        return url.appending(
            path:           ".git/config",
            directoryHint:  .notDirectory
        )
    }
    
    
    
    /// The absolute path to the configuration file.
    var configPath: String
    {
        return configURL.path(percentEncoded: false)
    }
    
    
    
    /// Commits changes to the specified file with the given content and
    /// message.
    /// - Parameters:
    ///   - content: The new content of the file.
    ///   - path: The path to the file to modify, relative to the repository's
    ///   root.
    ///   - message: The commit message.
    ///   - appending: Whether the new content should be appended to the
    ///   existing content.
    /// - Returns: The ID of the created commit.
    /// - Throws: An error if an operation fails.
    @discardableResult
    func commit(
        _           content : String,
        toFile      path    : String,
        message             : String,
        appending           : Bool      = false
    ) throws -> GitOID
    {
        try modifyFile(
            at:         path,
            with:       content,
            appending:  appending
        )
        
        return try _commit(
            message:    message,
            options:    nil,
            fromStage:  false,
            path:       path
        )
    }
    
    
    
    /// Commits the staged changes with the given message.
    /// - Parameters:
    ///   - message: The commit message.
    ///   - options: The options for commit creation.
    /// - Returns: The ID of the created commit.
    /// - Throws: An error if an operation fails.
    @discardableResult
    func commitStaged(
        message : String,
        options : GitCommitCreateOptions?   = nil
    ) throws -> GitOID
    {
        return try _commit(
            message:    message,
            options:    options,
            fromStage:  true
        )
    }
    
    
    
    /// Creates a commit with the given content and message.
    /// - Parameters:
    ///   - message: The commit message.
    ///   - options: The options for commit creation.
    ///   - fromStage: Whether the commit should be created from staged changes.
    ///   - path: The path to the file to modify. This will be appended to the
    ///   repository's URL.
    /// - Returns: The ID of the created commit.
    /// - Throws: An error if an operation fails.
    @discardableResult
    private func _commit(
        message     : String,
        options     : GitCommitCreateOptions?   = nil,
        fromStage   : Bool,
        path        : String?                   = nil
    ) throws -> GitOID
    {
        var indexPointer: OpaquePointer? = nil
        
        defer
        {
            gitIndexFree(index: indexPointer)
        }
        
        
        
        let repositoryIndexResult: Int32 = git_repository_index(
            &indexPointer,
            pointer
        )
        
        XCTAssertOK(GitErrorCode(rawValue: repositoryIndexResult))
        
        guard let indexPointer: OpaquePointer = indexPointer
        else
        {
            throw NSError.makeError("The index pointer was nil.")
        }
        
        
        
        if let path: String = path
        {
            let indexAddBypathResult: GitErrorCode = gitIndexAddByPath(
                index:  indexPointer,
                path:   path
            )
            
            XCTAssertOK(indexAddBypathResult)
            
            
            
            let indexWriteResult: GitErrorCode
                = gitIndexWrite(index: indexPointer)
            
            XCTAssertOK(indexWriteResult)
        }
        
        
        
        if fromStage
        {
            var commitOID = GitOID()
            
            let commitCreateFromStageResult: GitErrorCode
                = gitCommitCreateFromStage(
                    id:         &commitOID,
                    repo:       pointer,
                    message:    message,
                    opts:       options
                )
            
            XCTAssertOK(commitCreateFromStageResult)
            XCTAssertNotZeroOID(commitOID)
            
            
            
            var commitPointer: OpaquePointer? = nil

            defer
            {
                gitCommitFree(commit: commitPointer)
            }
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &commitPointer,
                repo:       pointer,
                id:         commitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                throw NSError.makeError("The staged commit pointer was nil.")
            }
            
            
            
            let messageEncoding: String?
                = gitCommitMessageEncoding(commit: commitPointer)
            
            XCTAssertNotNil(messageEncoding)
            XCTAssertEqual(messageEncoding, options?.messageEncoding)
            
            
            
            let author: GitSignature = gitCommitAuthor(commit: commitPointer)
            
            XCTAssertEqual(author.name, options?.author?.name)
            XCTAssertEqual(author.email, options?.author?.email)
            
            
            
            let committer: GitSignature
                = gitCommitCommitter(commit: commitPointer)
            
            XCTAssertEqual(committer.name, options?.committer?.name)
            XCTAssertEqual(committer.email, options?.committer?.email)
            
            
            
            return commitOID
        }
        
        
        
        var treeOID = GitOID()
        
        let indexWriteTreeResult: GitErrorCode = gitIndexWriteTree(
            out:    &treeOID,
            index:  indexPointer
        )
        
        XCTAssertOK(indexWriteTreeResult)
        
        
        
        var treePointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeTree(treePointer)
        }
        
        
        
        // TODO: Remove once `git_tree_lookup()` has a binding.
        var cTreeOID: git_oid = treeOID.cValue()
        
        let treeLookupResult: Int32 = git_tree_lookup(
            &treePointer,
            pointer,
            &cTreeOID
        )
        
        XCTAssertOK(GitErrorCode(rawValue: treeLookupResult))
        
        guard let treePointer: OpaquePointer = treePointer
        else
        {
            throw NSError.makeError("The tree pointer was nil.")
        }
        
        
        
        var headCommitPointer: OpaquePointer? = nil
        
        defer
        {
            gitCommitFree(commit: headCommitPointer)
        }
        
        
        
        // TODO: Remove once `git_reference_name_to_id()` has a binding.
        var cHeadOID = git_oid()
        
        /// Get the current HEAD commit as the parent commit, if it exists.
        let referenceToNameToIDResult: Int32 = git_reference_name_to_id(
            &cHeadOID,
            pointer,
            "HEAD"
        )
        
        if isOK(GitErrorCode(rawValue: referenceToNameToIDResult))
        {
            let commitLookupResult: GitErrorCode = gitCommitLookup(
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
        
        let commitCreateResult: GitErrorCode = gitCommitCreate(
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
    ///   - resetType: The type of reset to perform. The default value is
    ///   `GIT_RESET_HARD`.
    func reset(
        to      commitOID   : GitOID,
        type    resetType   : git_reset_t   = GIT_RESET_HARD
    )
    {
        var commitPointer: OpaquePointer? = nil
        
        defer
        {
            gitCommitFree(commit: commitPointer)
        }
        
        
        
        let commitLookupResult: GitErrorCode = gitCommitLookup(
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
        
        XCTAssertOK(GitErrorCode(rawValue: resetResult))
    }
    
    
    
    /// Creates a directory at the given path in the repository.
    /// - Parameter path: The path to the directory to create. This will be
    /// appended to the repository's URL.
    /// - Returns: The URL of the created directory.
    /// - Throws: An error if an operation fails.
    @discardableResult
    func createDirectory(
        at path: String
    ) throws -> URL
    {
        let fileURL: URL = url.appending(
            path:           path,
            directoryHint:  .isDirectory
        )
        
        try FileManager.default.createDirectory(
            at:                             fileURL,
            withIntermediateDirectories:    true
        )
        
        return fileURL
    }
    
    
    
    /// Modifies the content of a file.
    /// - Parameters:
    ///   - path: The path to the file to modify. This will be appended to the
    ///   repository's URL.
    ///   - content: The new content of the file. This is ignored when creating
    ///   a directory.
    ///   - appending: Whether the new content should be appended to the
    ///   existing content.
    /// - Returns: The URL to which the content was written.
    /// - Throws: An error if an operation fails.
    @discardableResult
    func modifyFile(
        at          path    : String,
        with        content : String,
        appending           : Bool      = false
    ) throws -> URL
    {
        let fileURL: URL = url.appending(
            path:           path,
            directoryHint:  .notDirectory
        )
        
        var writeContent: String = content
        
        if appending
        {
            let existingContent = try String(contentsOf: fileURL)
            writeContent += existingContent
        }
        
        try writeContent.atomicWrite(to: fileURL)
        
        return fileURL
    }
    
    
    
    /// Asserts that the contents of the specified file are equal to the given
    /// value.
    /// - Parameters:
    ///   - path: The path to the file content to verify. This will be appended
    ///   to the repository's URL.
    ///   - content: The expected content of the file.
    ///   - directoryHint: A hint to URL file APIs for handling paths that may
    ///   reference directories.
    /// - Throws: An error if an operation fails.
    func assertFileContent(
        at              path    : String,
        equals          content : String,
        directoryHint           : URL.DirectoryHint     = .notDirectory
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

extension Repository
{
    /// Creates blame data in the given repository.
    /// - Parameter repository: The repository.
    /// - Throws: An error if an operation fails.
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
        
        try repository.commit(
            initialContent,
            toFile:     blameFileName,
            message:    "Add blame file"
        )
        
        
        
        let modifiedContent: String =
        """
        1: Initial content
        2: Modified in second commit
        3: Even more content
        4: Added in second commit
        """
        
        try repository.commit(
            modifiedContent,
            toFile:     blameFileName,
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
        
        try repository.commit(
            finalContent,
            toFile:     blameFileName,
            message:    "Final blame file update"
        )
    }
    
    
    
    /// Creates a temporary directory with the given name.
    /// - Parameter directoryName: The name of the directory.
    /// - Returns: The URL of the temporary directory.
    /// - Throws: An error if an operation fails.
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
    /// - Throws: An error if an operation fails.
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
        
        XCTAssertOK(GitErrorCode(rawValue: repositoryInitResult))
        
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
        
        
        
        try repository.commit(
            readmeFileContent,
            toFile:     readmeFileName,
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
    
    
    
    /// Calls the given closure with a `Repository` instance and a pointer to
    /// the repository's index.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    static func withRepositoryAndIndexPointer(
        _ body: (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try withRepository
        {
            repository in
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let repositoryIndexResult: Int32 = git_repository_index(
                &indexPointer,
                repository.pointer
            )
            
            XCTAssertOK(GitErrorCode(rawValue: repositoryIndexResult))
            
            guard let indexPointer: OpaquePointer = indexPointer
            else
            {
                throw NSError.makeError("The index pointer was nil.")
            }
            
            return try body(
                repository,
                indexPointer
            )
        }
    }
}
