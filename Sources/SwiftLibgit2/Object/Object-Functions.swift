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



/// Looks up a reference to the specified object in the given repository.
/// - Parameters:
///   - object: The pointer in which to store the object. The underlying
///   type must be `git_object`.
///   - repo: The repository containing the object. The underlying type must
///   be `git_repository`.
///   - id: The ID of the object to look up.
///   - type: The type of the object to look up. Pass
///   ``GitObjectT/gitObjectAny`` to guess the type of the object.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_object_lookup()`](https://libgit2.org/docs/reference/main/object/git_object_lookup.html)
public func gitObjectLookup(
    object  : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    id      : GitOID,
    type    : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_object_lookup(
            object,
            repo,
            &cID,
            type.cValue()
        )
    }
}



// TODO: Replace `GIT_OID_MINPREFIXLEN` in documentation.
/// Looks up a reference to the specified object in the given repository,
/// using a prefix of the object's ID.
/// - Parameters:
///   - objectOut: The pointer in which to store the object. The underlying
///   type must be `git_object`.
///   - repo: The repository containing the object. The underlying type must
///   be `git_repository`.
///   - id: The prefix of the ID of the object to lookup.
///   - len: The length of the object's ID prefix.
///   - type: The type of the object to look up. Pass
///   ``GitObjectT/gitObjectAny`` to guess the type of the object.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will try to match the first `len` hexadecimal characters of
/// the given ID. The remaining characters must be zeros.
///
/// `len` must be greater than or equal to `GIT_OID_MINPREFIXLEN`, and long
/// enough to identify a unique object matching the prefix.
///
/// ## C Equivalent
///
/// [`git_object_lookup_prefix()`](https://libgit2.org/docs/reference/main/object/git_object_lookup_prefix.html)
public func gitObjectLookupPrefix(
    objectOut   : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    id          : GitOID,
    len         : Int,
    type        : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_object_lookup_prefix(
            objectOut,
            repo,
            &cID,
            len,
            type.cValue()
        )
    }
}



/// Looks up an object that represents the given tree.
/// - Parameters:
///   - out: The pointer in which to store the object. The underlying type
///   must be `git_object`.
///   - treeish: The root object that can be peeled to a tree. The underlying
///   type must be `git_object`.
///   - path: The relative path from the root object to the target object.
///   - type: The type of the object to look up. Pass
///   ``GitObjectT/gitObjectAny`` to guess the type of the object.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_object_lookup_bypath()`](https://libgit2.org/docs/reference/main/object/git_object_lookup_bypath.html)
public func gitObjectLookupByPath(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    treeish : OpaquePointer,
    path    : String,
    type    : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_object_lookup_bypath(
            out,
            treeish,
            path,
            type.cValue()
        )
    }
}



/// Gets the ID of the given object.
/// - Parameter obj: The object for which to get the ID. The underlying type
/// must be `git_object`.
/// - Returns: The ID of the given object.
///
/// ## C Equivalent
///
/// [`git_object_id()`](https://libgit2.org/docs/reference/main/object/git_object_id.html)
public func gitObjectID(
    obj: OpaquePointer
) -> GitOID
{
    let objectOID: UnsafePointer<git_oid> = git_object_id(obj)
    
    return GitOID(cValue: objectOID.pointee)
}



/// Gets the abbreviated ID for the given object.
/// - Parameters:
///   - out: The `Data` instance to update with the abbreviated ID.
///   - obj: The object for which to get the abbreviated ID. The underlying
///   type must be `git_object`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function begins at the `core.abbrev` length (which defaults to 7
/// characters) and iteratively extends to a longer string if that length is
/// ambiguous. The resulting ID will be unambiguous until new objects are
/// added to the repository.
///
/// ## C Equivalent
///
/// [`git_object_short_id()`](https://libgit2.org/docs/reference/main/object/git_object_short_id.html)
public func gitObjectShortID(
    out : inout Data,
    obj : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingGitBuf
        {
            cOut in
            
            return git_object_short_id(
                cOut,
                obj
            )
        }
    }
}



/// Gets the type of the given object.
/// - Parameter obj: The object for which to get the type. The underlying type
/// must be `git_object`.
/// - Returns: The type of the given object.
///
/// ## C Equivalent
///
/// [`git_object_type()`](https://libgit2.org/docs/reference/main/object/git_object_type.html)
public func gitObjectType(
    obj: OpaquePointer
) -> GitObjectT?
{
    let objectType: git_object_t = git_object_type(obj)
    
    return GitObjectT(cValue: objectType)
}



