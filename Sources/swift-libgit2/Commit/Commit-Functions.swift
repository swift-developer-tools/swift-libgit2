//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Looks up a commit from a repository.
/// - Parameters:
///   - commit: The pointer in which to store the resulting commit. The underlying type should be
///   `git_commit`.
///   - repo: The repository in which to look up the commit. The underlying type should be
///   `git_repository`.
///   - id: The commit ID. If the object is an annotated tag, it will be peeled back to the commit.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_commit_lookup()`](https://libgit2.org/docs/reference/main/commit/git_commit_lookup.html)
public func gitCommitLookup(
    commit  : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID
) -> Int32
{
    var cID: git_oid = id.cValue
    
    return git_commit_lookup(
        commit,
        repo,
        &cID
    )
}



/// Looks up a commit from a repository, given a prefix of its identifier (short ID).
/// - Parameters:
///   - commit: The pointer in which to store the resulting commit. The underlying type should be
///   `git_commit`.
///   - repo: The repository in which to look up the commit. The underlying type should be
///   `git_repository`.
///   - id: The commit ID. If the object is an annotated tag, it will be peeled back to the commit.
///   - len: The length of the short ID.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_commit_lookup_prefix()`](https://libgit2.org/docs/reference/main/commit/git_commit_lookup_prefix.html)
public func gitCommitLookupPrefix(
    commit  : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID,
    len     : Int
) -> Int32
{
    var cID: git_oid = id.cValue
    
    return git_commit_lookup_prefix(
        commit,
        repo,
        &cID,
        len
    )
}



/// Frees the memory allocated for a `git_commit` instance.
/// - Parameter commit: The commit to free. The underlying type should be `git_commit`.
///
/// ## C Equivalent
///
/// [`git_commit_free()`](https://libgit2.org/docs/reference/main/commit/git_commit_free.html)
public func gitCommitFree(
    commit: OpaquePointer?
)
{
    git_commit_free(commit)
}



/// Gets the ID of the given commit.
/// - Parameter commit: The commit.  The underlying type should be `git_commit`.
/// - Returns: The commit ID.
///
/// ## C Equivalent
///
/// [`git_commit_id()`](https://libgit2.org/docs/reference/main/commit/git_commit_id.html)
public func gitCommitID(
    commit: OpaquePointer
) -> GitOID
{
    let commitID: UnsafePointer<git_oid> = git_commit_id(commit)
    
    return GitOID(cValue: commitID.pointee)
}



/// Gets the repository that contains the given commit.
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The repository that contains the commit.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The message of the given commit.
///
/// ## Discussion
///
/// The returned message will be slightly prettified by removing any potential leading newlines.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The summary of the given commit.
///
/// ## Discussion
///
/// The summary of a commit is the first paragraph of the commit message with whitespace trimmed and
/// squashed.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The body of the given commit.
///
/// ## Discussion
///
/// The body of a commit is everything except the first paragraph of the commit message. Leading and
/// trailing whitespace will be trimmed.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
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
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The committer of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_committer()`](https://libgit2.org/docs/reference/main/commit/git_commit_committer.html)
public func gitCommitCommitter(
    commit: OpaquePointer
) -> GitSignature
{
    let committer: UnsafePointer<git_signature> = git_commit_committer(commit)
    
    return GitSignature(cValue: committer.pointee)
}



/// Gets the author of the given commit.
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The author of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_author()`](https://libgit2.org/docs/reference/main/commit/git_commit_author.html)
public func gitCommitAuthor(
    commit: OpaquePointer
) -> GitSignature
{
    let author: UnsafePointer<git_signature> = git_commit_author(commit)
    
    return GitSignature(cValue: author.pointee)
}



/// Gets the committer of the given commit, using the mailmap to map names and email addresses to
/// canonical real names and email addresses.
/// - Parameters:
///   - out: The resolved signature.
///   - commit: The commit. The underlying type should be `git_commit`.
///   - mailmap: The mailmap with which to resolve the signature. The underlying type should be
///   `git_mailmap`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If an error occurs, `out` will not be updated.
///
/// ## C Equivalent
///
/// [`git_commit_committer_with_mailmap()`](https://libgit2.org/docs/reference/main/commit/git_commit_committer_with_mailmap.html)
public func gitCommitCommitterWithMailmap(
    out     : inout GitSignature,
    commit  : OpaquePointer,
    mailmap : OpaquePointer?
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return git_commit_committer_with_mailmap(
            cOut,
            commit,
            mailmap
        )
    }
}



