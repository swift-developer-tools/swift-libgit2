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



/// Looks up the specified reference in the given repository.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository containing the reference. The underlying type must
///   be `git_repository`.
///   - name: The full reference name to use. This will be checked for validity.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_lookup()`](https://libgit2.org/docs/reference/main/refs/git_reference_lookup.html)
public func gitReferenceLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_lookup(
            out,
            repo,
            name
        )
    }
}



/// Resolves the given reference name to an ID.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the resolved ID.
///   - repo: The repository containing the reference. The underlying type must
///   be `git_repository`.
///   - name: The full reference name to use. This will be checked for validity.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_name_to_id()`](https://libgit2.org/docs/reference/main/refs/git_reference_name_to_id.html)
public func gitReferenceNameToID(
    out     : inout GitOID,
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingCValue
        {
            cOut in
            
            return git_reference_name_to_id(
                cOut,
                repo,
                name
            )
        }
    }
}



/// Looks up the specified reference in the given repository, by applying Git
/// precedence rules to the given shorthand.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository containing the reference. The underlying type must
///   be `git_repository`.
///   - shorthand: The shorthand reference name to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_dwim()`](https://libgit2.org/docs/reference/main/refs/git_reference_dwim.html)
public func gitReferenceDWIM(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    shorthand   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_dwim(
            out,
            repo,
            shorthand
        )
    }
}



/// Conditionally creates a new symbolic reference.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository containing the reference. The underlying type must
///   be `git_repository`.
///   - name: The reference name to use. This will be checked for validity.
///   - target: The name of the target reference to use. This will be checked
///   for validity.
///   - force: Whether to overwrite an existing reference.
///   - currentValue: The reference value at the time of the update.
///   - logMessage: The one-line long message to append to the reflog.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A symbolic reference is a reference name that refers to another reference
/// name. If the other name moves, the symbolic name will also move. For
/// example, the `HEAD` reference may refer to `refs/heads/main` while on the
/// `main` branch of a repository.
///
/// The symbolic reference will be created in the given repository and written
/// to the disk.
///
/// The given reflog message will be ignored if the reference does not belong
/// in the standard set (`HEAD`, branches, and remote-tracking branches), and
/// it does not have a reflog.
///
/// ## C Equivalent
///
/// [`git_reference_symbolic_create_matching()`](https://libgit2.org/docs/reference/main/refs/git_reference_symbolic_create_matching.html)
public func gitReferenceSymbolicCreateMatching(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    repo            : OpaquePointer,
    name            : String,
    target          : String,
    force           : Bool,
    currentValue    : String?,
    logMessage      : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_symbolic_create_matching(
            out,
            repo,
            name,
            target,
            force.int32Value,
            currentValue,
            logMessage
        )
    }
}



/// Creates a new symbolic reference.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository containing the reference. The underlying type must
///   be `git_repository`.
///   - name: The reference name to use. This will be checked for validity.
///   - target: The name of the target reference to use. This will be checked
///   for validity.
///   - force: Whether to overwrite an existing reference.
///   - logMessage: The one-line long message to append to the reflog.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A symbolic reference is a reference name that refers to another reference
/// name. If the other name moves, the symbolic name will also move. For
/// example, the `HEAD` reference may refer to `refs/heads/main` while on the
/// `main` branch of a repository.
///
/// The symbolic reference will be created in the given repository and written
/// to the disk.
///
/// The given reflog message will be ignored if the reference does not belong
/// in the standard set (`HEAD`, branches, and remote-tracking branches), and
/// it does not have a reflog.
///
/// ## C Equivalent
///
/// [`git_reference_symbolic_create()`](https://libgit2.org/docs/reference/main/refs/git_reference_symbolic_create.html)
public func gitReferenceSymbolicCreate(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    name        : String,
    target      : String,
    force       : Bool,
    logMessage  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_symbolic_create(
            out,
            repo,
            name,
            target,
            force.int32Value,
            logMessage
        )
    }
}



