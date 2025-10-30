//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import Foundation



/// Looks up a commit in the given repository.
/// - Parameters:
///   - commit: The pointer in which to store the commit. The underlying type
///   must be `git_commit`.
///   - repo: The repository in which to look up the commit. The underlying
///   type must be `git_repository`.
///   - id: The commit ID. If the object is an annotated tag, it will be
///   peeled back to the commit.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_lookup()`](https://libgit2.org/docs/reference/main/commit/git_commit_lookup.html)
public func gitCommitLookup(
    commit  : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_commit_lookup(
                commit,
                repo,
                cID
            )
        }
    }
}



/// Looks up the specified commit in the given repository, using a prefix of
/// the commit's ID.
/// - Parameters:
///   - commit: The pointer in which to store the commit. The underlying type
///   must be `git_commit`.
///   - repo: The repository in which to look up the commit. The underlying
///   type must be `git_repository`.
///   - id: The prefix of the ID of the commit to lookup. If the object is
///   an annotated tag, it will be peeled back to the commit.
///   - len: The length of the commit's ID prefix. This must be greater than or
///   equal to ``gitOIDMinPrefixLen``, and long enough to identify a unique
///   commit matching the prefix.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_lookup_prefix()`](https://libgit2.org/docs/reference/main/commit/git_commit_lookup_prefix.html)
public func gitCommitLookupPrefix(
    commit  : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID,
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_commit_lookup_prefix(
                commit,
                repo,
                cID,
                len
            )
        }
    }
}



/// Frees the memory allocated for the given `git_commit` instance.
/// - Parameter commit: The commit to free. The underlying type must be
/// `git_commit`.
///
/// ## C Equivalent
///
/// [`git_commit_free()`](https://libgit2.org/docs/reference/main/commit/git_commit_free.html)
public func gitCommitFree(
    commit: OpaquePointer?
)
{
    guard let commit: OpaquePointer = commit
    else
    {
        return
    }
    
    git_commit_free(commit)
}



/// Gets the ID of the given commit.
/// - Parameter commit: The commit for which to get the ID. The underlying
/// type must be `git_commit`.
/// - Returns: The ID of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_id()`](https://libgit2.org/docs/reference/main/commit/git_commit_id.html)
public func gitCommitID(
    commit: OpaquePointer
) -> GitOID?
{
    guard let commitOID: UnsafePointer<git_oid> = git_commit_id(commit)
    else
    {
        return nil
    }
    
    return GitOID(cValue: commitOID.pointee)
}



/// Gets the repository containing the given commit.
/// - Parameter commit: The commit for which to get the repository. The
/// underlying type must be `git_commit`.
/// - Returns: The repository containing the given commit. The underlying
/// type will be `git_repository`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given commit and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_commit_owner()`](https://libgit2.org/docs/reference/main/commit/git_commit_owner.html)
public func gitCommitOwner(
    commit: OpaquePointer
) -> OpaquePointer
{
    return git_commit_owner(commit)
}



/// Gets the encoding of the message of the given commit.
/// - Parameter commit: The commit for which to get the message encoding. The
/// underlying type must be `git_commit`.
/// - Returns: The encoding of the message of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_message_encoding()`](https://libgit2.org/docs/reference/main/commit/git_commit_message_encoding.html)
public func gitCommitMessageEncoding(
    commit: OpaquePointer
) -> String?
{
    let encoding: UnsafePointer<CChar>? = git_commit_message_encoding(commit)
    
    return String(optionalCString: encoding)
}



/// Gets the message of the given commit.
/// - Parameter commit: The commit for which to get the message. The underlying
/// type must be `git_commit`.
/// - Returns: The message of the given commit.
///
/// ## Discussion
///
/// The commit message will be slightly prettified by removing any potential
/// leading newlines.
///
/// ## C Equivalent
///
/// [`git_commit_message()`](https://libgit2.org/docs/reference/main/commit/git_commit_message.html)
public func gitCommitMessage(
    commit: OpaquePointer
) -> String?
{
    let message: UnsafePointer<CChar>? = git_commit_message(commit)
    
    return String(optionalCString: message)
}