/// Gets the author of the given commit, using the mailmap to map names and email addresses to
/// canonical real names and email addresses.
/// - Parameters:
///   - out: The resolved signature.
///   - commit: The commit. The underlying type should be `git_commit`.
///   - mailmap: The mailmap with which to resolve the signature. The underlying type should be
///   `git_mailmap`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If an error occurs, `out` will not be updated.
///
/// ## C Equivalent
///
/// [`git_commit_author_with_mailmap()`](https://libgit2.org/docs/reference/main/commit/git_commit_author_with_mailmap.html)
public func gitCommitAuthorWithMailmap(
    out     : inout GitSignature,
    commit  : OpaquePointer,
    mailmap : OpaquePointer?
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return git_commit_author_with_mailmap(
            cOut,
            commit,
            mailmap
        )
    }
}



/// Gets the raw text of the given commit's header.
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
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
///   - out: The pointer in which to store the resulting tree. The underlying type should be `git_tree`.
///   - commit:The commit. The underlying type should be `git_commit`.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_commit_tree()`](https://libgit2.org/docs/reference/main/commit/git_commit_tree.html)
public func gitCommitTree(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    commit  : OpaquePointer
) -> Int32
{
    return git_commit_tree(
        out,
        commit
    )
}



/// Gets the ID of the tree pointed to by the given commit.
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The ID of the tree pointed to by the given commit.
///
/// ## Discussion
///
/// This function differs from ``gitCommitTree(out:commit:)`` in that no attempts will be made
/// to fetch an object from the object database.
///
/// ## C Equivalent
///
/// [`git_commit_tree_id()`](https://libgit2.org/docs/reference/main/commit/git_commit_tree_id.html)
public func gitCommitTreeID(
    commit: OpaquePointer
) -> GitOID
{
    let treeID: UnsafePointer<git_oid> = git_commit_tree_id(commit)
    
    return GitOID(cValue: treeID.pointee)
}



/// Gets the number of parents of the given commit.
/// - Parameter commit: The commit. The underlying type should be `git_commit`.
/// - Returns: The number of parents of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_parentcount()`](https://libgit2.org/docs/reference/main/commit/git_commit_parentcount.html)
public func gitCommitParentCount(
    commit: OpaquePointer
) -> Int
{
    let parentCount: UInt32 = git_commit_parentcount(commit)
    
    return Int(parentCount)
}



/// Gets the specified parent of the given commit.
/// - Parameters:
///   - out: The pointer in which to store the resulting parent commit. The underlying type should be
///   `git_commit`.
///   - commit: The commit. The underlying type should be `git_commit`.
///   - n: The 0-indexed position of the parent.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_commit_parent()`](https://libgit2.org/docs/reference/main/commit/git_commit_parent.html)
public func gitCommitParent(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    commit  : OpaquePointer,
    n       : UInt
) -> Int32
{
    return git_commit_parent(
        out,
        commit,
        UInt32(n)
    )
}



/// Gets the ID of the specified parent of the given commit.
/// - Parameters:
///   - commit: The commit. The underlying type should be `git_commit`.
///   - n: The 0-indexed position of the parent.
/// - Returns: The ID of the specified parent of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_parent_id()`](https://libgit2.org/docs/reference/main/commit/git_commit_parent_id.html)
public func gitCommitParentID(
    commit  : OpaquePointer,
    n       : UInt
) -> GitOID
{
    let parentCommitID: UnsafePointer<git_oid> = git_commit_parent_id(
        commit,
        UInt32(n)
    )
    
    return GitOID(cValue: parentCommitID.pointee)
}



