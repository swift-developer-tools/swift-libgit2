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



final class StatusTests: XCTestCaseStopOnFail
{
    func testGitStatusFile() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let fileName: String = "file.txt"
            
            try repository.commit(
                "Tracked content",
                toFile:     fileName,
                message:    "Add file"
            )
            
            
            
            var status = GitStatusT()
            
            var statusFileResult: GitErrorCode = gitStatusFile(
                statusFlags:    &status,
                repo:           repository.pointer,
                path:           fileName
            )
            
            XCTAssertOK(statusFileResult)
            XCTAssertTrue(status.contains(.gitStatusCurrent))
            
            
            
            try repository.modifyFile(
                at:     fileName,
                with:   "Modified content"
            )
            
            
            
            statusFileResult = gitStatusFile(
                statusFlags:    &status,
                repo:           repository.pointer,
                path:           fileName
            )
            
            XCTAssertOK(statusFileResult)
            XCTAssertTrue(status.contains(.gitStatusCurrent))
            XCTAssertTrue(status.contains(.gitStatusWTModified))
            
            
            
            statusFileResult = gitStatusFile(
                statusFlags:    &status,
                repo:           repository.pointer,
                path:           "non-existent.txt"
            )
            
            XCTAssertNotOK(statusFileResult)
        }
    }
    
    
    
    func testGitStatusForEach() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let trackedFileName     : String    = "tracked.txt"
            let untrackedFileName   : String    = "untracked.txt"
            
            try repository.commit(
                "Initial content",
                toFile:     trackedFileName,
                message:    "Initial commit"
            )
            
            try repository.modifyFile(
                at:     untrackedFileName,
                with:   "Untracked content"
            )
            
            try repository.modifyFile(
                at:     trackedFileName,
                with:   "Modified content"
            )
            
            
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let statusForEachResult: GitErrorCode = gitStatusForEach(
                    repo:       repository.pointer,
                    callback:   Self.statusCB,
                    payload:    UnsafeMutableRawPointer(callbackDataPointer)
                )
                
                XCTAssertOK(statusForEachResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            
            
            
            guard let trackedFileIndex: Int
                    = callbackData.paths.firstIndex(of: trackedFileName)
            else
            {
                XCTFail("The tracked file index was nil.")
                return
            }
            
            guard let untrackedFileIndex: Int
                    = callbackData.paths.firstIndex(of: untrackedFileName)
            else
            {
                XCTFail("The untracked file index was nil.")
                return
            }
            
            
            
            let trackedFileStatus: GitStatusT
                = callbackData.statuses[trackedFileIndex]
            
            XCTAssertEqual(trackedFileStatus, .gitStatusWTModified)
            
            
            
            let untrackedFileStatus: GitStatusT
                = callbackData.statuses[untrackedFileIndex]
            
            XCTAssertEqual(untrackedFileStatus, .gitStatusWTNew)
        }
    }
    
    
    
    func testGitStatusForEachExt() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let rootFileName            : String    = "root.txt"
            let subdirectoryName        : String    = "subdirectory/"
            let subdirectoryFileName    : String    = "subdirectory-file.txt"
            let untrackedFileName       : String    = "untracked.txt"
            let ignoredFileName         : String    = "file.ignored"
            
            try repository.commit(
                "Tracked in root",
                toFile:     rootFileName,
                message:    "Add root"
            )
            
            try repository.createDirectory(at: subdirectoryName)
            
            try repository.commit(
                "Tracked in subdirectory",
                toFile:     "\(subdirectoryName)\(subdirectoryFileName)",
                message:    "Add subdirectory"
            )
            
            try repository.modifyFile(
                at:     ".gitignore",
                with:   "*.ignored\n"
            )
            
            try repository.commit(
                ".gitignore",
                toFile:     ".gitignore",
                message:    "Add gitignore"
            )
            
            try repository.modifyFile(
                at:     untrackedFileName,
                with:   "Untracked"
            )
            
            try repository.modifyFile(
                at:     ignoredFileName,
                with:   "Ignored"
            )
            
            try repository.modifyFile(
                at:     rootFileName,
                with:   "Modified content"
            )
            
            try repository.modifyFile(
                at:     "\(subdirectoryName)\(subdirectoryFileName)",
                with:   "Modified content"
            )
            
            
            
            var statusOptions = GitStatusOptions()
            
            statusOptions.show = .gitStatusShowIndexAndWorkdir
            
            statusOptions.flags =
            [
                .gitStatusOptIncludeUntracked,
                .gitStatusOptIncludeIgnored
            ]
            
            
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let statusForEachExtResult: GitErrorCode
                    = gitStatusForEachExt(
                        repo:       repository.pointer,
                        opts:       statusOptions,
                        callback:   Self.statusCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(statusForEachExtResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            XCTAssertTrue(callbackData.paths.contains(rootFileName))
            XCTAssertTrue(callbackData.paths.contains(untrackedFileName))
            XCTAssertTrue(callbackData.paths.contains(ignoredFileName))
            
            
            
            statusOptions = GitStatusOptions()
            
            statusOptions.show      = .gitStatusShowIndexAndWorkdir
            statusOptions.flags     = .gitStatusOptIncludeUntracked
            statusOptions.pathspec  = ["\(subdirectoryName)*"]
            
            
            
            callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let statusForEachExtResult: GitErrorCode
                    = gitStatusForEachExt(
                        repo:       repository.pointer,
                        opts:       statusOptions,
                        callback:   Self.statusCB,
                        payload:    UnsafeMutableRawPointer(callbackDataPointer)
                    )
                
                XCTAssertOK(statusForEachExtResult)
            }
            
            XCTAssertGreaterThan(callbackData.callCount, 0)
            XCTAssertTrue(callbackData.paths.allSatisfy { $0.hasPrefix(subdirectoryName) })
        }
    }
    
    
    
    func testGitStatusEntry() throws
    {
        let statusEntry = GitStatusEntry(cValue: git_status_entry())
        
        XCTAssertEqual(statusEntry.status, .gitStatusCurrent)
        XCTAssertNil(statusEntry.headToIndex)
        XCTAssertNil(statusEntry.indexToWorkdir)
        
        try statusEntry.withCValue
        {
            cStatusEntry in
            
            XCTAssertEqual(GitStatusT(cValue: cStatusEntry.pointee.status), .gitStatusCurrent)
            XCTAssertNil(cStatusEntry.pointee.head_to_index)
            XCTAssertNil(cStatusEntry.pointee.index_to_workdir)
        }
    }
    
    
    
    func testGitStatusList() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try repository.commit(
                "First content",
                toFile:     "first.txt",
                message:    "First commit"
            )
            
            try repository.commit(
                "Second content",
                toFile:     "second.txt",
                message:    "Second commit"
            )
            
            try repository.modifyFile(
                at:     "first.txt",
                with:   "Modified content"
            )
            
            try repository.modifyFile(
                at:     "untracked.txt",
                with:   "Untracked content"
            )
            
            
            
            var statusListPointer: OpaquePointer? = nil
            
            defer
            {
                gitStatusListFree(statusList: statusListPointer)
            }
            
            
            
            var statusOptions = GitStatusOptions()
            
            statusOptions.show = .gitStatusShowIndexAndWorkdir
            
            statusOptions.flags =
            [
                .gitStatusOptIncludeUntracked,
                .gitStatusOptRenamesHEADToIndex,
                .gitStatusOptRenamesIndexToWorkdir
            ]
            
            
            
            let statusListNewResult: GitErrorCode = gitStatusListNew(
                out:    &statusListPointer,
                repo:   repository.pointer,
                opts:   statusOptions
            )
            
            XCTAssertOK(statusListNewResult)
            
            guard let statusListPointer: OpaquePointer = statusListPointer
            else
            {
                XCTFail("The status list pointer was nil.")
                return
            }
            
            
            
            let entryCount: Int
                = gitStatusListEntryCount(statusList: statusListPointer)
            
            XCTAssertGreaterThan(entryCount, 0)
            
            
            
            var foundModified   : Bool  = false
            var foundUntracked  : Bool  = false
            
            for index in 0..<entryCount
            {
                guard let statusEntry: GitStatusEntry = gitStatusByIndex(
                    statusList:     statusListPointer,
                    idx:            index
                )
                else
                {
                    XCTFail("The status entry was nil.")
                    return
                }
                
                
                
                if statusEntry.status.contains(.gitStatusWTModified)
                {
                    foundModified = true
                }
                
                if statusEntry.status.contains(.gitStatusWTNew)
                {
                    foundUntracked = true
                }
            }
            
            XCTAssertTrue(foundModified)
            XCTAssertTrue(foundUntracked)
        }
    }
    
    
    
    func testGitStatusListFree() throws
    {
        gitStatusListFree(statusList: nil)
    }
    
    
    
    func testGitStatusOptionsInit() throws
    {
        var statusOptions = git_status_options()
        
        let statusOptionsInitResult: GitErrorCode = gitStatusOptionsInit(
            opts:       &statusOptions,
            version:    gitStatusOptionsVersion
        )
        
        XCTAssertOK(statusOptionsInitResult)
    }
    
    
    
    func testGitStatusOptions() throws
    {
        let statusOptions = GitStatusOptions()
        
        XCTAssertEqual(statusOptions.version, gitStatusOptionsVersion)
        XCTAssertEqual(statusOptions.show, .gitStatusShowIndexAndWorkdir)
        XCTAssertEqual(statusOptions.flags, [])
        XCTAssertEqual(statusOptions.pathspec, [])
        XCTAssertNil(statusOptions.baseline)
        XCTAssertEqual(statusOptions.renameThreshold, 50)
        
        try statusOptions.withCValue
        {
            cStatusOptions in
            
            XCTAssertEqual(cStatusOptions.pointee.version, gitStatusOptionsVersion)
            XCTAssertEqual(GitStatusShowT(cValue: cStatusOptions.pointee.show), .gitStatusShowIndexAndWorkdir)
            XCTAssertEqual(GitStatusOptT(rawValue: cStatusOptions.pointee.flags), [])
            XCTAssertEqual(Array(cStatusOptions.pointee.pathspec), [])
            XCTAssertNil(cStatusOptions.pointee.baseline)
            XCTAssertEqual(cStatusOptions.pointee.rename_threshold, 50)
        }
    }
    
    
    
    func testGitStatusOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitStatusOptionsVersion), GIT_STATUS_OPTIONS_VERSION)
    }
    
    
    
    func testGitStatusOptDefaults() throws
    {
        let defaults: GitStatusOptT =
        [
            .gitStatusOptIncludeIgnored,
            .gitStatusOptIncludeUntracked,
            .gitStatusOptRecurseUntrackedDirs
        ]
        
        XCTAssertEqual(gitStatusOptDefaults, defaults)
    }
    
    
    
    func testGitStatusOptT() throws
    {
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUntracked.rawValue, GIT_STATUS_OPT_INCLUDE_UNTRACKED.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeIgnored.rawValue, GIT_STATUS_OPT_INCLUDE_IGNORED.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUnmodified.rawValue, GIT_STATUS_OPT_INCLUDE_UNMODIFIED.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptExcludeSubmodules.rawValue, GIT_STATUS_OPT_EXCLUDE_SUBMODULES.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRecurseUntrackedDirs.rawValue, GIT_STATUS_OPT_RECURSE_UNTRACKED_DIRS.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptDisablePathspecMatch.rawValue, GIT_STATUS_OPT_DISABLE_PATHSPEC_MATCH.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRecurseIgnoredDirs.rawValue, GIT_STATUS_OPT_RECURSE_IGNORED_DIRS.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRenamesHEADToIndex.rawValue, GIT_STATUS_OPT_RENAMES_HEAD_TO_INDEX.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRenamesIndexToWorkdir.rawValue, GIT_STATUS_OPT_RENAMES_INDEX_TO_WORKDIR.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptSortCaseSensitively.rawValue, GIT_STATUS_OPT_SORT_CASE_SENSITIVELY.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptSortCaseInsensitively.rawValue, GIT_STATUS_OPT_SORT_CASE_INSENSITIVELY.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRenamesFromRewrites.rawValue, GIT_STATUS_OPT_RENAMES_FROM_REWRITES.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptNoRefresh.rawValue, GIT_STATUS_OPT_NO_REFRESH.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptUpdateIndex.rawValue, GIT_STATUS_OPT_UPDATE_INDEX.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUnreadable.rawValue, GIT_STATUS_OPT_INCLUDE_UNREADABLE.rawValue)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUnreadableAsUntracked.rawValue, GIT_STATUS_OPT_INCLUDE_UNREADABLE_AS_UNTRACKED.rawValue)
        
        XCTAssertEqual(GitStatusOptT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUntracked.cValue(), GIT_STATUS_OPT_INCLUDE_UNTRACKED)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeIgnored.cValue(), GIT_STATUS_OPT_INCLUDE_IGNORED)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUnmodified.cValue(), GIT_STATUS_OPT_INCLUDE_UNMODIFIED)
        XCTAssertEqual(GitStatusOptT.gitStatusOptExcludeSubmodules.cValue(), GIT_STATUS_OPT_EXCLUDE_SUBMODULES)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRecurseUntrackedDirs.cValue(), GIT_STATUS_OPT_RECURSE_UNTRACKED_DIRS)
        XCTAssertEqual(GitStatusOptT.gitStatusOptDisablePathspecMatch.cValue(), GIT_STATUS_OPT_DISABLE_PATHSPEC_MATCH)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRecurseIgnoredDirs.cValue(), GIT_STATUS_OPT_RECURSE_IGNORED_DIRS)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRenamesHEADToIndex.cValue(), GIT_STATUS_OPT_RENAMES_HEAD_TO_INDEX)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRenamesIndexToWorkdir.cValue(), GIT_STATUS_OPT_RENAMES_INDEX_TO_WORKDIR)
        XCTAssertEqual(GitStatusOptT.gitStatusOptSortCaseSensitively.cValue(), GIT_STATUS_OPT_SORT_CASE_SENSITIVELY)
        XCTAssertEqual(GitStatusOptT.gitStatusOptSortCaseInsensitively.cValue(), GIT_STATUS_OPT_SORT_CASE_INSENSITIVELY)
        XCTAssertEqual(GitStatusOptT.gitStatusOptRenamesFromRewrites.cValue(), GIT_STATUS_OPT_RENAMES_FROM_REWRITES)
        XCTAssertEqual(GitStatusOptT.gitStatusOptNoRefresh.cValue(), GIT_STATUS_OPT_NO_REFRESH)
        XCTAssertEqual(GitStatusOptT.gitStatusOptUpdateIndex.cValue(), GIT_STATUS_OPT_UPDATE_INDEX)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUnreadable.cValue(), GIT_STATUS_OPT_INCLUDE_UNREADABLE)
        XCTAssertEqual(GitStatusOptT.gitStatusOptIncludeUnreadableAsUntracked.cValue(), GIT_STATUS_OPT_INCLUDE_UNREADABLE_AS_UNTRACKED)
        
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_INCLUDE_UNTRACKED), .gitStatusOptIncludeUntracked)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_INCLUDE_IGNORED), .gitStatusOptIncludeIgnored)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_INCLUDE_UNMODIFIED), .gitStatusOptIncludeUnmodified)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_EXCLUDE_SUBMODULES), .gitStatusOptExcludeSubmodules)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_RECURSE_UNTRACKED_DIRS), .gitStatusOptRecurseUntrackedDirs)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_DISABLE_PATHSPEC_MATCH), .gitStatusOptDisablePathspecMatch)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_RECURSE_IGNORED_DIRS), .gitStatusOptRecurseIgnoredDirs)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_RENAMES_HEAD_TO_INDEX), .gitStatusOptRenamesHEADToIndex)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_RENAMES_INDEX_TO_WORKDIR), .gitStatusOptRenamesIndexToWorkdir)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_SORT_CASE_SENSITIVELY), .gitStatusOptSortCaseSensitively)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_SORT_CASE_INSENSITIVELY), .gitStatusOptSortCaseInsensitively)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_RENAMES_FROM_REWRITES), .gitStatusOptRenamesFromRewrites)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_NO_REFRESH), .gitStatusOptNoRefresh)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_UPDATE_INDEX), .gitStatusOptUpdateIndex)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_INCLUDE_UNREADABLE), .gitStatusOptIncludeUnreadable)
        XCTAssertEqual(GitStatusOptT(cValue: GIT_STATUS_OPT_INCLUDE_UNREADABLE_AS_UNTRACKED), .gitStatusOptIncludeUnreadableAsUntracked)
        
        
        
        let flags: GitStatusOptT =
        [
            .gitStatusOptExcludeSubmodules,
            .gitStatusOptRenamesIndexToWorkdir
        ]
        
        XCTAssertTrue(flags.contains(.gitStatusOptExcludeSubmodules))
        XCTAssertTrue(flags.contains(.gitStatusOptRenamesIndexToWorkdir))
        XCTAssertFalse(flags.contains(.gitStatusOptIncludeUnreadable))
    }
    
    
    
    func testGitStatusShouldIgnore() throws
    {
        try Repository.withRepository
        {
            repository in
            
            let gitignoreContent: String =
            """
            *.log
            temp/
            """
            
            let gitignoreURL: URL = repository.url.appending(
                path:           ".gitignore",
                directoryHint:  .notDirectory
            )
            
            try gitignoreContent.atomicWrite(to: gitignoreURL)
            
            
            
            let fileNamesAndIgnoredResults: [String : Bool] =
            [
                "debug.log"     : true,
                "file.txt"      : false,
                "temp/file.txt" : true
            ]
            
            
            
            for (fileName, ignoredResult) in fileNamesAndIgnoredResults
            {
                var isIgnored: Bool = false
                
                let statusShouldIgnoreResult: GitErrorCode
                    = gitStatusShouldIgnore(
                        ignored:    &isIgnored,
                        repo:       repository.pointer,
                        path:       fileName
                    )
                
                XCTAssertOK(statusShouldIgnoreResult)
                XCTAssertEqual(isIgnored, ignoredResult)
            }
        }
    }
    
    
    
    func testGitStatusShowT() throws
    {
        XCTAssertEqual(GitStatusShowT.gitStatusShowIndexAndWorkdir.rawValue, GIT_STATUS_SHOW_INDEX_AND_WORKDIR.rawValue)
        XCTAssertEqual(GitStatusShowT.gitStatusShowIndexOnly.rawValue, GIT_STATUS_SHOW_INDEX_ONLY.rawValue)
        XCTAssertEqual(GitStatusShowT.gitStatusShowWorkdirOnly.rawValue, GIT_STATUS_SHOW_WORKDIR_ONLY.rawValue)
        
        XCTAssertNil(GitStatusShowT(rawValue: 123))
        
        XCTAssertEqual(GitStatusShowT.gitStatusShowIndexAndWorkdir.cValue(), GIT_STATUS_SHOW_INDEX_AND_WORKDIR)
        XCTAssertEqual(GitStatusShowT.gitStatusShowIndexOnly.cValue(), GIT_STATUS_SHOW_INDEX_ONLY)
        XCTAssertEqual(GitStatusShowT.gitStatusShowWorkdirOnly.cValue(), GIT_STATUS_SHOW_WORKDIR_ONLY)
        
        XCTAssertEqual(GitStatusShowT(cValue: GIT_STATUS_SHOW_INDEX_AND_WORKDIR), .gitStatusShowIndexAndWorkdir)
        XCTAssertEqual(GitStatusShowT(cValue: GIT_STATUS_SHOW_INDEX_ONLY), .gitStatusShowIndexOnly)
        XCTAssertEqual(GitStatusShowT(cValue: GIT_STATUS_SHOW_WORKDIR_ONLY), .gitStatusShowWorkdirOnly)
    }
    
    
    
    func testGitStatusT() throws
    {
        XCTAssertEqual(GitStatusT.gitStatusCurrent.rawValue, GIT_STATUS_CURRENT.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusIndexNew.rawValue, GIT_STATUS_INDEX_NEW.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusIndexModified.rawValue, GIT_STATUS_INDEX_MODIFIED.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusIndexDeleted.rawValue, GIT_STATUS_INDEX_DELETED.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusIndexRenamed.rawValue, GIT_STATUS_INDEX_RENAMED.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusIndexTypeChange.rawValue, GIT_STATUS_INDEX_TYPECHANGE.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusWTNew.rawValue, GIT_STATUS_WT_NEW.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusWTModified.rawValue, GIT_STATUS_WT_MODIFIED.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusWTDeleted.rawValue, GIT_STATUS_WT_DELETED.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusWTTypeChange.rawValue, GIT_STATUS_WT_TYPECHANGE.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusWTRenamed.rawValue, GIT_STATUS_WT_RENAMED.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusWTUnreadable.rawValue, GIT_STATUS_WT_UNREADABLE.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusIgnored.rawValue, GIT_STATUS_IGNORED.rawValue)
        XCTAssertEqual(GitStatusT.gitStatusConflicted.rawValue, GIT_STATUS_CONFLICTED.rawValue)
        
        XCTAssertEqual(GitStatusT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitStatusT.gitStatusCurrent.cValue(), GIT_STATUS_CURRENT)
        XCTAssertEqual(GitStatusT.gitStatusIndexNew.cValue(), GIT_STATUS_INDEX_NEW)
        XCTAssertEqual(GitStatusT.gitStatusIndexModified.cValue(), GIT_STATUS_INDEX_MODIFIED)
        XCTAssertEqual(GitStatusT.gitStatusIndexDeleted.cValue(), GIT_STATUS_INDEX_DELETED)
        XCTAssertEqual(GitStatusT.gitStatusIndexRenamed.cValue(), GIT_STATUS_INDEX_RENAMED)
        XCTAssertEqual(GitStatusT.gitStatusIndexTypeChange.cValue(), GIT_STATUS_INDEX_TYPECHANGE)
        XCTAssertEqual(GitStatusT.gitStatusWTNew.cValue(), GIT_STATUS_WT_NEW)
        XCTAssertEqual(GitStatusT.gitStatusWTModified.cValue(), GIT_STATUS_WT_MODIFIED)
        XCTAssertEqual(GitStatusT.gitStatusWTDeleted.cValue(), GIT_STATUS_WT_DELETED)
        XCTAssertEqual(GitStatusT.gitStatusWTTypeChange.cValue(), GIT_STATUS_WT_TYPECHANGE)
        XCTAssertEqual(GitStatusT.gitStatusWTRenamed.cValue(), GIT_STATUS_WT_RENAMED)
        XCTAssertEqual(GitStatusT.gitStatusWTUnreadable.cValue(), GIT_STATUS_WT_UNREADABLE)
        XCTAssertEqual(GitStatusT.gitStatusIgnored.cValue(), GIT_STATUS_IGNORED)
        XCTAssertEqual(GitStatusT.gitStatusConflicted.cValue(), GIT_STATUS_CONFLICTED)
        
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_CURRENT), .gitStatusCurrent)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_INDEX_NEW), .gitStatusIndexNew)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_INDEX_MODIFIED), .gitStatusIndexModified)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_INDEX_DELETED), .gitStatusIndexDeleted)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_INDEX_RENAMED), .gitStatusIndexRenamed)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_INDEX_TYPECHANGE), .gitStatusIndexTypeChange)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_WT_NEW), .gitStatusWTNew)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_WT_MODIFIED), .gitStatusWTModified)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_WT_DELETED), .gitStatusWTDeleted)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_WT_TYPECHANGE), .gitStatusWTTypeChange)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_WT_RENAMED), .gitStatusWTRenamed)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_WT_UNREADABLE), .gitStatusWTUnreadable)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_IGNORED), .gitStatusIgnored)
        XCTAssertEqual(GitStatusT(cValue: GIT_STATUS_CONFLICTED), .gitStatusConflicted)
        
        
        
        let flags: GitStatusT =
        [
            .gitStatusIndexDeleted,
            .gitStatusIndexDeleted
        ]
        
        XCTAssertTrue(flags.contains(.gitStatusIndexDeleted))
        XCTAssertTrue(flags.contains(.gitStatusIndexDeleted))
        XCTAssertFalse(flags.contains(.gitStatusIgnored))
    }
}



// MARK: - Extensions

private extension StatusTests
{
    struct CallbackData
    {
        var callCount   : Int           = 0
        var paths       : [String]      = []
        var statuses    : [GitStatusT]  = []
    }
    
    
    
    static let statusCB: GitStatusCB =
    {
        path, statusFlags, payload in
        
        guard let payload: UnsafeMutableRawPointer = payload
        else
        {
            XCTFail("The payload was nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.callCount += 1
        
        if let path = String(optionalCString: path)
        {
            payloadPointer.pointee.paths.append(path)
        }
        
        payloadPointer.pointee.statuses.append(
            GitStatusT(rawValue: statusFlags)
        )
        
        return GitErrorCode.gitOK.rawValue
    }
}
