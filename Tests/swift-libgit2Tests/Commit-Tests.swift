//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import XCTest
@testable import SwiftLibgit2



final class CommitTests: XCTestCaseStopOnFail
{
    func testGitCommitAmendAndDup() throws
    {
        try amendOrDuplicateCommit(type: .amend)
        try amendOrDuplicateCommit(type: .duplicate)
    }
    
    
    
    func testGitCommitCreateBufferWithSignatureAndExtract() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var buffer          : GitBuf            = GitBuf()
            var indexPointer    : OpaquePointer?    = nil
            var treePointer     : OpaquePointer?    = nil
            
            defer
            {
                gitBufDispose(buffer: &buffer)
                Free.freeIndex(indexPointer)
                Free.freeTree(treePointer)
            }
            
            
            
            let repositoryIndexResult: Int32 = git_repository_index(
                &indexPointer,
                repository.pointer
            )
            
            XCTAssertOK(repositoryIndexResult)
            
            
            
            // TODO: Replace once `git_index_write_tree()` and `git_tree_lookup()` have bindings.
            var treeOID = git_oid()
            
            let indexWriteTreeResult: Int32 = git_index_write_tree(
                &treeOID,
                indexPointer
            )
            
            XCTAssertOK(indexWriteTreeResult)
            
            
            
            let treeLookupResult: Int32 = git_tree_lookup(
                &treePointer,
                repository.pointer,
                &treeOID
            )
            
            XCTAssertOK(treeLookupResult)
            
            guard let treePointer: OpaquePointer = treePointer
            else
            {
                XCTFail("The tree pointer was nil.")
                return
            }
            
            
            
            var signature = GitSignature()
            
            let signatureNowResult: Int32 = gitSignatureNow(
                out:    &signature,
                name:   Repository.commitAuthorName,
                email:  Repository.commitAuthorEmail
            )
            
            XCTAssertOK(signatureNowResult)
            
            
            
