//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Initializes the given `git_submodule_update_options` instance.
/// - Parameters:
///   - opts: The `git_submodule_update_options` instance to initialize.
///   - version: The version to use. Pass ``gitSubmoduleUpdateOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_update_options_init()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_update_options_init.html)
public func gitSubmoduleUpdateOptionsInit(
    opts    : UnsafeMutablePointer<git_submodule_update_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_update_options_init(
            opts,
            version
        )
    }
}



/// Updates the given submodule.
///
/// This function will clone a missing submodule and checkout the subrepository
/// to the commit specified in the index of the containing repository. If the
/// submodule repository does not contain the target commit, then the submodule
/// will be fetched using the given fetch options.
///
/// - Parameters:
///   - submodule: The submodule to update. The underlying type must be
///   `git_submodule`.
///   - initialize: Whether to initialize the submodule before updating it,
///   if the submodule is not already initialized.
///   - options: The submodule update options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_update()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_update.html)
public func gitSubmoduleUpdate(
    submodule       : OpaquePointer,
    init initialize : Bool,
    options         : GitSubmoduleUpdateOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_submodule_update(
                submodule,
                initialize.int32Value,
                cOptions
            )
        }
    }
}



/// Looks up the specified submodule.
/// - Parameters:
///   - out: The pointer in which to store the submodule. The underlying type
///   must be `git_submodule`.
///   - repo: The repository containing the submodule. The underlying type must
///   be `git_repository`.
///   - name: The name or path of the submodule to lookup. This may include a
///   trailing slash (`/`).
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_lookup()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_lookup.html)
public func gitSubmoduleLookup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_lookup(
            out,
            repo,
            name
        )
    }
}



/// Creates an in-memory copy of the given submodule.
/// - Parameters:
///   - out: The pointer in which to store the copied submodule. The underlying
///   type must be `git_submodule`.
///   - source: The submodule to copy. The underlying type must be
///   `git_submodule`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_dup()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_dup.html)
public func gitSubmoduleDup(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    source  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_dup(
            out,
            source
        )
    }
}



/// Frees the memory allocated for the given `git_submodule` instance.
/// - Parameter submodule: The submodule to free. The underlying type must be
/// `git_submodule`.
///
/// ## C Equivalent
///
/// [`git_submodule_free()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_free.html)
public func gitSubmoduleFree(
    submodule: OpaquePointer?
)
{
    guard let submodule
    else
    {
        return
    }
    
    git_submodule_free(submodule)
}



/// Loops over all the tracked submodule in the given repository.
/// - Parameters:
///   - repo: The repository containing the submodules. The underlying type
///   must be `git_repository`.
///   - callback: The ``GitSubmoduleCB`` callback to invoke for each submodule.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_foreach()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_foreach.html)
public func gitSubmoduleForEach(
    repo        : OpaquePointer,
    callback    : GitSubmoduleCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_foreach(
            repo,
            callback,
            payload
        )
    }
}



/// Adds a new submodule to the given repository.
///
/// This function will prepare a new submodule, create an entry in
/// `.gitmodules`, and create an empty initialized repository either at the
/// given path in the working directory, or in `.git/modules` with a Gitlink
/// from the working directory to the new repository.
///
/// To fully replicate the behavior of `git submodule add`, call this function,
/// then open the submodule repository and perform the clone step by calling
/// ``gitSubmoduleClone(out:submodule:opts:)`` and
/// ``gitSubmoduleAddFinalize(submodule:)``.
///
/// - Parameters:
///   - out: The pointer in which to store the submodule. The underlying type
///   must be `git_submodule`.
///   - repo: The repository to which to add the submodule. The underlying type
///   must be `git_repository`.
///   - url: The submodule remote URL to use.
///   - path: The path to the location at which to create the submodule.
///   - useGitlink: Whether the working directory should contain a Gitlink to
///   the repository in `.git/modules`, as opposed to initializing an empty
///   repository at the specified location in the working directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_add_setup()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_add_setup.html)
public func gitSubmoduleAddSetup(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    repo        : OpaquePointer,
    url         : String,
    path        : String,
    useGitlink  : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_add_setup(
            out,
            repo,
            url,
            path,
            useGitlink.int32Value
        )
    }
}



