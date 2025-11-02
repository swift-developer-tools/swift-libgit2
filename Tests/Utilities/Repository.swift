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



/// Repository-related test utilities.
struct Repository
{
    /// The URL of the repository.
    let url         : URL
    
    /// A pointer to the repository.
    let pointer     : OpaquePointer
    
    /// The default signature using ``commitAuthorName`` and
    /// ``commitAuthorEmail``.
    let signature   : GitSignature
    
    
    
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
    
    
    
    /// The URL of the configuration file.
    var configURL: URL
    {
        return url.appending(
            path:           ".git/config",
            directoryHint:  .notDirectory
        )
    }
    
    
    
    /// The absolute path of the configuration file.
    var configPath: String
    {
        return configURL.path(percentEncoded: false)
    }
    
    
    
    /// The URL of the attributes file.
    var gitAttributesURL: URL
    {
        return url.appending(
            path:           ".gitattributes",
            directoryHint:  .notDirectory
        )
    }
    
    
    
    /// The HEAD reference ID.
    var headOID: GitOID
    {
        var headOID = GitOID()
        
        let referenceNameToIDResult: GitErrorCode = gitReferenceNameToID(
            out:    &headOID,
            repo:   pointer,
            name:   "HEAD"
        )
        
        XCTAssertOK(referenceNameToIDResult)
        XCTAssertNotZeroOID(headOID)
        
        return headOID
    }
    
    
    
    /// The URL of the objects directory.
    var objectsURL: URL
    {
        return url.appending(
            path:           ".git/objects",
            directoryHint:  .isDirectory
        )
    }
    
    
    
    /// The URL of the objects information directory.
    var objectsInfoURL: URL
    {
        return objectsURL.appending(
            path:           "info",
            directoryHint:  .isDirectory
        )
    }
    
    
    
    /// Commits changes to the specified file with the given content and
    /// message.
    /// - Parameters:
    ///   - content: The new content of the file.
    ///   - path: The path to the file to modify, relative to the repository's
    ///   root.
    ///   - message: The commit message.
    ///   - appending: Whether to append the new content to the existing
    ///   content.
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
    ///   - fromStage: Whether to create the commit from staged changes.
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
        
        
        
        let repoIndexResult: GitErrorCode = gitRepositoryIndex(
            out:    &indexPointer,
            repo:   pointer
        )
        
        XCTAssertOK(repoIndexResult)
        
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
            
            
            
            let author: GitSignature? = gitCommitAuthor(commit: commitPointer)
            
            XCTAssertNotNil(author)
            XCTAssertEqual(author?.name, options?.author?.name)
            XCTAssertEqual(author?.email, options?.author?.email)
            
            
            
            let committer: GitSignature?
                = gitCommitCommitter(commit: commitPointer)
            
