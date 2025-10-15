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



final class NotesTests: XCTestCaseStopOnFail
{
    func testGitNoteAuthor() throws
    {
        try withRepositoryAndNote
        {
            _, notePointer, _ in
            
            let signature: GitSignature? = gitNoteAuthor(note: notePointer)
            
            XCTAssertNotNil(signature)
            XCTAssertNotNil(signature?.name)
            XCTAssertNotNil(signature?.email)
            XCTAssertEqual(signature?.name, Repository.commitAuthorName)
            XCTAssertEqual(signature?.email, Repository.commitAuthorEmail)
        }
    }
    
    
    
    func testGitNoteCommitCreateAndRead() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID         : GitOID    = OID.getHEADCommitOID(in: repository)
            var notesCommitOID  : GitOID    = GitOID()
            var notesBlobOID    : GitOID    = GitOID()
            
            let noteCommitCreateResult: GitErrorCode = gitNoteCommitCreate(
                notesCommitOut:         &notesCommitOID,
                notesBlobOut:           &notesBlobOID,
                repo:                   repository.pointer,
                parent:                 nil,
                author:                 repository.signature,
                committer:              repository.signature,
                oid:                    headOID,
                note:                   Self.defaultNoteMessage,
                allowNoteOverwrite:     false
            )
            
            XCTAssertOK(noteCommitCreateResult)
            XCTAssertNotZeroOID(notesCommitOID)
            XCTAssertNotZeroOID(notesBlobOID)
            
            
            
