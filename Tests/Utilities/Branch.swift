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



/// Branch-related testing utilities.
enum Branch
{
    // MARK: - createLocalBranch()
    
    /// Creates a local branch from the HEAD commit.
    /// - Parameters:
    ///   - branchName: The branch name.
    ///   - repository: The repository in which the branch should be created.
    ///   - force: Whether to overwrite an existing branch.
    ///   - annotated: Whether the branch should be created from an annotated commit.
    ///   - free: Whether the branch should be freed. Use this to create a branch without
    ///   access to the resulting pointer.
    /// - Returns: A pointer to the branch. If `free` is `true`, the pointer will be `nil`.
    /// - Throws: An `NSError` if the branch could not be created.
    ///
    /// ## Discussion
    ///
    /// If `free` is `false`, the caller is responsible for freeing the branch.
    static func createLocalBranch(
        named       branchName  : String,
        in          repository  : Repository,
        force                   : Bool,
        annotated               : Bool,
        free        freeBranch  : Bool
    ) throws -> OpaquePointer?
    {
        var headCommitPointer       : OpaquePointer?    = nil
        var annotatedCommitPointer  : OpaquePointer?    = nil
        var branchPointer           : OpaquePointer?    = nil
        
        defer
        {
            Free.freeCommit(&headCommitPointer)
            Free.freeAnnotatedCommit(&annotatedCommitPointer)
            
            if freeBranch
            {
                Free.freeReference(&branchPointer)
            }
        }
        
        
        
        let headOID: GitOID = OID.getHEADCommitOID(in: repository)
        
        
        
        if annotated
        {
            let annotatedCommitLookup: Int32 = gitAnnotatedCommitLookup(
                out:    &annotatedCommitPointer,
                repo:   repository.pointer,
                id:     headOID
            )
            
            XCTAssertOK(annotatedCommitLookup)
            
            guard let annotatedCommitPointer: OpaquePointer = annotatedCommitPointer
            else
            {
                XCTFail("The annotated commit pointer was nil.")
                
                throw NSError.create(
                    code:       Int(GIT_EUSER.rawValue),
                    message:    "The annotated commit pointer was nil."
                )
            }
            
            
            
            let branchCreateFromAnnotatedResult: Int32 = gitBranchCreateFromAnnotated(
                refOut:         &branchPointer,
                repo:           repository.pointer,
                branchName:     branchName,
                target:         annotatedCommitPointer,
                force:          force
            )
            
            XCTAssertOK(branchCreateFromAnnotatedResult)
        }
        else
        {
            var cHeadOID: git_oid = headOID.cValue
            
            let commitLookupResult: Int32 = git_commit_lookup(
                &headCommitPointer,
                repository.pointer,
                &cHeadOID
            )
            
            XCTAssertOK(commitLookupResult)
            
            guard let headCommitPointer: OpaquePointer = headCommitPointer
            else
            {
                XCTFail("The  was nil.")
                
                throw NSError.create(
                    code:       Int(GIT_EUSER.rawValue),
                    message:    "The HEAD commit pointer was nil."
                )
            }
            
            
            
            let branchCreateResult: Int32 = gitBranchCreate(
                out:            &branchPointer,
                repo:           repository.pointer,
                branchName:     branchName,
                target:         headCommitPointer,
                force:          force
            )
            
            XCTAssertOK(branchCreateResult)
        }
        
        
        
        return branchPointer
    }
    
    
    
    // MARK: - withExistingLocalBranchPointer()
    
    /// Calls the given closure with a pointer to an existing local branch.
    /// - Parameters:
    ///   - branchName: The branch name.
    ///   - repository: The repository in which the branch exists.
    ///   - body: The closure to call.
    /// - Throws: An `Error` thrown by the closure.
    static func withExistingLocalBranchPointer(
        named   branchName  : String,
        in      repository  : Repository,
        _       body        : (inout OpaquePointer?) throws -> Void
    ) rethrows
    {
        var branchPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeReference(&branchPointer)
        }
        
        
        
        let branchLookupResult: Int32 = gitBranchLookup(
            out:            &branchPointer,
            repo:           repository.pointer,
            branchName:     branchName,
            branchType:     .gitBranchLocal
        )
        
        XCTAssertOK(branchLookupResult)
        
        
        
        return try body(&branchPointer)
    }
    
    
    
    // MARK: - withNewLocalBranchPointer()
    
    /// Calls the given closure with a pointer to a local branch created from the HEAD commit.
    /// - Parameters:
    ///   - branchName: The branch name.
    ///   - repository: The repository in which the branch should be created.
    ///   - force: Whether to overwrite an existing branch.
    ///   - annotated: Whether the branch should be created from an annotated commit.
    ///   - body: The closure to call.
    /// - Throws: An `Error` thrown by the closure, or an `NSError` if the branch could not
    /// be created.
    static func withNewLocalBranchPointer(
        named       branchName  : String,
        in          repository  : Repository,
        force                   : Bool,
        annotated               : Bool,
        _           body        : (inout OpaquePointer?) throws -> Void
    ) throws
    {
        var branchPointer: OpaquePointer? = try Branch.createLocalBranch(
            named:      branchName,
            in:         repository,
            force:      force,
            annotated:  annotated,
            free:       false
        )
        
        defer
        {
            Free.freeReference(&branchPointer)
        }
        
        
        
        return try body(&branchPointer)
    }
}
