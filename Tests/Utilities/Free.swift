//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
@testable import SwiftLibgit2



/// Functions to free and reset pointers.
enum Free
{
    /// Frees an annotated commit pointer.
    /// - Parameter annotatedCommitPointer: The annotated commit pointer to free.
    static func freeAnnotatedCommitPointer(
        _ annotatedCommitPointer: inout OpaquePointer?
    )
    {
        if annotatedCommitPointer != nil
        {
            gitAnnotatedCommitFree(commit: annotatedCommitPointer!)
            annotatedCommitPointer = nil
        }
    }
    
    
    
    /// Frees a blame pointer.
    /// - Parameter blamePointer: The blame pointer to free.
    static func freeBlamePointer(
        _ blamePointer: inout OpaquePointer?
    )
    {
        if blamePointer != nil
        {
            gitBlameFree(blame: blamePointer)
            blamePointer = nil
        }
    }
    
    
    
    /// Frees a commit pointer.
    /// - Parameter commitPointer: The commit pointer to free.
    static func freeCommitPointer(
        _ commitPointer: inout OpaquePointer?
    )
    {
        if commitPointer != nil
        {
            git_commit_free(commitPointer)
            commitPointer = nil
        }
    }
    
    
    
    /// Frees a diff pointer.
    /// - Parameter diffPointer: The diff pointer to free.
    static func freeDiffPointer(
        _ diffPointer: inout OpaquePointer?
    )
    {
        if diffPointer != nil
        {
            git_diff_free(diffPointer)
            diffPointer = nil
        }
    }
    
    
    
    /// Frees an index pointer.
    /// - Parameter indexPointer: The index pointer to free.
    static func freeIndexPointer(
        _ indexPointer: inout OpaquePointer?
    )
    {
        if indexPointer != nil
        {
            git_index_free(indexPointer)
            indexPointer = nil
        }
    }
    
    
    
    /// Frees a reference pointer.
    /// - Parameter referencePointer: The reference pointer to free.
    static func freeReferencePointer(
        _ referencePointer: inout OpaquePointer?
    )
    {
        if referencePointer != nil
        {
            git_reference_free(referencePointer!)
            referencePointer = nil
        }
    }
    
    
    
    /// Frees a repository pointer.
    /// - Parameter repositoryPointer: The repository pointer to free.
    static func freeRepositoryPointer(
        _ repositoryPointer: inout OpaquePointer?
    )
    {
        if repositoryPointer != nil
        {
            git_repository_free(repositoryPointer)
            repositoryPointer = nil
        }
    }
    
    
    
    /// Frees a signature pointer.
    /// - Parameter signaturePointer: The signature pointer to free.
    static func freeSignaturePointer(
        _ signaturePointer: inout UnsafeMutablePointer<git_signature>?
    )
    {
        if signaturePointer != nil
        {
            git_signature_free(signaturePointer)
            signaturePointer = nil
        }
    }
    
    
    
    /// Frees a tree pointer.
    /// - Parameter treePointer: The tree pointer to free.
    static func freeTreePointer(
        _ treePointer: inout OpaquePointer?
    )
    {
        if treePointer != nil
        {
            git_tree_free(treePointer)
            treePointer = nil
        }
    }
}