            let commitCreateBufferResult: Int32 = gitCommitCreateBuffer(
                out:                &buffer,
                repo:               repository.pointer,
                author:             signature,
                committer:          signature,
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
            
            let commitCreateWithSignatureResult: Int32 = gitCommitCreateWithSignature(
                out:                &signedCommitOID,
                repo:               repository.pointer,
                commitContent:      commitContent,
                signature:          fakeSignatureContent,
                signatureField:     nil
            )
            
            XCTAssertOK(commitCreateWithSignatureResult)
            OID.assertOIDsNotEqual(signedCommitOID, GitOID())
            
            
            
            var extractedSignature      = GitBuf()
            var extractedSignedData     = GitBuf()
            
            defer
            {
                gitBufDispose(buffer: &extractedSignature)
                gitBufDispose(buffer: &extractedSignedData)
            }
            
            
            
            let commitExtractSignatureResult: Int32 = gitCommitExtractSignature(
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
            
            guard let extractedSignatureContent = String(optionalCString: extractedSignature.ptr)
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
        /// Simulate a rebase operation to test ``GitCommitCreateCB``, which is used only
        /// in rebases. An actual rebase would be performed differently. This test only attempts to
        /// check that the callback behaves correctly.
        try Repository.withRepository
        {
            repository in
            
            let baseCommitOID: GitOID = try repository.createCommit(
                path:       "base.txt",
                content:    "Base content",
                message:    "Base commit"
            )
            
            let branchCommitOID: GitOID = try repository.createCommit(
                path:       "branch.txt",
                content:    "Branch content",
                message:    "Branch commit"
            )
            
            
            
            repository.resetToCommit(
                commitOID:  baseCommitOID,
                resetType:  GIT_RESET_HARD
            )
            
            try repository.createCommit(
                path:       "other.txt",
                content:    "Other content",
                message:    "Other commit"
            )
            
            
            
            var callbackData = CommitCreateCallbackData()
                        
            let commitCreateCB: GitCommitCreateCB =
            {
                out, author, committer, messageEncoding, message,
                tree, parentCount, parents, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    return GIT_PASSTHROUGH.rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CommitCreateCallbackData>
                    = payload.assumingMemoryBound(to: CommitCreateCallbackData.self)
                
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
                Free.freeAnnotatedCommit(annotatedCommitPointer)
                Free.freeRebase(rebasePointer)
            }
            
            
            
            let annotatedCommitLookup: Int32 = gitAnnotatedCommitLookup(
                out:    &annotatedCommitPointer,
                repo:   repository.pointer,
                id:     branchCommitOID
            )
            
            XCTAssertOK(annotatedCommitLookup)
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                var rebaseOptions = git_rebase_options()
                
                let rebaseOptionsInitResult: Int32 = git_rebase_options_init(
                    &rebaseOptions,
                    UInt32(GIT_REBASE_OPTIONS_VERSION)
                )
                
                XCTAssertOK(rebaseOptionsInitResult)
                
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
                
                XCTAssertOK(rebaseInitResult)
                
                guard let rebasePointer: OpaquePointer = rebasePointer
                else
                {
                    XCTFail("The rebase pointer was nil.")
                    return
                }
                
                
                
                while true
                {
                    var rebaseOperationPointer: UnsafeMutablePointer<git_rebase_operation>? = nil
                    
                    let rebaseNextResult: Int32 = git_rebase_next(
                        &rebaseOperationPointer,
                        rebasePointer
                    )
                    
                    if rebaseNextResult == GIT_ITEROVER.rawValue
                    {
                        break
                    }
                    
                    
                    
                    var signature = GitSignature()
                    
                    let signatureNowResult: Int32 = gitSignatureNow(
                        out:    &signature,
                        name:   Repository.commitAuthorName,
                        email:  Repository.commitAuthorEmail
                    )
                    
                    XCTAssertOK(signatureNowResult)
                    
                    
                    
                    // TODO: Replace once `git_rebase_commit()` has a binding.
                    var rebasedCommitOID = git_oid()
                    
                    signature.withCValue
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
                        
                        if rebaseCommitResult != GIT_EAPPLIED.rawValue
                        {
                            XCTAssertOK(rebaseCommitResult)
                        }
                    }
                }
                
                
                
                let rebaseFinishResult: Int32 = git_rebase_finish(
                    rebasePointer,
                    nil
                )
                
                XCTAssertOK(rebaseFinishResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            XCTAssertNotNil(callbackData.lastMessage)
            XCTAssertFalse(callbackData.lastMessage?.isEmpty ?? false)
        }
    }
    
    
    
    func testGitCommitCreateFromStage() throws
    {
        var signature = GitSignature()
        
        let signatureNowResult: Int32 = gitSignatureNow(
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
            
            try repository.createCommit(
                path:       "hello-world.txt",
                content:    "Hello World!",
                message:    "Add Hello World",
                options:    commitCreateOptions,
                fromStage:  true
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
        
        XCTAssertEqual(gitCommitCreateOptionsVersion, UInt32(GIT_COMMIT_CREATE_OPTIONS_VERSION))
    }
    
    
    
    func testGitCommitHeaderField() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var buffer          : GitBuf            = GitBuf()
            var commitPointer   : OpaquePointer?    = nil

            defer
            {
                gitBufDispose(buffer: &buffer)
                Free.freeCommit(commitPointer)
            }
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         headOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            let commitHeaderFieldResult: Int32 = gitCommitHeaderField(
                out:        &buffer,
                commit:     commitPointer,
                field:      "tree"
            )
            
            XCTAssertOK(commitHeaderFieldResult)
            XCTAssertNotNil(buffer.ptr)
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
                Free.freeCommit(commitPointer)
            }
            
            
            
            let summary : String    = "Add Hello World"
            let body    : String    = "Need to add Goodbye World."
            let message : String    = "\(summary)\n\n\(body)"
            
            let commitOID: GitOID = try repository.createCommit(
                path:       "hello-world.txt",
                content:    "Hello World!",
                message:    message
            )
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
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
            
            
            var signature = GitSignature()
            
            let signatureNowResult: Int32 = gitSignatureNow(
                out:    &signature,
                name:   Repository.commitAuthorName,
                email:  Repository.commitAuthorEmail
            )
            
            XCTAssertOK(signatureNowResult)
            
            
            
            let retrievedOID: GitOID = gitCommitID(commit: commitPointer)
            
            OID.assertOIDsEqual(retrievedOID, commitOID)
            
            
            
            let ownerPointer: OpaquePointer = gitCommitOwner(commit: commitPointer)
            
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
                Free.freeCommit(commitPointer)
            }
            
            
            
            let commitLookupPrefixResult: Int32 = gitCommitLookupPrefix(
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
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var commitPointer: OpaquePointer? = nil
            
            defer
            {
                Free.freeCommit(commitPointer)
            }
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         headOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            var author      = GitSignature()
            var committer   = GitSignature()
            
            
            
            let commitAuthorWithMailmapResult: Int32 = gitCommitAuthorWithMailmap(
                out:        &author,
                commit:     commitPointer,
                mailmap:    nil
            )
            
            XCTAssertOK(commitAuthorWithMailmapResult)
            
            
            
            let commitCommitterWithMailmapResult: Int32 = gitCommitCommitterWithMailmap(
                out:        &committer,
                commit:     commitPointer,
                mailmap:    nil
            )
            
            XCTAssertOK(commitCommitterWithMailmapResult)
        }
    }
    
    
    
    func testGitCommitNthGenAncestor() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.createCommit(
                path:       "file1.txt",
                content:    "Content 1",
                message:    "Add file1"
            )
            