/// Creates a new direct reference.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository containing the reference. The underlying type must
///   be `git_repository`.
///   - name: The reference name to use. This will be checked for validity.
///   - id: The ID to which the specified reference points.
///   - force: Whether to overwrite an existing reference.
///   - logMessage: The one-line long message to append to the reflog.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A direct reference (also called an object ID reference) refers directly to
/// a specific object in the repository. The ID permanently refers to the
/// object, although the reference itself can be moved.
///
/// The direct reference will be created in the given repository and written
/// to the disk.
///
/// The given reflog message will be ignored if the reference does not belong
/// in the standard set (`HEAD`, branches, and remote-tracking branches), and
/// it does not have a reflog.
///
/// ## C Equivalent
///
/// [`git_reference_create()`](https://libgit2.org/docs/reference/main/refs/git_reference_create.html)
public func gitReferenceCreate(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    name        : String,
    id          : GitOID,
    force       : Bool,
    logMessage  : String
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_reference_create(
            out,
            repo,
            name,
            &cID,
            force.int32Value,
            logMessage
        )
    }
}



/// Conditionally creates a new direct reference.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - repo: The repository containing the reference. The underlying type must
///   be `git_repository`.
///   - name: The reference name to use. This will be checked for validity.
///   - id: The ID to which the specified reference points.
///   - force: Whether to overwrite an existing reference.
///   - currentID: The reference ID at the time of the update.
///   - logMessage: The one-line long message to append to the reflog.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A direct reference (also called an object ID reference) refers directly to
/// a specific object in the repository. The ID permanently refers to the
/// object, although the reference itself can be moved.
///
/// The direct reference will be created in the given repository and written
/// to the disk.
///
/// The given reflog message will be ignored if the reference does not belong
/// in the standard set (`HEAD`, branches, and remote-tracking branches), and
/// it does not have a reflog.
///
/// ## C Equivalent
///
/// [`git_reference_create_matching()`](https://libgit2.org/docs/reference/main/refs/git_reference_create_matching.html)
public func gitReferenceCreateMatching(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    name        : String,
    id          : GitOID,
    force       : Bool,
    currentID   : GitOID,
    logMessage  : String
) -> GitErrorCode
{
    return withCConversion
    {
        var cID         : git_oid   = id.cValue()
        var cCurrentID  : git_oid   = currentID.cValue()
        
        return git_reference_create_matching(
            out,
            repo,
            name,
            &cID,
            force.int32Value,
            &cCurrentID,
            logMessage
        )
    }
}



/// Gets the ID to which the given direct reference points.
/// - Parameter ref: The direct reference to use. The underlying type must be
/// `git_reference`.
/// - Returns: The ID to which the given direct reference points.
///
/// ## Discussion
///
/// - Note: The find the ID of a symbolic reference, call
/// ``gitReferenceResolve(out:ref:)`` before calling this function, or use
/// ``gitReferenceNameToID(out:repo:name:)`` instead.
///
/// ## C Equivalent
///
/// [`git_reference_target()`](https://libgit2.org/docs/reference/main/refs/git_reference_target.html)
public func gitReferenceTarget(
    ref: OpaquePointer
) -> GitOID?
{
    guard let targetOID: UnsafePointer<git_oid> = git_reference_target(ref)
    else
    {
        return nil
    }
    
    return GitOID(cValue: targetOID.pointee)
}



/// Gets the ID to which the given direct reference points.
/// - Parameter ref: The direct reference to use. The underlying type must be
/// `git_reference`. The reference must point to a tag.
/// - Returns: The ID to which the given direct reference points.
///
/// ## C Equivalent
///
/// [`git_reference_target_peel()`](https://libgit2.org/docs/reference/main/refs/git_reference_target_peel.html)
public func gitReferenceTargetPeel(
    ref: OpaquePointer
) -> GitOID?
{
    guard let targetOID: UnsafePointer<git_oid> = git_reference_target_peel(ref)
    else
    {
        return nil
    }
    
    return GitOID(cValue: targetOID.pointee)
}