/// Clones the given newly-created submodule.
/// - Parameters:
///   - out: The pointer in which to store the new repository. The underlying
///   type must be `git_repository`.
///   - submodule: The newly-created submodule to clone. The underlying type
///   must be `git_submodule`.
///   - opts: The submodule update options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_clone()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_clone.html)
public func gitSubmoduleClone(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    submodule   : OpaquePointer,
    opts        : GitSubmoduleUpdateOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_submodule_clone(
                out,
                submodule,
                cOpts
            )
        }
    }
}



/// Resolves the setup of the given newly-created submodule.
///
/// Call this function after adding and cloning the given submodule. This
/// function will add the `.gitmodules` file and the newly-cloned submodule
/// to the index, where they will be ready to commit. This function does not
/// perform the commit.
///
/// - Parameter submodule: The newly-created submodule to resolve. The
/// underlying type must be `git_submodule`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_add_finalize()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_add_finalize.html)
public func gitSubmoduleAddFinalize(
    submodule: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_add_finalize(submodule)
    }
}



/// Adds the HEAD of the given submodule to the index of the superproject.
///
/// If `writeIndex` is `false`, use ``gitIndexWrite(index:)`` to save the
/// changes.
///
/// - Parameters:
///   - submodule: The submodule to add. The underlying type must be
///   `git_submodule`.
///   - writeIndex: Whether to immediately write the index file.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_add_to_index()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_add_to_index.html)
public func gitSubmoduleAddToIndex(
    submodule   : OpaquePointer,
    writeIndex  : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_add_to_index(
            submodule,
            writeIndex.int32Value
        )
    }
}



/// Gets the repository containing the given submodule.
///
/// - Important: The returned pointer is owned by the given submodule and
/// must not be freed. It will be a reference to the repository that was
/// passed to ``gitSubmoduleLookup(out:repo:name:)``. If that repository has
/// been freed, the returned pointer will be a dangling reference.
///
/// - Parameter submodule: The submodule for which to get the repository. The
/// underlying type must be `git_submodule`.
/// - Returns: The repository containing the given submodule. The underlying
/// type will be `git_repository`.
///
/// ## C Equivalent
///
/// [`git_submodule_owner()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_owner.html)
public func gitSubmoduleOwner(
    submodule: OpaquePointer
) -> OpaquePointer
{
    return git_submodule_owner(submodule)
}



/// Gets the name of the given submodule.
/// - Parameter submodule: The submodule for which to get the name. The
/// underlying type must be `git_submodule`.
/// - Returns: The name of the given submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_name()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_name.html)
public func gitSubmoduleName(
    submodule: OpaquePointer
) -> String?
{
    let submoduleName: UnsafePointer<CChar>? = git_submodule_name(submodule)
    
    return String(optionalCString: submoduleName)
}



/// Gets the path of the given submodule.
///
/// The path of a submodule is generally the same as its name, although the
/// two are not required to match.
///
/// - Parameter submodule: The submodule for which to get the path. The
/// underlying type must be `git_submodule`.
/// - Returns: The path of the given submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_path()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_path.html)
public func gitSubmodulePath(
    submodule: OpaquePointer
) -> String?
{
    let submodulePath: UnsafePointer<CChar>? = git_submodule_path(submodule)
    
    return String(optionalCString: submodulePath)
}



/// Gets the URL of the given submodule.
/// - Parameter submodule: The submodule for which to get the URL. The underlying
/// type must be `git_submodule`.
/// - Returns: The URL of the given submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_url()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_url.html)
public func gitSubmoduleURL(
    submodule: OpaquePointer
) -> String?
{
    let submoduleURL: UnsafePointer<CChar>? = git_submodule_url(submodule)
    
    return String(optionalCString: submoduleURL)
}