            try repository.createCommit(
                path:       "file2.txt",
                content:    "Content 2",
                message:    "Add file2"
            )
            
            
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var commitPointer           : OpaquePointer?    = nil
            var ancestorCommitPointer   : OpaquePointer?    = nil
            
            defer
            {
                Free.freeCommit(commitPointer)
                Free.freeCommit(ancestorCommitPointer)
            }
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         headOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            let commitNthGenAncestorResult: Int32 = gitCommitNthGenAncestor(
                ancestor:   &ancestorCommitPointer,
                commit:     commitPointer,
                n:          2
            )
            
            XCTAssertOK(commitNthGenAncestorResult)
            XCTAssertNotNil(ancestorCommitPointer)
        }
    }
    
    
    
    func testGitCommitParentFunctions() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let commitOID: GitOID = try repository.createCommit(
                path:       "test.txt",
                content:    "Test content",
                message:    "Second commit"
            )
            
            
            
            var commitPointer       : OpaquePointer?    = nil
            var parentCommmiPointer : OpaquePointer?    = nil
            
            defer
            {
                Free.freeCommit(commitPointer)
                Free.freeCommit(parentCommmiPointer)
            }
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
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
            
            
            
            let parentCount: Int = gitCommitParentCount(commit: commitPointer)
            
            XCTAssertEqual(parentCount, 1)
            
            
            
            let commitParentResult: Int32 = gitCommitParent(
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
            
            OID.assertOIDsNotEqual(parentCommitOID, commitOID)
        }
    }
    
    
    
    func testGitCommitRawHeader() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var commitPointer: OpaquePointer? = nil

            defer
            {
                Free.freeCommit(commitPointer)
            }
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         headOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            guard let rawCommitHeader: String = gitCommitRawHeader(commit: commitPointer)
            else
            {
                XCTFail("The raw commit header was nil.")
                return
            }
            
            XCTAssertTrue(rawCommitHeader.contains("tree"))
        }
    }
    
    
    
    func testGitCommitTreeAndTreeID() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var commitPointer   : OpaquePointer?    = nil
            var treePointer     : OpaquePointer?    = nil
            
            defer
            {
                Free.freeCommit(commitPointer)
                Free.freeTree(treePointer)
            }
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
                commit:     &commitPointer,
                repo:       repository.pointer,
                id:         headOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let commitPointer: OpaquePointer = commitPointer
            else
            {
                XCTFail("The commit pointer was nil.")
                return
            }
            
            
            
            let treeOID: GitOID = gitCommitTreeID(commit: commitPointer)
            
            OID.assertOIDsNotEqual(treeOID, GitOID())
            
            
            
            let commitTreeResult: Int32 = gitCommitTree(
                out:        &treePointer,
                commit:     commitPointer
            )
            
            XCTAssertOK(commitTreeResult)
            XCTAssertNotNil(treePointer)
        }
    }
}



// MARK: - Extensions

extension CommitTests
{
    private struct CommitCreateCallbackData
    {
        var callCount   : Int       = 0
        var lastMessage : String?   = nil
    }
    
    
    
    private enum AmendOrDuplicate
    {
        case amend
        case duplicate
    }
    
    
    
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
                Free.freeCommit(newCommitPointer)
                Free.freeCommit(originalCommitPointer)
            }
            
            
            
            let commitLookupResult: Int32 = gitCommitLookup(
                commit:     &originalCommitPointer,
                repo:       repository.pointer,
                id:         originalCommitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let originalCommitPointer: OpaquePointer = originalCommitPointer
            else
            {
                XCTFail("The original commit pointer was nil.")
                return
            }
            
            
            
            var newCommitOID    : GitOID    = GitOID()
            let amendedMessage  : String    = "Amended commit message"
            
            
            
            if type == .amend
            {
                let commitAmendResult: Int32 = gitCommitAmend(
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
                
                
                
                let amendedCommitLookupResult: Int32 = gitCommitLookup(
                    commit:     &newCommitPointer,
                    repo:       repository.pointer,
                    id:         newCommitOID
                )
                
                XCTAssertOK(amendedCommitLookupResult)
            }
            else
            {
                let commitDupResult: Int32 = gitCommitDup(
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
                let retrievedOID: GitOID = gitCommitID(commit: newCommitPointer)
                
                OID.assertOIDsEqual(retrievedOID, newCommitOID)
            }
            
            OID.assertOIDsNotEqual(newCommitOID, originalCommitOID)
            
            
            
            let ownerPointer: OpaquePointer = gitCommitOwner(commit: newCommitPointer)
            
            XCTAssertEqual(ownerPointer, repository.pointer)
            
            
            
            let newCommitMessage: String? = gitCommitMessage(commit: newCommitPointer)
            
            XCTAssertNotNil(newCommitMessage)
            
            
            
            let newCommitSummary: String? = gitCommitSummary(commit: newCommitPointer)
            
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
