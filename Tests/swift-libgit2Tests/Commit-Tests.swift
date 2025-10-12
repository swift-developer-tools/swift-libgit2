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



final class CommitTests: XCTestCaseStopOnFail
{
    func testGitCommitAmendAndDup() throws
    {
        try amendOrDuplicateCommit(type: .amend)
        try amendOrDuplicateCommit(type: .duplicate)
    }
    
    
    
    func testGitCommitArrayDispose() throws
    {
        var array = git_commitarray()
        
        gitCommitArrayDispose(array: &array)
        gitCommitArrayDispose(array: &array)
        gitCommitArrayDispose(array: nil)
    }
    
    
    
    func testGitCommitCreateBufferWithSignatureAndExtract() throws
    {
        try Repository.withRepositoryAndIndexPointer
        {
            repository, indexPointer in
            
            var buffer      : GitBuf            = GitBuf()
            var treePointer : OpaquePointer?    = nil
            
            defer
            {
                XCTAssertOK(gitBufDispose(buffer: &buffer))
                Free.freeTree(treePointer)
            }
            
            
            
            var treeOID = GitOID()
            
            let indexWriteTreeResult: GitErrorCode = gitIndexWriteTree(
                out:    &treeOID,
                index:  indexPointer
            )
            
            XCTAssertOK(indexWriteTreeResult)
            
            
            
            // TODO: Remove once `git_tree_lookup()` has a binding.
            var cTreeOID: git_oid = treeOID.cValue()
            
            let treeLookupResult: Int32 = git_tree_lookup(
                &treePointer,
                repository.pointer,
                &cTreeOID
            )
            
            XCTAssertOK(GitErrorCode(rawValue: treeLookupResult))
            
            guard let treePointer: OpaquePointer = treePointer
            else
            {
                XCTFail("The tree pointer was nil.")
                return
            }
            
            
            
            let commitCreateBufferResult: GitErrorCode = gitCommitCreateBuffer(
                out:                &buffer,
                repo:               repository.pointer,
                author:             repository.signature,
                committer:          repository.signature,
                messageEncoding:    nil,
                message:            "Buffer commit",
                tree:               treePointer,
                parentCount:        0,
                parents:            nil
            )
            
            XCTAssertOK(commitCreateBufferResult)
            XCTAssertNotNil(buffer.ptr)
            XCTAssertGreaterThan(buffer.size, 0)
            
            guard let commitContent = String(optionalCString: buffer.ptr)
            else
            {
                XCTFail("The commit content was nil.")
                return
            }
            
            
            
            let fakeSignatureContent: String =
            """
            -----BEGIN PGP SIGNATURE-----
            Version: GnuPG v1
            
            hello world
            -----END PGP SIGNATURE-----
            """
            
            
            
            var signedCommitOID = GitOID()
            
            let commitCreateWithSignatureResult: GitErrorCode
                = gitCommitCreateWithSignature(
                    out:                &signedCommitOID,
                    repo:               repository.pointer,
                    commitContent:      commitContent,
                    signature:          fakeSignatureContent,
                    signatureField:     nil
                )
            
            XCTAssertOK(commitCreateWithSignatureResult)
            XCTAssertNotZeroOID(signedCommitOID)
            
            
            
            var extractedSignature      = GitBuf()
            var extractedSignedData     = GitBuf()
            
            defer
            {
                XCTAssertOK(gitBufDispose(buffer: &extractedSignature))
                XCTAssertOK(gitBufDispose(buffer: &extractedSignedData))
            }
            
            
            
            let commitExtractSignatureResult: GitErrorCode
                = gitCommitExtractSignature(
                    signature:      &extractedSignature,
                    signedData:     &extractedSignedData,
                    repo:           repository.pointer,
                    commitID:       signedCommitOID,
                    field:          nil
                )
            
            XCTAssertOK(commitExtractSignatureResult)
            XCTAssertNotNil(extractedSignature.ptr)
            XCTAssertGreaterThan(extractedSignature.size, 0)
            XCTAssertNotNil(extractedSignedData.ptr)
            XCTAssertGreaterThan(extractedSignedData.size, 0)
            
            guard let extractedSignatureContent
                    = String(optionalCString: extractedSignature.ptr)
            else
            {
                XCTFail("The extracted signature content was nil.")
                return
            }
            
            XCTAssertEqual(extractedSignatureContent, fakeSignatureContent)
        }
    }
    
    
    
