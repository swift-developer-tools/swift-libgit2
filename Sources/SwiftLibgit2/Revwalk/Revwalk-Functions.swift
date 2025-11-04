//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a new revision walker for the given repository.
/// - Parameters:
///   - out: The pointer in which to store the revision walker. The underlying
///   type must be `git_revwalk`.
///   - repo: The repository to iterate. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The revision walker uses a custom memory pool and an internal commit cache,
/// so it is relatively expensive to allocate. For maximum performance, reuse
/// the created revision walker for different walks.
///
/// - Important: The revision walker is not thread-safe. It must be used only
/// in a single thread. However, it is possible to have several revision
/// walkers in different threads, walking the same repository.
///
/// ## C Equivalent
///
/// [`git_revwalk_new()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_new.html)
public func gitRevwalkNew(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_new(
            out,
            repo
        )
    }
}



/// Resets the given revision walker.
/// - Parameter walker: The revision walker to reset. The underlying type must
/// be `git_revwalk`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This will clear all the pushed and hidden commits, and leave the given
/// revision walker in a blank state.
///
/// - Note: A revision walker is automatically reset when a walk ends.
///
/// ## C Equivalent
///
/// [`git_revwalk_reset()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_reset.html)
public func gitRevwalkReset(
    walker: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_reset(walker)
    }
}



/// Adds a new root to the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - id: The ID of the committish object from which to start walking. The
///   object must belong to the repository being walked.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The pushed commit will be marked as one of the roots from which to start
/// the walk. The commit may not be walked if it is hidden, or if one of its
/// child commits is hidden. At least one commit must be pushed onto the
/// revision walker before the walk can begin.
///
/// ## C Equivalent
///
/// [`git_revwalk_push()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_push.html)
public func gitRevwalkPush(
    walk    : OpaquePointer,
    id      : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_revwalk_push(
                walk,
                cID
            )
        }
    }
}



/// Pushes the IDs matching the given glob pattern to the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - glob: The glob pattern to match.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A leading `refs/` will be implied, if it is not present in the given glob
/// pattern. Similarly, a trailing `/\*` sequence will be implied, if the glob
/// pattern lacks a question mark (`?`), opening bracket (`[`), or a `\*`
/// sequence.
///
/// Any references matching the glob pattern that do not point to a committish
/// object will be ignored.
///
/// ## C Equivalent
///
/// [`git_revwalk_push_glob()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_push_glob.html)
public func gitRevwalkPushGlob(
    walk    : OpaquePointer,
    glob    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_push_glob(
            walk,
            glob
        )
    }
}



/// Pushes the HEAD of the walked repository to the given revision walker.
/// - Parameter walk: The revision walker to update. The underlying type must
/// be `git_revwalk`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_push_head()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_push_head.html)
public func gitRevwalkPushHEAD(
    walk: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_push_head(walk)
    }
}



/// Hides the specified committish object and its ancestors from the output
/// of the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - commitID: The ID of the committish object to hide. The object must
///   belong to the repository being walked.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_hide()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_hide.html)
public func gitRevwalkHide(
    walk        : OpaquePointer,
    commitID    : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return commitID.withCValue
        {
            cCommitID in
            
            return git_revwalk_hide(
                walk,
                cCommitID
            )
        }
    }
}



/// Hides the IDs matching the given glob pattern to the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - glob: The glob pattern to match.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A leading `refs/` will be implied, if it is not present in the given glob
/// pattern. Similarly, a trailing `/\*` sequence will be implied, if the glob
/// pattern lacks a question mark (`?`), opening bracket (`[`), or a `\*`
/// sequence.
///
/// Any references matching the glob pattern that do not point to a committish
/// object will be ignored.
///
/// ## C Equivalent
///
/// [`git_revwalk_hide_glob()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_hide_glob.html)
public func gitRevwalkHideGlob(
    walk    : OpaquePointer,
    glob    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_hide_glob(
            walk,
            glob
        )
    }
}



/// Hides the HEAD of the walked repository to the given revision walker.
/// - Parameter walk: The revision walker to update. The underlying type must
/// be `git_revwalk`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_hide_head()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_hide_head.html)
public func gitRevwalkHideHEAD(
    walk: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_hide_head(walk)
    }
}



