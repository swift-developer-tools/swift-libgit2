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



/// Functions to free memory.
enum Free
{
    /// Frees the memory allocated for an annotated commit.
    /// - Parameter annotatedCommit: The annotated commit to free. The underlying type
    /// should be `git_annotated_commit`
    static func freeAnnotatedCommit(
        _ annotatedCommit: inout OpaquePointer?
    )
    {
        if annotatedCommit != nil
        {
            gitAnnotatedCommitFree(commit: annotatedCommit!)
            annotatedCommit = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a blame.
    /// - Parameter blame: The blame to free. The underlying type should be `git_blame`.
    static func freeBlame(
        _ blame: inout OpaquePointer?
    )
    {
        if blame != nil
        {
            gitBlameFree(blame: blame)
            blame = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a buffer.
    /// - Parameter buffer: The buffer to free.
    static func freeBuffer(
        _ buffer: inout git_buf
    )
    {
        git_buf_dispose(&buffer)
        buffer.ptr      = nil
        buffer.size     = 0
    }
    
    
    
    /// Frees the memory allocated for a branch iterator.
    /// - Parameter branchIterator: The branch iterator to free. The underlying type should
    /// be `git_branch_iterator`.
    static func freeBranchIterator(
        _ branchIterator: inout OpaquePointer?
    )
    {
        if branchIterator != nil
        {
            gitBranchIteratorFree(iter: branchIterator)
            branchIterator = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a commit.
    /// - Parameter commit: The commit to free. The underlying type should be `git_commit`.
    static func freeCommit(
        _ commit: inout OpaquePointer?
    )
    {
        if commit != nil
        {
            git_commit_free(commit)
            commit = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a diff.
    /// - Parameter diff: The diff to free. The underlying type should be `git_diff`.
    static func freeDiff(
        _ diff: inout OpaquePointer?
    )
    {
        if diff != nil
        {
            git_diff_free(diff)
            diff = nil
        }
    }
    
    
    
    /// Frees the memory allocated for an index.
    /// - Parameter index: The index to free. The underlying type should be  `git_index`.
    static func freeIndex(
        _ index: inout OpaquePointer?
    )
    {
        if index != nil
        {
            git_index_free(index)
            index = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a reference.
    /// - Parameter reference: The reference to free. The underlying type should be
    /// `git_reference`.
    static func freeReference(
        _ reference: inout OpaquePointer?
    )
    {
        if reference != nil
        {
            git_reference_free(reference!)
            reference = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a repository.
    /// - Parameter repository: The repository to free. The underlying type should be
    /// `git_repository`.
    static func freeRepository(
        _ repository: inout OpaquePointer?
    )
    {
        if repository != nil
        {
            git_repository_free(repository)
            repository = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a signature.
    /// - Parameter signature: The signature to free.
    static func freeSignature(
        _ signature: inout UnsafeMutablePointer<git_signature>?
    )
    {
        if signature != nil
        {
            git_signature_free(signature)
            signature = nil
        }
    }
    
    
    
    /// Frees the memory allocated for a tree.
    /// - Parameter tree: The tree to free. The underlying type should be `git_tree`.
    static func freeTree(
        _ tree: inout OpaquePointer?
    )
    {
        if tree != nil
        {
            git_tree_free(tree)
            tree = nil
        }
    }
}
