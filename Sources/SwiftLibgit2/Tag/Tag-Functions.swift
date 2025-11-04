//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Looks up the specified tag.
/// - Parameters:
///   - out: The pointer in which to store the tag. The underlying type must
///   be `git_tag`.
///   - repo: The repository containing the tag. The underlying type must
///   be `git_repository`.
///   - id: The ID of the tag to look up.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_lookup()`](https://libgit2.org/docs/reference/main/tag/git_tag_lookup.html)
public func gitTagLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_tag_lookup(
                out,
                repo,
                cID
            )
        }
    }
}



/// Looks up the specified tag in the given repository, using a prefix of the
/// tag's ID.
/// - Parameters:
///   - out: The pointer in which to store the tag. The underlying
///   type must be `git_tag`.
///   - repo: The repository containing the tag. The underlying type must
///   be `git_repository`.
///   - id: The prefix of the ID of the tag to lookup.
///   - len: The length of the tag's ID prefix. This must be greater than or
///   equal to ``gitOIDMinPrefixLen``, and long enough to identify a unique
///   tag matching the prefix.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_lookup_prefix()`](https://libgit2.org/docs/reference/main/tag/git_tag_lookup_prefix.html)
public func gitTagLookupPrefix(
    out     : UnsafeMutablePointer<OpaquePointer?>,
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
            
            return git_tag_lookup_prefix(
                out,
                repo,
                cID,
                len
            )
        }
    }
}



/// Frees the memory allocated for the given `git_tag` instance.
/// - Parameter tag: The tag to free. The underlying type must be `git_tag`.
///
/// ## C Equivalent
///
/// [`git_tag_free()`](https://libgit2.org/docs/reference/main/tag/git_tag_free.html)
public func gitTagFree(
    tag: OpaquePointer?
)
{
    guard let tag
    else
    {
        return
    }
    
    git_tag_free(tag)
}



/// Gets the ID of the given tag.
/// - Parameter tag: The tag for which to get the ID. The underlying type must
/// be `git_tag`.
/// - Returns: The ID of the given tag.
///
/// ## C Equivalent
///
/// [`git_tag_id()`](https://libgit2.org/docs/reference/main/tag/git_tag_id.html)
public func gitTagID(
    tag: OpaquePointer
) -> GitOID?
{
    guard let tagOID: UnsafePointer<git_oid> = git_tag_id(tag)
    else
    {
        return nil
    }
    
    return GitOID(cValue: tagOID.pointee)
}



/// Gets the repository containing the given tag.
/// - Parameter tag: The tag for which to get the repository. The underlying
/// type must be `git_tag`.
/// - Returns: The repository containing the given tag. The underlying type
/// will be `git_repository`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given tag and must
/// not be freed.
///
/// ## C Equivalent
///
/// [`git_tag_owner()`](https://libgit2.org/docs/reference/main/tag/git_tag_owner.html)
public func gitTagOwner(
    tag: OpaquePointer
) -> OpaquePointer
{
    return git_tag_owner(tag)
}



/// Gets the tagged object of the given tag.
/// - Parameters:
///   - targetOut: The pointer in which to store the tagged object. The
///   underlying type must be `git_object`.
///   - tag: The tag for which to get the tagged object. The underlying type
///   must be `git_tag`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_target()`](https://libgit2.org/docs/reference/main/tag/git_tag_target.html)
public func gitTagTarget(
    targetOut   : UnsafeMutablePointer<OpaquePointer?>,
    tag         : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tag_target(
            targetOut,
            tag
        )
    }
}



/// Gets the tagged object ID of the given tag.
/// - Parameter tag: The tag for which to get the tagged object ID. The
/// underlying type must be `git_tag`.
/// - Returns: The tagged object ID of the given tag.
///
/// ## C Equivalent
///
/// [`git_tag_target_id()`](https://libgit2.org/docs/reference/main/tag/git_tag_target_id.html)
public func gitTagTargetID(
    tag: OpaquePointer
) -> GitOID?
{
    guard let tagTargetOID: UnsafePointer<git_oid> = git_tag_target_id(tag)
    else
    {
        return nil
    }
    
    return GitOID(cValue: tagTargetOID.pointee)
}



/// Gets the tagged object type of the given tag.
/// - Parameter tag: The tag for which to get the tagged object type. The
/// underlying type must be `git_tag`.
/// - Returns: The tagged object type of the given tag.
///
/// ## C Equivalent
///
/// [`git_tag_target_type()`](https://libgit2.org/docs/reference/main/tag/git_tag_target_type.html)
public func gitTagTargetType(
    tag: OpaquePointer
) -> GitObjectT?
{
    let objectType: git_object_t = git_tag_target_type(tag)
    
    return GitObjectT(cValue: objectType)
}