/// Gets the commit that is the n<sup>th</sup> generation ancestor of the given commit, following only
/// the first parents.
/// - Parameters:
///   - ancestor: The pointer in which to store the resulting ancestor commit. The underlying type
///   should be `git_commit`.
///   - commit: The commit. The underlying type should be `git_commit`.
///   - n: The 0-indexed generation.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// Passing `0` as the generation number will return another instance of the given commit.
///
/// ## C Equivalent
///
/// [`git_commit_nth_gen_ancestor()`](https://libgit2.org/docs/reference/main/commit/git_commit_nth_gen_ancestor.html)
public func gitCommitNthGenAncestor(
    ancestor    : UnsafeMutablePointer<OpaquePointer?>,
    commit      : OpaquePointer,
    n           : UInt
) -> Int32
{
    return git_commit_nth_gen_ancestor(
        ancestor,
        commit,
        UInt32(n)
    )
}



/// Gets the a header field from the given commit.
/// - Parameters:
///   - out: The buffer into which the header field should be written.
///   - commit: The commit in which to look. The underlying type should be `git_commit`.
///   - field: The header field to return.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_commit_header_field()`](https://libgit2.org/docs/reference/main/commit/git_commit_header_field.html)
public func gitCommitHeaderField(
    out     : inout GitBuf,
    commit  : OpaquePointer,
    field   : String
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return field.withCString
        {
            cField in
            
            return git_commit_header_field(
                cOut,
                commit,
                cField
            )
        }
    }
}



// TODO: Replace `GIT_ERROR_INVALID` and `GIT_ERROR_OBJECT` in documentation.
/// Extracts the signature from a commit.
/// - Parameters:
///   - signature: The buffer into which the signature block should be written.
///   - signedData: The buffer into which the signed data (the commit content less the signature
///   block) should be written.
///   - repo: The repository in which the commit exists. The underlying type should be
///   `git_repository`.
///   - commitID: The commit from which to extract the data.
///   - field: The name of the header field containing the signature block. Pass `nil` to extract
///   `gpgsig`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If `commitID` is not the ID of a commit, the error class will be `GIT_ERROR_INVALID`.
///
/// If the commit does not have a signature, the error class will be `GIT_ERROR_OBJECT`.
///
/// ## C Equivalent
///
/// [`git_commit_extract_signature()`](https://libgit2.org/docs/reference/main/commit/git_commit_extract_signature.html)
public func gitCommitExtractSignature(
    signature   : inout GitBuf,
    signedData  : inout GitBuf,
    repo        : OpaquePointer,
    commitID    : GitOID,
    field       : String?
) -> Int32
{
    var cCommitID: git_oid = commitID.cValue
    
    return signature.withMutatingCValue
    {
        cSignature in
        
        return signedData.withMutatingCValue
        {
            cSignedData in
            
            guard let field: String = field
            else
            {
                return git_commit_extract_signature(
                    cSignature,
                    cSignedData,
                    repo,
                    &cCommitID,
                    nil
                )
            }
            
            return field.withCString
            {
                cField in
                
                return git_commit_extract_signature(
                    cSignature,
                    cSignedData,
                    repo,
                    &cCommitID,
                    cField
                )
            }
        }
    }
}



