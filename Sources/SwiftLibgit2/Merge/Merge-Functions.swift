//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_merge_file_input` instance.
/// - Parameters:
///   - opts: The `git_merge_file_input` instance to initialize.
///   - version: The version to use. Pass ``gitMergeFileInputVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_file_input_init()`](https://libgit2.org/docs/reference/main/merge/git_merge_file_input_init.html)
public func gitMergeFileInputInit(
    opts    : UnsafeMutablePointer<git_merge_file_input>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_merge_file_input_init(
            opts,
            version
        )
    }
}



/// Initializes the given `git_merge_file_options` instance.
/// - Parameters:
///   - opts: The `git_merge_file_options` instance to initialize.
///   - version: The version to use. Pass ``gitMergeFileOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_file_options_init()`](https://libgit2.org/docs/reference/main/merge/git_merge_file_options_init.html)
public func gitMergeFileOptionsInit(
    opts    : UnsafeMutablePointer<git_merge_file_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_merge_file_options_init(
            opts,
            version
        )
    }
}



/// Initializes the given `git_merge_options` instance.
/// - Parameters:
///   - opts: The `git_merge_options` instance to initialize.
///   - version: The version to use. Pass ``gitMergeOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_options_init()`](https://libgit2.org/docs/reference/main/merge/git_merge_options_init.html)
public func gitMergeOptionsInit(
    opts    : UnsafeMutablePointer<git_merge_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_merge_options_init(
            opts,
            version
        )
    }
}



/// Analyzes the given branches and determines the opportunities for merging
/// them into the HEAD of the given repository.
/// - Parameters:
///   - analysisOut: The ``GitMergeAnalysisT`` instance in which to store the
///   merge opportunity analysis.
///   - preferenceOut: The ``GitMergePreferenceT`` instance in which to store
///   the merge preference analysis.
///   - repo: The repository to merge. The underlying type must be
///   `git_repository`.
///   - theirHeads: The heads to merge into. The underlying type must be an
///   array of `git_annotated_commit` instances, of length `theirHeadsLen`.
///   - theirHeadsLen: The length of `theirHeads`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_analysis()`](https://libgit2.org/docs/reference/main/merge/git_merge_analysis.html)
public func gitMergeAnalysis(
    analysisOut     : inout GitMergeAnalysisT,
    preferenceOut   : inout GitMergePreferenceT,
    repo            : OpaquePointer,
    theirHeads      : UnsafeMutablePointer<OpaquePointer?>,
    theirHeadsLen   : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return analysisOut.withMutatingCValue
        {
            cAnalysisOut in
            
            return preferenceOut.withMutatingCValue
            {
                cPreferenceOut in
                
                return git_merge_analysis(
                    cAnalysisOut,
                    cPreferenceOut,
                    repo,
                    theirHeads,
                    theirHeadsLen
                )
            }
        }
    }
}



/// Analyzes the given branches and determines the opportunities for merging
/// them into the given reference.
/// - Parameters:
///   - analysisOut: The ``GitMergeAnalysisT`` instance in which to store the
///   merge opportunity analysis.
///   - preferenceOut: The ``GitMergePreferenceT`` instance in which to store
///   the merge preference analysis.
///   - repo: The repository to merge. The underlying type must be
///   `git_repository`.
///   - ourRef: The reference on which to perform the merge analysis. The
///   underlying type must be `git_reference`.
///   - theirHeads: The heads to merge into. The underlying type must be an
///   array of `git_annotated_commit` instances, of length `theirHeadsLen`.
///   - theirHeadsLen: The length of `theirHeads`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_analysis_for_ref()`](https://libgit2.org/docs/reference/main/merge/git_merge_analysis_for_ref.html)
public func gitMergeAnalysisForRef(
    analysisOut     : inout GitMergeAnalysisT,
    preferenceOut   : inout GitMergePreferenceT,
    repo            : OpaquePointer,
    ourRef          : OpaquePointer,
    theirHeads      : UnsafeMutablePointer<OpaquePointer?>,
    theirHeadsLen   : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return analysisOut.withMutatingCValue
        {
            cAnalysisOut in
            
            return preferenceOut.withMutatingCValue
            {
                cPreferenceOut in
                
                return git_merge_analysis_for_ref(
                    cAnalysisOut,
                    cPreferenceOut,
                    repo,
                    ourRef,
                    theirHeads,
                    theirHeadsLen
                )
            }
        }
    }
}