/// Gets the name of the given tag.
/// - Parameter tag: The tag for which to get the name. The underlying type
/// must be `git_tag`.
/// - Returns: The name of the given tag.
///
/// ## C Equivalent
///
/// [`git_tag_name()`](https://libgit2.org/docs/reference/main/tag/git_tag_name.html)
public func gitTagName(
    tag: OpaquePointer
) -> String?
{
    let tagName: UnsafePointer<CChar>? = git_tag_name(tag)
    
    return String(optionalCString: tagName)
}



/// Gets the author signature of the given tag.
/// - Parameter tag: The tag for which to get the author signature. The
/// underlying type must be `git_tag`.
/// - Returns: The author signature of the given tag.
///
/// ## C Equivalent
///
/// [`git_tag_tagger()`](https://libgit2.org/docs/reference/main/tag/git_tag_tagger.html)
public func gitTagTagger(
    tag: OpaquePointer
) -> GitSignature?
{
    guard let taggerSignature: UnsafePointer<git_signature>
            = git_tag_tagger(tag)
    else
    {
        return nil
    }
    
    return GitSignature(cValue: taggerSignature.pointee)
}



/// Gets the message of the given tag.
/// - Parameter tag: The tag for which to get the message. The underlying type
/// must be `git_tag`.
/// - Returns: The message of the given tag.
///
/// ## C Equivalent
///
/// [`git_tag_message()`](https://libgit2.org/docs/reference/main/tag/git_tag_message.html)
public func gitTagMessage(
    tag: OpaquePointer
) -> String?
{
    let tagMessage: UnsafePointer<CChar>? = git_tag_message(tag)
    
    return String(optionalCString: tagMessage)
}



/// Creates a tag in the given repository.
/// - Parameters:
///   - oid: The ``GitOID`` instance in which to store the ID of the tag.
///   - repo: The repository in which to create the tag. The underlying type
///   must be `git_repository`.
///   - tagName: The tag name to use. This will be checked for validity.
///   - target: The object to which to point the tag. The underlying type
///   must be `git_object`. This must belong to the given repository.
///   - tagger: The author signature to use.
///   - message: The tag message to use.
///   - force: Whether to overwrite an existing tag.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The tag message will not be cleaned up automatically. Use
/// ``gitMessagePrettify(out:message:stripComments:commentChar:)`` to clean
/// up the tag message.
///
/// ## C Equivalent
///
/// [`git_tag_create()`](https://libgit2.org/docs/reference/main/tag/git_tag_create.html)
public func gitTagCreate(
    oid     : inout GitOID,
    repo    : OpaquePointer,
    tagName : String,
    target  : OpaquePointer,
    tagger  : GitSignature,
    message : String,
    force   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return try oid.withMutatingCValue
        {
            cOID in
            
            return try tagger.withCValue
            {
                cTagger in
                
                return git_tag_create(
                    cOID,
                    repo,
                    tagName,
                    target,
                    cTagger,
                    message,
                    force.int32Value
                )
            }
        }
    }
}



/// Creates a tag in the given repository.
/// - Parameters:
///   - oid: The ``GitOID`` instance in which to store the ID of the tag.
///   - repo: The repository in which to create the tag. The underlying type
///   must be `git_repository`.
///   - tagName: The tag name to use. This will be checked for validity.
///   - target: The object to which to point the tag. The underlying type
///   must be `git_object`. This must belong to the given repository.
///   - tagger: The author signature to use.
///   - message: The tag message to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The tag message will not be cleaned up automatically. Use
/// ``gitMessagePrettify(out:message:stripComments:commentChar:)`` to clean
/// up the tag message.
///
/// ## C Equivalent
///
/// [`git_tag_annotation_create()`](https://libgit2.org/docs/reference/main/tag/git_tag_annotation_create.html)
public func gitTagAnnotationCreate(
    oid     : inout GitOID,
    repo    : OpaquePointer,
    tagName : String,
    target  : OpaquePointer,
    tagger  : GitSignature,
    message : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try oid.withMutatingCValue
        {
            cOID in
            
            return try tagger.withCValue
            {
                cTagger in
                
                return git_tag_annotation_create(
                    cOID,
                    repo,
                    tagName,
                    target,
                    cTagger,
                    message
                )
            }
        }
    }
}



/// Creates a tag in the given repository.
/// - Parameters:
///   - oid: The ``GitOID`` instance in which to store the ID of the tag.
///   - repo: The repository in which to create the tag. The underlying type
///   must be `git_repository`.
///   - buffer: The raw tag data to use.
///   - force: Whether to overwrite an existing tag.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_create_from_buffer()`](https://libgit2.org/docs/reference/main/tag/git_tag_create_from_buffer.html)
public func gitTagCreateFromBuffer(
    oid     : inout GitOID,
    repo    : OpaquePointer,
    buffer  : String,
    force   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return try oid.withMutatingCValue
        {
            cOID in
            
            /// "Raw tag data" in the documentation refers to the complete
            /// tag object format, not binary data. Since Git tag objects are
            /// always UTF-8 text, `String` is the correct type for `buffer`.
            ///
            /// `Data` must not be used. `git_tag_create_frombuffer()` uses
            /// `strlen()` in its implementation, and passing a `Data` instance
            /// containing content that is not null-terminated will cause a
            /// heap buffer overflow. If `Data` is used, a null terminator
            /// must be added before converting it to a C buffer.
            return git_tag_create_frombuffer(
                cOID,
                repo,
                buffer,
                force.int32Value
            )
        }
    }
}