// TODO: Replace `git_message_prettify()` in documentation.
/// Creates a new commit in the given repository from a list of `git_object` pointers.
/// - Parameters:
///   - id: The ID of the newly-created commit.
///   - repo: The repository in which to store the commit. The underlying type should be
///   `git_repository`.
///   - updateRef: The name of the reference that will be updated to point to the commit.
///   - author: The author of the commit.
///   - committer: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - tree: The tree object that should be used as the tree for the commit. The underlying type should
///   be `git_tree`.
///   - parentCount: The number of parents of the commit.
///   - parents: The parents of the commit. The underlying type should be an array of `git_commit`
///   objects, of length `parentCount`. All the given commits should be owned by `repo`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The commit message will not be cleaned up automatically. Use `git_message_prettify()`
/// to clean up the commit message.
///
/// If `updateRef` is not direct, it will be resolved to a direct reference. Pass `HEAD` to update the
/// HEAD of the current branch and make it point to this commit. If the reference does not exist yet, it will
/// be created. If it does exist, the first parent must be the tip of this branch.
///
/// `parents` may be `nil` if `parentCount` is `0`.
///
/// ## Variadic Function
///
/// libgit2 provides a similar variadic function called
/// [`git_commit_create_v()`](https://libgit2.org/docs/reference/main/commit/git_commit_create_v.html).
/// There is no binding for `git_commit_create_v()`, since it uses the `...` syntax for its
/// variadic arguments, and Swift can only import C variadic functions that use a `va_list` for their
/// arguments.
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
) -> Int32
{
    var cID: git_oid = id.cValue
    
    let commitCreateResult: Int32 = author.withCValue
    {
        cAuthor in
        
        return committer.withCValue
        {
            cCommitter in
            
            return message.withCString
            {
                cMessage in
                
                return withComposedCommitCreateProperties(
                    updateRef,
                    messageEncoding
                )
                {
                    cUpdateRef, cMessageEncoding in
                    
                    return git_commit_create(
                        &cID,
                        repo,
                        cUpdateRef,
                        cAuthor,
                        cCommitter,
                        cMessageEncoding,
                        cMessage,
                        tree,
                        parentCount,
                        parents
                    )
                }
            }
        }
    }
    
    
    
    id = GitOID(cValue: cID)
    
    return commitCreateResult
}



/// Commits the staged changes in the repository.
/// - Parameters:
///   - id: The ID of the newly-created commit.
///   - repo: The repository in which to store the commit. The underlying type should be
///   `git_repository`.
///   - message: The commit message.
///   - opts: The options for commit creation.
/// - Returns: `0` on success, or an error code.
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
) -> Int32
{
    var cID: git_oid = id.cValue
    
    
    
    let commitCreateFromStageResult: Int32 = message.withCString
    {
        cMessage in
        
        guard let opts: GitCommitCreateOptions = opts
        else
        {
            return git_commit_create_from_stage(
                &cID,
                repo,
                cMessage,
                nil
            )
        }
        
        return opts.withCValue
        {
            cOpts in
            
            return git_commit_create_from_stage(
                &cID,
                repo,
                cMessage,
                cOpts
            )
        }
    }
    
    
    
    id = GitOID(cValue: cID)
    
    return commitCreateFromStageResult
}



/// Amends an existing commit by replacing only non-`nil` values.
/// - Parameters:
///   - id: The ID of the newly-created commit.
///   - commitToAmend: The commit to amend. The underlying type should be `git_commit`.
///   - updateRef: The name of the reference that will be updated to point to the commit.
///   - author: The author of the commit.
///   - committer: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - tree: The tree object that should be used as the tree for the commit. The underlying type should
///   be `git_tree`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function creates a new commit that is exactly the same as the old commit, except that any
/// non-`nil` values will be updated. The new commit will have the same parents as the old commit.
///
/// If `updateRef` is not direct, it will be resolved to a direct reference. Pass `HEAD` to update the
/// HEAD of the current branch and make it point to this commit. If the reference does not exist yet, it will
/// be created. If it does exist, the first parent must be the tip of this branch.
///
/// Unlike ``gitCommitCreate(id:repo:updateRef:author:committer:messageEncoding:message:tree:parentCount:parents:)``,
/// the `author`, `committer`, `message`,  and `tree` parameters can be `nil`, in which case
/// the values from the original `commitToAmend` will be used.
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
) -> Int32
{
    var cID: git_oid = id.cValue
    
    
    
    let commitAmendResult: Int32 = withComposedCommitAmendProperties(
        updateRef,
        author,
        committer,
        messageEncoding,
        message
    )
    {
        cUpdateRef, cAuthor, cCommitter, cMessageEncoding, cMessage in
        
        return git_commit_amend(
            &cID,
            commitToAmend,
            cUpdateRef,
            cAuthor,
            cCommitter,
            cMessageEncoding,
            cMessage,
            tree
        )
    }
    
    
    
    id = GitOID(cValue: cID)
    
    return commitAmendResult
}