            var notesCommitPointer  : OpaquePointer?    = nil
            var notePointer         : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: notesCommitPointer)
                gitNoteFree(note: notePointer)
            }
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &notesCommitPointer,
                repo:       repository.pointer,
                id:         notesCommitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let notesCommitPointer: OpaquePointer = notesCommitPointer
            else
            {
                XCTFail("The notes commit pointer was nil.")
                return
            }
            
            
            
            let noteCommitReadResult: GitErrorCode = gitNoteCommitRead(
                out:            &notePointer,
                repo:           repository.pointer,
                notesCommit:    notesCommitPointer,
                oid:            headOID
            )
            
            XCTAssertOK(noteCommitReadResult)
            
            guard let notePointer: OpaquePointer = notePointer
            else
            {
                XCTFail("The note pointer was nil.")
                return
            }
            
            
            
            let retrievedNoteMessage: String?
                = gitNoteMessage(note: notePointer)
            
            XCTAssertNotNil(retrievedNoteMessage)
            XCTAssertEqual(retrievedNoteMessage, Self.defaultNoteMessage)
            
            
            
            let retrievedNoteOID: GitOID = gitNoteID(note: notePointer)
            
            XCTAssertEqual(retrievedNoteOID, notesBlobOID)
        }
    }
    
    
    
    func testGitNoteCommitIteratorNewAndNext() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second commit content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            
            
            var firstNotesCommitOID     = GitOID()
            var firstNotesBlobOID       = GitOID()
            var secondNotesCommitOID    = GitOID()
            var secondNotesBlobOID      = GitOID()
            
            var firstNotesCommitPointer     : OpaquePointer?    = nil
            var secondNotesCommitPointer    : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: firstNotesCommitPointer)
                gitCommitFree(commit: secondNotesCommitPointer)
            }
            
            
            
            let firstNoteCommitCreateResult: GitErrorCode
                = gitNoteCommitCreate(
                    notesCommitOut:         &firstNotesCommitOID,
                    notesBlobOut:           &firstNotesBlobOID,
                    repo:                   repository.pointer,
                    parent:                 nil,
                    author:                 repository.signature,
                    committer:              repository.signature,
                    oid:                    headOID,
                    note:                   "First commit note",
                    allowNoteOverwrite:     false
                )
            
            XCTAssertOK(firstNoteCommitCreateResult)
            XCTAssertNotZeroOID(firstNotesCommitOID)
            XCTAssertNotZeroOID(firstNotesBlobOID)
            
            
            
            let firstCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &firstNotesCommitPointer,
                repo:       repository.pointer,
                id:         firstNotesCommitOID
            )
            
            XCTAssertOK(firstCommitLookupResult)
            XCTAssertNotNil(firstNotesCommitPointer)
            
            
            
            let secondNoteCommitCreateResult: GitErrorCode
                = gitNoteCommitCreate(
                    notesCommitOut:         &secondNotesCommitOID,
                    notesBlobOut:           &secondNotesBlobOID,
                    repo:                   repository.pointer,
                    parent:                 firstNotesCommitPointer,
                    author:                 repository.signature,
                    committer:              repository.signature,
                    oid:                    secondCommitOID,
                    note:                   "Second commit note",
                    allowNoteOverwrite:     false
                )
            
            XCTAssertOK(secondNoteCommitCreateResult)
            XCTAssertNotZeroOID(secondNotesCommitOID)
            XCTAssertNotZeroOID(secondNotesBlobOID)
            
            
            
            let secondCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &secondNotesCommitPointer,
                repo:       repository.pointer,
                id:         secondNotesCommitOID
            )
            
            XCTAssertOK(secondCommitLookupResult)
            
            guard let secondNotesCommitPointer: OpaquePointer
                    = secondNotesCommitPointer
            else
            {
                XCTFail("The second notes commit pointer was nil.")
                return
            }
            
            
            
            var iteratorPointer: OpaquePointer? = nil
            
            defer
            {
                gitNoteIteratorFree(it: iteratorPointer)
            }
            
            
            
            let noteCommitIteratorNewResult: GitErrorCode
                = gitNoteCommitIteratorNew(
                    out:            &iteratorPointer,
                    notesCommit:    secondNotesCommitPointer
                )
            
            XCTAssertOK(noteCommitIteratorNewResult)
            
            guard let iteratorPointer: OpaquePointer = iteratorPointer
            else
            {
                XCTFail("The note iterator pointer was nil.")
                return
            }
            
            
            
            var noteCount: Int = 0
            
            while true
            {
                var noteOID         = GitOID()
                var annotatedOID    = GitOID()
                
                let noteNextResult: GitErrorCode = gitNoteNext(
                    noteID:         &noteOID,
                    annotatedID:    &annotatedOID,
                    it:             iteratorPointer
                )
                
                if noteNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(noteNextResult)
                XCTAssertNotZeroOID(noteOID)
                XCTAssertNotZeroOID(annotatedOID)
                
                noteCount += 1
            }
            
            XCTAssertEqual(noteCount, 2)
        }
    }
    
    
    
    func testGitNoteCommitRemove() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            var notesCommitOID  = GitOID()
            var notesBlobOID    = GitOID()
            
            let noteCommitCreateResult: GitErrorCode = gitNoteCommitCreate(
                notesCommitOut:         &notesCommitOID,
                notesBlobOut:           &notesBlobOID,
                repo:                   repository.pointer,
                parent:                 nil,
                author:                 repository.signature,
                committer:              repository.signature,
                oid:                    headOID,
                note:                   "Goodbye World!",
                allowNoteOverwrite:     false
            )
            
            XCTAssertOK(noteCommitCreateResult)
            XCTAssertNotZeroOID(notesCommitOID)
            XCTAssertNotZeroOID(notesBlobOID)
            
            
            
            var notesCommitPointer      : OpaquePointer?    = nil
            var newNotesCommitPointer   : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: notesCommitPointer)
                gitCommitFree(commit: newNotesCommitPointer)
            }
            
            
            
            let commitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &notesCommitPointer,
                repo:       repository.pointer,
                id:         notesCommitOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let notesCommitPointer: OpaquePointer = notesCommitPointer
            else
            {
                XCTFail("The notes commit pointer was nil.")
                return
            }
            
            
            
            var newNotesCommitOID = GitOID()
            
            let noteCommitRemoveResult: GitErrorCode = gitNoteCommitRemove(
                notesCommitOut:     &newNotesCommitOID,
                repo:               repository.pointer,
                notesCommit:        notesCommitPointer,
                author:             repository.signature,
                committer:          repository.signature,
                oid:                headOID
            )
            
            XCTAssertOK(noteCommitRemoveResult)
            XCTAssertNotZeroOID(newNotesCommitOID)
            XCTAssertNotEqual(newNotesCommitOID, notesCommitOID)
            
            
            
            let newCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &newNotesCommitPointer,
                repo:       repository.pointer,
                id:         newNotesCommitOID
            )
            
            XCTAssertOK(newCommitLookupResult)
            
            guard let newNotesCommitPointer: OpaquePointer
                    = newNotesCommitPointer
            else
            {
                XCTFail("The new notes commit pointer was nil.")
                return
            }
            
            
            
            var invalidNotePointer: OpaquePointer? = nil
            
            defer
            {
                gitNoteFree(note: invalidNotePointer)
            }
            
            
            
            let noteCommitReadResult: GitErrorCode = gitNoteCommitRead(
                out:            &invalidNotePointer,
                repo:           repository.pointer,
                notesCommit:    newNotesCommitPointer,
                oid:            headOID
            )
            
            XCTAssertNotOK(noteCommitReadResult)
            XCTAssertNil(invalidNotePointer)
        }
    }
    
    
    
    func testGitNoteCommitter() throws
    {
        try withRepositoryAndNote
        {
            _, notePointer, _ in
            
            let signature: GitSignature? = gitNoteCommitter(note: notePointer)
            
            XCTAssertNotNil(signature)
            XCTAssertNotNil(signature?.name)
            XCTAssertNotNil(signature?.email)
            XCTAssertEqual(signature?.name, Repository.commitAuthorName)
            XCTAssertEqual(signature?.email, Repository.commitAuthorEmail)
        }
    }
    
    
    
    func testGitNoteCreateAndRead() throws
    {
        try withRepositoryAndNote
        {
            _, notePointer, noteOID in
            
            let retrievedNoteMessage: String?
                = gitNoteMessage(note: notePointer)
            
            XCTAssertNotNil(retrievedNoteMessage)
            XCTAssertEqual(retrievedNoteMessage, Self.defaultNoteMessage)
            
            
            
            let retrievedNoteOID: GitOID = gitNoteID(note: notePointer)
            
            XCTAssertEqual(retrievedNoteOID, noteOID)
        }
    }
    
    
    
    func testGitNoteDefaultRef() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var buffer = GitBuf()
            
            defer
            {
                XCTAssertOK(gitBufDispose(buffer: &buffer))
            }
            
            
            
            let noteDefaultResult: GitErrorCode = gitNoteDefaultRef(
                out:    &buffer,
                repo:   repository.pointer
            )
            
            XCTAssertOK(noteDefaultResult)
            XCTAssertNotNil(buffer.ptr)
            XCTAssertGreaterThan(buffer.size, 0)
            
            guard let defaultReference = String(optionalCString: buffer.ptr)
            else
            {
                XCTFail("The default reference was nil.")
                return
            }
            
            XCTAssertTrue(defaultReference.hasPrefix("refs/notes"))
        }
    }
    
    
    
    func testGitNoteForEach() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            var firstNoteOID = GitOID()
            
            let firstNoteCreateResult: GitErrorCode = gitNoteCreate(
                out         : &firstNoteOID,
                repo        : repository.pointer,
                notesRef    : nil,
                author      : repository.signature,
                committer   : repository.signature,
                oid         : headOID,
                note        : "First note",
                force       : false
            )
            
            XCTAssertOK(firstNoteCreateResult)
            XCTAssertNotZeroOID(firstNoteOID)
            
            
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second commit content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            var secondNoteOID = GitOID()
            
            let secondNoteCreateResult: GitErrorCode = gitNoteCreate(
                out         : &secondNoteOID,
                repo        : repository.pointer,
                notesRef    : nil,
                author      : repository.signature,
                committer   : repository.signature,
                oid         : secondCommitOID,
                note        : "Second note",
                force       : false
            )
            
            XCTAssertOK(secondNoteCreateResult)
            XCTAssertNotZeroOID(secondNoteOID)
            
            
            
            var callbackData = CallbackData()
            
            let noteForEachCB: GitNoteForEachCB =
            {
                blobID, annotatedObjectID, payload in
                
                guard let payload: UnsafeMutableRawPointer = payload
                else
                {
                    XCTFail("The payload was nil.")
                    return GitErrorCode.gitUnknown(-123).rawValue
                }
                
                let payloadPointer: UnsafeMutablePointer<CallbackData>
                    = payload.assumingMemoryBound(to: CallbackData.self)
                
                payloadPointer.pointee.callCount += 1
                
                if let blobOID: git_oid = blobID?.pointee
                {
                    payloadPointer.pointee.noteOIDs.append(
                        GitOID(cValue: blobOID)
                    )
                }
                
                if let annotatedObjectOID: git_oid = annotatedObjectID?.pointee
                {
                    payloadPointer.pointee.annotatedOIDs.append(
                        GitOID(cValue: annotatedObjectOID)
                    )
                }
                
                return GitErrorCode.gitOK.rawValue
            }
            
            
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let noteForEachResult: GitErrorCode = gitNoteForEach(
                    repo:       repository.pointer,
                    notesRef:   nil,
                    noteCB:     noteForEachCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(noteForEachResult)
            }
            
            XCTAssertEqual(callbackData.callCount, 2)
            XCTAssertEqual(callbackData.noteOIDs.count, 2)
            XCTAssertEqual(callbackData.annotatedOIDs.count, 2)
            
            let firstNoteOIDIsContained: Bool =
                gitOIDEqual(a: callbackData.noteOIDs[0], b: firstNoteOID) ||
                gitOIDEqual(a: callbackData.noteOIDs[1], b: firstNoteOID)
            
            let secondNoteOIDIsContained: Bool =
                gitOIDEqual(a: callbackData.noteOIDs[0], b: secondNoteOID) ||
                gitOIDEqual(a: callbackData.noteOIDs[1], b: secondNoteOID)
            
            XCTAssertTrue(firstNoteOIDIsContained)
            XCTAssertTrue(secondNoteOIDIsContained)
        }
    }
    
    
    
    func testGitNoteFree() throws
    {
        gitNoteFree(note: nil)
    }
    
    
    
    func testGitNoteIteratorFree() throws
    {
        gitNoteIteratorFree(it: nil)
    }
    
    
    
    func testGitNoteIteratorNewAndNext() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            var firstNoteOID = GitOID()
            
            let firstNoteCreateResult: GitErrorCode = gitNoteCreate(
                out         : &firstNoteOID,
                repo        : repository.pointer,
                notesRef    : nil,
                author      : repository.signature,
                committer   : repository.signature,
                oid         : headOID,
                note        : "First note",
                force       : false
            )
            
            XCTAssertOK(firstNoteCreateResult)
            XCTAssertNotZeroOID(firstNoteOID)
            
            
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second commit content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            var secondNoteOID = GitOID()
            
            let secondNoteCreateResult: GitErrorCode = gitNoteCreate(
                out         : &secondNoteOID,
                repo        : repository.pointer,
                notesRef    : nil,
                author      : repository.signature,
                committer   : repository.signature,
                oid         : secondCommitOID,
                note        : "Second note",
                force       : false
            )
            
            XCTAssertOK(secondNoteCreateResult)
            XCTAssertNotZeroOID(secondNoteOID)
            
            
            
            var iteratorPointer: OpaquePointer? = nil
            
            defer
            {
                gitNoteIteratorFree(it: iteratorPointer)
            }
            
            
            
            let noteIteratorNewResult: GitErrorCode = gitNoteIteratorNew(
                out:        &iteratorPointer,
                repo:       repository.pointer,
                notesRef:   nil
            )
            
            XCTAssertOK(noteIteratorNewResult)
            
            guard let iteratorPointer: OpaquePointer = iteratorPointer
            else
            {
                XCTFail("The note iterator pointer was nil.")
                return
            }
            
            
            
            var noteCount: Int = 0
            
            while true
            {
                var noteOID         = GitOID()
                var annotatedOID    = GitOID()
                
                let noteNextResult: GitErrorCode = gitNoteNext(
                    noteID:         &noteOID,
                    annotatedID:    &annotatedOID,
                    it:             iteratorPointer
                )
                
                if noteNextResult == .gitIterOver
                {
                    break
                }
                
                XCTAssertOK(noteNextResult)
                XCTAssertNotZeroOID(noteOID)
                XCTAssertNotZeroOID(annotatedOID)
                
                noteCount += 1
            }
            
            XCTAssertEqual(noteCount, 2)
        }
    }
    
    
    
    func testGitNoteRemove() throws
    {
        try withRepositoryAndNote
        {
            repository, _, _ in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let noteRemoveResult: GitErrorCode = gitNoteRemove(
                repo:       repository.pointer,
                notesRef:   nil,
                author:     repository.signature,
                committer:  repository.signature,
                oid:        headOID
            )
            
            XCTAssertOK(noteRemoveResult)
            
            
            
            var invalidNotePointer: OpaquePointer? = nil
            
            defer
            {
                gitNoteFree(note: invalidNotePointer)
            }
            
            
            
            let noteReadResult: GitErrorCode = gitNoteRead(
                out:        &invalidNotePointer,
                repo:       repository.pointer,
                notesRef:   nil,
                oid:        headOID
            )
            
            XCTAssertNotOK(noteReadResult)
            XCTAssertNil(invalidNotePointer)
        }
    }
}