/// Gets the full name of the reference to which the given symbolic reference
/// points.
/// - Parameter ref: The symbolic reference to use. The underlying type must
/// be `git_reference`.
/// - Returns: The full name of the reference to which the given symbolic
/// reference points.
///
/// ## C Equivalent
///
/// [`git_reference_symbolic_target()`](https://libgit2.org/docs/reference/main/refs/git_reference_symbolic_target.html)
public func gitReferenceSymbolicTarget(
    ref: OpaquePointer
) -> String?
{
    let targetName: UnsafePointer<CChar>? = git_reference_symbolic_target(ref)
    
    return String(optionalCString: targetName)
}



/// Gets the type of the given reference.
/// - Parameter ref: The reference for which to get the type. The underlying
/// type must be `git_reference`.
/// - Returns: The type of the given reference.
///
/// ## C Equivalent
///
/// [`git_reference_type()`](https://libgit2.org/docs/reference/main/refs/git_reference_type.html)
public func gitReferenceType(
    ref: OpaquePointer
) -> GitReferenceT?
{
    let referenceType: git_reference_t = git_reference_type(ref)
    
    return GitReferenceT(cValue: referenceType)
}



/// Gets the full name of the given reference.
/// - Parameter ref: The reference for whicih to get the full name. The
/// underlying type must be `git_reference`.
/// - Returns: The full name of the given reference.
///
/// ## C Equivalent
///
/// [`git_reference_name()`](https://libgit2.org/docs/reference/main/refs/git_reference_name.html)
public func gitReferenceName(
    ref: OpaquePointer
) -> String?
{
    let referenceName: UnsafePointer<CChar>? = git_reference_name(ref)
    
    return String(optionalCString: referenceName)
}



/// Resolves the given symbolic reference to a direct reference.
/// - Parameters:
///   - out: The pointer in which to store the resolved reference. The
///   underlying type must be `git_reference`.
///   - ref: The reference to resolve. The underlying type must be
///   `git_reference`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function iteratively peels the given symbolic reference until it
/// resolves to a direct reference to an ID. If the given reference is a
/// direct reference, a copy of that reference will be returned.
///
/// ## C Equivalent
///
/// [`git_reference_resolve()`](https://libgit2.org/docs/reference/main/refs/git_reference_resolve.html)
public func gitReferenceResolve(
    out : UnsafeMutablePointer<OpaquePointer?>,
    ref : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_resolve(
            out,
            ref
        )
    }
}



/// Gets the repository containing the given reference.
/// - Parameter ref: The reference for which to get the repository. The
/// underlying type must be `git_reference`.
/// - Returns: The repository containing the given reference. The underlying
/// type will be `git_repository`.
///
/// ## C Equivalent
///
/// [`git_reference_owner()`](https://libgit2.org/docs/reference/main/refs/git_reference_owner.html)
public func gitReferenceOwner(
    ref: OpaquePointer
) -> OpaquePointer
{
    return git_reference_owner(ref)
}




/// Creates a new reference with the same name as the given reference, but with
/// the given symbolic target.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - ref: The reference to use. The underlying type must be `git_reference`.
///   This must be a symbolic reference.
///   - target: The name of the target reference to use. This will be checked
///   for validity.
///   - logMessage: The one-line long message to append to the reflog.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The new reference will be written to the disk.
///
/// The given reflog message will be ignored if the reference does not belong
/// in the standard set (`HEAD`, branches, and remote-tracking branches), and
/// it does not have a reflog.
///
/// ## C Equivalent
///
/// [`git_reference_symbolic_set_target()`](https://libgit2.org/docs/reference/main/refs/git_reference_symbolic_set_target.html)
public func gitReferenceSymbolicSetTarget(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    ref         : OpaquePointer,
    target      : String,
    logMessage  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_symbolic_set_target(
            out,
            ref,
            target,
            logMessage
        )
    }
}