/// Creates a new commit in the given repository and writes it into a buffer.
/// - Parameters:
///   - out: The buffer into which the commit content should be written.
///   - repo: The repository in which to store the commit. The underlying type should be
///   `git_repository`.
///   - author: The author of the commit.
///   - committer: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - tree: The tree object that should be used as the tree for the commit. The underlying type should
///   be `git_tree`.
///   - parentCount: The number of parents of the commit.
///   - parents: The parents of the commit. The underlying type should be an array of `git_commit`
///   objects, of length `parentCount`. All the given commits should be owned by `repo`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// `parents` may be `nil` if `parentCount` is `0`.
///
/// This function is similar to
/// ``gitCommitCreate(id:repo:updateRef:author:committer:messageEncoding:message:tree:parentCount:parents:)``,
/// except instead of writing the new commit into the object database, it writes the commit content into
/// the given buffer.
///
/// ## C Equivalent
///
/// [`git_commit_create_buffer()`](https://libgit2.org/docs/reference/main/commit/git_commit_create_buffer.html)
public func gitCommitCreateBuffer(
    out             : inout GitBuf,
    repo            : OpaquePointer,
    author          : GitSignature,
    committer       : GitSignature,
    messageEncoding : String?,
    message         : String,
    tree            : OpaquePointer,
    parentCount     : Int,
    parents         : UnsafeMutablePointer<OpaquePointer?>?
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return author.withCValue
        {
            cAuthor in
            
            return committer.withCValue
            {
                cCommitter in
                
                return message.withCString
                {
                    cMessage in
                    
                    guard let messageEncoding: String = messageEncoding
                    else
                    {
                        return git_commit_create_buffer(
                            cOut,
                            repo,
                            cAuthor,
                            cCommitter,
                            nil,
                            cMessage,
                            tree,
                            parentCount,
                            parents
                        )
                    }
                    
                    return messageEncoding.withCString
                    {
                        cMessageEncoding in
                        
                        return git_commit_create_buffer(
                            cOut,
                            repo,
                            cAuthor,
                            cCommitter,
                            cMessageEncoding,
                            cMessage,
                            tree,
                            parentCount,
                            parents
                        )
                    }
                }
            }
        }
    }
}



/// Creates a commit from the given content and signature.
/// - Parameters:
///   - out: The ID of the newly-created commit
///   - repo: The repository in which to store the commit. The underlying type should be
///   `git_repository`.
///   - commitContent: The content of the unsigned commit.
///   - signature: The signature to add to the commit.
///   - signatureField: The header field which should contain the signature. Pass `nil` to use
///   `gpgsig`.
/// - Returns: `0` on success, or an error code.
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
) -> Int32
{
    var cOut: git_oid = out.cValue
    
    
    
    let commitCreateWithSignatureResult: Int32 = commitContent.withCString
    {
        cCommitContent in
        
        return (signatureField ?? "gpgsig").withCString
        {
            cSignatureField in
            
            guard let signature: String = signature
            else
            {
                return git_commit_create_with_signature(
                    &cOut,
                    repo,
                    cCommitContent,
                    nil,
                    cSignatureField
                )
            }
            
            return signature.withCString
            {
                cSignature in
                
                return git_commit_create_with_signature(
                    &cOut,
                    repo,
                    cCommitContent,
                    cSignature,
                    cSignatureField
                )
            }
        }
    }
    
    
    
    out = GitOID(cValue: cOut)
    
    return commitCreateWithSignatureResult
}