// MARK: - Extensions

extension NotesTests
{
    private static let defaultNoteMessage: String = "Hello World!"
    
    
    
    private struct CallbackData
    {
        var callCount       : Int       = 0
        var noteOIDs        : [GitOID]  = []
        var annotatedOIDs   : [GitOID]  = []
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance, a pointer to
    /// a created, and the ID of that note.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    private func withRepositoryAndNote(
        _ body: (Repository, OpaquePointer, GitOID) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            var noteOID = GitOID()
            
            let noteCreateResult: GitErrorCode = gitNoteCreate(
                out         : &noteOID,
                repo        : repository.pointer,
                notesRef    : nil,
                author      : repository.signature,
                committer   : repository.signature,
                oid         : headOID,
                note        : Self.defaultNoteMessage,
                force       : false
            )
            
            XCTAssertOK(noteCreateResult)
            XCTAssertNotZeroOID(noteOID)
            
            
            
            var notePointer: OpaquePointer? = nil
            
            defer
            {
                gitNoteFree(note: notePointer)
            }
            
            
            
            let noteReadResult: GitErrorCode = gitNoteRead(
                out:        &notePointer,
                repo:       repository.pointer,
                notesRef:   nil,
                oid:        headOID
            )
            
            XCTAssertOK(noteReadResult)
            
            guard let notePointer: OpaquePointer = notePointer
            else
            {
                XCTFail("The note pointer was nil.")
                return
            }
            
            
            
            return try body(
                repository,
                notePointer,
                noteOID
            )
        }
    }
}