/// Conditionally creates a new reference with the same name as the given
/// reference, but with the given symbolic target.
/// - Parameters:
///   - out: The pointer in which to store the reference. The underlying type
///   must be `git_reference`.
///   - ref: The reference to use. The underlying type must be `git_reference`.
///   This must be a direct reference.
///   - id: The new target ID for the reference.
///   - logMessage: The one-line long message to append to the reflog.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The new reference will be written to the disk, overwriting the given
/// reference.
///
/// ## C Equivalent
///
/// [`git_reference_set_target()`](https://libgit2.org/docs/reference/main/refs/git_reference_set_target.html)
public func gitReferenceSetTarget(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    ref         : OpaquePointer,
    id          : GitOID,
    logMessage  : String
) -> GitErrorCode
{
    return withCConversion
    {
        var cID: git_oid = id.cValue()
        
        return git_reference_set_target(
            out,
            ref,
            &cID,
            logMessage
        )
    }
}



/// Renames the given reference.
/// - Parameters:
///   - newRef: The pointer in which to store the new reference. The underlying
///   type mus be `git_reference`.
///   - ref: The reference to rename. The underlying type must be
///   `git_reference`.
///   - newName: The new reference name to use. This will be checked for
///   validity.
///   - force: Whether to overwrite an existing reference.
///   - logMessage: The one-line long message to append to the reflog.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_rename()`](https://libgit2.org/docs/reference/main/refs/git_reference_rename.html)
public func gitReferenceRename(
    newRef      : UnsafeMutablePointer<OpaquePointer?>,
    ref         : OpaquePointer,
    newName     : String,
    force       : Bool,
    logMessage  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_rename(
            newRef,
            ref,
            newName,
            force.int32Value,
            logMessage
        )
    }
}



/// Deletes the given reference.
/// - Parameter ref: The reference to delete. The underlying type must be
///   `git_reference`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: The given reference will be immediately removed from the disk,
/// but the caller must free the memory.
///
/// ## C Equivalent
///
/// [`git_reference_delete()`](https://libgit2.org/docs/reference/main/refs/git_reference_delete.html)
public func gitReferenceDelete(
    ref: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_delete(ref)
    }
}



/// Deletes the specified reference.
/// - Parameters:
///   - repo: The repository containing the specified reference. The underlying
///   type must be `git_repository`.
///   - name: The name of the reference to delete.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The specified reference will be removed without considering its old value.
///
/// ## C Equivalent
///
/// [`git_reference_remove()`](https://libgit2.org/docs/reference/main/refs/git_reference_remove.html)
public func gitReferenceRemove(
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_remove(
            repo,
            name
        )
    }
}



/// Gets the names of all the references contained by the given repository.
/// - Parameters:
///   - array: The array of strings in which to store the reference names.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_list()`](https://libgit2.org/docs/reference/main/refs/git_reference_list.html)
public func gitReferenceList(
    array   : inout [String],
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try array.withMutatingGitStrArray
        {
            cArray in
            
            return git_reference_list(
                cArray,
                repo
            )
        }
    }
}



/// Loops over all the references contained by the given repository.
/// - Parameters:
///   - repo: The repository containing the references. The underlying type
///   must be `git_repository`.
///   - callback: The callback to invoke for each reference.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_note_foreach()`](https://libgit2.org/docs/reference/main/notes/git_note_foreach.html)
public func gitReferenceForEach(
    repo        : OpaquePointer,
    callback    : GitReferenceForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_foreach(
            repo,
            callback,
            payload
        )
    }
}



/// Loops over the names of all the references contained by the given
/// repository.
/// - Parameters:
///   - repo: The repository containing the references. The underlying type
///   must be `git_repository`.
///   - callback: The callback to invoke for each reference name.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_foreach_name()`](https://libgit2.org/docs/reference/main/refs/git_reference_foreach_name.html)
public func gitReferenceForEachName(
    repo        : OpaquePointer,
    callback    : GitReferenceForEachNameCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_foreach_name(
            repo,
            callback,
            payload
        )
    }
}