/// Creates an in-memory copy of the given commit.
/// - Parameters:
///   - out: The pointer in which to store the resulting commit. The underlying type should be
///   `git_commit`.
///   - source: The original commit to copy. The underlying type should be `git_commit`.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_commit_dup()`](https://libgit2.org/docs/reference/main/commit/git_commit_dup.html)
public func gitCommitDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> Int32
{
    return git_commit_dup(
        out,
        source
    )
}



/// Frees the commits contained in a `git_commitarray`.
/// - Parameter array: The array containing the commits to free.
///
/// ## Discussion
///
/// This function is only needed when working directly with `git_commitarray` instances allocated by
/// libgit2. ``GitCommitArray`` instances do not need to be freed.
///
/// This function does not free the `git_commitarray` itself, since libgit2 will never allocate that object
/// directly.
///
/// ## C Equivalent
///
/// [`git_commitarray_dispose()`](https://libgit2.org/docs/reference/main/commit/git_commitarray_dispose.html)
public func gitCommitArrayDispose(
    array: UnsafeMutablePointer<git_commitarray>?
)
{
    return git_commitarray_dispose(array)
}



// MARK: - Private

/// Composes the optional properties of
/// ``gitCommitCreate(id:repo:updateRef:author:committer:messageEncoding:message:tree:parentCount:parents:)``,
/// then calls the given closure with optional pointers to the C values.
/// - Parameters:
///   - updateRef: The name of the reference that will be updated to point to the commit.
///   - messageEncoding: The encoding of the commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// This function composes the following optional properties:
/// - `updateRef`
/// - `messageEncoding`
///
/// The composition begins by calling ``withCommitCreateUpdateRef(_:_:_:)``.
private func withComposedCommitCreateProperties<T>(
    _   updateRef       : String?,
    _   messageEncoding : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   messageEncoding : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    return withCommitCreateUpdateRef(
        updateRef,
        messageEncoding,
        body
    )
}



/// Composes the value of `updateRef`, then continues the composition by calling
/// ``withCommitCreateMessageEncoding(_:_:_:)``.
/// - Parameters:
///   - updateRef: The name of the reference that will be updated to point to the commit.
///   - messageEncoding: The encoding of the commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// If `updateRef` is `nil`, this function will proceed directly to the next step in the composition.
private func withCommitCreateUpdateRef<T>(
    _   updateRef       : String?,
    _   messageEncoding : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   messageEncoding : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    guard let updateRef: String = updateRef
    else
    {
        return withCommitCreateMessageEncoding(
            nil,
            messageEncoding,
            body
        )
    }
    
    return updateRef.withCString
    {
        cUpdateRef in
        
        return withCommitCreateMessageEncoding(
            cUpdateRef,
            messageEncoding,
            body
        )
    }
}



/// Composes the value of `messageEncoding`, then finishes the composition by calling the given closure.
/// - Parameters:
///   - cUpdateRef: The name of the reference that will be updated to point to the commit.
///   - messageEncoding: The encoding of the commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// If `messageEncoding` is `nil`, this function will proceed directly to calling the given closure.
private func withCommitCreateMessageEncoding<T>(
    _   cUpdateRef      : UnsafePointer<CChar>?,
    _   messageEncoding : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   messageEncoding : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    guard let messageEncoding: String = messageEncoding
    else
    {
        return body(
            cUpdateRef,
            nil
        )
    }
    
    return messageEncoding.withCString
    {
        cMessageEncoding in
        
        return body(
            cUpdateRef,
            cMessageEncoding
        )
    }
}