/// Gets the repository containing the given object.
/// - Parameter obj: The object for which to get the repository. The underlying
/// type must be `git_object`.
/// - Returns: The repository containing the given object. The underlying
/// type will be `git_repository`.
///
/// ## C Equivalent
///
/// [`git_object_owner()`](https://libgit2.org/docs/reference/main/object/git_object_owner.html)
public func gitObjectOwner(
    obj: OpaquePointer
) -> OpaquePointer
{
    return git_object_owner(obj)
}



/// Frees the memory allocated for the given `git_object` instance.
/// - Parameter object: The object to free. The underlying type must be
/// `git_object`.
///
/// ## C Equivalent
///
/// [`git_object_free()`](https://libgit2.org/docs/reference/main/object/git_object_free.html)
public func gitObjectFree(
    object: OpaquePointer?
)
{
    guard let object: OpaquePointer = object
    else
    {
        return
    }
    
    git_object_free(object)
}



/// Converts the given object type to its string representation.
/// - Parameter type: The object type to convert.
/// - Returns: The string representation of the given object type.
///
/// ## C Equivalent
///
/// [`git_object_type2string()`](https://libgit2.org/docs/reference/main/object/git_object_type2string.html)
public func gitObjectType2String(
    type: GitObjectT
) -> String?
{
    let objectType: UnsafePointer<CChar>?
        = git_object_type2string(type.cValue())
    
    return String(optionalCString: objectType)
}



/// Converts the given string representation of an object type to a
/// ``GitObjectT`` instance.
/// - Parameter str: The string representation to convert.
/// - Returns: A ``GitObjectT`` instance.
///
/// ## C Equivalent
///
/// [`git_object_string2type()`](https://libgit2.org/docs/reference/main/object/git_object_string2type.html)
public func gitObjectString2Type(
    str: String
) -> GitObjectT?
{
    let objectType: git_object_t = git_object_string2type(str)
    
    return GitObjectT(cValue: objectType)
}



/// Recursively peels the given object until an object of the given type is
/// found.
/// - Parameters:
///   - peeled: The pointer in which to store the peeled object. The underlying
///   type must be `git_object`.
///   - object: The object to peel. The underlying type must be `git_object`.
///   - targetType: The type of the object to find. Pass
///   ``GitObjectT/gitObjectAny`` to peel the given object until the type
///   changes.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_object_peel()`](https://libgit2.org/docs/reference/main/object/git_object_peel.html)
public func gitObjectPeel(
    peeled      : UnsafeMutablePointer<OpaquePointer?>,
    object      : OpaquePointer,
    targetType  : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_object_peel(
            peeled,
            object,
            targetType.cValue()
        )
    }
}



/// Creates an in-memory copy of the given object.
/// - Parameters:
///   - dest: The pointer in which to store the copied object. The underlying
///   type must be `git_object`.
///   - source: The object to copy. The underlying type must be `git_object`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_object_dup()`](https://libgit2.org/docs/reference/main/object/git_object_dup.html)
public func gitObjectDup(
    dest    : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_object_dup(
            dest,
            source
        )
    }
}



/// Checks if the given raw object content is valid.
/// - Parameters:
///   - valid: The pointer in which to store the resulting boolean.
///   - buf: The raw object content to check.
///   - len: The length of `buf`.
///   - objectType: The type of the object to check.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Note: Blobs are always valid.
///
/// ## C Equivalent
///
/// [`git_object_rawcontent_is_valid()`](https://libgit2.org/docs/reference/main/object/git_object_rawcontent_is_valid.html)
public func gitObjectRawContentIsValid(
    valid       : UnsafeMutablePointer<Bool>,
    buf         : Data,
    len         : Int,
    objectType  : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return try buf.withCBuffer
        {
            cBuf, cBufCount in
            
            var intValid: Int32 = 0
            
            let objectRawContentIsValidResult: Int32
                = git_object_rawcontent_is_valid(
                    &intValid,
                    cBuf,
                    cBufCount,
                    objectType.cValue()
                )
            
            valid.pointee = Bool(intValid)
            
            return objectRawContentIsValidResult
        }
    }
}