/// Gets the raw message of the given commit.
/// - Parameter commit: The commit for which to get the raw message. The
/// underlying type must be `git_commit`.
/// - Returns: The raw message of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_message_raw()`](https://libgit2.org/docs/reference/main/commit/git_commit_message_raw.html)
public func gitCommitMessageRaw(
    commit: OpaquePointer
) -> String?
{
    let message: UnsafePointer<CChar>? = git_commit_message_raw(commit)
    
    return String(optionalCString: message)
}



/// Gets the summary of the given commit.
/// - Parameter commit: The commit for which to get the summary. The underlying
/// type must be `git_commit`.
/// - Returns: The summary of the given commit.
///
/// ## Discussion
///
/// The summary of a commit is the first paragraph of the commit message with
/// whitespace trimmed.
///
/// ## C Equivalent
///
/// [`git_commit_summary()`](https://libgit2.org/docs/reference/main/commit/git_commit_summary.html)
public func gitCommitSummary(
    commit: OpaquePointer
) -> String?
{
    let summary: UnsafePointer<CChar>? = git_commit_summary(commit)
    
    return String(optionalCString: summary)
}



/// Gets the body of the given commit.
/// - Parameter commit: The commit for which to get the body. The underlying
/// type must be `git_commit`.
/// - Returns: The body of the given commit.
///
/// ## Discussion
///
/// The body of a commit is everything except the first paragraph of the
/// commit message. Leading and trailing whitespace will be trimmed.
///
/// ## C Equivalent
///
/// [`git_commit_body()`](https://libgit2.org/docs/reference/main/commit/git_commit_body.html)
public func gitCommitBody(
    commit: OpaquePointer
) -> String?
{
    let body: UnsafePointer<CChar>? = git_commit_body(commit)
    
    return String(optionalCString: body)
}



/// Gets the time of the given commit.
/// - Parameter commit: The commit for which to get the time. The underlying
/// type must be `git_commit`.
/// - Returns: The time of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_time()`](https://libgit2.org/docs/reference/main/commit/git_commit_time.html)
public func gitCommitTime(
    commit: OpaquePointer
) -> GitTimeT
{
    return git_commit_time(commit)
}



/// Gets the timezone offset of the given commit.
/// - Parameter commit: The commit for which to get the timezone offset. The
/// underlying type must be `git_commit`.
/// - Returns: The timezone offset of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_time_offset()`](https://libgit2.org/docs/reference/main/commit/git_commit_time_offset.html)
public func gitCommitTimeOffset(
    commit: OpaquePointer
) -> Int32
{
    return git_commit_time_offset(commit)
}



/// Gets the committer of the given commit.
/// - Parameter commit: The commit for which to get the committer. The
/// underlying type must be `git_commit`.
/// - Returns: The committer of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_committer()`](https://libgit2.org/docs/reference/main/commit/git_commit_committer.html)
public func gitCommitCommitter(
    commit: OpaquePointer
) -> GitSignature?
{
    guard let committer: UnsafePointer<git_signature>
            = git_commit_committer(commit)
    else
    {
        return nil
    }
    
    return GitSignature(cValue: committer.pointee)
}



/// Gets the author of the given commit.
/// - Parameter commit: The commit for which to get the author. The underlying
/// type must be `git_commit`.
/// - Returns: The author of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_author()`](https://libgit2.org/docs/reference/main/commit/git_commit_author.html)
public func gitCommitAuthor(
    commit: OpaquePointer
) -> GitSignature?
{
    guard let author: UnsafePointer<git_signature> = git_commit_author(commit)
    else
    {
        return nil
    }
    
    return GitSignature(cValue: author.pointee)
}