/// Creates a lightweight tag in the given repository.
/// - Parameters:
///   - oid: The ``GitOID`` instance in which to store the ID of the tag.
///   - repo: The repository in which to create the tag. The underlying type
///   must be `git_repository`.
///   - tagName: The tag name to use. This will be checked for validity.
///   - target: The object to which to point the tag. The underlying type
///   must be `git_object`. This must belong to the given repository.
///   - force: Whether to overwrite an existing tag.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_create_lightweight()`](https://libgit2.org/docs/reference/main/tag/git_tag_create_lightweight.html)
public func gitTagCreateLightweight(
    oid     : inout GitOID,
    repo    : OpaquePointer,
    tagName : String,
    target  : OpaquePointer,
    force   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return try oid.withMutatingCValue
        {
            cOID in
            
            return git_tag_create_lightweight(
                cOID,
                repo,
                tagName,
                target,
                force.int32Value
            )
        }
    }
}



/// Deletes the specified tag from the given repository.
/// - Parameters:
///   - repo: The repository from which to delete the tag. The underlying type
///   must be `git_repository`.
///   - tagName: The name of the tag to delete. This will be checked for
///   validity.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_delete()`](https://libgit2.org/docs/reference/main/tag/git_tag_delete.html)
public func gitTagDelete(
    repo    : OpaquePointer,
    tagName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tag_delete(
            repo,
            tagName
        )
    }
}



/// Gets the names of all the tags in the given repository.
/// - Parameters:
///   - tagNames: The array of strings in which to store the tag names.
///   - repo: The repository for which to get the tag names. The underlying
///   type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_list()`](https://libgit2.org/docs/reference/main/tag/git_tag_list.html)
public func gitTagList(
    tagNames    : inout [String],
    repo        : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try tagNames.withMutatingGitStrArray
        {
            cTagNames in
            
            return git_tag_list(
                cTagNames,
                repo
            )
        }
    }
}



/// Gets the names of all the tags in the given repository matching the given
/// pattern.
/// - Parameters:
///   - tagNames: The array of strings in which to store the tag names.
///   - pattern: The pattern to match. Pass an empty string to match all tags.
///   - repo: The repository for which to get the tag names. The underlying
///   type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_list_match()`](https://libgit2.org/docs/reference/main/tag/git_tag_list_match.html)
public func gitTagListMatch(
    tagNames    : inout [String],
    pattern     : String,
    repo        : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try tagNames.withMutatingGitStrArray
        {
            cTagNames in
            
            return git_tag_list_match(
                cTagNames,
                pattern,
                repo
            )
        }
    }
}



/// Loops over all the tags in the given repository.
/// - Parameters:
///   - repo: The repository containing the tags. The underlying type must be
///   `git_repository`.
///   - callback: The ``GitTagForEachCB`` callback to invoke for each tag.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_foreach()`](https://libgit2.org/docs/reference/main/tag/git_tag_foreach.html)
public func gitTagForEach(
    repo        : OpaquePointer,
    callback    : GitTagForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tag_foreach(
            repo,
            callback,
            payload
        )
    }
}



/// Recursively peels the given tag until a non-tag object is found.
/// - Parameters:
///   - out: The pointer in which to store the peeled object. The underlying
///   type must be `git_object`.
///   - tag: The tag to peel. The underlying type must be `git_tag`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_peel()`](https://libgit2.org/docs/reference/main/tag/git_tag_peel.html)
public func gitTagPeel(
    out : UnsafeMutablePointer<OpaquePointer?>,
    tag : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tag_peel(
            out,
            tag
        )
    }
}



/// Creates an in-memory copy of the given tag.
/// - Parameters:
///   - out: The pointer in which to store the copied tag. The underlying type
///   must be `git_tag`.
///   - source: The tag to copy. The underlying type must be `git_tag`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_dup()`](https://libgit2.org/docs/reference/main/tag/git_tag_dup.html)
public func gitTagDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_tag_dup(
            out,
            source
        )
    }
}



/// Checks whether the given tag name is valid.
/// - Parameters:
///   - valid: The `Bool` instance in which to store whether the given tag
///   name is valid.
///   - name: The tag name to check.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_tag_name_is_valid()`](https://libgit2.org/docs/reference/main/tag/git_tag_name_is_valid.html)
public func gitTagNameIsValid(
    valid   : inout Bool,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return valid.withMutatingBool
        {
            cValid in
            
            return git_tag_name_is_valid(
                cValid,
                name
            )
        }
    }
}