/// Resolves the URL of the given submodule, relative to the given repository.
/// - Parameters:
///   - out: The `String` instance in which to store the resolved URL.
///   - repo: The repository against which to resolve the relative URL. The
///   underlying type must be `git_repository`.
///   - url: The relative URL to resolve.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_resolve_url()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_resolve_url.html)
public func gitSubmoduleResolveURL(
    out     : inout String?,
    repo    : OpaquePointer,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_submodule_resolve_url(
                cOut,
                repo,
                url
            )
        }
    }
}



/// Gets the branch name of the given submodule.
/// - Parameter submodule: The submodule for which to get the branch name. The
/// underlying type must be `git_submodule`.
/// - Returns: The branch name of the given submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_branch()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_branch.html)
public func gitSubmoduleBranch(
    submodule: OpaquePointer
) -> String?
{
    let submoduleBranch: UnsafePointer<CChar>?
        = git_submodule_branch(submodule)
    
    return String(optionalCString: submoduleBranch)
}



/// Sets the branch of the specified submodule.
///
/// After calling this function, optionally use ``gitSubmoduleSync(submodule:)``
/// to write the changes to the checked out submodule repository.
///
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - name: The name of the submodule for which to set the branch.
///   - branch: The name of the branch to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_set_branch()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_set_branch.html)
public func gitSubmoduleSetBranch(
    repo    : OpaquePointer,
    name    : String,
    branch  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_set_branch(
            repo,
            name,
            branch
        )
    }
}



/// Sets the URL of the specified submodule.
///
/// After calling this function, optionally use ``gitSubmoduleSync(submodule:)``
/// to write the changes to the checked out submodule repository.
///
/// - Parameters:
///   - repo: The repository to update. The underlying type must be
///   `git_repository`.
///   - name: The name of the submodule for which to set the URL.
///   - url: The URL to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_set_url()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_set_url.html)
public func gitSubmoduleSetURL(
    repo    : OpaquePointer,
    name    : String,
    url     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_set_url(
            repo,
            name,
            url
        )
    }
}



/// Gets the ID of the given submodule in the index.
/// - Parameter submodule: The submodule for which to get the ID. The
/// underlying type must be `git_submodule`.
/// - Returns: The ID of the given submodule in the index.
///
/// ## C Equivalent
///
/// [`git_submodule_index_id()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_index_id.html)
public func gitSubmoduleIndexID(
    submodule: OpaquePointer
) -> GitOID?
{
    guard let submoduleOID: UnsafePointer<git_oid>
            = git_submodule_index_id(submodule)
    else
    {
        return nil
    }
    
    return GitOID(cValue: submoduleOID.pointee)
}



/// Gets the ID of the given submodule in the HEAD tree.
/// - Parameter submodule: The submodule for which to get the ID. The
/// underlying type must be `git_submodule`.
/// - Returns: The ID of the given submodule in the HEAD tree.
///
/// ## C Equivalent
///
/// [`git_submodule_head_id()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_head_id.html)
public func gitSubmoduleHEADID(
    submodule: OpaquePointer
) -> GitOID?
{
    guard let submoduleOID: UnsafePointer<git_oid>
            = git_submodule_head_id(submodule)
    else
    {
        return nil
    }
    
    return GitOID(cValue: submoduleOID.pointee)
}



/// Gets the ID of the given submodule in the working directory.
///
/// This function returns the ID corresponding to the HEAD of the checked out
/// submodule, and does not account for pending changes in the index. Use
/// ``gitSubmoduleStatus(status:repo:name:ignore:)`` for more complete
/// information about the state of the working directory.
///
/// - Parameter submodule: The submodule for which to get the ID. The
/// underlying type must be `git_submodule`.
/// - Returns: The ID of the given submodule in the working directory.
///
/// ## C Equivalent
///
/// [`git_submodule_wd_id()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_wd_id.html)
public func gitSubmoduleWDID(
    submodule: OpaquePointer
) -> GitOID?
{
    guard let submoduleOID: UnsafePointer<git_oid>
            = git_submodule_wd_id(submodule)
    else
    {
        return nil
    }
    
    return GitOID(cValue: submoduleOID.pointee)
}



