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



/// Branch-related testing utilities.
enum Branch
{
    /// Creates a local branch from the HEAD commit.
    /// - Parameters:
    ///   - branchName: The branch name.
    ///   - repository: The repository in which the branch should be created.
    ///   - force: Whether to overwrite an existing branch.
    ///   - annotated: Whether the branch should be created from an annotated
    ///   commit.
    ///   - free: Whether the branch should be freed. Use this to create a
    ///   branch without access to the resulting pointer.
    /// - Returns: A pointer to the branch. If `free` is `true`, the pointer
    /// will be `nil`.
    /// - Throws: An error if an operation fails.
    ///
    /// ## Discussion
    ///
    /// If `free` is `false`, the caller is responsible for freeing the branch.
    @discardableResult
    static func createLocalBranch(
        named       branchName  : String,
        in          repository  : Repository,
        force                   : Bool,
        annotated               : Bool,
        free        freeBranch  : Bool
    ) throws -> OpaquePointer?
    {
        var annotatedCommitPointer  : OpaquePointer?    = nil
        var branchPointer           : OpaquePointer?    = nil
        
        defer
        {
            gitAnnotatedCommitFree(commit: annotatedCommitPointer)
            
            if freeBranch
            {
                Free.freeReference(branchPointer)
            }
        }
        
        
        
        if annotated
        {
            let headOID: GitOID = OID.getHEADCommitOID(in: repository)
            
            let annotatedCommitLookup: GitErrorCode
                = gitAnnotatedCommitLookup(
                    out:    &annotatedCommitPointer,
                    repo:   repository.pointer,
                    id:     headOID
                )
            
            XCTAssertOK(annotatedCommitLookup)
            
            guard let annotatedCommitPointer: OpaquePointer
                    = annotatedCommitPointer
            else
            {
                throw NSError.makeError(
                    "The annotated commit pointer was nil."
                )
            }
            
            
            
            let branchCreateFromAnnotatedResult: GitErrorCode
                = gitBranchCreateFromAnnotated(
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
            try Commit.withHEADCommit(in: repository)
            {
                commitPointer in

                let branchCreateResult: GitErrorCode = gitBranchCreate(
                    out:            &branchPointer,
                    repo:           repository.pointer,
                    branchName:     branchName,
                    target:         commitPointer,
                    force:          force
                )
                
                XCTAssertOK(branchCreateResult)
            }
        }
        
        
        
        return branchPointer
    }
    
    
    
    /// Calls the given closure with a pointer to an existing local branch.
    /// - Parameters:
    ///   - branchName: The branch name.
    ///   - repository: The repository in which the branch exists.
    ///   - body: The closure to call.
    static func withExistingLocalBranchPointer(
        named   branchName  : String,
        in      repository  : Repository,
        _       body        : (inout OpaquePointer?) throws -> Void
    ) rethrows
    {
        var branchPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeReference(branchPointer)
        }
        
        
        
        let branchLookupResult: GitErrorCode = gitBranchLookup(
            out:            &branchPointer,
            repo:           repository.pointer,
            branchName:     branchName,
            branchType:     .gitBranchLocal
        )
        
        XCTAssertOK(branchLookupResult)
        
        
        
        return try body(&branchPointer)
    }
    
    
    
    /// Calls the given closure with a pointer to a local branch created from
    /// the HEAD commit.
    /// - Parameters:
    ///   - branchName: The branch name.
    ///   - repository: The repository in which the branch should be created.
    ///   - force: Whether to overwrite an existing branch.
    ///   - annotated: Whether the branch should be created from an annotated
    ///   commit.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    static func withNewLocalBranchPointer(
        named       branchName  : String,
        in          repository  : Repository,
        force                   : Bool,
        annotated               : Bool,
        _           body        : (inout OpaquePointer?) throws -> Void
    ) throws
    {
        var branchPointer: OpaquePointer? = try createLocalBranch(
            named:      branchName,
            in:         repository,
            force:      force,
            annotated:  annotated,
            free:       false
        )
        
        defer
        {
            Free.freeReference(branchPointer)
        }
        
        
        
        return try body(&branchPointer)
    }
}
