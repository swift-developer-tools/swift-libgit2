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
@testable import SwiftLibgit2TestUtilities



final class CommitAdvancedTests: XCTestCaseStopOnFail
{
    func testGitCommitCreateFromCallbackWithoutParents() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            try testGitCommitCreateFromCallbacks(
                in:         repository,
                tree:       treePointer,
                parent:     nil
            )
        }
    }
    
    
    
    func testGitCommitCreateFromCallbackWithParents() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            try testGitCommitCreateFromCallbacks(
                in:         repository,
                tree:       treePointer,
                parent:     repository.headOID
            )
        }
    }
    
    
    
    func testGitCommitCreateFromIDsWithoutParents() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            try testGitCommitCreateFromIDs(
                in:         repository,
                tree:       treePointer,
                updateRef:  nil,
                parents:    []
            )
        }
    }
    
    
    
    func testGitCommitCreateFromIDsWithParents() throws
    {
        try Repository.withTree
        {
            repository, treePointer in
            
            try testGitCommitCreateFromIDs(
                in:         repository,
                tree:       treePointer,
                updateRef:  "HEAD",
                parents:    [repository.headOID]
            )
        }
    }
}



private extension CommitAdvancedTests
{
    struct CallbackData
    {
        var callCount   : Int       = 0
        var parent      : git_oid   = git_oid()
        var hasParent   : Bool      = false
    }
    
    
    
    /// Tests creating a commit from a callback.
    /// - Parameters:
    ///   - repository: The repository in which to create the commit.
    ///   - treePointer: The commit tree to use. The underlying type must be
    ///   `git_tree`.
    ///   - parent: The ID of the commits to use as the parent of the commit.
    ///   Pass `nil` to create a commit with no parents.
    /// - Throws: An error if an operation fails.
    func testGitCommitCreateFromCallbacks(
        in      repository  : Repository,
        tree    treePointer : OpaquePointer,
        parent              : GitOID?
    ) throws
    {
        guard let treeOID: GitOID = gitTreeID(tree: treePointer)
        else
        {
            XCTFail("The tree OID was nil.")
            return
        }
        
        XCTAssertNotZeroOID(treeOID)
        
        
        
        var commitOID       : GitOID    = GitOID()
        let commitMessage   : String    = "Create commit from callback"
        var parentCount     : Int       = 0
        
        
        
        var callbackData = CallbackData()
        
        if let parent
        {
            parentCount             = 1
            callbackData.parent     = parent.cValue()
            callbackData.hasParent  = true
        }
        
        
        
        let commitParentCB: GitCommitParentCB =
        {
            idx, payload in
            
            guard let payload
            else
            {
                XCTFail("The payload was nil.")
                return nil
            }
            
            let payloadPointer: UnsafeMutablePointer<CallbackData>
                = payload.assumingMemoryBound(to: CallbackData.self)
            
            payloadPointer.pointee.callCount += 1
            
            if
                idx == 0,
                payloadPointer.pointee.hasParent
            {
                return payloadPointer.pointer(to: \.parent)
            }
            
            return nil
        }
        
        
        
        withUnsafeMutablePointer(to: &callbackData)
        {
            callbackDataPointer in
            
            let commitCreateFromCallbackResult: GitErrorCode
                = gitCommitCreateFromCallback(
                    id:                 &commitOID,
                    repo:               repository.pointer,
                    updateRef:          nil,
                    author:             repository.signature,
                    committer:          repository.signature,
                    messageEncoding:    nil,
                    message:            commitMessage,
                    tree:               treeOID,
                    parentCB:           commitParentCB,
                    parentPayload:      UnsafeMutableRawPointer(callbackDataPointer)
                )
            
            XCTAssertOK(commitCreateFromCallbackResult)
        }
        
        /// The callback will be called once after the last parent.
        XCTAssertEqual(callbackData.callCount, parentCount + 1)
        XCTAssertNotZeroOID(commitOID)
        
        try validateCommit(
            id:             commitOID,
            in:             repository,
            message:        commitMessage,
            tree:           treeOID,
            parentCount:    parentCount
        )
    }
    
    
    