/// Gets the ignore rule of the given submodule.
/// - Parameter submodule: The submodule for which to get the ignore rule. The
/// underlying type must be `git_submodule`.
/// - Returns: The ignore rule of the given submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_ignore()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_ignore.html)
public func gitSubmoduleIgnore(
    submodule: OpaquePointer
) -> GitSubmoduleIgnoreT?
{
    let submoduleIgnore: git_submodule_ignore_t
        = git_submodule_ignore(submodule)
    
    return GitSubmoduleIgnoreT(cValue: submoduleIgnore)
}



/// Sets the ignore rule of the specified submodule.
///
/// - Note: This does not affect any existing submodule instances.
///
/// - Parameters:
///   - repo: The repository containing the submodule. The underlying type must
///   be `git_repository`.
///   - name: The name of the submodule for which to set the ignore rule.
///   - ignore: The submodule ignore rule to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_set_ignore()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_set_ignore.html)
public func gitSubmoduleSetIgnore(
    repo    : OpaquePointer,
    name    : String,
    ignore  : GitSubmoduleIgnoreT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_set_ignore(
            repo,
            name,
            ignore.cValue()
        )
    }
}



/// Gets the update rule of the given submodule.
/// - Parameter submodule: The submodule for which to get the update rule. The
/// underlying type must be `git_submodule`.
/// - Returns: The update rule of the given submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_update_strategy()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_update_strategy.html)
public func gitSubmoduleUpdateStrategy(
    submodule: OpaquePointer
) -> GitSubmoduleUpdateT?
{
    let submoduleUpdate: git_submodule_update_t
        = git_submodule_update_strategy(submodule)
    
    return GitSubmoduleUpdateT(cValue: submoduleUpdate)
}



/// Sets the update rule of the specified submodule.
///
/// - Note: This does not affect any existing submodule instances.
///
/// - Parameters:
///   - repo: The repository containing the submodule. The underlying type must
///   be `git_repository`.
///   - name: The name of the submodule for which to set the update rule.
///   - ignore: The submodule update rule to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_set_update()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_set_update.html)
public func gitSubmoduleSetUpdate(
    repo    : OpaquePointer,
    name    : String,
    ignore  : GitSubmoduleUpdateT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_set_update(
            repo,
            name,
            ignore.cValue()
        )
    }
}



/// Gets the recursion rule of the given submodule.
///
/// This function accesses the `submodule.<name>.fetchRecurseSubmodules`
/// configuration variable value for the given submodule.
///
/// - Note: libgit2 does not honor this recursion setting, and the fetch
/// functionality ignores submodules.
///
/// - Parameter submodule: The submodule for which to get the recursion rule.
/// The underlying type must be `git_submodule`.
/// - Returns: The recursion rule of the given submodule.
///
/// ## C Equivalent
///
/// [`git_submodule_fetch_recurse_submodules()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_fetch_recurse_submodules.html)
public func gitSubmoduleFetchRecurseSubmodules(
    submodule: OpaquePointer
) -> GitSubmoduleRecurseT?
{
    let submoduleRecurse: git_submodule_recurse_t
        = git_submodule_fetch_recurse_submodules(submodule)
    
    return GitSubmoduleRecurseT(cValue: submoduleRecurse)
}



/// Sets the recursion rule of the specified submodule.
///
/// - Note: This does not affect any existing submodule instances.
///
/// - Parameters:
///   - repo: The repository containing the submodule. The underlying type must
///   be `git_repository`.
///   - name: The name of the submodule for which to set the recursion rule.
///   - fetchRecurseSubmodules: The submodule recursion rule to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_set_fetch_recurse_submodules()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_set_fetch_recurse_submodules.html)
public func gitSubmoduleSetFetchRecurseSubmodules(
    repo                    : OpaquePointer,
    name                    : String,
    fetchRecurseSubmodules  : GitSubmoduleRecurseT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_set_fetch_recurse_submodules(
            repo,
            name,
            fetchRecurseSubmodules.cValue()
        )
    }
}