    func testGitCommitCreateCB() throws
    {
        /// Simulate a rebase operation to test ``GitCommitCreateCB``,
        /// which is used only in rebases. An actual rebase would be performed
        /// differently. This test only attempts to check that the callback
        /// behaves correctly.
        try Repository.withRepository
        {
            repository in
            
            let baseCommitOID: GitOID = try repository.commit(
                "Base content",
                toFile:     "base.txt",
                message:    "Base commit"
            )
            
            let branchCommitOID: GitOID = try repository.commit(
                "Branch content",
                toFile:     "branch.txt",
                message:    "Branch commit"
            )
            
            
            
            repository.reset(to: baseCommitOID)
            
            try repository.commit(
                "Other content",
                toFile:     "other.txt",
                message:    "Other commit"
            )
            
            
            
            var callbackData = CallbackData()
                        
            let commitCreateCB: GitCommitCreateCB =
            {
                out, author, committer, messageEncoding, message,
                tree, parentCount, parents, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return GIT_PASSTHROUGH.rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                if let lastMessage = String(optionalCString: message)
                {
                    payloadPointer.pointee.lastMessage = lastMessage
                }
                
                /// Let the rebase create the commit normally.
                return GIT_PASSTHROUGH.rawValue
            }
            
            
            
            var annotatedCommitPointer  : OpaquePointer?    = nil
            var rebasePointer           : OpaquePointer?    = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
                Free.freeRebase(rebasePointer)
            }
            
            
            
            let annotatedCommitLookup: GitErrorCode = gitAnnotatedCommitLookup(
                out:    &annotatedCommitPointer,
                repo:   repository.pointer,
                id:     branchCommitOID
            )
            
            XCTAssertOK(annotatedCommitLookup)
            
            
            
            try withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var rebaseOptions = git_rebase_options()
                
                let rebaseOptionsInitResult: Int32 = git_rebase_options_init(
                    &rebaseOptions,
                    UInt32(GIT_REBASE_OPTIONS_VERSION)
                )
                
                XCTAssertOK(GitErrorCode(rawValue: rebaseOptionsInitResult))
                
                rebaseOptions.commit_create_cb  = commitCreateCB
                rebaseOptions.payload           = UnsafeMutableRawPointer(callbackDataPointer)
                
                
                
                let rebaseInitResult: Int32 = git_rebase_init(
                    &rebasePointer,
                    repository.pointer,
                    nil,
                    annotatedCommitPointer,
                    nil,
                    &rebaseOptions
                )
                
                XCTAssertOK(GitErrorCode(rawValue: rebaseInitResult))
                
                guard let rebasePointer: OpaquePointer = rebasePointer
                else
                {
                    XCTFail("The rebase pointer was nil.")
                    return
                }
                
                
                
                while true
                {
                    var rebaseOperationPointer: UnsafeMutablePointer<git_rebase_operation>?
                        = nil
                    
                    let rebaseNextResult: Int32 = git_rebase_next(
                        &rebaseOperationPointer,
                        rebasePointer
                    )
                    
                    if rebaseNextResult == GitErrorCode.gitIterOver.rawValue
                    {
                        break
                    }
                    
                    
                    
                    // TODO: Replace once `git_rebase_commit()` has a binding.
                    var rebasedCommitOID = git_oid()
                    
                    try repository.signature.withCValue
                    {
                        cSignature in
                        
                        let rebaseCommitResult: Int32 = git_rebase_commit(
                            &rebasedCommitOID,
                            rebasePointer,
                            nil,
                            cSignature,
                            nil,
                            nil
                        )
                        
                        if rebaseCommitResult != GitErrorCode.gitEApplied.rawValue
                        {
                            XCTAssertOK(GitErrorCode(rawValue: rebaseCommitResult))
                        }
                    }
                }
                
                
                
                let rebaseFinishResult: Int32 = git_rebase_finish(
                    rebasePointer,
                    nil
                )
                
                XCTAssertOK(GitErrorCode(rawValue: rebaseFinishResult))
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            XCTAssertNotNil(callbackData.lastMessage)
            XCTAssertFalse(callbackData.lastMessage?.isEmpty ?? false)
        }
    }
    
    
    
    func testGitCommitCreateFromStage() throws
    {
        var signature = GitSignature()
        
        let signatureNowResult: GitErrorCode = gitSignatureNow(
            out:    &signature,
            name:   "Options User",
            email:  "options-user@example.com"
        )
        
        XCTAssertOK(signatureNowResult)
        
        
        
        var commitCreateOptions = GitCommitCreateOptions()
        
        commitCreateOptions.allowEmptyCommit    = true
        commitCreateOptions.author              = signature
        commitCreateOptions.committer           = signature
        commitCreateOptions.messageEncoding     = "UTF-8"
        
        
        
        try Repository.withRepository
        {
            repository in
            
            try repository.commitStaged(
                message:    "Add Hello World",
                options:    commitCreateOptions
            )
        }
    }
    
    
    
    func testGitCommitCreateOptions() throws
    {
        let commitCreateOptions = GitCommitCreateOptions()
        
        XCTAssertEqual(commitCreateOptions.version, gitCommitCreateOptionsVersion)
        XCTAssertFalse(commitCreateOptions.allowEmptyCommit)
        XCTAssertNil(commitCreateOptions.author)
        XCTAssertNil(commitCreateOptions.committer)
        XCTAssertNil(commitCreateOptions.messageEncoding)
        
        try commitCreateOptions.withCValue
        {
            cCommitCreateOptions in
            
            XCTAssertEqual(cCommitCreateOptions.pointee.version, gitCommitCreateOptionsVersion)
            XCTAssertFalse(Bool(cCommitCreateOptions.pointee.allow_empty_commit))
            XCTAssertNil(cCommitCreateOptions.pointee.author)
            XCTAssertNil(cCommitCreateOptions.pointee.committer)
            XCTAssertNil(cCommitCreateOptions.pointee.message_encoding)
        }
    }
    
    
    
    func testGitCommitCreateOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitCommitCreateOptionsVersion), GIT_COMMIT_CREATE_OPTIONS_VERSION)
    }
    
    
    
    func testGitCommitFree() throws
    {
        gitCommitFree(commit: nil)
    }
    
    
    
    func testGitCommitHeaderField() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var buffer: GitBuf = GitBuf()

            defer
            {
                XCTAssertOK(gitBufDispose(buffer: &buffer))
            }
            
            
            
            let commitHeaderFieldResult: GitErrorCode
                = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in

                return gitCommitHeaderField(
                    out:        &buffer,
                    commit:     commitPointer,
                    field:      "tree"
                )
            }
            
            XCTAssertOK(commitHeaderFieldResult)
            XCTAssertNotNil(buffer.ptr)
            XCTAssertGreaterThan(buffer.size, 0)
        }
    }
    
    
    
    func testGitCommitLookupAndGetters() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var commitPointer: OpaquePointer? = nil
            
            defer
            {
                gitCommitFree(commit: commitPointer)
            }
            
            
            
            let summary : String    = "Add Hello World"
            let body    : String    = "Need to add Goodbye World."
            let message : String    = "\(summary)\n\n\(body)"
            
            let commitOID: GitOID = try repository.commit(
                "Hello World!",
                toFile:     "hello-world.txt",
                message:    message
            )
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         commitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            let retrievedOID: GitOID = gitCommitID(commit: commitPointer)
            
            XCTAssertEqual(retrievedOID, commitOID)
            
            
            
            let ownerPointer: OpaquePointer
                = gitCommitOwner(commit: commitPointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
            
            
            
            let commitMessage: String? = gitCommitMessage(commit: commitPointer)
            
            XCTAssertNotNil(commitMessage)
            XCTAssertEqual(commitMessage, message)
            
            
            
            let commitSummary: String? = gitCommitSummary(commit: commitPointer)
            
            XCTAssertNotNil(commitSummary)
            XCTAssertEqual(commitSummary, summary)
            
            
            
            let commitBody: String? = gitCommitBody(commit: commitPointer)
            
            XCTAssertNotNil(commitBody)
            XCTAssertEqual(commitBody, body)
            
            
            
            XCTAssertNotNil(gitCommitMessageRaw(commit: commitPointer))
            XCTAssertGreaterThan(gitCommitTime(commit: commitPointer), 0)
            XCTAssertNotEqual(gitCommitTimeOffset(commit: commitPointer), Int32.max)
            XCTAssertNil(gitCommitMessageEncoding(commit: commitPointer))
            
            
            
            let author: GitSignature = gitCommitAuthor(commit: commitPointer)
            
            XCTAssertEqual(author.name, Repository.commitAuthorName)
            XCTAssertEqual(author.email, Repository.commitAuthorEmail)
            
            
            
            let committer: GitSignature = gitCommitCommitter(commit: commitPointer)
            
            XCTAssertEqual(committer.name, Repository.commitAuthorName)
            XCTAssertEqual(committer.email, Repository.commitAuthorEmail)
        }
    }
    
    
    
    func testGitCommitLookupPrefix() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var commitPointer: OpaquePointer? = nil
            
            defer
            {
                gitCommitFree(commit: commitPointer)
            }
            
            
            
            let commitLookupPrefixResult: GitErrorCode = gitCommitLookupPrefix(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         headOID,
                len:        7
            )
            
            XCTAssertOK(commitLookupPrefixResult)
            XCTAssertNotNil(commitPointer)
        }
    }
    
    
    
    func testGitCommitWithMailmap() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                var author      = GitSignature()
                var committer   = GitSignature()
                
                
                
                let commitAuthorWithMailmapResult: GitErrorCode
                    = gitCommitAuthorWithMailmap(
                        out:        &author,
                        commit:     commitPointer,
                        mailmap:    nil
                    )
                
                XCTAssertOK(commitAuthorWithMailmapResult)
                
                
                
                let commitCommitterWithMailmapResult: GitErrorCode
                    = gitCommitCommitterWithMailmap(
                        out:        &committer,
                        commit:     commitPointer,
                        mailmap:    nil
                    )
                
                XCTAssertOK(commitCommitterWithMailmapResult)
            }
        }
    }
    
    
    
    func testGitCommitNthGenAncestor() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.commit(
                "Content 1",
                toFile:     "file1.txt",
                message:    "Add file1"
            )
            
            try repository.commit(
                "Content 2",
                toFile:     "file2.txt",
                message:    "Add file2"
            )
            
            
            
            var ancestorCommitPointer: OpaquePointer? = nil
            
            defer
            {
                gitCommitFree(commit: ancestorCommitPointer)
            }
            
            
            
            let commitNthGenAncestorResult: GitErrorCode
                = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in

                return gitCommitNthGenAncestor(
                    ancestor:   &ancestorCommitPointer,
                    commit:     commitPointer,
                    n:          2
                )
            }
            
            XCTAssertOK(commitNthGenAncestorResult)
            XCTAssertNotNil(ancestorCommitPointer)
        }
    }
    
    
    
    func testGitCommitParentFunctions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let commitOID: GitOID = try repository.commit(
                "Test content",
                toFile:     "test.txt",
                message:    "Second commit"
            )
            
            
            
            var commitPointer       : OpaquePointer?    = nil
            var parentCommmiPointer : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: commitPointer)
                gitCommitFree(commit: parentCommmiPointer)
            }
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         commitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            let parentCount: UInt32
                = gitCommitParentCount(commit: commitPointer)
            
            XCTAssertEqual(parentCount, 1)
            
            
            
            let commitParentResult: GitErrorCode = gitCommitParent(
                out:        &parentCommmiPointer,
                commit:     commitPointer,
                n:          0
            )
            
            XCTAssertOK(commitParentResult)
            XCTAssertNotNil(parentCommmiPointer)
            
            
            
            let parentCommitOID: GitOID = gitCommitParentID(
                commit:     commitPointer,
                n:          0
            )
            
            XCTAssertNotEqual(parentCommitOID, commitOID)
        }
    }
    
    
    
    func testGitCommitRawHeader() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in

                guard let rawCommitHeader: String
                        = gitCommitRawHeader(commit: commitPointer)
                else
                {
                    XCTFail("The raw commit header was nil.")
                    return
                }
                
                XCTAssertTrue(rawCommitHeader.contains("tree"))
            }
        }
    }
    
    
    
    func testGitCommitTreeAndTreeID() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var treePointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeTree(treePointer)
            }
            
            
            
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in

                let treeOID: GitOID = gitCommitTreeID(commit: commitPointer)
                
                XCTAssertNotZeroOID(treeOID)
                
                
                
                let commitTreeResult: GitErrorCode = gitCommitTree(
                    out:        &treePointer,
                    commit:     commitPointer
                )
                
                XCTAssertOK(commitTreeResult)
                XCTAssertNotNil(treePointer)
            }
        }
    }
}