/// Gets the committer of the given commit, using the mailmap to map names
/// and email addresses to canonical real names and email addresses.
/// - Parameters:
///   - out: The ``GitSignature`` instance in which to store the resolved
///   signature.
///   - commit: The commit for which to get the committer. The underlying type
///   must be `git_commit`.
///   - mailmap: The mailmap with which to resolve the signature. The
///   underlying type must be `git_mailmap`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_committer_with_mailmap()`](https://libgit2.org/docs/reference/main/commit/git_commit_committer_with_mailmap.html)
public func gitCommitCommitterWithMailmap(
    out     : inout GitSignature,
    commit  : OpaquePointer,
    mailmap : OpaquePointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_commit_committer_with_mailmap(
                cOut,
                commit,
                mailmap
            )
        }
    }
}



/// Gets the author of the given commit, using the mailmap to map names and
/// email addresses to canonical real names and email addresses.
/// - Parameters:
///   - out: The ``GitSignature`` instance in which to store the resolved
///   signature.
///   - commit: The commit for which to get the author. The underlying type
///   must be `git_commit`.
///   - mailmap: The mailmap with which to resolve the signature. The
///   underlying type must be `git_mailmap`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_author_with_mailmap()`](https://libgit2.org/docs/reference/main/commit/git_commit_author_with_mailmap.html)
public func gitCommitAuthorWithMailmap(
    out     : inout GitSignature,
    commit  : OpaquePointer,
    mailmap : OpaquePointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_commit_author_with_mailmap(
                cOut,
                commit,
                mailmap
            )
        }
    }
}



/// Gets the raw text of the given commit's header.
/// - Parameter commit: The commit for which to get the raw text. The
/// underlying type must be `git_commit`.
/// - Returns: The body of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_raw_header()`](https://libgit2.org/docs/reference/main/commit/git_commit_raw_header.html)
public func gitCommitRawHeader(
    commit: OpaquePointer
) -> String?
{
    let rawHeader: UnsafePointer<CChar>? = git_commit_raw_header(commit)
    
    return String(optionalCString: rawHeader)
}



/// Gets the tree pointed to by the given commit.
/// - Parameters:
///   - out: The pointer in which to store the tree. The underlying type must
///   be `git_tree`.
///   - commit: The commit for which to get the tree. The underlying type must
///   be `git_commit`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_tree()`](https://libgit2.org/docs/reference/main/commit/git_commit_tree.html)
public func gitCommitTree(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    commit  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_tree(
            out,
            commit
        )
    }
}



/// Gets the ID of the tree pointed to by the given commit.
/// - Parameter commit: The commit for which to get the tree ID. The underlying
/// type must be `git_commit`.
/// - Returns: The ID of the tree pointed to by the given commit.
///
/// ## Discussion
///
/// This function differs from ``gitCommitTree(out:commit:)`` in that no
/// attempts will be made to fetch an object from the object database.
///
/// ## C Equivalent
///
/// [`git_commit_tree_id()`](https://libgit2.org/docs/reference/main/commit/git_commit_tree_id.html)
public func gitCommitTreeID(
    commit: OpaquePointer
) -> GitOID?
{
    guard let treeOID: UnsafePointer<git_oid> = git_commit_tree_id(commit)
    else
    {
        return nil
    }
    
    return GitOID(cValue: treeOID.pointee)
}



/// Gets the number of parents of the given commit.
/// - Parameter commit: The commit for which to get the number of parents. The
/// underlying type must be `git_commit`.
/// - Returns: The number of parents of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_parentcount()`](https://libgit2.org/docs/reference/main/commit/git_commit_parentcount.html)
public func gitCommitParentCount(
    commit: OpaquePointer
) -> UInt32
{
    return git_commit_parentcount(commit)
}



/// Gets the specified parent of the given commit.
/// - Parameters:
///   - out: The pointer in which to store the parent commit. The underlying
///   type must be `git_commit`.
///   - commit: The commit for which to get the specified parent. The
///   underlying type must be `git_commit`.
///   - n: The 0-indexed position of the parent.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_parent()`](https://libgit2.org/docs/reference/main/commit/git_commit_parent.html)
public func gitCommitParent(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    commit  : OpaquePointer,
    n       : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_parent(
            out,
            commit,
            n
        )
    }
}