/// Pushes the ID of the specified reference to the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - refName: The name of the reference to push. The reference must point
///   to a committish object owned by the repository being walked.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_push_ref()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_push_ref.html)
public func gitRevwalkPushRef(
    walk    : OpaquePointer,
    refName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_push_ref(
            walk,
            refName
        )
    }
}



/// Hides the ID of the specified reference to the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - refName: The name of the reference to hide. The reference must point
///   to a committish object owned by the repository being walked.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_hide_ref()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_hide_ref.html)
public func gitRevwalkHideRef(
    walk    : OpaquePointer,
    refName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_hide_ref(
            walk,
            refName
        )
    }
}



/// Gets the ID of next commit from the given revision walker.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID of the next
///   commit.
///   - walk: The revision walker to use. The underlying type must be
///   `git_revwalk`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The initial call to the function will not be blocking when iterating a
/// repository with chronological sorting.
///
/// The initial call to the function will be blocking when iterating with
/// topological or inverted sorting, in order to preprocess the commit list.
/// The block should generally be unnoticeable on most repositories.
///
/// ## C Equivalent
///
/// [`git_revwalk_next()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_next.html)
public func gitRevwalkNext(
    out     : inout GitOID,
    walk    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_revwalk_next(
                cOut,
                walk
            )
        }
    }
}



/// Sets the sorting mode of the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - sortMode: The sorting mode to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_sorting()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_sorting.html)
public func gitRevwalkSorting(
    walk: OpaquePointer,
    sortMode: GitSortT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_sorting(
            walk,
            sortMode.rawValue
        )
    }
}



/// Pushes the starting point and hides the ending point of the specified
/// range in the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - range: The range to use. This must be in the form `<commit>..<commit>`,
///   where each `<commit>` is in the revision string form accepted by
///   ``gitRevparseSingle(out:repo:spec:)``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_push_range()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_push_range.html)
public func gitRevwalkPushRange(
    walk    : OpaquePointer,
    range   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_push_range(
            walk,
            range
        )
    }
}



/// Simplifies the history of the given revision walker by first-parent.
/// - Parameter walk: The revision walker to update. The underlying type must
/// be `git_revwalk`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// When the revision history is simplified, no parent commits other than the
/// first parent of each commit will be walked.
///
/// ## C Equivalent
///
/// [`git_revwalk_simplify_first_parent()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_simplify_first_parent.html)
public func gitRevwalkSimplifyFirstParent(
    walk: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_simplify_first_parent(walk)
    }
}



/// Frees the memory allocated for the given `git_revwalk` instance.
/// - Parameter walk: The revision walker to free. The underlying type must be
/// `git_revwalk`.
///
/// ## C Equivalent
///
/// [`git_revwalk_free()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_free.html)
public func gitRevwalkFree(
    walk: OpaquePointer?
)
{
    guard let walk
    else
    {
        return
    }
    
    git_revwalk_free(walk)
}



/// Gets the repository being walked by the given revision walker.
/// - Parameter walk: The revision walker to use. The underlying type must be
/// `git_revwalk`.
/// - Returns: The repository being walked by the given revision walker.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given revision walker
/// and must not be freed.
///
/// ## C Equivalent
///
/// [`git_revwalk_repository()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_repository.html)
public func gitRevwalkRepository(
    walk: OpaquePointer
) -> OpaquePointer
{
    return git_revwalk_repository(walk)
}



/// Adds, changes, or removes the callback invoked by the given revision walker.
/// - Parameters:
///   - walk: The revision walker to update. The underlying type must be
///   `git_revwalk`.
///   - hideCB: The ``GitRevwalkHideCB`` callback to invoke to hide the
///   specified commit and its parents. Pass `nil` to unset the callback.
///   - payload: The payload to pass to `hideCB`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revwalk_add_hide_cb()`](https://libgit2.org/docs/reference/main/revwalk/git_revwalk_add_hide_cb.html)
public func gitRevwalkAddHideCB(
    walk    : OpaquePointer,
    hideCB  : GitRevwalkHideCB?,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revwalk_add_hide_cb(
            walk,
            hideCB,
            payload
        )
    }
}