/// Finds a merge base between the given commits.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the merge base.
///   - repo: The repository containing the given commits. The underlying
///   type must be `git_repository`.
///   - one: The ID of the first commit for which to find a merge base.
///   - two: The ID of the second commit for which to find a merge base.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_base()`](https://libgit2.org/docs/reference/main/merge/git_merge_base.html)
public func gitMergeBase(
    out     : inout GitOID,
    repo    : OpaquePointer,
    one     : GitOID,
    two     : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            var cOne    : git_oid   = one.cValue()
            var cTwo    : git_oid   = two.cValue()
            
            return git_merge_base(
                cOut,
                repo,
                &cOne,
                &cTwo
            )
        }
    }
}



/// Finds the merge bases between the given commits.
/// - Parameters:
///   - out: The array of ``GitOID`` instances in which to store the merge
///   bases.
///   - repo: The repository containing the given commits. The underlying
///   type must be `git_repository`.
///   - one: The ID of the first commit for which to find merge bases.
///   - two: The ID of the second commit for which to find merge bases.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_bases()`](https://libgit2.org/docs/reference/main/merge/git_merge_bases.html)
public func gitMergeBases(
    out     : inout [GitOID],
    repo    : OpaquePointer,
    one     : GitOID,
    two     : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitOIDArray
        {
            cOut in
            
            var cOne    : git_oid   = one.cValue()
            var cTwo    : git_oid   = two.cValue()
            
            return git_merge_bases(
                cOut,
                repo,
                &cOne,
                &cTwo
            )
        }
    }
}



/// Finds a merge base between the given commits.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the merge base.
///   - repo: The repository containing the given commits. The underlying
///   type must be `git_repository`.
///   - length: The length of `inputArray`.
///   - inputArray: The IDs for which to find a merge base.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_base_many()`](https://libgit2.org/docs/reference/main/merge/git_merge_base_many.html)
public func gitMergeBaseMany(
    out         : inout GitOID,
    repo        : OpaquePointer,
    length      : Int,
    inputArray  : [GitOID]
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return inputArray.withArrayOfGitOIDs
            {
                cInputArray, cInputArrayCount in
                
                return git_merge_base_many(
                    cOut,
                    repo,
                    cInputArrayCount,
                    cInputArray
                )
            }
        }
    }
}



/// Finds the merge bases between the given commits.
/// - Parameters:
///   - out: The array of ``GitOID`` instances in which to store the merge
///   bases.
///   - repo: The repository containing the given commits. The underlying
///   type must be `git_repository`.
///   - length: The length of `inputArray`.
///   - inputArray: The IDs for which to find a merge base.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is similar to `git merge-base`.
///
/// Given three commits `a`, `b`, and `c`, this will compute a hypothetical
/// commit `m`, which is a merge between commits `b` and `c`.
///
/// For example, with the following topology:
///
/// ```text
///        o---o---o---o---C
///       /
///      /   o---o---o---B
///     /   /
/// ---2---1---o---o---o---A
/// ```
///
/// The result of the merge given `a`, `b`, and `c` will be `1`. This is
/// because the equivalent topology with the imaginary merge commit `m`
/// between commits `b` and `c` is as follows:
///
/// ```text
///        o---o---o---o---o
///       /                 \
///      /   o---o---o---o---M
///     /   /
/// ---2---1---o---o---o---A
/// ```
///
/// The result of the merge given commits `a` and `m` will be `1`.
///
/// - Note: To find the common ancestor of the given commits, use
/// ``gitMergeBaseOctopus(out:repo:length:inputArray:)`` instead.
///
/// ## C Equivalent
///
/// [`git_merge_bases_many()`](https://libgit2.org/docs/reference/main/merge/git_merge_bases_many.html)
public func gitMergeBasesMany(
    out         : inout [GitOID],
    repo        : OpaquePointer,
    length      : Int,
    inputArray  : [GitOID]
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitOIDArray
        {
            cOut in
            
            return inputArray.withArrayOfGitOIDs
            {
                cInputArray, cInputArrayCount in
                
                return git_merge_bases_many(
                    cOut,
                    repo,
                    cInputArrayCount,
                    cInputArray
                )
            }
        }
    }
}