/// Gets the ID of the specified parent of the given commit.
/// - Parameters:
///   - commit: The commit for which to get the ID of the specified parent.
///   The underlying type must be `git_commit`.
///   - n: The 0-indexed position of the parent.
/// - Returns: The ID of the specified parent of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_parent_id()`](https://libgit2.org/docs/reference/main/commit/git_commit_parent_id.html)
public func gitCommitParentID(
    commit  : OpaquePointer,
    n       : UInt32
) -> GitOID?
{
    guard let parentCommitOID: UnsafePointer<git_oid>
            = git_commit_parent_id(
                commit,
                n
            )
    else
    {
        return nil
    }
    
    return GitOID(cValue: parentCommitOID.pointee)
}



/// Gets the commit that is the n<sup>th</sup> generation ancestor of the
/// given commit, following only the first parents.
/// - Parameters:
///   - ancestor: The pointer in which to store the ancestor commit. The
///   underlying type must be `git_commit`.
///   - commit: The commit for which to get the n<sup>th</sup> generation
///   ancestor. The underlying type must be `git_commit`.
///   - n: The 0-indexed generation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Passing `0` as the generation number will return another instance of the
/// given commit.
///
/// ## C Equivalent
///
/// [`git_commit_nth_gen_ancestor()`](https://libgit2.org/docs/reference/main/commit/git_commit_nth_gen_ancestor.html)
public func gitCommitNthGenAncestor(
    ancestor    : UnsafeMutablePointer<OpaquePointer?>,
    commit      : OpaquePointer,
    n           : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_nth_gen_ancestor(
            ancestor,
            commit,
            n
        )
    }
}



/// Gets the specified header field from the given commit.
/// - Parameters:
///   - out: The `String` instance in which to store the header field.
///   - commit: The commit for which to get the specified header field. The
///   underlying type must be `git_commit`.
///   - field: The header field to return.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_header_field()`](https://libgit2.org/docs/reference/main/commit/git_commit_header_field.html)
public func gitCommitHeaderField(
    out     : inout String?,
    commit  : OpaquePointer,
    field   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_commit_header_field(
                cOut,
                commit,
                field
            )
        }
    }
}



/// Extracts the signature from a commit.
/// - Parameters:
///   - signature: The `Data` instance in which to store the signature block.
///   - signedData: The `Data` instance in which to store the signed data (the
///   commit content less the signature block).
///   - repo: The repository containing the commit. The underlying type must
///   be `git_repository`.
///   - commitID: The commit from which to extract the data.
///   - field: The name of the header field containing the signature block.
///   Pass `nil` to extract `gpgsig`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If `commitID` is not the ID of a commit, the error class will be
/// ``GitErrorT/gitErrorInvalid``.
///
/// If the commit does not have a signature, the error class will be
/// ``GitErrorT/gitErrorObject``.
///
/// ## C Equivalent
///
/// [`git_commit_extract_signature()`](https://libgit2.org/docs/reference/main/commit/git_commit_extract_signature.html)
public func gitCommitExtractSignature(
    signature   : inout Data,
    signedData  : inout Data,
    repo        : OpaquePointer,
    commitID    : GitOID,
    field       : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try signature.withMutatingGitBuf
        {
            cSignature in
            
            return try signedData.withMutatingGitBuf
            {
                cSignedData in
                
                return commitID.withCValue
                {
                    cCommitID in
                    
                    return git_commit_extract_signature(
                        cSignature,
                        cSignedData,
                        repo,
                        cCommitID,
                        field
                    )
                }
            }
        }
    }
}