    /// Tests creating a commit from IDs.
    /// - Parameters:
    ///   - repository: The repository in which to create the commit.
    ///   - treePointer: The commit tree to use. The underlying type must be
    ///   `git_tree`.
    ///   - updateRef: The name of the reference to update to point to the
    ///   commit.
    ///   - parents: The IDs of the commits to use as parents of the commit.
    ///   Pass an empty array to create a commit with no parents.
    /// - Throws: An error if an operation fails.
    func testGitCommitCreateFromIDs(
        in          repository  : Repository,
        tree        treePointer : OpaquePointer,
        updateRef               : String?,
        parents                 : [GitOID]
    ) throws
    {
        guard let treeOID: GitOID = gitTreeID(tree: treePointer)
        else
        {
            XCTFail("The tree OID was nil.")
            return
        }
        
        XCTAssertNotZeroOID(treeOID)
        
        
        
        let commitMessage   : String    = "Create commit from IDs"
        var commitOID       : GitOID    = GitOID()
        
        let commitCreateFromIDsResult: GitErrorCode
            = gitCommitCreateFromIDs(
                id:                 &commitOID,
                repo:               repository.pointer,
                updateRef:          updateRef,
                author:             repository.signature,
                committer:          repository.signature,
                messageEncoding:    nil,
                message:            commitMessage,
                tree:               treeOID,
                parentCount:        parents.count,
                parents:            parents
            )
        
        XCTAssertOK(commitCreateFromIDsResult)
        XCTAssertNotZeroOID(commitOID)
        
        try validateCommit(
            id:             commitOID,
            in:             repository,
            message:        commitMessage,
            tree:           treeOID,
            parentCount:    parents.count
        )
    }
    
    
    
    /// Looks up the given commit and validates its properties.
    /// - Parameters:
    ///   - commitOID: The ID of the commit to validate.
    ///   - repository: The repository containing the given remote. The
    ///   underlying type must be `git_repository`.
    ///   - message: The expected commit message.
    ///   - treeOID: The expected tree ID.
    ///   - parentCount: The expected number of parents.
    /// - Throws: An error if an operation fails.
    func validateCommit(
        id              commitOID   : GitOID,
        in              repository  : Repository,
        message                     : String,
        tree            treeOID     : GitOID,
        parentCount                 : Int
    ) throws
    {
        var commitPointer: OpaquePointer? = nil
        
        defer
        {
            gitCommitFree(commit: commitPointer)
        }
        
        
        
        let commitLookupResult: GitErrorCode = gitCommitLookup(
            commit:     &commitPointer,
            repo:       repository.pointer,
            id:         commitOID
        )
        
        XCTAssertOK(commitLookupResult)
        
        guard let commitPointer
        else
        {
            XCTFail("The commit pointer was nil.")
            return
        }
        
        
        
        let retrievedMessage: String? = gitCommitMessage(commit: commitPointer)
        
        XCTAssertNotNil(retrievedMessage)
        XCTAssertEqual(retrievedMessage, message)
        
        
        
        let retrievedTreeOID: GitOID? = gitCommitTreeID(commit: commitPointer)
        
        XCTAssertNotNil(retrievedTreeOID)
        XCTAssertNotZeroOID(retrievedTreeOID)
        XCTAssertEqual(retrievedTreeOID, treeOID)
        
        
        
        guard
            parentCount >= UInt32.min,
            parentCount <= UInt32.max
        else
        {
            XCTFail("The parent count was out of UInt32 range.")
            return
        }
        
        let retrievedParentCount: UInt32
            = gitCommitParentCount(commit: commitPointer)
        
        XCTAssertEqual(retrievedParentCount, UInt32(parentCount))
    }
}