// MARK: - Extensions

extension CommitTests
{
    private struct CallbackData
    {
        var callCount   : Int       = 0
        var lastMessage : String?   = nil
    }
    
    
    
    private enum AmendOrDuplicate
    {
        case amend
        case duplicate
    }
    
    
    
    /// Amends or duplicates a commit.
    /// - Parameter type: Whether to amend or duplicate a commit.
    /// - Throws: An error if an operation fails.
    private func amendOrDuplicateCommit(
        type: AmendOrDuplicate
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            let originalCommitOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var newCommitPointer        : OpaquePointer?    = nil
            var originalCommitPointer   : OpaquePointer?    = nil

            defer
            {
                gitCommitFree(commit: newCommitPointer)
                gitCommitFree(commit: originalCommitPointer)
            }
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &originalCommitPointer,
                repo:       repository.pointer,
                id:         originalCommitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let originalCommitPointer: OpaquePointer
                    = originalCommitPointer
            else
            {
                XCTFail("The original commit pointer was nil.")
                return
            }
            
            
            
            var newCommitOID    : GitOID    = GitOID()
            let amendedMessage  : String    = "Amended commit message"
            
            
            
            if type == .amend
            {
                let commitAmendResult: GitErrorCode = gitCommitAmend(
                    id:                 &newCommitOID,
                    commitToAmend:      originalCommitPointer,
                    updateRef:          "HEAD",
                    author:             nil,
                    committer:          nil,
                    messageEncoding:    nil,
                    message:            amendedMessage,
                    tree:               nil
                )
                
                XCTAssertOK(commitAmendResult)
                
                
                
                let amendedCommitLookupResult: GitErrorCode = gitCommitLookup(
                    commit:     &newCommitPointer,
                    repo:       repository.pointer,
                    id:         newCommitOID
                )
                
                XCTAssertOK(amendedCommitLookupResult)
            }
            else
            {
                let commitDupResult: GitErrorCode = gitCommitDup(
                    out:        &newCommitPointer,
                    source:     originalCommitPointer
                )
                
                XCTAssertOK(commitDupResult)
            }
            
            
            
            guard let newCommitPointer: OpaquePointer = newCommitPointer
            else
            {
                XCTFail("The new commit pointer was nil.")
                return
            }
            
            
            
            if type == .amend
            {
                let retrievedOID: GitOID
                    = gitCommitID(commit: newCommitPointer)
                
                XCTAssertEqual(retrievedOID, newCommitOID)
            }
            
            XCTAssertNotEqual(newCommitOID, originalCommitOID)
            
            
            
            let ownerPointer: OpaquePointer
                = gitCommitOwner(commit: newCommitPointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
            
            
            
            let newCommitMessage: String?
                = gitCommitMessage(commit: newCommitPointer)
            
            XCTAssertNotNil(newCommitMessage)
            
            
            
            let newCommitSummary: String?
                = gitCommitSummary(commit: newCommitPointer)
            
            XCTAssertNotNil(newCommitSummary)
            
            
            
            if type == .amend
            {
                XCTAssertEqual(newCommitMessage, amendedMessage)
                XCTAssertEqual(newCommitSummary, amendedMessage)
            }
            else
            {
                let originalCommitMessage   : String?   = gitCommitMessage(commit: originalCommitPointer)
                let originalCommitSummary   : String?   = gitCommitSummary(commit: originalCommitPointer)
                
                XCTAssertEqual(newCommitMessage, originalCommitMessage)
                XCTAssertEqual(newCommitSummary, originalCommitSummary)
            }
            
            
            
            let newCommitBody: String? = gitCommitBody(commit: newCommitPointer)
            
            XCTAssertNil(newCommitBody)
            
            
            
            XCTAssertNotNil(gitCommitMessageRaw(commit: newCommitPointer))
            XCTAssertGreaterThan(gitCommitTime(commit: newCommitPointer), 0)
            XCTAssertNotEqual(gitCommitTimeOffset(commit: newCommitPointer), Int32.max)
            XCTAssertNil(gitCommitMessageEncoding(commit: newCommitPointer))
            
            
            
            let author: GitSignature = gitCommitAuthor(commit: newCommitPointer)
            
            XCTAssertEqual(author.name, Repository.commitAuthorName)
            XCTAssertEqual(author.email, Repository.commitAuthorEmail)
            
            
            
            let committer: GitSignature = gitCommitCommitter(commit: newCommitPointer)
            
            XCTAssertEqual(committer.name, Repository.commitAuthorName)
            XCTAssertEqual(committer.email, Repository.commitAuthorEmail)
        }
    }
}
