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



final class MergeTests: XCTestCaseStopOnFail
{
    func testGitMerge() throws
    {
        try withPreparedMerge
        {
            repository, indexPointer, annotatedCommitPointer, _ in
            
            var theirHeads: [OpaquePointer?] = [annotatedCommitPointer]
            
            
            
            var mergeOptions = GitMergeOptions()
            
            mergeOptions.flags      = .gitMergeFailOnConflict
            mergeOptions.fileFavor  = .gitMergeFileFavorOurs
            
            
            
            var checkoutOptions = GitCheckoutOptions()
            
            checkoutOptions.checkoutStrategy    = .gitCheckoutAllowConflicts
            checkoutOptions.ancestorLabel       = "ancestor"
            checkoutOptions.ourLabel            = "ours"
            checkoutOptions.theirLabel          = "theirs"
            checkoutOptions.fileMode            = 0o100644
            
            
            
            let mergeResult: GitErrorCode = gitMerge(
                repo:           repository.pointer,
                theirHeads:     &theirHeads,
                theirHeadsLen:  theirHeads.count,
                mergeOpts:      mergeOptions,
                checkoutOpts:   checkoutOptions
            )
            
            XCTAssertOK(mergeResult)
            
            
            
            let repositoryStateResult: Int32
                = git_repository_state(repository.pointer)
            
            XCTAssertEqual(UInt32(repositoryStateResult), GIT_REPOSITORY_STATE_MERGE.rawValue)
            
            
            
            let indexEntryCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(indexEntryCount, 0)
            
            
            
            let repositoryStateCleanupResult: Int32
                = git_repository_state_cleanup(repository.pointer)
            
            XCTAssertOK(GitErrorCode(rawValue: repositoryStateCleanupResult))
        }
    }
    
    
    
    func testGitMergeAnalysis() throws
    {
        try withPreparedMerge
        {
            repository, _, annotatedCommitPointer, _ in
            
            var mergeAnalysis   : GitMergeAnalysisT     = .gitMergeAnalysisNone
            var mergePreference : GitMergePreferenceT   = .gitMergePreferenceNone
            var theirHeads      : [OpaquePointer?]      = [annotatedCommitPointer]

            
            let mergeAnalysisResult: GitErrorCode = gitMergeAnalysis(
                analysisOut:    &mergeAnalysis,
                preferenceOut:  &mergePreference,
                repo:           repository.pointer,
                theirHeads:     &theirHeads,
                theirHeadsLen:  theirHeads.count
            )
            
            XCTAssertOK(mergeAnalysisResult)
            XCTAssertTrue(mergeAnalysis.contains(.gitMergeAnalysisFastForward))
        }
    }
    
    
    
    func testGitMergeAnalysisForRef() throws
    {
        try withPreparedMerge
        {
            repository, _, annotatedCommitPointer, headReferencePointer in
            
            var mergeAnalysis   : GitMergeAnalysisT     = .gitMergeAnalysisNone
            var mergePreference : GitMergePreferenceT   = .gitMergePreferenceNone
            var theirHeads      : [OpaquePointer?]      = [annotatedCommitPointer]
            
            let mergeAnalysisForRefResult: GitErrorCode
                = gitMergeAnalysisForRef(
                    analysisOut:    &mergeAnalysis,
                    preferenceOut:  &mergePreference,
                    repo:           repository.pointer,
                    ourRef:         headReferencePointer,
                    theirHeads:     &theirHeads,
                    theirHeadsLen:  theirHeads.count
                )
            
            XCTAssertOK(mergeAnalysisForRefResult)
            XCTAssertTrue(mergeAnalysis.contains(.gitMergeAnalysisFastForward))
        }
    }
    
    
    