/// Creates a new commit in the given repository.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the
///   newly-created commit.
///   - repo: The repository in which to create the commit. The underlying type
///   must be `git_repository`.
///   - updateRef: The name of the reference to update to point to the commit.
///   - author: The author signature to use.
///   - committer: The committer signature to use.
///   - messageEncoding: The commit message encoding to use. Pass `nil` to
///   use the original message encoding.
///   - message: The commit message to use.
///   - tree: The commit tree to use. The underlying type must be `git_tree`.
///   - parentCount: The length of `parents`.
///   - parents: The parents of the commit. The underlying type must be an
///   array of `git_commit` instances, of length `parentCount`. All the commits
///   must belong to the given repository. This may be `nil` if `parentCount`
///   is `0`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The commit message will not be cleaned up automatically. Use
/// ``gitMessagePrettify(out:message:stripComments:commentChar:)`` to clean
/// up the commit message.
///
/// If `updateRef` is not direct, it will be resolved to a direct reference.
/// Pass `HEAD` to update the HEAD of the current branch and make it point to
/// this commit. If the reference does not exist yet, it will be created.
/// If it does exist, the first parent must be the tip of this branch.
///
/// ## C Equivalent
///
/// [`git_commit_create()`](https://libgit2.org/docs/reference/main/commit/git_commit_create.html)
public func gitCommitCreate(
    id              : inout GitOID,
    repo            : OpaquePointer,
    updateRef       : String?,
    author          : GitSignature,
    committer       : GitSignature,
    messageEncoding : String?,
    message         : String,
    tree            : OpaquePointer,
    parentCount     : Int,
    parents         : UnsafeMutablePointer<OpaquePointer?>?
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return try author.withCValue
            {
                cAuthor in
                
                return try committer.withCValue
                {
                    cCommitter in
                    
                    return git_commit_create(
                        cID,
                        repo,
                        updateRef,
                        cAuthor,
                        cCommitter,
                        messageEncoding,
                        message,
                        tree,
                        parentCount,
                        parents
                    )
                }
            }
        }
    }
}



/// Commits the staged changes in the repository.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the
///   newly-created commit.
///   - repo: The repository in which to create the commit. The underlying type
///   must be `git_repository`.
///   - message: The commit message to use.
///   - opts: The commit creation options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This is a near analog of `git commit -m message`.
///
/// ## C Equivalent
///
/// [`git_commit_create_from_stage()`](https://libgit2.org/docs/reference/main/commit/git_commit_create_from_stage.html)
public func gitCommitCreateFromStage(
    id      : inout GitOID,
    repo    : OpaquePointer,
    message : String,
    opts    : GitCommitCreateOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_commit_create_from_stage(
                    cID,
                    repo,
                    message,
                    cOpts
                )
            }
        }
    }
}



/// Amends an existing commit by replacing only non-`nil` values.
/// - Parameters:
///   - id: The ``GitOID`` instance in which to store the ID of the
///   newly-created commit.
///   - commitToAmend: The commit to amend. The underlying type must be
///   `git_commit`.
///   - updateRef: The name of the reference to update to point to the commit.
///   - author: The author signature to use.
///   - committer: The committer signature to use.
///   - messageEncoding: The commit message encoding to use. Pass `nil` to
///   use the original message encoding.
///   - message: The commit message to use.
///   - tree: The commit tree to use. The underlying type must be `git_tree`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function creates a new commit that is exactly the same as the old
/// commit, except that any non-`nil` values will be updated. The new commit
/// will have the same parents as the old commit.
///
/// If `updateRef` is not direct, it will be resolved to a direct reference.
/// Pass `HEAD` to update the HEAD of the current branch and make it point to
/// this commit. If the reference does not exist yet, it will be created.
/// If it does exist, the first parent must be the tip of this branch.
///
/// Unlike ``gitCommitCreate(id:repo:updateRef:author:committer:messageEncoding:message:tree:parentCount:parents:)``,
/// the `author`, `committer`, `message`,  and `tree` parameters can be `nil`,
/// in which case the values from the original `commitToAmend` will be used.
///
/// ## C Equivalent
///
/// [`git_commit_amend()`](https://libgit2.org/docs/reference/main/commit/git_commit_amend.html)
public func gitCommitAmend(
    id              : inout GitOID,
    commitToAmend   : OpaquePointer,
    updateRef       : String?,
    author          : GitSignature?,
    committer       : GitSignature?,
    messageEncoding : String?,
    message         : String?,
    tree            : OpaquePointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try id.withMutatingCValue
        {
            cID in
            
            return try author.withOptionalCValue
            {
                cAuthor in
                
                return try committer.withOptionalCValue
                {
                    cCommitter in
                    
                    return git_commit_amend(
                        cID,
                        commitToAmend,
                        updateRef,
                        cAuthor,
                        cCommitter,
                        messageEncoding,
                        message,
                        tree
                    )
                }
            }
        }
    }
}