/// Finds a merge base in prepartion for an octopus merge.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the merge base.
///   - repo: The repository containing the given commits. The underlying
///   type must be `git_repository`.
///   - length: The length of `inputArray`.
///   - inputArray: The IDs for which to find a merge base.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_base_octopus()`](https://libgit2.org/docs/reference/main/merge/git_merge_base_octopus.html)
public func gitMergeBaseOctopus(
    out         : inout GitOID,
    repo        : OpaquePointer,
    length      : Int,
    inputArray  : [GitOID]
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return inputArray.withArrayOfGitOIDs
            {
                cInputArray, cInputArrayCount in
                
                return git_merge_base_octopus(
                    cOut,
                    repo,
                    cInputArrayCount,
                    cInputArray
                )
            }
        }
    }
}



/// Merges the given files as they exist in-memory, using the given common
/// ancestor as the baseline.
/// - Parameters:
///   - out: The ``GitMergeFileResult`` instance in which to store the file
///   merge result.
///   - ancestor: The contents of the ancestor file.
///   - ours: The contents of "our" file.
///   - theirs: The contents of "their" file.
///   - opts: The file merge options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_file()`](https://libgit2.org/docs/reference/main/merge/git_merge_file.html)
public func gitMergeFile(
    out         : inout GitMergeFileResult,
    ancestor    : GitMergeFileInput,
    ours        : GitMergeFileInput,
    theirs      : GitMergeFileInput,
    opts        : GitMergeFileOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try ancestor.withCValue
            {
                cAncestor in
                
                return try ours.withCValue
                {
                    cOurs in
                    
                    return try theirs.withCValue
                    {
                        cTheirs in
                        
                        return try opts.withOptionalCValue
                        {
                            cOpts in
                            
                            return git_merge_file(
                                cOut,
                                cAncestor,
                                cOurs,
                                cTheirs,
                                cOpts
                            )
                        }
                    }
                }
            }
        }
    }
}



/// Merges the given files as they exist in the index, using the given common
/// ancestor as the baseline.
/// - Parameters:
///   - out: The ``GitMergeFileResult`` instance in which to store the file
///   merge result.
///   - repo: The repository containing the files. The underlying type must
///   be `git_repository`.
///   - ancestor: The ancestor index entry (stage level 1).
///   - ours: "Our" index entry (stage level 2).
///   - theirs: "Their" index entry (stage level 3).
///   - opts: The file merge options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_file_from_index()`](https://libgit2.org/docs/reference/main/merge/git_merge_file_from_index.html)
public func gitMergeFileFromIndex(
    out         : inout GitMergeFileResult,
    repo        : OpaquePointer,
    ancestor    : GitIndexEntry,
    ours        : GitIndexEntry,
    theirs      : GitIndexEntry,
    opts        : GitMergeFileOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try ancestor.withCValue
            {
                cAncestor in
                
                return try ours.withCValue
                {
                    cOurs in
                    
                    return try theirs.withCValue
                    {
                        cTheirs in
                        
                        return try opts.withOptionalCValue
                        {
                            cOpts in
                            
                            return git_merge_file_from_index(
                                cOut,
                                repo,
                                cAncestor,
                                cOurs,
                                cTheirs,
                                cOpts
                            )
                        }
                    }
                }
            }
        }
    }
}



/// Frees the memory allocated for the given `git_merge_file_result` instance.
/// - Parameter result: The merge file result to free.
///
/// ## C Equivalent
///
/// [`git_merge_file_result_free()`](https://libgit2.org/docs/reference/main/merge/git_merge_file_result_free.html)
public func gitMergeFileResultFree(
    result: UnsafeMutablePointer<git_merge_file_result>?
)
{
    guard let result: UnsafeMutablePointer<git_merge_file_result> = result
    else
    {
        return
    }
    
    git_merge_file_result_free(result)
}