            XCTAssertNotNil(committer)
            XCTAssertEqual(committer?.name, options?.committer?.name)
            XCTAssertEqual(committer?.email, options?.committer?.email)
            
            
            
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
            gitTreeFree(tree: treePointer)
        }
        
        
        
        let treeLookupResult: GitErrorCode = gitTreeLookup(
            out:    &treePointer,
            repo:   pointer,
            id:     treeOID
        )
        
        XCTAssertOK(treeLookupResult)
        
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
        
        
        
        var headOID = GitOID()
        
        /// Get the current HEAD commit as the parent commit, if it exists.
        let referenceToNameToIDResult: GitErrorCode = gitReferenceNameToID(
            out:    &headOID,
            repo:   pointer,
            name:   "HEAD"
        )
        
        if isOK(referenceToNameToIDResult)
        {
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &headCommitPointer,
                repo:       pointer,
                id:         headOID
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
        XCTAssertNotZeroOID(commitOID)
        
        
        return commitOID
    }
    
    
    
    /// Inserts the given blob data into the given treebuilder.
    /// - Parameters:
    ///   - blobData: The blob data to insert.
    ///   - fileName: The file name to use.
    ///   - treebuilderPointer: The treebuilder to update. The underlying
    ///   type must be `git_treebuilder`.
    func insertBlob(
        _       blobData            : Data,
        named   fileName            : String,
        into    treebuilderPointer  : OpaquePointer
    )
    {
        var blobOID = GitOID()
        
        let blobCreateFromBufferResult: GitErrorCode
            = gitBlobCreateFromBuffer(
                id:         &blobOID,
                repo:       pointer,
                buffer:     blobData,
                len:        blobData.count
            )
        
        XCTAssertOK(blobCreateFromBufferResult)
        XCTAssertNotZeroOID(blobOID)
        
        
        
        var treeEntryPointer: OpaquePointer? = nil
        
        let treebuilderInsertResult: GitErrorCode = gitTreebuilderInsert(
            out:        &treeEntryPointer,
            bld:        treebuilderPointer,
            fileName:   fileName,
            id:         blobOID,
            fileMode:   .gitFileModeBlob
        )
        
        XCTAssertOK(treebuilderInsertResult)
        XCTAssertNotNil(treeEntryPointer)
    }
    
    
    
    /// Resets the repository to the specified commit.
    /// - Parameters:
    ///   - commitOID: The ID of the commit to use.
    ///   - resetType: The type of reset to perform.
    func reset(
        to      commitOID   : GitOID,
        type    resetType   : GitResetT     = .gitResetHard
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
        
        guard let commitPointer: OpaquePointer = commitPointer
        else
        {
            XCTFail("The commit pointer was nil.")
            return
        }
        
        
        
        let resetResult: GitErrorCode = gitReset(
            repo:           pointer,
            target:         commitPointer,
            resetType:      resetType,
            checkoutOpts:   nil
        )
        
        XCTAssertOK(resetResult)
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
    
    
    
    /// Creates packfile data.
    /// - Returns: The packfile data.
    /// - Throws: An error if an operation fails.
    func createPackfileData() throws -> Data
    {
        var packbuilderPointer: OpaquePointer? = nil
        
        defer
        {
            gitPackbuilderFree(pb: packbuilderPointer)
        }
        
        
        
        let packbuilderNewResult: GitErrorCode = gitPackbuilderNew(
            out:    &packbuilderPointer,
            repo:   pointer
        )
        
        XCTAssertOK(packbuilderNewResult)
        
        guard let packbuilderPointer: OpaquePointer = packbuilderPointer
        else
        {
            throw NSError.makeError("The packbuilder pointer was nil.")
        }
        
        
        
        let packbuilderInsertCommitResult: GitErrorCode
            = gitPackbuilderInsertCommit(
                pb:     packbuilderPointer,
                id:     headOID
            )
        
        XCTAssertOK(packbuilderInsertCommitResult)
        
        
        
        var packData = Data()
        
        let packbuilderForEachCB: GitPackbuilderForEachCB =
        {
            data, size, payload in
            
            guard
                let data    : UnsafeMutableRawPointer   = data,
                let payload : UnsafeMutableRawPointer   = payload
            else
            {
                XCTFail("All or some callback parameters were nil.")
                return GitErrorCode.gitUnknown(-123).rawValue
            }
            
            let payloadPointer: UnsafeMutablePointer<Data>
                = payload.assumingMemoryBound(to: Data.self)
            
            let bytes = Data(
                bytes:  data,
                count:  size
            )
            
            payloadPointer.pointee.append(bytes)
            
            return GitErrorCode.gitOK.rawValue
        }
        
        
        
        withUnsafeMutablePointer(to: &packData)
        {
            packDataPointer in
            
            let packbuilderForEachResult: GitErrorCode = gitPackbuilderForEach(
                pb:         packbuilderPointer,
                cb:         packbuilderForEachCB,
                payload:    packDataPointer
            )
            
            XCTAssertOK(packbuilderForEachResult)
        }
        
        return packData
    }
    
    
    
    /// Indexes and validates the given packfile data.
    /// - Parameters:
    ///   - packfileData: The packfile data to index and validate.
    ///   - indexerOptions: The indexer options.
    ///   - deleteIndexer: Whether to delete the indexer directory before
    ///   returning. If this is `false`, the caller must delete the directory.
    /// - Returns: The URL of the index file.
    /// - Throws: An error if an operation fails.
    @discardableResult
    func validatePackfileData(
        _               packfileData    : Data,
        options         indexerOptions  : GitIndexerOptions?    = nil,
        deleteIndexer                   : Bool                  = false
    ) throws -> URL
    {
        let indexerURL: URL = try Repository.createTemporaryDirectory(
            named: "SwiftLibgit2IndexerTests"
        )
        
        var indexerPointer  : OpaquePointer?    = nil
        var odbPointer      : OpaquePointer?    = nil
        
        defer
        {
            gitIndexerFree(idx: indexerPointer)
            gitODBFree(db: odbPointer)
            
            if deleteIndexer
            {
                try? FileManager.default.removeItem(at: indexerURL)
            }
        }
        
        
        
        if indexerOptions?.verify == true
        {
            let repoODBResult: GitErrorCode = gitRepositoryODB(
                out:    &odbPointer,
                repo:   pointer
            )
            
            XCTAssertOK(repoODBResult)
        }
        
        
        
        let indexerNewResult: GitErrorCode = gitIndexerNew(
            out:    &indexerPointer,
            path:   indexerURL.path(),
            mode:   0,
            odb:    odbPointer,
            opts:   indexerOptions
        )
        
        XCTAssertOK(indexerNewResult)
        
        guard let indexerPointer: OpaquePointer = indexerPointer
        else
        {
            throw NSError.makeError("The indexer pointer was nil.")
        }
        
        
        
        var indexerProgress = GitIndexerProgress()
        
        let indexerAppendResult: GitErrorCode = gitIndexerAppend(
            idx:    indexerPointer,
            data:   packfileData,
            size:   packfileData.count,
            stats:  &indexerProgress
        )
        
        XCTAssertOK(indexerAppendResult)
        
        
        
        let indexerCommitResult: GitErrorCode = gitIndexerCommit(
            idx:    indexerPointer,
            stats:  &indexerProgress
        )
        
        XCTAssertOK(indexerCommitResult)
        XCTAssertGreaterThan(indexerProgress.indexedObjects, 0)
        
        
        
        let packfileOID: GitOID? = gitIndexerHash(idx: indexerPointer)
        
        XCTAssertNotNil(packfileOID)
        XCTAssertNotZeroOID(packfileOID)
        
        
        
        let packfileName: String? = gitIndexerName(idx: indexerPointer)
        
        guard let packfileName: String = packfileName
        else
        {
            throw NSError.makeError("The packfile name was nil.")
        }
        
        XCTAssertFalse(packfileName.isEmpty)
        
        
        
        let indexURL: URL = indexerURL.appending(
            path:           "pack-\(packfileName).idx",
            directoryHint:  .notDirectory
        )
        
        return indexURL
    }
    
    
    
    /// Modifies the content of a file.
    /// - Parameters:
    ///   - path: The path to the file to modify. This will be appended to the
    ///   repository's URL.
    ///   - content: The new content of the file. This is ignored when creating
    ///   a directory.
    ///   - appending: Whether to append the new content to the existing
    ///   content.
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
    
    
    
    /// Validates that the contents of the specified file are equal to the
    /// given value.
    /// - Parameters:
    ///   - path: The path to the file content to verify. This will be appended
    ///   to the repository's URL.
    ///   - content: The expected content of the file.
    ///   - directoryHint: A hint to URL file APIs for handling paths that may
    ///   reference directories.
    /// - Throws: An error if an operation fails.
    func validateFileContent(
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

internal extension Repository
{
    static let commitAuthorName     : String    = "Test User"
    static let commitAuthorEmail    : String    = "test@example.com"
    
    static let readmeFileName       : String    = "README.md"
    static let readmeFileContent    : String    = "# Hello World!"
    static let blameFileName        : String    = "blame.txt"
    
    static let fetchSource          : String    = "refs/heads/*"
    static let fetchDestination     : String    = "refs/remotes/origin/*"
    static let fetchRefspec         : String    = "\(fetchSource):\(fetchDestination)"
    
    static let pushSource           : String    = "refs/heads/*"
    static let pushDestination      : String    = "refs/heads/origin/*"
    static let pushRefspec          : String    = "\(pushSource):\(pushDestination)"
    
    static let treebuilderFileName  : String    = "treebuilder-test.txt"
    
    static let worktreeName         : String    = "worktree"
    static let worktreePath         : String    = worktreeURL.path()
    
    static let worktreeURL: URL
        = FileManager.default.temporaryDirectory
            .appending(path: worktreeName, directoryHint: .isDirectory)
            .appendingPathExtension(UUID().uuidString)
    
    static let gitAttributesContent: String =
    """
    *.txt text eol=lf
    *.bin binary
    *.special custom=customvalue
    *.false -text
    *.macro attr1 attr2=value
    """
    
    static let gitAttributesFiles: [(String, String)] =
    [
        ("test.txt",        "This is a text file\n"),
        ("data.bin",        "Binary data"),
        ("file.special",    "Special file"),
        ("negative.false",  "File with false attribute")
    ]
    
    
    
    /// Creates attribute and blame data in the repository.
    /// - Parameter repository: The repository.
    /// - Throws: An error if an operation fails.
    private func createMiscellaneousData() throws
    {
        let initialContent: String =
        """
        1: Initial content
        2: More content
        3: Even more content
        """
        
        try commit(
            initialContent,
            toFile:     Self.blameFileName,
            message:    "Add blame file"
        )
        
        
        
        let modifiedContent: String =
        """
        1: Initial content
        2: Modified in second commit
        3: Even more content
        4: Added in second commit
        """
        
        try commit(
            modifiedContent,
            toFile:     Self.blameFileName,
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
        
        try commit(
            finalContent,
            toFile:     Self.blameFileName,
            message:    "Final blame file update"
        )
        
        
        
        try Self.gitAttributesContent.atomicWrite(to: gitAttributesURL)
        
        for (fileName, content) in Self.gitAttributesFiles
        {
            let fileURL: URL = url.appending(
                path:           fileName,
                directoryHint:  .notDirectory
            )
            
            try content.atomicWrite(to: fileURL)
        }
        
        
        
        try createDirectory(at: objectsInfoURL.path())
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
    
    
    
    /// Calls the given closure with a ``Repository`` instance.
    /// - Parameters:
    ///   - options: The repository initialization options to use.
    ///   - isBare: Whether to initialize a bare repository.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    @discardableResult
    static func withRepository<T>(
        options : GitRepositoryInitOptions?     = nil,
        isBare  : Bool                          = false,
        _ body  : (Repository) throws -> T
    ) throws -> T
    {
        let url: URL = try createTemporaryDirectory(named: "SwiftLibgit2Tests")
        
        var repoPointer: OpaquePointer? = nil
        
        defer
        {
            gitRepositoryFree(repo: repoPointer)
            
            try? FileManager.default.removeItem(at: url)
        }
        
        
        
        if let options: GitRepositoryInitOptions = options
        {
            let repoInitExtResult: GitErrorCode = gitRepositoryInitExt(
                out:        &repoPointer,
                repoPath:   url.path(),
                opts:       options
            )
            
            XCTAssertOK(repoInitExtResult)
        }
        else
        {
            let repoInitResult: GitErrorCode = gitRepositoryInit(
                out:        &repoPointer,
                path:       url.path(),
                isBare:     isBare
            )
            
            XCTAssertOK(repoInitResult)
        }
        
        guard let repoPointer: OpaquePointer = repoPointer
        else
        {
            throw NSError.makeError("The repository pointer was nil.")
        }
        
        let repository = Repository(
            url:        url,
            pointer:    repoPointer
        )
        
        
        
        if isBare
        {
            return try body(repository)
        }
        
        
        
        try repository.commit(
            readmeFileContent,
            toFile:     readmeFileName,
            message:    "Initial commit"
        )
        
        try repository.createMiscellaneousData()
        
        
        
        return try body(repository)
    }
    
    
    
    /// Calls the closure with a ``Repository`` instance and a pointer to an
    /// on-disk configuration object.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withConfig<T>(
        _ body: (Repository, OpaquePointer) throws -> T
    ) throws -> T
    {
        return try Repository.withRepository
        {
            repository in
            
            var configPointer: OpaquePointer? = nil
            
            defer
            {
                gitConfigFree(cfg: configPointer)
            }
            
            
            
            let configOpenOnDiskResult: GitErrorCode = gitConfigOpenOnDisk(
                out:    &configPointer,
                path:   repository.configPath
            )
            
            XCTAssertOK(configOpenOnDiskResult)
            
            guard let configPointer: OpaquePointer = configPointer
            else
            {
                throw NSError.makeError("The configuration pointer was nil.")
            }
            
            return try body(
                repository,
                configPointer
            )
        }
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to the repository's index.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withIndex<T>(
        _ body: (Repository, OpaquePointer) throws -> T
    ) throws -> T
    {
        return try withRepository
        {
            repository in
            
            var indexPointer: OpaquePointer? = nil
            
            defer
            {
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let repoIndexResult: GitErrorCode = gitRepositoryIndex(
                out:    &indexPointer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(repoIndexResult)
            
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
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to an opened object database.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withODB<T>(
        _ body: (Repository, OpaquePointer) throws -> T
    ) throws -> T
    {
        return try Repository.withRepository
        {
            repository in
            
            var odbPointer: OpaquePointer? = nil
            
            defer
            {
                gitODBFree(db: odbPointer)
            }
            
            
            
            let odbOpenResult: GitErrorCode = gitODBOpen(
                odbOut:         &odbPointer,
                objectsDir:     repository.objectsURL.path()
            )
            
            XCTAssertOK(odbOpenResult)
            
            guard let odbPointer: OpaquePointer = odbPointer
            else
            {
                throw NSError.makeError("The ODB pointer was nil.")
            }
            
            
            
            let backendCount: Int = gitODBNumBackends(odb: odbPointer)
            
            XCTAssertGreaterThan(backendCount, 0)
            
            
            
            return try body(
                repository,
                odbPointer
            )
        }
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a tree.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withTree<T>(
        _ body: (Repository, OpaquePointer) throws -> T
    ) throws -> T
    {
        return try withTreebuilder
        {
            repository, treebuilderPointer in
            
            var treeOID = GitOID()
            
            let treebuilderWriteResult: GitErrorCode = gitTreebuilderWrite(
                id:     &treeOID,
                bld:    treebuilderPointer
            )
            
            XCTAssertOK(treebuilderWriteResult)
            XCTAssertNotZeroOID(treeOID)
            
            
            
            var treePointer: OpaquePointer? = nil
            
            defer
            {
                gitTreeFree(tree: treePointer)
            }
            
            
            
            let treeLookupResult: GitErrorCode = gitTreeLookup(
                out:    &treePointer,
                repo:   repository.pointer,
                id:     treeOID
            )
            
            XCTAssertOK(treeLookupResult)
            
            guard let treePointer: OpaquePointer = treePointer
            else
            {
                throw NSError.makeError("The tree pointer was nil.")
            }
            
            
            
            return try body(
                repository,
                treePointer
            )
        }
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a treebuilder.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withTreebuilder<T>(
        _ body: (Repository, OpaquePointer) throws -> T
    ) throws -> T
    {
        return try Repository.withRepository
        {
            repository in
            
            var treebuilderPointer: OpaquePointer? = nil
            
            defer
            {
                gitTreebuilderFree(bld: treebuilderPointer)
            }
            
            
            
            let treebuilderNewResult: GitErrorCode = gitTreebuilderNew(
                out:        &treebuilderPointer,
                repo:       repository.pointer,
                source:     nil
            )
            
            XCTAssertOK(treebuilderNewResult)
            
            guard let treebuilderPointer: OpaquePointer = treebuilderPointer
            else
            {
                throw NSError.makeError("The treebuilder pointer was nil.")
            }
            
            
            
            repository.insertBlob(
                Data("Treebuilder content".utf8),
                named:  Self.treebuilderFileName,
                into:   treebuilderPointer
            )
            
            
            
            return try body(
                repository,
                treebuilderPointer
            )
        }
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a worktree.
    /// - Parameters:
    ///   - options: The worktree adding options to use.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if an operation fails.
    static func withWorktree<T>(
        options : GitWorktreeAddOptions? = nil,
        _ body  : (Repository, OpaquePointer) throws -> T
    ) throws -> T
    {
        return try Repository.withRepository
        {
            repository in
            
            var worktreePointer: OpaquePointer? = nil
            
            defer
            {
                gitWorktreeFree(wt: worktreePointer)
                
                try? FileManager.default.removeItem(at: Self.worktreeURL)
            }
            
            
            
            try? FileManager.default.removeItem(at: Self.worktreeURL)
            
            let worktreeAddResult: GitErrorCode = gitWorktreeAdd(
                out:    &worktreePointer,
                repo:   repository.pointer,
                name:   Self.worktreeName,
                path:   Self.worktreePath,
                opts:   options
            )
            
            XCTAssertOK(worktreeAddResult)
            
            guard let worktreePointer: OpaquePointer = worktreePointer
            else
            {
                throw NSError.makeError("The worktree pointer was nil.")
            }
            
            
            
            return try body(
                repository,
                worktreePointer
            )
        }
    }
}