/// Creates a new commit in the given repository and updates the given `Data`
/// instance with the commit content.
/// - Parameters:
///   - out: The `Data` instance in which to store the commit content.
///   - repo: The repository in which to create the commit. The underlying type
///   must be `git_repository`.
///   - author: The author signature to use.
///   - committer: The committer signature to use.
///   - messageEncoding: The commit message encoding to use. Pass `nil` to
///   use the original message encoding.
///   - message: The commit message to use.
///   - tree: The commit tree to use. The underlying type must be `git_tree`.
///   - parentCount: The length of `parents`.
///   - parents: The parents of the commit. The underlying type must be an
///   array of `git_commit` instances, of length `parentCount`. All the given
///   commits must belong to the given repository.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// `parents` may be `nil` if `parentCount` is `0`.
///
/// This function is similar to
/// ``gitCommitCreate(id:repo:updateRef:author:committer:messageEncoding:message:tree:parentCount:parents:)``,
/// except instead of writing the new commit into the object database, it
/// updates the given `Data` instance with the commit content.
///
/// ## C Equivalent
///
/// [`git_commit_create_buffer()`](https://libgit2.org/docs/reference/main/commit/git_commit_create_buffer.html)
public func gitCommitCreateBuffer(
    out             : inout Data,
    repo            : OpaquePointer,
    author          : GitSignature,
    committer       : GitSignature,
    messageEncoding : String?,
    message         : String,
    tree            : OpaquePointer,
    parentCount     : Int,
    parents         : UnsafeMutablePointer<OpaquePointer?>?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return try author.withCValue
            {
                cAuthor in
                
                return try committer.withCValue
                {
                    cCommitter in
                    
                    return git_commit_create_buffer(
                        cOut,
                        repo,
                        cAuthor,
                        cCommitter,
                        messageEncoding,
                        message,
                        tree,
                        parentCount,
                        parents
                    )
                }
            }
        }
    }
}



/// Creates a commit from the given content and signature.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the
///   newly-created commit
///   - repo: The repository in which to create the commit. The underlying type
///   must be `git_repository`.
///   - commitContent: The content of the unsigned commit to use.
///   - signature: The signature to add to the commit.
///   - signatureField: The header field containing the signature.
///   Pass `nil` to use `gpgsig`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_create_with_signature()`](https://libgit2.org/docs/reference/main/commit/git_commit_create_with_signature.html)
public func gitCommitCreateWithSignature(
    out             : inout GitOID,
    repo            : OpaquePointer,
    commitContent   : String,
    signature       : String?,
    signatureField  : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_commit_create_with_signature(
                cOut,
                repo,
                commitContent,
                signature,
                signatureField
            )
        }
    }
}



/// Creates an in-memory copy of the given commit.
/// - Parameters:
///   - out: The pointer in which to store the copied commit. The underlying
///   type must be `git_commit`.
///   - source: The commit to copy. The underlying type must be `git_commit`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_dup()`](https://libgit2.org/docs/reference/main/commit/git_commit_dup.html)
public func gitCommitDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_dup(
            out,
            source
        )
    }
}



/// Frees the memory allocated for the commits of a `git_commitarray` instance.
/// - Parameter array: The array containing the commits to free.
///
/// ## Discussion
///
/// This function does not free the `git_commitarray` instance itself, since
/// libgit2 will never allocate that object directly.
///
/// ## C Equivalent
///
/// [`git_commitarray_dispose()`](https://libgit2.org/docs/reference/main/commit/git_commitarray_dispose.html)
public func gitCommitArrayDispose(
    array: UnsafeMutablePointer<git_commitarray>?
)
{
    guard let array: UnsafeMutablePointer<git_commitarray> = array
    else
    {
        return
    }
    
    return git_commitarray_dispose(array)
}