    func testGitMergeAnalysisT() throws
    {
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisNone.rawValue, GIT_MERGE_ANALYSIS_NONE.rawValue)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisNormal.rawValue, GIT_MERGE_ANALYSIS_NORMAL.rawValue)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisUpToDate.rawValue, GIT_MERGE_ANALYSIS_UP_TO_DATE.rawValue)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisFastForward.rawValue, GIT_MERGE_ANALYSIS_FASTFORWARD.rawValue)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisUnborn.rawValue, GIT_MERGE_ANALYSIS_UNBORN.rawValue)
        
        XCTAssertEqual(GitMergeAnalysisT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisNone.cValue(), GIT_MERGE_ANALYSIS_NONE)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisNormal.cValue(), GIT_MERGE_ANALYSIS_NORMAL)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisUpToDate.cValue(), GIT_MERGE_ANALYSIS_UP_TO_DATE)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisFastForward.cValue(), GIT_MERGE_ANALYSIS_FASTFORWARD)
        XCTAssertEqual(GitMergeAnalysisT.gitMergeAnalysisUnborn.cValue(), GIT_MERGE_ANALYSIS_UNBORN)
        
        XCTAssertEqual(GitMergeAnalysisT(cValue: GIT_MERGE_ANALYSIS_NONE).cValue(), GIT_MERGE_ANALYSIS_NONE)
        XCTAssertEqual(GitMergeAnalysisT(cValue: GIT_MERGE_ANALYSIS_NORMAL).cValue(), GIT_MERGE_ANALYSIS_NORMAL)
        XCTAssertEqual(GitMergeAnalysisT(cValue: GIT_MERGE_ANALYSIS_UP_TO_DATE).cValue(), GIT_MERGE_ANALYSIS_UP_TO_DATE)
        XCTAssertEqual(GitMergeAnalysisT(cValue: GIT_MERGE_ANALYSIS_FASTFORWARD).cValue(), GIT_MERGE_ANALYSIS_FASTFORWARD)
        XCTAssertEqual(GitMergeAnalysisT(cValue: GIT_MERGE_ANALYSIS_UNBORN).cValue(), GIT_MERGE_ANALYSIS_UNBORN)
        
        
        
        let flags: GitMergeAnalysisT =
        [
            .gitMergeAnalysisUnborn,
            .gitMergeAnalysisUpToDate
        ]
        
        XCTAssertTrue(flags.contains(.gitMergeAnalysisUnborn))
        XCTAssertTrue(flags.contains(.gitMergeAnalysisUpToDate))
        XCTAssertFalse(flags.contains(.gitMergeAnalysisFastForward))
    }
    
    
    
    func testGitMergeBaseAndBases() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstCommitOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second commit",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            let thirdCommitOID: GitOID = try repository.commit(
                "Third commit",
                toFile:     "third.txt",
                message:    "Third commit"
            )
            
            
            
            var mergeBase = GitOID()
            
            var mergeBaseResult: GitErrorCode = gitMergeBase(
                out:    &mergeBase,
                repo:   repository.pointer,
                one:    secondCommitOID,
                two:    thirdCommitOID
            )
            
            XCTAssertOK(mergeBaseResult)
            XCTAssertEqual(mergeBase, secondCommitOID)
            
            
            
            var mergeBases: [GitOID] = []
            
            let mergeBasesResult: GitErrorCode = gitMergeBases(
                out:    &mergeBases,
                repo:   repository.pointer,
                one:    secondCommitOID,
                two:    thirdCommitOID
            )
            
            XCTAssertOK(mergeBasesResult)
            XCTAssertEqual(mergeBases.count, 1)
            XCTAssertEqual(mergeBases[0], secondCommitOID)
            
            
            
            mergeBase = GitOID()
            
            mergeBaseResult = gitMergeBase(
                out:    &mergeBase,
                repo:   repository.pointer,
                one:    firstCommitOID,
                two:    thirdCommitOID
            )
            
            XCTAssertOK(mergeBaseResult)
            XCTAssertEqual(mergeBase, firstCommitOID)
        }
    }
    
    
    
    func testGitMergeBaseManyAndBasesMany() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstCommitOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second commit",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            let thirdCommitOID: GitOID = try repository.commit(
                "Third commit",
                toFile:     "third.txt",
                message:    "Third commit"
            )
            
            let fourthCommitOID: GitOID = try repository.commit(
                "Fourth commit",
                toFile:     "fourth.txt",
                message:    "Fourth commit"
            )
            
            
            
            var mergeBase = GitOID()
            
            var inputCommits: [GitOID] =
            [
                secondCommitOID,
                thirdCommitOID,
                fourthCommitOID
            ]
            
            var mergeBaseManyResult: GitErrorCode = gitMergeBaseMany(
                out:            &mergeBase,
                repo:           repository.pointer,
                length:         inputCommits.count,
                inputArray:     inputCommits
            )
            
            XCTAssertOK(mergeBaseManyResult)
            XCTAssertEqual(mergeBase, secondCommitOID)
            
            
            
            var mergeBases: [GitOID] = []
            
            let mergeBasesManyResult: GitErrorCode = gitMergeBasesMany(
                out:            &mergeBases,
                repo:           repository.pointer,
                length:         inputCommits.count,
                inputArray:     inputCommits
            )
            
            XCTAssertOK(mergeBasesManyResult)
            XCTAssertEqual(mergeBases.count, 1)
            XCTAssertEqual(mergeBases[0], secondCommitOID)
            
            
            
            mergeBase = GitOID()
            
            inputCommits =
            [
                firstCommitOID,
                thirdCommitOID,
                fourthCommitOID
            ]
            
            mergeBaseManyResult = gitMergeBaseMany(
                out:            &mergeBase,
                repo:           repository.pointer,
                length:         inputCommits.count,
                inputArray:     inputCommits
            )
            
            XCTAssertOK(mergeBaseManyResult)
            XCTAssertEqual(mergeBase, firstCommitOID)
        }
    }
    
    
    
    func testGitMergeBaseOctopus() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let firstCommitOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let secondCommitOID: GitOID = try repository.commit(
                "Second commit",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            let thirdCommitOID: GitOID = try repository.commit(
                "Third commit",
                toFile:     "third.txt",
                message:    "Third commit"
            )
            
            let fourthCommitOID: GitOID = try repository.commit(
                "Fourth commit",
                toFile:     "fourth.txt",
                message:    "Fourth commit"
            )
            
            
            
            var octopusBase = GitOID()
            
            var inputCommits: [GitOID] =
            [
                secondCommitOID,
                thirdCommitOID,
                fourthCommitOID
            ]
            
            var mergeBaseOctopusResult: GitErrorCode = gitMergeBaseOctopus(
                out:            &octopusBase,
                repo:           repository.pointer,
                length:         inputCommits.count,
                inputArray:     inputCommits
            )
            
            XCTAssertOK(mergeBaseOctopusResult)
            XCTAssertEqual(octopusBase, secondCommitOID)
            
            
            
            octopusBase = GitOID()
            
            inputCommits =
            [
                firstCommitOID,
                secondCommitOID,
                thirdCommitOID,
                fourthCommitOID
            ]
            
            mergeBaseOctopusResult = gitMergeBaseOctopus(
                out:            &octopusBase,
                repo:           repository.pointer,
                length:         inputCommits.count,
                inputArray:     inputCommits
            )
            
            XCTAssertOK(mergeBaseOctopusResult)
            XCTAssertEqual(octopusBase, firstCommitOID)
        }
    }
    
    
    
    func testGitMergeCommits() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var ourCommitPointer    : OpaquePointer?    = nil
            var theirCommitPointer  : OpaquePointer?    = nil
            var indexPointer        : OpaquePointer?    = nil
            
            defer
            {
                gitCommitFree(commit: ourCommitPointer)
                gitCommitFree(commit: theirCommitPointer)
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let baseOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            try repository.commit(
                "Our content\n",
                toFile:     "ours.txt",
                message:    "Our commit"
            )
            
            let ourOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            repository.reset(to: baseOID)
            
            
            
            let ourCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &ourCommitPointer,
                repo:       repository.pointer,
                id:         ourOID
            )
            
            XCTAssertOK(ourCommitLookupResult)
            
            guard let ourCommitPointer: OpaquePointer = ourCommitPointer
            else
            {
                XCTFail("Our commit pointer was nil.")
                return
            }
            
            
            
            let theirCommitLookupResult: GitErrorCode = gitCommitLookup(
                commit:     &theirCommitPointer,
                repo:       repository.pointer,
                id:         ourOID
            )
            
            XCTAssertOK(theirCommitLookupResult)
            
            guard let theirCommitPointer: OpaquePointer = theirCommitPointer
            else
            {
                XCTFail("Their commit pointer was nil.")
                return
            }
            
            
            
            var mergeOptions = GitMergeOptions()
            
            mergeOptions.flags      = .gitMergeFailOnConflict
            mergeOptions.fileFavor  = .gitMergeFileFavorOurs
            
            
            
            let mergeCommitsResult: GitErrorCode = gitMergeCommits(
                out:            &indexPointer,
                repo:           repository.pointer,
                ourCommit:      ourCommitPointer,
                theirCommit:    theirCommitPointer,
                opts:           mergeOptions
            )
            
            XCTAssertOK(mergeCommitsResult)
            
            guard let indexPointer: OpaquePointer = indexPointer
            else
            {
                XCTFail("The index pointer was nil.")
                return
            }
            
            
            
            let indexEntryCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(indexEntryCount, 0)
        }
    }
    
    
    
    func testGitMergeConflictMarkerSize() throws
    {
        XCTAssertEqual(Int32(gitMergeConflictMarkerSize), GIT_MERGE_CONFLICT_MARKER_SIZE)
    }
    
    
    
    func testGitMergeFile() throws
    {
        let fileMode        : UInt32    = 0o100644
        let fileName        : String    = "test.txt"
        let ancestorContent : String    = "Line 1\nLine 2\nLine 3\n"
        let ourContent      : String    = "Line 1\nLine 2\nLine 3\n"
        let theirContent    : String    = "Line 1\nLine 2\nLine 3\nLine 4\n"
        
        
        
        var ancestorFileInput = GitMergeFileInput()
        
        ancestorFileInput.ptr   = Data(ancestorContent.utf8)
        ancestorFileInput.path  = fileName
        ancestorFileInput.mode  = fileMode
        
        var ourFileInput = GitMergeFileInput()
        
        ourFileInput.ptr    = Data(ourContent.utf8)
        ourFileInput.path   = fileName
        ourFileInput.mode   = fileMode
        
        var theirFileInput = GitMergeFileInput()
        
        theirFileInput.ptr      = Data(theirContent.utf8)
        theirFileInput.path     = fileName
        theirFileInput.mode     = fileMode
        
        var mergeFileOptions = GitMergeFileOptions()
        
        mergeFileOptions.ancestorLabel  = "ancestor"
        mergeFileOptions.ourLabel       = "ours"
        mergeFileOptions.theirLabel     = "theirs"
        
        
        
        var mergeFileResult = GitMergeFileResult()
        
        var fileResult: GitErrorCode = gitMergeFile(
            out:        &mergeFileResult,
            ancestor:   ancestorFileInput,
            ours:       ourFileInput,
            theirs:     theirFileInput,
            opts:       mergeFileOptions
        )
        
        XCTAssertOK(fileResult)
        XCTAssertTrue(mergeFileResult.automergeable)
        XCTAssertEqual(mergeFileResult.path, fileName)
        XCTAssertEqual(mergeFileResult.mode, fileMode)
        XCTAssertNotNil(mergeFileResult.ptr)
        XCTAssertGreaterThan(mergeFileResult.len, 0)
        
        
        
        mergeFileResult = GitMergeFileResult()
        
        fileResult = gitMergeFile(
            out:        &mergeFileResult,
            ancestor:   ancestorFileInput,
            ours:       ourFileInput,
            theirs:     theirFileInput,
            opts:       nil
        )
        
        XCTAssertOK(fileResult)
        XCTAssertTrue(mergeFileResult.automergeable)
        XCTAssertEqual(mergeFileResult.path, fileName)
        XCTAssertEqual(mergeFileResult.mode, fileMode)
        XCTAssertNotNil(mergeFileResult.ptr)
        XCTAssertGreaterThan(mergeFileResult.len, 0)
    }
    
    
    
    func testGitMergeFileFromIndex() throws
    {
        try Repository.withRepositoryAndIndexPointer
        {
            repository, indexPointer in
            
            let fileMode    : UInt32    = 0o100644
            let fileName    : String    = "merge.txt"
            let fileContent : String    = "Initial content\n"
            
            
            
            try repository.commit(
                fileContent,
                toFile:     fileName,
                message:    "Initial commit"
            )
            
            let baseOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            try repository.commit(
                "\(fileContent)Our changes\n",
                toFile:     fileName,
                message:    "Our commit"
            )
            
            let ourOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            repository.reset(to: baseOID)
            
            
            
            try repository.commit(
                "\(fileContent)Their changes\n",
                toFile:     fileName,
                message:    "Their commit"
            )
            
            let theirOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            var ancestoryEntry = GitIndexEntry()
            
            ancestoryEntry.path     = fileName
            ancestoryEntry.mode     = fileMode
            ancestoryEntry.id       = baseOID
            
            var ourEntry = GitIndexEntry()
            
            ourEntry.path   = fileName
            ourEntry.mode   = fileMode
            ourEntry.id     = ourOID
            
            var theirEntry = GitIndexEntry()
            
            theirEntry.path     = fileName
            theirEntry.mode     = fileMode
            theirEntry.id       = theirOID
            
            var mergeFileOptions = GitMergeFileOptions()
            
            mergeFileOptions.ancestorLabel  = "ancestor"
            mergeFileOptions.ourLabel       = "ours"
            mergeFileOptions.theirLabel     = "theirs"
            
            
            
            var mergeFileResult = GitMergeFileResult()
            
            var mergeFileFromIndexResult: GitErrorCode = gitMergeFileFromIndex(
                out:        &mergeFileResult,
                repo:       repository.pointer,
                ancestor:   ancestoryEntry,
                ours:       ourEntry,
                theirs:     theirEntry,
                opts:       mergeFileOptions
            )
            
            XCTAssertOK(mergeFileFromIndexResult)
            XCTAssertFalse(mergeFileResult.automergeable)
            XCTAssertEqual(mergeFileResult.path, fileName)
            XCTAssertEqual(mergeFileResult.mode, fileMode)
            XCTAssertNotNil(mergeFileResult.ptr)
            XCTAssertGreaterThan(mergeFileResult.len, 0)
            
            
            
            mergeFileResult = GitMergeFileResult()
            
            mergeFileFromIndexResult = gitMergeFileFromIndex(
                out:        &mergeFileResult,
                repo:       repository.pointer,
                ancestor:   ancestoryEntry,
                ours:       ourEntry,
                theirs:     theirEntry,
                opts:       nil
            )
            
            XCTAssertOK(mergeFileFromIndexResult)
            XCTAssertFalse(mergeFileResult.automergeable)
            XCTAssertEqual(mergeFileResult.path, fileName)
            XCTAssertEqual(mergeFileResult.mode, fileMode)
            XCTAssertNotNil(mergeFileResult.ptr)
            XCTAssertGreaterThan(mergeFileResult.len, 0)
        }
    }
    
    
    
    func testGitMergeFileFavorT() throws
    {
        XCTAssertEqual(GitMergeFileFavorT.gitMergeFileFavorNormal.cValue(), GIT_MERGE_FILE_FAVOR_NORMAL)
        XCTAssertEqual(GitMergeFileFavorT.gitMergeFileFavorOurs.cValue(), GIT_MERGE_FILE_FAVOR_OURS)
        XCTAssertEqual(GitMergeFileFavorT.gitMergeFileFavorTheirs.cValue(), GIT_MERGE_FILE_FAVOR_THEIRS)
        XCTAssertEqual(GitMergeFileFavorT.gitMergeFileFavorUnion.cValue(), GIT_MERGE_FILE_FAVOR_UNION)
        
        XCTAssertNil(GitMergeFileFavorT(rawValue: 123))
        
        XCTAssertEqual(GitMergeFileFavorT(cValue: GIT_MERGE_FILE_FAVOR_NORMAL), .gitMergeFileFavorNormal)
        XCTAssertEqual(GitMergeFileFavorT(cValue: GIT_MERGE_FILE_FAVOR_OURS), .gitMergeFileFavorOurs)
        XCTAssertEqual(GitMergeFileFavorT(cValue: GIT_MERGE_FILE_FAVOR_THEIRS), .gitMergeFileFavorTheirs)
        XCTAssertEqual(GitMergeFileFavorT(cValue: GIT_MERGE_FILE_FAVOR_UNION), .gitMergeFileFavorUnion)
    }
    
    
    
    func testGitMergeFileFlagT() throws
    {
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileDefault.rawValue, GIT_MERGE_FILE_DEFAULT.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileStyleMerge.rawValue, GIT_MERGE_FILE_STYLE_MERGE.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileStyleDiff3.rawValue, GIT_MERGE_FILE_STYLE_DIFF3.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileSimplifyAlnum.rawValue, GIT_MERGE_FILE_SIMPLIFY_ALNUM.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileIgnoreWhitespace.rawValue, GIT_MERGE_FILE_IGNORE_WHITESPACE.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileIgnoreWhitespaceChange.rawValue, GIT_MERGE_FILE_IGNORE_WHITESPACE_CHANGE.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileIgnoreWhitespaceEOL.rawValue, GIT_MERGE_FILE_IGNORE_WHITESPACE_EOL.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileDiffPatience.rawValue, GIT_MERGE_FILE_DIFF_PATIENCE.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileDiffMinimal.rawValue, GIT_MERGE_FILE_DIFF_MINIMAL.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileStyleZDiff3.rawValue, GIT_MERGE_FILE_STYLE_ZDIFF3.rawValue)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileAcceptConflicts.rawValue, GIT_MERGE_FILE_ACCEPT_CONFLICTS.rawValue)
        
        XCTAssertEqual(GitMergeFileFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileDefault.cValue(), GIT_MERGE_FILE_DEFAULT)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileStyleMerge.cValue(), GIT_MERGE_FILE_STYLE_MERGE)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileStyleDiff3.cValue(), GIT_MERGE_FILE_STYLE_DIFF3)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileSimplifyAlnum.cValue(), GIT_MERGE_FILE_SIMPLIFY_ALNUM)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileIgnoreWhitespace.cValue(), GIT_MERGE_FILE_IGNORE_WHITESPACE)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileIgnoreWhitespaceChange.cValue(), GIT_MERGE_FILE_IGNORE_WHITESPACE_CHANGE)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileIgnoreWhitespaceEOL.cValue(), GIT_MERGE_FILE_IGNORE_WHITESPACE_EOL)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileDiffPatience.cValue(), GIT_MERGE_FILE_DIFF_PATIENCE)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileDiffMinimal.cValue(), GIT_MERGE_FILE_DIFF_MINIMAL)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileStyleZDiff3.cValue(), GIT_MERGE_FILE_STYLE_ZDIFF3)
        XCTAssertEqual(GitMergeFileFlagT.gitMergeFileAcceptConflicts.cValue(), GIT_MERGE_FILE_ACCEPT_CONFLICTS)
        
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_DEFAULT).cValue(), GIT_MERGE_FILE_DEFAULT)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_STYLE_MERGE).cValue(), GIT_MERGE_FILE_STYLE_MERGE)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_STYLE_DIFF3).cValue(), GIT_MERGE_FILE_STYLE_DIFF3)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_SIMPLIFY_ALNUM).cValue(), GIT_MERGE_FILE_SIMPLIFY_ALNUM)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_IGNORE_WHITESPACE).cValue(), GIT_MERGE_FILE_IGNORE_WHITESPACE)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_IGNORE_WHITESPACE_CHANGE).cValue(), GIT_MERGE_FILE_IGNORE_WHITESPACE_CHANGE)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_IGNORE_WHITESPACE_EOL).cValue(), GIT_MERGE_FILE_IGNORE_WHITESPACE_EOL)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_DIFF_PATIENCE).cValue(), GIT_MERGE_FILE_DIFF_PATIENCE)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_DIFF_MINIMAL).cValue(), GIT_MERGE_FILE_DIFF_MINIMAL)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_STYLE_ZDIFF3).cValue(), GIT_MERGE_FILE_STYLE_ZDIFF3)
        XCTAssertEqual(GitMergeFileFlagT(cValue: GIT_MERGE_FILE_ACCEPT_CONFLICTS).cValue(), GIT_MERGE_FILE_ACCEPT_CONFLICTS)
        
        
        
        let flags: GitMergeFileFlagT =
        [
            .gitMergeFileStyleMerge,
            .gitMergeFileSimplifyAlnum
        ]
        
        XCTAssertTrue(flags.contains(.gitMergeFileStyleMerge))
        XCTAssertTrue(flags.contains(.gitMergeFileSimplifyAlnum))
        XCTAssertFalse(flags.contains(.gitMergeFileIgnoreWhitespaceEOL))
    }
    
    
    
    func testGitMergeFileInput() throws
    {
        let mergeFileInput = GitMergeFileInput()
        
        XCTAssertEqual(mergeFileInput.version, gitMergeFileInputVersion)
        XCTAssertNil(mergeFileInput.ptr)
        XCTAssertEqual(mergeFileInput.size, 0)
        XCTAssertNil(mergeFileInput.path)
        XCTAssertEqual(mergeFileInput.mode, 0)
        
        try mergeFileInput.withCValue
        {
            cMergeFileInput in
            
            XCTAssertEqual(cMergeFileInput.pointee.version, gitMergeFileInputVersion)
            XCTAssertNil(cMergeFileInput.pointee.ptr)
            XCTAssertEqual(cMergeFileInput.pointee.size, 0)
            XCTAssertNil(cMergeFileInput.pointee.path)
            XCTAssertEqual(cMergeFileInput.pointee.mode, 0)
        }
    }
    
    
    
    func testGitMergeFileInputInit() throws
    {
        var mergeFileInput = git_merge_file_input()
        
        let mergeFileInputInitResult: GitErrorCode = gitMergeFileInputInit(
            opts:       &mergeFileInput,
            version:    gitMergeFileInputVersion
        )
        
        XCTAssertOK(mergeFileInputInitResult)
    }
    
    
    
    func testGitMergeFileInputVersion() throws
    {
        XCTAssertEqual(Int32(gitMergeFileInputVersion), GIT_MERGE_FILE_INPUT_VERSION)
    }
    
    
    
    func testGitMergeFileOptions() throws
    {
        let mergeFileOptions = GitMergeFileOptions()
        
        XCTAssertEqual(mergeFileOptions.version, gitMergeFileOptionsVersion)
        XCTAssertNil(mergeFileOptions.ancestorLabel)
        XCTAssertNil(mergeFileOptions.ourLabel)
        XCTAssertNil(mergeFileOptions.theirLabel)
        XCTAssertEqual(mergeFileOptions.favor, .gitMergeFileFavorNormal)
        XCTAssertEqual(mergeFileOptions.flags, .gitMergeFileDefault)
        XCTAssertEqual(mergeFileOptions.markerSize, gitMergeConflictMarkerSize)
        
        try mergeFileOptions.withCValue
        {
            cMergeFileOptions in
            
            XCTAssertEqual(cMergeFileOptions.pointee.version, gitMergeFileOptionsVersion)
            XCTAssertNil(cMergeFileOptions.pointee.ancestor_label)
            XCTAssertNil(cMergeFileOptions.pointee.our_label)
            XCTAssertNil(cMergeFileOptions.pointee.their_label)
            XCTAssertEqual(GitMergeFileFavorT(cValue: cMergeFileOptions.pointee.favor), .gitMergeFileFavorNormal)
            XCTAssertEqual(GitMergeFileFlagT(rawValue: cMergeFileOptions.pointee.flags), .gitMergeFileDefault)
            XCTAssertEqual(cMergeFileOptions.pointee.marker_size, gitMergeConflictMarkerSize)
        }
    }
    
    
    
    func testGitMergeFileOptionsInit() throws
    {
        var mergeFileOptions = git_merge_file_options()
        
        let mergeFileOptionsInitResult: GitErrorCode = gitMergeFileOptionsInit(
            opts:       &mergeFileOptions,
            version:    gitMergeFileOptionsVersion
        )
        
        XCTAssertOK(mergeFileOptionsInitResult)
    }
    
    
    
    func testGitMergeFileOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitMergeFileOptionsVersion), GIT_MERGE_FILE_OPTIONS_VERSION)
    }
    
    
    
    func testGitMergeFileResult() throws
    {
        let mergeFileResult = GitMergeFileResult()
        
        XCTAssertFalse(mergeFileResult.automergeable)
        XCTAssertNil(mergeFileResult.path)
        XCTAssertEqual(mergeFileResult.mode, 0)
        XCTAssertNil(mergeFileResult.ptr)
        XCTAssertEqual(mergeFileResult.len, 0)
        
        mergeFileResult.withCValue
        {
            cMergeFileResult in
            
            XCTAssertFalse(Bool(cMergeFileResult.pointee.automergeable))
            XCTAssertNil(cMergeFileResult.pointee.path)
            XCTAssertEqual(cMergeFileResult.pointee.mode, 0)
            XCTAssertNil(cMergeFileResult.pointee.ptr)
            XCTAssertEqual(cMergeFileResult.pointee.len, 0)
        }
    }
    
    
    
    func testGitMergeFileResultFree() throws
    {
        var mergeFileResult = git_merge_file_result()
        
        gitMergeFileResultFree(result: &mergeFileResult)
        gitMergeFileResultFree(result: &mergeFileResult)
        gitMergeFileResultFree(result: nil)
    }
    
    
    
    func testGitMergeFlagT() throws
    {
        XCTAssertEqual(GitMergeFlagT.gitMergeFindRenames.rawValue, GIT_MERGE_FIND_RENAMES.rawValue)
        XCTAssertEqual(GitMergeFlagT.gitMergeFailOnConflict.rawValue, GIT_MERGE_FAIL_ON_CONFLICT.rawValue)
        XCTAssertEqual(GitMergeFlagT.gitMergeSkipREUC.rawValue, GIT_MERGE_SKIP_REUC.rawValue)
        XCTAssertEqual(GitMergeFlagT.gitMergeNoRecursive.rawValue, GIT_MERGE_NO_RECURSIVE.rawValue)
        XCTAssertEqual(GitMergeFlagT.gitMergeVirtualBase.rawValue, GIT_MERGE_VIRTUAL_BASE.rawValue)
        
        XCTAssertEqual(GitMergeFlagT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitMergeFlagT.gitMergeFindRenames.cValue(), GIT_MERGE_FIND_RENAMES)
        XCTAssertEqual(GitMergeFlagT.gitMergeFailOnConflict.cValue(), GIT_MERGE_FAIL_ON_CONFLICT)
        XCTAssertEqual(GitMergeFlagT.gitMergeSkipREUC.cValue(), GIT_MERGE_SKIP_REUC)
        XCTAssertEqual(GitMergeFlagT.gitMergeNoRecursive.cValue(), GIT_MERGE_NO_RECURSIVE)
        XCTAssertEqual(GitMergeFlagT.gitMergeVirtualBase.cValue(), GIT_MERGE_VIRTUAL_BASE)
        
        XCTAssertEqual(GitMergeFlagT(cValue: GIT_MERGE_FIND_RENAMES).cValue(), GIT_MERGE_FIND_RENAMES)
        XCTAssertEqual(GitMergeFlagT(cValue: GIT_MERGE_FAIL_ON_CONFLICT).cValue(), GIT_MERGE_FAIL_ON_CONFLICT)
        XCTAssertEqual(GitMergeFlagT(cValue: GIT_MERGE_SKIP_REUC).cValue(), GIT_MERGE_SKIP_REUC)
        XCTAssertEqual(GitMergeFlagT(cValue: GIT_MERGE_NO_RECURSIVE).cValue(), GIT_MERGE_NO_RECURSIVE)
        XCTAssertEqual(GitMergeFlagT(cValue: GIT_MERGE_VIRTUAL_BASE).cValue(), GIT_MERGE_VIRTUAL_BASE)
        
        
        
        let flags: GitMergeFlagT =
        [
            .gitMergeFailOnConflict,
            .gitMergeNoRecursive
        ]
        
        XCTAssertTrue(flags.contains(.gitMergeFailOnConflict))
        XCTAssertTrue(flags.contains(.gitMergeNoRecursive))
        XCTAssertFalse(flags.contains(.gitMergeVirtualBase))
    }
    
    
    
    func testGitMergeOptions() throws
    {
        let mergeOptions = GitMergeOptions()
        
        XCTAssertEqual(mergeOptions.version, gitMergeOptionsVersion)
        XCTAssertEqual(mergeOptions.flags, .gitMergeFindRenames)
        XCTAssertEqual(mergeOptions.renameThreshold, 50)
        XCTAssertEqual(mergeOptions.targetLimit, 200)
        XCTAssertNil(mergeOptions.metric)
        XCTAssertEqual(mergeOptions.recursionLimit, 0)
        XCTAssertNil(mergeOptions.defaultDriver)
        XCTAssertEqual(mergeOptions.fileFavor, .gitMergeFileFavorNormal)
        XCTAssertEqual(mergeOptions.fileFlags, .gitMergeFileDefault)
        
        try mergeOptions.withCValue
        {
            cMergeOptions in
            
            XCTAssertEqual(cMergeOptions.pointee.version, gitMergeOptionsVersion)
            XCTAssertEqual(GitMergeFlagT(rawValue: cMergeOptions.pointee.flags), .gitMergeFindRenames)
            XCTAssertEqual(cMergeOptions.pointee.rename_threshold, 50)
            XCTAssertEqual(cMergeOptions.pointee.target_limit, 200)
            XCTAssertNil(cMergeOptions.pointee.metric)
            XCTAssertEqual(cMergeOptions.pointee.recursion_limit, 0)
            XCTAssertNil(cMergeOptions.pointee.default_driver)
            XCTAssertEqual(GitMergeFileFavorT(cValue: cMergeOptions.pointee.file_favor), .gitMergeFileFavorNormal)
            XCTAssertEqual(GitMergeFileFlagT(rawValue: cMergeOptions.pointee.file_flags), .gitMergeFileDefault)
        }
    }
    
    
    
    func testGitMergeOptionsInit() throws
    {
        var mergeOptions = git_merge_options()
        
        let mergeOptionsInitResult: GitErrorCode = gitMergeOptionsInit(
            opts:       &mergeOptions,
            version:    gitMergeOptionsVersion
        )
        
        XCTAssertOK(mergeOptionsInitResult)
    }
    
    
    
    func testGitMergeOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitMergeOptionsVersion), GIT_MERGE_OPTIONS_VERSION)
    }
    
    
    
    func testGitMergePreferenceT() throws
    {
        XCTAssertEqual(GitMergePreferenceT.gitMergePreferenceNone.rawValue, GIT_MERGE_PREFERENCE_NONE.rawValue)
        XCTAssertEqual(GitMergePreferenceT.gitMergePreferenceNoFastForward.rawValue, GIT_MERGE_PREFERENCE_NO_FASTFORWARD.rawValue)
        XCTAssertEqual(GitMergePreferenceT.gitMergePreferenceFastForwardOnly.rawValue, GIT_MERGE_PREFERENCE_FASTFORWARD_ONLY.rawValue)
        
        XCTAssertEqual(GitMergePreferenceT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitMergePreferenceT.gitMergePreferenceNone.cValue(), GIT_MERGE_PREFERENCE_NONE)
        XCTAssertEqual(GitMergePreferenceT.gitMergePreferenceNoFastForward.cValue(), GIT_MERGE_PREFERENCE_NO_FASTFORWARD)
        XCTAssertEqual(GitMergePreferenceT.gitMergePreferenceFastForwardOnly.cValue(), GIT_MERGE_PREFERENCE_FASTFORWARD_ONLY)
        
        XCTAssertEqual(GitMergePreferenceT(cValue: GIT_MERGE_PREFERENCE_NONE).cValue(), GIT_MERGE_PREFERENCE_NONE)
        XCTAssertEqual(GitMergePreferenceT(cValue: GIT_MERGE_PREFERENCE_NO_FASTFORWARD).cValue(), GIT_MERGE_PREFERENCE_NO_FASTFORWARD)
        XCTAssertEqual(GitMergePreferenceT(cValue: GIT_MERGE_PREFERENCE_FASTFORWARD_ONLY).cValue(), GIT_MERGE_PREFERENCE_FASTFORWARD_ONLY)
        
        
        
        let flags: GitMergePreferenceT =
        [
            .gitMergePreferenceNoFastForward
        ]
        
        XCTAssertTrue(flags.contains(.gitMergePreferenceNoFastForward))
        XCTAssertFalse(flags.contains(.gitMergePreferenceFastForwardOnly))
    }
    
    
    
    func testGitMergeTrees() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var ancestorTreePointer : OpaquePointer?    = nil
            var ourTreePointer      : OpaquePointer?    = nil
            var theirTreePointer    : OpaquePointer?    = nil
            var indexPointer        : OpaquePointer?    = nil
            
            defer
            {
                Free.freeTree(ancestorTreePointer)
                Free.freeTree(ourTreePointer)
                Free.freeTree(theirTreePointer)
                gitIndexFree(index: indexPointer)
            }
            
            
            
            let ancestorCommitTreeResult: GitErrorCode
                = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return gitCommitTree(
                    out:        &ancestorTreePointer,
                    commit:     commitPointer
                )
            }
            
            XCTAssertOK(ancestorCommitTreeResult)
            
            
            
            try repository.commit(
                "Our content\n",
                toFile:     "ours.txt",
                message:    "Our commit"
            )
            
            
            
            let ourCommitTreeResult: GitErrorCode
                = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return gitCommitTree(
                    out:        &ourTreePointer,
                    commit:     commitPointer
                )
            }
            
            XCTAssertOK(ourCommitTreeResult)
            
            guard let ourTreePointer: OpaquePointer = ourTreePointer
            else
            {
                XCTFail("Our tree pointer was nil.")
                return
            }
            
            let ourOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            
            
            repository.reset(to: OID.getHEADCommitOID(in: repository))
            
            
            
            try repository.commit(
                "Their content\n",
                toFile:     "theirs.txt",
                message:    "Their commit"
            )
            
            
            
            let theirCommitTreeResult: GitErrorCode
                = try Commit.withHEADCommit(in: repository)
            {
                commitPointer in
                
                return gitCommitTree(
                    out:        &theirTreePointer,
                    commit:     commitPointer
                )
            }
            
            XCTAssertOK(theirCommitTreeResult)
            
            guard let theirTreePointer: OpaquePointer = theirTreePointer
            else
            {
                XCTFail("Their tree pointer was nil.")
                return
            }
            
            
            
            repository.reset(to: ourOID)
            
            
            
            var mergeOptions = GitMergeOptions()
            
            mergeOptions.flags      = .gitMergeFailOnConflict
            mergeOptions.fileFavor  = .gitMergeFileFavorOurs
            
            
            
            let mergeTreesResult: GitErrorCode = gitMergeTrees(
                out:            &indexPointer,
                repo:           repository.pointer,
                ancestorTree:   ancestorTreePointer,
                ourTree:        ourTreePointer,
                theirTree:      theirTreePointer,
                opts:           mergeOptions
            )
            
            XCTAssertOK(mergeTreesResult)
            
            guard let indexPointer: OpaquePointer = indexPointer
            else
            {
                XCTFail("The index pointer was nil.")
                return
            }
            
            
            
            let indexEntryCount: Int = gitIndexEntryCount(index: indexPointer)
            
            XCTAssertGreaterThan(indexEntryCount, 0)
        }
    }
}