/// Composes the optional properties of
/// ``gitCommitAmend(id:commitToAmend:updateRef:author:committer:messageEncoding:message:tree:)``,
/// then calls the given closure with optional pointers to the C values.
/// - Parameters:
///   - updateRef: The name of the reference that will be updated to point to the commit.
///   - author: The author of the commit.
///   - committer: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// This function composes the following optional properties:
/// - `updateRef`
/// - `author`
/// - `committer`
/// - `messageEncoding`
/// - `message`
///
/// The composition begins by calling ``withCommitAmendUpdateRef(_:_:_:_:_:_:)``.
private func withComposedCommitAmendProperties<T>(
    _   updateRef       : String?,
    _   author          : GitSignature?,
    _   committer       : GitSignature?,
    _   messageEncoding : String?,
    _   message         : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   author          : UnsafePointer<git_signature>?,
        _   committer       : UnsafePointer<git_signature>?,
        _   messageEncoding : UnsafePointer<CChar>?,
        _   message         : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    return withCommitAmendUpdateRef(
        updateRef,
        author,
        committer,
        messageEncoding,
        message,
        body
    )
}



/// Composes the value of `updateRef`, then continues the composition by calling
/// ``withCommitAmendAuthor(_:_:_:_:_:_:)``.
/// - Parameters:
///   - updateRef: The name of the reference that will be updated to point to the commit.
///   - author: The author of the commit.
///   - committer: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// If `updateRef` is `nil`, this function will proceed directly to the next step in the composition.
private func withCommitAmendUpdateRef<T>(
    _   updateRef       : String?,
    _   author          : GitSignature?,
    _   committer       : GitSignature?,
    _   messageEncoding : String?,
    _   message         : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   author          : UnsafePointer<git_signature>?,
        _   committer       : UnsafePointer<git_signature>?,
        _   messageEncoding : UnsafePointer<CChar>?,
        _   message         : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    guard let updateRef: String = updateRef
    else
    {
        return withCommitAmendAuthor(
            nil,
            author,
            committer,
            messageEncoding,
            message,
            body
        )
    }
    
    return updateRef.withCString
    {
        cUpdateRef in
        
        return withCommitAmendAuthor(
            cUpdateRef,
            author,
            committer,
            messageEncoding,
            message,
            body
        )
    }
}



/// Composes the value of `author`, then continues the composition by calling
/// ``withCommitAmendCommitter(_:_:_:_:_:_:)``.
/// - Parameters:
///   - cUpdateRef: The name of the reference that will be updated to point to the commit.
///   - author: The author of the commit.
///   - committer: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// If `author` is `nil`, this function will proceed directly to the next step in the composition.
private func withCommitAmendAuthor<T>(
    _   cUpdateRef      : UnsafePointer<CChar>?,
    _   author          : GitSignature?,
    _   committer       : GitSignature?,
    _   messageEncoding : String?,
    _   message         : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   author          : UnsafePointer<git_signature>?,
        _   committer       : UnsafePointer<git_signature>?,
        _   messageEncoding : UnsafePointer<CChar>?,
        _   message         : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    guard let author: GitSignature = author
    else
    {
        return withCommitAmendCommitter(
            cUpdateRef,
            nil,
            committer,
            messageEncoding,
            message,
            body
        )
    }
    
    return author.withCValue
    {
        cAuthor in
        
        return withCommitAmendCommitter(
            cUpdateRef,
            UnsafePointer(cAuthor),
            committer,
            messageEncoding,
            message,
            body
        )
    }
}



