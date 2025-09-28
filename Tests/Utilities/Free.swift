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
        _ annotatedCommit: OpaquePointer?
    )
    {
        if annotatedCommit != nil
        {
            gitAnnotatedCommitFree(commit: annotatedCommit!)
        }
    }
    
    
    
    /// Frees the memory allocated for a blame.
    /// - Parameter blame: The blame to free. The underlying type should be `git_blame`.
    static func freeBlame(
        _ blame: OpaquePointer?
    )
    {
        if blame != nil
        {
            gitBlameFree(blame: blame)
        }
    }
    
    
    
    /// Frees the memory allocated for a blob.
    /// - Parameter blob: The blob to free. The underlying type should be `git_blob`.
    static func freeBlob(
        _ blob: OpaquePointer?
    )
    {
        if blob != nil
        {
            gitBlobFree(blob: blob)
        }
    }
    
    
    
    /// Frees the memory allocated for a branch iterator.
    /// - Parameter branchIterator: The branch iterator to free. The underlying type should
    /// be `git_branch_iterator`.
    static func freeBranchIterator(
        _ branchIterator: OpaquePointer?
    )
    {
        if branchIterator != nil
        {
            gitBranchIteratorFree(iter: branchIterator)
        }
    }
    
    
    
    /// Frees the memory allocated for a commit.
    /// - Parameter commit: The commit to free. The underlying type should be `git_commit`.
    static func freeCommit(
        _ commit: OpaquePointer?
    )
    {
        if commit != nil
        {
            gitCommitFree(commit: commit)
        }
    }
    
    
    
    /// Frees the memory allocated for a configuration object.
    /// - Parameter config: The configuration object to free. The underlying type should be
    /// `git_config`.
    static func freeConfig(
        _ config: OpaquePointer?
    )
    {
        if config != nil
        {
            gitConfigFree(cfg: config)
        }
    }
    
    
    
    /// Frees the memory allocated for a configuration backend object.
    /// - Parameter configBackend: The configuration backend object to free.
    static func freeConfigBackend(
        _ configBackend: UnsafeMutablePointer<git_config_backend>?
    )
    {
        if configBackend != nil
        {
            configBackend?.pointee.free(configBackend)
        }
    }
    
    
    
    /// Frees the memory allocated for a configuration entry.
    /// - Parameter configEntry: The configuration entry to free.
    static func freeConfigEntry(
        _ configEntry: UnsafeMutablePointer<git_config_entry>?
    )
    {
        if configEntry != nil
        {
            gitConfigEntryFree(entry: configEntry)
        }
    }
    
    
    
    /// Frees the memory allocated for a configuration iterator.
    /// - Parameter configIterator: The configuration iterator to free.
    static func freeConfigIterator(
        _ configIterator: UnsafeMutablePointer<git_config_iterator>?
    )
    {
        if configIterator != nil
        {
            gitConfigIteratorFree(iter: configIterator)
        }
    }
    
    
    
    /// Frees the memory allocated for a credential.
    /// - Parameter credential: The credential to free.
    static func freeCredential(
        _ credential: UnsafeMutablePointer<git_credential>?
    )
    {
        if credential != nil
        {
            gitCredentialFree(cred: credential)
        }
    }
    
    
    
    /// Frees the memory allocated for a diff.
    /// - Parameter diff: The diff to free. The underlying type should be `git_diff`.
    static func freeDiff(
        _ diff: OpaquePointer?
    )
    {
        if diff != nil
        {
            git_diff_free(diff)
        }
    }
    
    
    
    /// Frees the memory allocated for an index.
    /// - Parameter index: The index to free. The underlying type should be  `git_index`.
    static func freeIndex(
        _ index: OpaquePointer?
    )
    {
        if index != nil
        {
            git_index_free(index)
        }
    }
    
    
    
    /// Frees the memory allocated for a rebase.
    /// - Parameter rebase: The rebase to free. The underlying type should be `git_rebase`.
    static func freeRebase(
        _ rebase: OpaquePointer?
    )
    {
        if rebase != nil
        {
            git_rebase_free(rebase)
        }
    }
    
    
    /// Frees the memory allocated for a reference.
    /// - Parameter reference: The reference to free. The underlying type should be
    /// `git_reference`.
    static func freeReference(
        _ reference: OpaquePointer?
    )
    {
        if reference != nil
        {
            git_reference_free(reference)
        }
    }
    
    
    
    /// Frees the memory allocated for a repository.
    /// - Parameter repository: The repository to free. The underlying type should be
    /// `git_repository`.
    static func freeRepository(
        _ repository: OpaquePointer?
    )
    {
        if repository != nil
        {
            git_repository_free(repository)
        }
    }
    
    
    
    /// Frees the memory allocated for a transaction.
    /// - Parameter transaction: The transaction to free. The underlying type should be
    /// `git_transaction`.
    static func freeTransaction(
        _ transaction: OpaquePointer?
    )
    {
        if transaction != nil
        {
            git_transaction_free(transaction)
        }
    }
    
    
    
    /// Frees the memory allocated for a tree.
    /// - Parameter tree: The tree to free. The underlying type should be `git_tree`.
    static func freeTree(
        _ tree: OpaquePointer?
    )
    {
        if tree != nil
        {
            git_tree_free(tree)
        }
    }
}