/// Copies the information of the given submodule into the superproject's
/// `.git/config` file.
///
/// This is similar to `git submodule init`.
///
/// - Parameters:
///   - submodule: The submodule to write into the superproject's `.git/config`
///   file. The underlying type must be `git_submodule`.
///   - overwrite: Whether to overwrite existing entries.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_init()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_init.html)
public func gitSubmoduleInit(
    submodule   : OpaquePointer,
    overwrite   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_init(
            submodule,
            overwrite.int32Value
        )
    }
}



/// Sets up the subrepository for the given submodule, in preparation for a
/// clone operation.
/// - Parameters:
///   - out: The pointer in which to store the new repository. The underlying
///   type must be `git_repository`.
///   - sm: The submodule from which to create the new repository. The
///   underlying type must be `git_submodule`.
///   - useGitlink: Whether the working directory should contain a Gitlink to
///   the repository in `.git/modules`, as opposed to initializing an empty
///   repository at the specified location in the working directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_repo_init()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_repo_init.html)
public func gitSubmoduleRepoInit(
    out         : UnsafeMutablePointer<OpaquePointer?>,
    sm          : OpaquePointer,
    useGitlink  : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_repo_init(
            out,
            sm,
            useGitlink.int32Value
        )
    }
}



/// Copies the remote information of the given submodule into the checked out
/// submodule configuration.
///
/// This is similar to `git submodule sync`.
///
/// - Parameter submodule: The submodule to copy. The underlying type must be
/// `git_submodule`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_sync()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_sync.html)
public func gitSubmoduleSync(
    submodule: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_sync(submodule)
    }
}



/// Opens the repository of the given submodule.
///
/// Multiple calls to this function will return distinct `git_repository`
/// instances.
///
/// - Parameters:
///   - repo: The pointer in which to store the opened repository. The
///   underlying type must be `git_repository`.
///   - submodule: The submodule to open. The underlying type must be
///   `git_submodule`. The submodule must be checked out into the working
///   directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_open()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_open.html)
public func gitSubmoduleOpen(
    repo        : UnsafeMutablePointer<OpaquePointer?>,
    submodule   : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_open(
            repo,
            submodule
        )
    }
}



/// Reloads cached information of the given submodule from the configuration,
/// the index, and HEAD.
/// - Parameters:
///   - submodule: The submodule to reload. The underlying type must be
///   `git_submodule`.
///   - force: Whether to reload even if the data does not seem out of date.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_reload()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_reload.html)
public func gitSubmoduleReload(
    submodule   : OpaquePointer,
    force       : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_submodule_reload(
            submodule,
            force.int32Value
        )
    }
}



/// Gets the status of the specified submodule.
/// - Parameters:
///   - status: The ``GitSubmoduleStatusT`` instance in which to store the
///   submodule status.
///   - repo: The repository containing the submodule. The underlying type
///   must be `git_repository`.
///   - name: The name of the submodule for which to get the status.
///   - ignore: The submodule ignore rules to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_status()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_status.html)
public func gitSubmoduleStatus(
    status  : inout GitSubmoduleStatusT,
    repo    : OpaquePointer,
    name    : String,
    ignore  : GitSubmoduleIgnoreT
) -> GitErrorCode
{
    return withCConversion
    {
        return status.withMutatingRawValue
        {
            cStatus in
            
            return git_submodule_status(
                cStatus,
                repo,
                name,
                ignore.cValue()
            )
        }
    }
}



/// Gets the location status of the specified submodule.
///
/// This function is a lightweight version of
/// ``gitSubmoduleStatus(status:repo:name:ignore:)``.
///
/// - Parameters:
///   - locationStatus: The ``GitSubmoduleStatusT`` instance in which to store
///   the submodule location status.
///   - submodule: The submodule for which to get the location status. The
///   underlying type must be `git_submodule`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_submodule_location()`](https://libgit2.org/docs/reference/main/submodule/git_submodule_location.html)
public func gitSubmoduleLocation(
    locationStatus  : inout GitSubmoduleStatusT,
    submodule       : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return locationStatus.withMutatingRawValue
        {
            cLocationStatus in
            
            return git_submodule_location(
                cLocationStatus,
                submodule
            )
        }
    }
}