/// Composes the value of `committer`, then continues the composition by calling
/// ``withCommitAmendMessageEncoding(_:_:_:_:_:_:)``.
/// - Parameters:
///   - cUpdateRef: The name of the reference that will be updated to point to the commit.
///   - cAuthor: The author of the commit.
///   - committer: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// If `committer` is `nil`, this function will proceed directly to the next step in the composition.
private func withCommitAmendCommitter<T>(
    _   cUpdateRef      : UnsafePointer<CChar>?,
    _   cAuthor         : UnsafePointer<git_signature>?,
    _   committer       : GitSignature?,
    _   messageEncoding : String?,
    _   message         : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   author          : UnsafePointer<git_signature>?,
        _   committer       : UnsafePointer<git_signature>?,
        _   messageEncoding : UnsafePointer<CChar>?,
        _   message         : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    guard let committer: GitSignature = committer
    else
    {
        return withCommitAmendMessageEncoding(
            cUpdateRef,
            cAuthor,
            nil,
            messageEncoding,
            message,
            body
        )
    }
    
    return committer.withCValue
    {
        cCommitter in
        
        return withCommitAmendMessageEncoding(
            cUpdateRef,
            cAuthor,
            UnsafePointer(cCommitter),
            messageEncoding,
            message,
            body
        )
    }
}



/// Composes the value of `messageEncoding`, then continues the composition by calling
/// ``withCommitAmendMessage(_:_:_:_:_:_:)``.
/// - Parameters:
///   - cUpdateRef: The name of the reference that will be updated to point to the commit.
///   - cAuthor: The author of the commit.
///   - cCommitter: The committer of the commit.
///   - messageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// If `messageEncoding` is `nil`, this function will proceed directly to the next step in the composition.
private func withCommitAmendMessageEncoding<T>(
    _   cUpdateRef      : UnsafePointer<CChar>?,
    _   cAuthor         : UnsafePointer<git_signature>?,
    _   cCommitter      : UnsafePointer<git_signature>?,
    _   messageEncoding : String?,
    _   message         : String?,
    _   body            : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   author          : UnsafePointer<git_signature>?,
        _   committer       : UnsafePointer<git_signature>?,
        _   messageEncoding : UnsafePointer<CChar>?,
        _   message         : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    guard let messageEncoding: String = messageEncoding
    else
    {
        return withCommitAmendMessage(
            cUpdateRef,
            cAuthor,
            cCommitter,
            nil,
            message,
            body
        )
    }
    
    return messageEncoding.withCString
    {
        cMessageEncoding in
        
        return withCommitAmendMessage(
            cUpdateRef,
            cAuthor,
            cCommitter,
            cMessageEncoding,
            message,
            body
        )
    }
}



/// Composes the value of `message`, then finishes the composition by calling the given closure.
/// - Parameters:
///   - cUpdateRef: The name of the reference that will be updated to point to the commit.
///   - cAuthor: The author of the commit.
///   - cCommitter: The committer of the commit.
///   - cMessageEncoding: The encoding of the commit message.
///   - message: The commit message.
///   - body: The closure to call.
/// - Returns: The return value of the given closure.
///
/// ## Discussion
///
/// If `message` is `nil`, this function will proceed directly to calling the given closure.
private func withCommitAmendMessage<T>(
    _   cUpdateRef          : UnsafePointer<CChar>?,
    _   cAuthor             : UnsafePointer<git_signature>?,
    _   cCommitter          : UnsafePointer<git_signature>?,
    _   cMessageEncoding    : UnsafePointer<CChar>?,
    _   message             : String?,
    _   body                : (
        _   updateRef       : UnsafePointer<CChar>?,
        _   author          : UnsafePointer<git_signature>?,
        _   committer       : UnsafePointer<git_signature>?,
        _   messageEncoding : UnsafePointer<CChar>?,
        _   message         : UnsafePointer<CChar>?
    ) -> T
) -> T
{
    guard let message: String = message
    else
    {
        return body(
            cUpdateRef,
            cAuthor,
            cCommitter,
            cMessageEncoding,
            nil
        )
    }
    
    return message.withCString
    {
        cMessage in
        
        return body(
            cUpdateRef,
            cAuthor,
            cCommitter,
            cMessageEncoding,
            cMessage
        )
    }
}
