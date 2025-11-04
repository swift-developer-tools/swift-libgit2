//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Looks up the specified merge driver.
/// - Parameter name: The name of the merge driver to look up.
/// - Returns: The specified merge driver.
///
/// ## C Equivalent
///
/// [`git_merge_driver_lookup()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_lookup.html)
public func gitMergeDriverLookup(
    name: String
) -> UnsafeMutablePointer<git_merge_driver>?
{
    return git_merge_driver_lookup(name)
}



/// Gets the repository containing the given merge driver source.
///
/// - Important: The returned pointer is owned by the given merge driver source
/// and must not be freed.
///
/// - Parameter src: The merge driver source for which to get the repository.
/// The underlying type must be `git_merge_driver_source`.
/// - Returns: The repository containing the given merge driver source. The
/// underlying type will be `git_repository`.
///
/// ## C Equivalent
///
/// [`git_merge_driver_source_repo()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_source_repo.html)
public func gitMergeDriverSourceRepo(
    src: OpaquePointer
) -> OpaquePointer
{
    return git_merge_driver_source_repo(src)
}



/// Gets the ancestor of the given merge driver source.
/// - Parameter src: The merge driver source for which to get the ancestor.
/// The underlying type must be `git_merge_driver_source`.
/// - Returns: The ancestor of the given merge driver source.
///
/// ## C Equivalent
///
/// [`git_merge_driver_source_ancestor()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_source_ancestor.html)
public func gitMergeDriverSourceAncestor(
    src: OpaquePointer
) -> GitIndexEntry?
{
    guard let indexEntry: UnsafePointer<git_index_entry>
            = git_merge_driver_source_ancestor(src)
    else
    {
        return nil
    }
    
    return GitIndexEntry(cValue: indexEntry.pointee)
}



/// Gets "our" side of the given merge driver source.
/// - Parameter src: The merge driver source for which to get "our" side.
/// The underlying type must be `git_merge_driver_source`.
/// - Returns: "Our" side of the given merge driver source.
///
/// ## C Equivalent
///
/// [`git_merge_driver_source_ours()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_source_ours.html)
public func gitMergeDriverSourceOurs(
    src: OpaquePointer
) -> GitIndexEntry?
{
    guard let indexEntry: UnsafePointer<git_index_entry>
            = git_merge_driver_source_ours(src)
    else
    {
        return nil
    }
    
    return GitIndexEntry(cValue: indexEntry.pointee)
}



/// Gets "their" side of the given merge driver source.
/// - Parameter src: The merge driver source for which to get "their" side.
/// The underlying type must be `git_merge_driver_source`.
/// - Returns: "Their" side of the given merge driver source.
///
/// ## C Equivalent
///
/// [`git_merge_driver_source_theirs()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_source_theirs.html)
public func gitMergeDriverSourceTheirs(
    src: OpaquePointer
) -> GitIndexEntry?
{
    guard let indexEntry: UnsafePointer<git_index_entry>
            = git_merge_driver_source_theirs(src)
    else
    {
        return nil
    }
    
    return GitIndexEntry(cValue: indexEntry.pointee)
}



/// Gets the merge file options with which the given merge driver source
/// was invoked.
/// - Parameter src: The merge driver source for which to get the merge file
/// options. The underlying type must be `git_merge_driver_source`.
/// - Returns: The merge file options with which the given merge driver source
/// was invoked.
///
/// ## C Equivalent
///
/// [`git_merge_driver_source_file_options()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_source_file_options.html)
public func gitMergeDriverSourceFileOptions(
    src: OpaquePointer
) -> GitMergeFileOptions?
{
    guard let mergeFileOptions: UnsafePointer<git_merge_file_options>
            = git_merge_driver_source_file_options(src)
    else
    {
        return nil
    }
    
    return GitMergeFileOptions(cValue: mergeFileOptions.pointee)
}



/// Registers the given merge driver with the given name.
///
/// - Important: The `driver` pointer will be stored by libgit2 and must remain
/// valid until the merge driver is unregistered or until libgit2 is shut down.
/// The pointer must be a durable allocation, meaning it must be statically
/// allocated or heap-allocated. Passing a stack-allocated pointer will result
/// in data loss or undefined behavior.
///
/// - Parameters:
///   - name: The merge driver name to use.
///   - driver: The merge driver to register.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_driver_register()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_register.html)
public func gitMergeDriverRegister(
    name    : String,
    driver  : UnsafeMutablePointer<git_merge_driver>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_merge_driver_register(
            name,
            driver
        )
    }
}



/// Unregisters the specified merge driver.
///
/// The built-in libgit2 merge drivers cannot be removed.
///
/// - Parameter name: The name of the merge driver to unregister.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_merge_driver_unregister()`](https://libgit2.org/docs/reference/main/sys/merge/git_merge_driver_unregister.html)
public func gitMergeDriverUnregister(
    name: String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_merge_driver_unregister(name)
    }
}