/// Creates an in-memory copy of the given reference.
/// - Parameters:
///   - dest: The pointer in which to store the copied reference. The
///   underlying type must be `git_reference`.
///   - source: The reference to copy. The underlying type must be
///   `git_reference`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_dup()`](https://libgit2.org/docs/reference/main/refs/git_reference_dup.html)
public func gitReferenceDup(
    dest    : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_dup(
            dest,
            source
        )
    }
}



/// Frees the memory allocated for the given `git_reference` instance.
/// - Parameter ref: The reference to free. The underlying type must be
/// `git_reference`.
///
/// ## C Equivalent
///
/// [`git_reference_free()`](https://libgit2.org/docs/reference/main/refs/git_reference_free.html)
public func gitReferenceFree(
    ref: OpaquePointer?
)
{
    guard let ref: OpaquePointer = ref
    else
    {
        return
    }
    
    git_reference_free(ref)
}



/// Checks whether the given references are equal.
/// - Parameters:
///   - ref1: The first reference to compare. The underlying type must be
///   `git_reference`.
///   - ref2: The second reference to compare. The underlying type must be
/// `git_reference`.
/// - Returns: Whether the given references are equal.
///
/// ## C Equivalent
///
/// [`git_reference_cmp()`](https://libgit2.org/docs/reference/main/refs/git_reference_cmp.html)
public func gitReferenceCmp(
    ref1    : OpaquePointer,
    ref2    : OpaquePointer
) -> Bool
{
    let equal: Int32 = git_reference_cmp(
        ref1,
        ref2
    )
    
    /// The `Bool` initializer follows the C convention that `0` is `false`,
    /// which is applicable throughout most of libgit2. This function returns
    /// `0` if the IDs match, since it uses `memcmp()` in its implementation.
    return !Bool(equal)
}



/// Creates a new reference iterator.
/// - Parameters:
///   - out: The pointer in which to store the reference iterator.
///   - repo: The repository containing the references. The underlying
///   type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_iterator_new()`](https://libgit2.org/docs/reference/main/refs/git_reference_iterator_new.html)
public func gitReferenceIteratorNew(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_reference_iterator>?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_iterator_new(
            out,
            repo
        )
    }
}



/// Creates a new reference iterator matching the specified glob.
/// - Parameters:
///   - out: The pointer in which to store the reference iterator.
///   - repo: The repository containing the references. The underlying
///   type must be `git_repository`.
///   - glob: The glob to match against the reference names.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_iterator_glob_new()`](https://libgit2.org/docs/reference/main/refs/git_reference_iterator_glob_new.html)
public func gitReferenceIteratorGlobNew(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_reference_iterator>?>,
    repo    : OpaquePointer,
    glob    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_iterator_glob_new(
            out,
            repo,
            glob
        )
    }
}



/// Gets the next reference from the given reference iterator.
/// - Parameters:
///   - out: The pointer in which to store the next reference. The underlying
///   type must be `git_reference`.
///   - iter: The reference iterator to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_next()`](https://libgit2.org/docs/reference/main/refs/git_reference_next.html)
public func gitReferenceNext(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    iter    : UnsafeMutablePointer<git_reference_iterator>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_next(
            out,
            iter
        )
    }
}



/// Gets the next reference name from the given reference iterator.
/// - Parameters:
///   - out: The `String` instance in which to store the next reference name.
///   - iter: The reference iterator to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_next_name()`](https://libgit2.org/docs/reference/main/refs/git_reference_next_name.html)
public func gitReferenceNextName(
    out     : inout String?,
    iter    : UnsafeMutablePointer<git_reference_iterator>
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withOptionalMutatingString
        {
            cOut in
            
            return git_reference_next_name(
                cOut,
                iter
            )
        }
    }
}



/// Frees the memory allocated for the given `git_reference_iterator` instance.
/// - Parameter iter: The reference iterator to free.
///
/// ## C Equivalent
///
/// [`git_reference_iterator_free()`](https://libgit2.org/docs/reference/main/refs/git_reference_iterator_free.html)
public func gitReferenceIteratorFree(
    iter: UnsafeMutablePointer<git_reference_iterator>?
)
{
    guard let iter: UnsafeMutablePointer<git_reference_iterator> = iter
    else
    {
        return
    }
    
    git_reference_iterator_free(iter)
}