/// Merges the given trees.
/// - Parameters:
///   - out: The pointer in which to store the index. The underlying type must
///   be `git_index`.
///   - repo: The repository containing the trees. The underlying type must
///   be `git_repository`.
///   - ancestorTree: The ancestor of the given trees. The underlying type must
///   be `git_tree`.
///   - ourTree: The destination tree. The underlying type must be `git_tree`.
///   - theirTree: The tree to merge into `ourTree`. The underlying type must
///   be `git_tree`.
///   - opts: The merge options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting index may be written as-is to the working directory or
/// checked out. If the index is to be converted to a tree, the caller must
/// resolve any conflicts that arose during the merge operation.
///
/// ## C Equivalent
///
/// [`git_merge_trees()`](https://libgit2.org/docs/reference/main/merge/git_merge_trees.html)
public func gitMergeTrees(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    repo            : OpaquePointer,
    ancestorTree    : OpaquePointer?,
    ourTree         : OpaquePointer,
    theirTree       : OpaquePointer,
    opts            : GitMergeOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_merge_trees(
                out,
                repo,
                ancestorTree,
                ourTree,
                theirTree,
                cOpts
            )
        }
    }
}



/// Merges the given commits.
/// - Parameters:
///   - out: The pointer in which to store the index. The underlying type must
///   be `git_index`.
///   - repo: The repository containing the commits. The underlying type must
///   be `git_repository`.
///   - ourCommit: The destination commit. The underlying type must be
///   `git_commit`.
///   - theirCommit: The commit to merge into `ourCommit`. The underlying type
///   must be `git_commit`.
///   - opts: The merge options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting index may be written as-is to the working directory or
/// checked out. If the index is to be converted to a tree, the caller must
/// resolve any conflicts that arose during the merge operation.
///
/// ## C Equivalent
///
/// [`git_merge_commits()`](https://libgit2.org/docs/reference/main/merge/git_merge_commits.html)
public func gitMergeCommits(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    repo            : OpaquePointer,
    ourCommit       : OpaquePointer,
    theirCommit     : OpaquePointer,
    opts            : GitMergeOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_merge_commits(
                out,
                repo,
                ourCommit,
                theirCommit,
                cOpts
            )
        }
    }
}



/// Merges the given commits into HEAD, and writes the results into the
/// working directory.
/// - Parameters:
///   - repo: The repository to merge. The underlying type must be
///   `git_repository`.
///   - theirHeads: The heads to merge into. The underlying type must be an
///   array of `git_annotated_commit` instances, of length `theirHeadsLen`.
///   - theirHeadsLen: The length of `theirHeads`.
///   - mergeOpts: The merge options to use.
///   - checkoutOpts: The checkout options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Any changes will be staged for commit, and any conflicts will be written
/// to the index. Callers should inspect the repository's index after this
/// operation completes, resolve any conflicts, and then prepare a commit.
///
/// - Note: To maintain compatability with Git, the repository is put into
/// a merging state. Once the commit is done, or the process is aborted, use
/// ``gitRepositoryStateCleanup(repo:)`` to clear the merging state.
///
/// ## C Equivalent
///
/// [`git_merge()`](https://libgit2.org/docs/reference/main/merge/git_merge.html)
public func gitMerge(
    repo            : OpaquePointer,
    theirHeads      : UnsafeMutablePointer<OpaquePointer?>,
    theirHeadsLen   : Int,
    mergeOpts       : GitMergeOptions?,
    checkoutOpts    : GitCheckoutOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try mergeOpts.withOptionalCValue
        {
            cMergeOpts in
            
            return try checkoutOpts.withOptionalCValue
            {
                cCheckoutOpts in
                
                return git_merge(
                    repo,
                    theirHeads,
                    theirHeadsLen,
                    cMergeOpts,
                    cCheckoutOpts
                )
            }
        }
    }
}
