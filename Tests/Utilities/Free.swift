//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
@testable import SwiftLibgit2



/// Functions to free memory.
enum Free
{
    /// Frees the memory allocated for the given `annotatedCommit` instance.
    /// - Parameter annotatedCommit: The annotated commit to free. The underlying type
    /// must be `git_annotated_commit`
    static func freeAnnotatedCommit(
        _ annotatedCommit: OpaquePointer?
    )
    {
        if annotatedCommit != nil
        {
            gitAnnotatedCommitFree(commit: annotatedCommit!)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_blame` instance.
    /// - Parameter blame: The blame to free. The underlying type must be `git_blame`.
    static func freeBlame(
        _ blame: OpaquePointer?
    )
    {
        if blame != nil
        {
            gitBlameFree(blame: blame)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_blob` instance.
    /// - Parameter blob: The blob to free. The underlying type must be `git_blob`.
    static func freeBlob(
        _ blob: OpaquePointer?
    )
    {
        if blob != nil
        {
            gitBlobFree(blob: blob)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_branch_iterator` instance.
    /// - Parameter branchIterator: The branch iterator to free. The underlying type must
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
    
    
    
    /// Frees the memory allocated for the given `git_commit` instance.
    /// - Parameter commit: The commit to free. The underlying type must be `git_commit`.
    static func freeCommit(
        _ commit: OpaquePointer?
    )
    {
        if commit != nil
        {
            gitCommitFree(commit: commit)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_config` instance.
    /// - Parameter config: The configuration object to free. The underlying type must be
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
    
    
    
    /// Frees the memory allocated for the given `git_config_backend` instance.
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
    
    
    
    /// Frees the memory allocated for the given `git_config_entry` instance.
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
    
    
    
    /// Frees the memory allocated for the given `git_config_iterator` instance.
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
    
    
    
    /// Frees the memory allocated for the given `git_credential` instance.
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
    
    
    
    /// Frees the memory allocated for the given `git_describe_result` instance.
    /// - Parameter describeResult: The description to free. The underlying type must be
    /// `git_describe_result`.
    static func freeDescribeResult(
        _ describeResult: OpaquePointer?
    )
    {
        if describeResult != nil
        {
            gitDescribeResultFree(result: describeResult)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_diff` instance.
    /// - Parameter diff: The diff to free. The underlying type must be `git_diff`.
    static func freeDiff(
        _ diff: OpaquePointer?
    )
    {
        if diff != nil
        {
            gitDiffFree(diff: diff)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_diff_stats` instance.
    /// - Parameter stats: The diff statistics to free. The underlying type must be
    /// `git_diff_stats`.
    static func freeDiffStats(
        _ diffStats: OpaquePointer?
    )
    {
        if diffStats != nil
        {
            gitDiffStatsFree(stats: diffStats)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_filter_list` instance.
    /// - Parameter filterList: The filter list to free. The underlying type must be
    /// `git_filter_list`.
    static func freeFilterList(
        _ filterList: OpaquePointer?
    )
    {
        if filterList != nil
        {
            gitFilterListFree(filters: filterList)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_index` instance.
    /// - Parameter index: The index to free. The underlying type must be  `git_index`.
    static func freeIndex(
        _ index: OpaquePointer?
    )
    {
        if index != nil
        {
            gitIndexFree(index: index)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_index_conflict_iterator` instance.
    /// - Parameter iterator: The index conflict iterator to free. The underlying type must be
    /// `git_index_conflict_iterator`.
    static func freeIndexConflictIterator(
        _ iterator: OpaquePointer?
    )
    {
        if iterator != nil
        {
            gitIndexConflictIteratorFree(iterator: iterator)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_indexer` instance.
    /// - Parameter indexer: The indexer to free. The underlying type must be  `git_indexer`.
    static func freeIndexer(
        _ indexer: OpaquePointer?
    )
    {
        if indexer != nil
        {
            gitIndexerFree(idx: indexer)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_index_iterator` instance.
    /// - Parameter iterator: The index iterator to free. The underlying type must be
    /// `git_index_iterator`.
    static func freeIndexIterator(
        _ iterator: OpaquePointer?
    )
    {
        if iterator != nil
        {
            gitIndexIteratorFree(iterator: iterator)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_odb` instance.
    /// - Parameter odb: The object database to free. The underlying type must be  `git_odb`.
    static func freeODB(
        _ odb: OpaquePointer?
    )
    {
        if odb != nil
        {
            git_odb_free(odb)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_packbuilder` instance.
    /// - Parameter packBuilder: The pack builder to free. The underlying type must be
    /// `git_packbuilder`.
    static func freePackBuilder(
        _ packBuilder: OpaquePointer?
    )
    {
        if packBuilder != nil
        {
            git_packbuilder_free(packBuilder)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_rebase` instance.
    /// - Parameter rebase: The rebase to free. The underlying type must be `git_rebase`.
    static func freeRebase(
        _ rebase: OpaquePointer?
    )
    {
        if rebase != nil
        {
            git_rebase_free(rebase)
        }
    }
    
    
    
    /// Frees the memory allocated for the given `git_reference` instance.
    /// - Parameter reference: The reference to free. The underlying type must be
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
    
    
    
    /// Frees the memory allocated for the given `git_repository` instance.
    /// - Parameter repository: The repository to free. The underlying type must be
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
    
    
    
    /// Frees the memory allocated for the given `git_transaction` instance.
    /// - Parameter transaction: The transaction to free. The underlying type must be
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
    
    
    
    /// Frees the memory allocated for the given `git_tree` instance.
    /// - Parameter tree: The tree to free. The underlying type must be `git_tree`.
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