/// Loops over the names of all the references contained by the given
/// repository, matching the given glob.
/// - Parameters:
///   - repo: The repository containing the references. The underlying type
///   must be `git_repository`.
///   - glob: The pattern to match.
///   - callback: The callback to invoke for each reference name.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The pattern will be matched using `fnmatch`-style matching:
///
/// - An asterisk (`*`) matches any sequence of letters.
/// - A question mark (`?`) matches any letter.
/// - Brackets (`[]`) define ranges (for example, `[0-9]` for digits).
///
/// ## C Equivalent
///
/// [`git_reference_foreach_glob()`](https://libgit2.org/docs/reference/main/refs/git_reference_foreach_glob.html)
public func gitReferenceForEachGlob(
    repo        : OpaquePointer,
    glob        : String,
    callback    : GitReferenceForEachNameCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_foreach_glob(
            repo,
            glob,
            callback,
            payload
        )
    }
}



/// Checks whether the specified reference has a reflog.
/// - Parameters:
///   - repo: The repository containing the reference. The underlying type
///   must be `git_repository`.
///   - refName: The name of the reference to check.
/// - Returns: Whether the given reference has a reflog, or `nil` if there
/// was an error.
///
/// ## C Equivalent
///
/// [`git_reference_has_log()`](https://libgit2.org/docs/reference/main/refs/git_reference_has_log.html)
public func gitReferenceHasLog(
    repo    : OpaquePointer,
    refName : String
) -> Bool?
{
    let hasReflog: Int32 = git_reference_has_log(
        repo,
        refName
    )
    
    if
        hasReflog != 0,
        hasReflog != 1
    {
        return nil
    }
    
    return Bool(hasReflog)
}



/// Ensures that the specified reference has a reflog.
/// - Parameters:
///   - repo: The repository containing the reference. The underlying type
///   must be `git_repository`.
///   - refName: The name of the reference to check.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_ensure_log()`](https://libgit2.org/docs/reference/main/refs/git_reference_ensure_log.html)
public func gitReferenceEnsureLog(
    repo    : OpaquePointer,
    refName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_ensure_log(
            repo,
            refName
        )
    }
}



/// Checks whether the given reference is a branch.
/// - Parameter ref: The reference to check. The underlying type must be
/// `git_reference`.
/// - Returns: Whether the given reference is a branch.
///
/// ## C Equivalent
///
/// [`git_reference_is_branch()`](https://libgit2.org/docs/reference/main/refs/git_reference_is_branch.html)
public func gitReferenceIsBranch(
    ref: OpaquePointer
) -> Bool
{
    let isBranch: Int32 = git_reference_is_branch(ref)
    
    return Bool(isBranch)
}



/// Checks whether the given reference is a remote-tracking branch.
/// - Parameter ref: The reference to check. The underlying type must be
/// `git_reference`.
/// - Returns: Whether the given reference is a remote-tracking branch.
///
/// ## C Equivalent
///
/// [`git_reference_is_remote()`](https://libgit2.org/docs/reference/main/refs/git_reference_is_remote.html)
public func gitReferenceIsRemote(
    ref: OpaquePointer
) -> Bool
{
    let isRemote: Int32 = git_reference_is_remote(ref)
    
    return Bool(isRemote)
}



/// Checks whether the given reference is a tag.
/// - Parameter ref: The reference to check. The underlying type must be
/// `git_reference`.
/// - Returns: Whether the given reference is a tag.
///
/// ## C Equivalent
///
/// [`git_reference_is_tag()`](https://libgit2.org/docs/reference/main/refs/git_reference_is_tag.html)
public func gitReferenceIsTag(
    ref: OpaquePointer
) -> Bool
{
    let isTag: Int32 = git_reference_is_tag(ref)
    
    return Bool(isTag)
}