// MARK: - Extensions

extension MergeTests
{
    /// Calls the given closure with a ``Repository`` instance, a pointer
    /// to the repository's index, a pointer to an annotated commit, and a
    /// pointer to the HEAD reference, after preparing the repostiory for a
    /// merge operation.
    /// - Parameter body: The closure to call.
    /// - Throws: An error if an operation fails.
    private func withPreparedMerge(
        _ body: (Repository, OpaquePointer, OpaquePointer, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepositoryAndIndexPointer
        {
            repository, indexPointer in
            
            let branchName: String = "feature/test"
            
            let initialHeadOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            try Branch.createLocalBranch(
                named:      branchName,
                in:         repository,
                force:      false,
                annotated:  false,
                free:       true
            )
            
            try repository.commit(
                "Branch content",
                toFile:     "branch.txt",
                message:    "Branch commit"
            )
            
            
            
            var annotatedCommitPointer  : OpaquePointer?    = nil
            var headReferencePointer    : OpaquePointer?    = nil
            
            defer
            {
                gitAnnotatedCommitFree(commit: annotatedCommitPointer)
                Free.freeReference(headReferencePointer)
            }
            
            
            
            let branchHeadOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let annotatedCommitLookupResult: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     branchHeadOID
                )
            
            XCTAssertOK(annotatedCommitLookupResult)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                return
            }
            
            
            
            repository.reset(to: initialHeadOID)
            
            
            
            let referenceLookupResult: Int32 = git_reference_lookup(
                &headReferencePointer,
                repository.pointer,
                "HEAD"
            )
            
            XCTAssertOK(GitErrorCode(rawValue: referenceLookupResult))
            
            guard let headReferencePointer: OpaquePointer
                    = headReferencePointer
            else
            {
                XCTFail("The HEAD reference pointer was nil.")
                return
            }
            
            
            
            return try body(
                repository,
                indexPointer,
                annotatedCommitPointer,
                headReferencePointer
            )
        }
    }
}