/// Checks whether the given reference is a note.
/// - Parameter ref: The reference to check. The underlying type must be
/// `git_reference`.
/// - Returns: Whether the given reference is a note.
///
/// ## C Equivalent
///
/// [`git_reference_is_note()`](https://libgit2.org/docs/reference/main/refs/git_reference_is_note.html)
public func gitReferenceIsNote(
    ref: OpaquePointer
) -> Bool
{
    let isNote: Int32 = git_reference_is_note(ref)
    
    return Bool(isNote)
}



/// Normalizes the given references name.
/// - Parameters:
///   - bufferOut: The `Data` instance in which to store the normalized name.
///   - bufferSize: The length of `bufferOut`.
///   - name: The reference name to normalize. The normalized name will be
///   checked for validity.
///   - flags: The flags controlling reference name validation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will normalize the given reference name by removing any
/// leading slash (`/`) and collapsing adjacent slashes between name components
/// into a single slash.
///
/// ## C Equivalent
///
/// [`git_reference_normalize_name()`](https://libgit2.org/docs/reference/main/refs/git_reference_normalize_name.html)
public func gitReferenceNormalizeName(
    bufferOut   : inout Data,
    bufferSize  : Int,
    name        : String,
    flags       : GitReferenceFormatT
) -> GitErrorCode
{
    return withCConversion
    {
        return try bufferOut.withMutatingCBuffer
        {
            cBufferOut, cBufferOutCount in
            
            return git_reference_normalize_name(
                cBufferOut,
                cBufferOutCount,
                name,
                flags.rawValue
            )
        }
    }
}



/// Recursively peels the given reference until an object of the given type is
/// found.
/// - Parameters:
///   - out: The pointer in which to store the peeled object. The underlying
///   type must be `git_object`.
///   - ref: The reference to peel. The underlying type must be `git_reference`.
///   - type: The type of the object to find. Pass ``GitObjectT/gitObjectAny``
///   to peel the given object until the type changes.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_reference_peel()`](https://libgit2.org/docs/reference/main/refs/git_reference_peel.html)
public func gitReferencePeel(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    ref     : OpaquePointer,
    type    : GitObjectT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_reference_peel(
            out,
            ref,
            type.cValue()
        )
    }
}



/// Checks whether the given reference name is valid.
/// - Parameters:
///   - valid: The `Bool` instance in which to store whether the given
///   reference name is valid.
///   - refName: The reference name to check.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Valid reference names must follow one of the following patterns:
///
/// - Top-level names must contain only capital letters and underscores, and
/// must begin and end with a letter. For example, `HEAD` or `ORIG_HEAD`.
/// - Names prefixed with `refs/` can be almost anything. The following
/// characters and sequences must not be used:
///     - Tildes (`~`)
///     - Carets (`^`)
///     - Colons (`:`)
///     - Question marks (`?`)
///     - Opening brackets (`[`)
///     - Asterisks (`*`)
///     - Two dots (`..`)
///     - An at sign followed by an opening curly brace (`@{`)
///     - Line breaks
///
/// ## C Equivalent
///
/// [`git_reference_name_is_valid()`](https://libgit2.org/docs/reference/main/refs/git_reference_name_is_valid.html)
public func gitReferenceNameIsValid(
    valid   : inout Bool,
    refName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return valid.withMutatingBool
        {
            cValid in
            
            return git_reference_name_is_valid(
                cValid,
                refName
            )
        }
    }
}



/// Gets the shorthand name of the given reference.
/// - Parameter ref: The reference for whicih to get the shorthand name. The
/// underlying type must be `git_reference`.
/// - Returns: The shorthand of the given reference.
///
/// ## Discussion
///
/// The full name will be returned if there is no appropriate shorthand name
/// for the given reference.
///
/// ## C Equivalent
///
/// [`git_reference_shorthand()`](https://libgit2.org/docs/reference/main/refs/git_reference_shorthand.html)
public func gitReferenceShorthand(
    ref: OpaquePointer
) -> String?
{
    let referenceShorthandName: UnsafePointer<CChar>?
        = git_reference_shorthand(ref)
    
    return String(optionalCString: referenceShorthandName)
}
