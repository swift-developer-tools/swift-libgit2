//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Looks up the specified filter.
/// - Parameter name: The name of the filter to look up.
/// - Returns: The specified filter.
///
/// ## C Equivalent
///
/// [`git_filter_lookup()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_lookup.html)
public func gitFilterLookup(
    name: String
) -> UnsafeMutablePointer<git_filter>?
{
    return git_filter_lookup(name)
}



/// Creates an empty filter list.
/// - Parameters:
///   - out: The pointer in which to store the filter list. The underlying
///   type must be `git_filter_lister`.
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
///   - mode: The filtering direction to use.
///   - options: The flags controlling the filtering process.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function may be used with ``gitFilterLookup(name:)`` and
/// ``gitFilterListPush(fl:filter:payload:)`` to assemble a chain of filters.
///
/// ## C Equivalent
///
/// [`git_filter_list_new()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_list_new.html)
public func gitFilterListNew(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    mode    : GitFilterModeT,
    options : GitFilterFlagT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_list_new(
            out,
            repo,
            mode.cValue(),
            options.rawValue
        )
    }
}



/// Adds the given filter the given filter list.
/// - Parameters:
///   - fl: The filter list to update. The underlying type must be
///   `git_filter_list`.
///   - filter: The filter to add.
///   - payload: The filter payload to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function allows more direct manipulation of filter lists. This
/// function is usually not necessary, since the filter list is created by
/// invoked the ``GitFilterCheckFN`` callback with registered filters when the
/// attributes are set.
///
/// - Note: A payload may be provided if the expected payload format is known.
/// Some filters will fail if the given payload is `nil`.
///
/// ## C Equivalent
///
/// [`git_filter_list_push()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_list_push.html)
public func gitFilterListPush(
    fl      : OpaquePointer,
    filter  : UnsafeMutablePointer<git_filter>,
    payload : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_list_push(
            fl,
            filter,
            payload
        )
    }
}



/// Gets the number of filters in the given filter list.
/// - Parameter fl: The filter list to check. The underlying type must be
/// `git_filter_list`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_filter_list_length()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_list_length.html)
public func gitFilterListLength(
    fl: OpaquePointer
) -> Int
{
    return git_filter_list_length(fl)
}



/// Gets the repository containing the given filter source.
/// - Parameter src: The filter source for which to get the repository. The
/// underlying type must be `git_filter_source`.
/// - Returns: The repository containing the given filter source. The
/// underlying type will be `git_repository`.
///
/// ## Discussion
///
/// - Important: The returned pointer is owned by the given filter source and
/// must not be freed.
///
/// ## C Equivalent
///
/// [`git_filter_source_repo()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_source_repo.html)
public func gitFilterSourceRepo(
    src: OpaquePointer
) -> OpaquePointer
{
    return git_filter_source_repo(src)
}



/// Gets the path of the given filter source.
/// - Parameter src: The filter source for which to get the path. The
/// underlying type must be `git_filter_source`.
/// - Returns: The path of the given filter source.
///
/// ## C Equivalent
///
/// [`git_filter_source_path()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_source_path.html)
public func gitFilterSourcePath(
    src: OpaquePointer
) -> String?
{
    let path: UnsafePointer<CChar>? = git_filter_source_path(src)
    
    return String(optionalCString: path)
}



/// Gets the file mode of the given filter source.
/// - Parameter src: The filter source for which to get the file mode. The
/// underlying type must be `git_filter_source`.
/// - Returns: The file mode of the given filter source.
///
/// ## C Equivalent
///
/// [`git_filter_source_filemode()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_source_filemode.html)
public func gitFilterSourceFileMode(
    src: OpaquePointer
) -> GitFileModeT?
{
    let fileMode: UInt16 = git_filter_source_filemode(src)
    
    return GitFileModeT(rawValue: fileMode)
}



/// Gets the ID of the given filter source.
/// - Parameter src: The filter source for which to get ID. The underlying
/// type must be `git_filter_source`.
/// - Returns: The ID of the given filter source.
///
/// ## C Equivalent
///
/// [`git_filter_source_id()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_source_id.html)
public func gitFilterSourceID(
    src: OpaquePointer
) -> GitOID?
{
    guard let filterSourceOID: UnsafePointer<git_oid>
            = git_filter_source_id(src)
    else
    {
        return nil
    }
    
    return GitOID(cValue: filterSourceOID.pointee)
}



/// Gets the filter mode of the given filter source.
/// - Parameter src: The filter source for which to get the filter mode. The
/// underlying type must be `git_filter_source`.
/// - Returns: The filter mode of the given filter source.
///
/// ## C Equivalent
///
/// [`git_filter_source_mode()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_source_mode.html)
public func gitFilterSourceMode(
    src: OpaquePointer
) -> GitFilterModeT?
{
    let filterMode: git_filter_mode_t = git_filter_source_mode(src)
    
    return GitFilterModeT(cValue: filterMode)
}



/// Gets the filter flags of the given filter source.
/// - Parameter src: The filter source for which to get the filter flags. The
/// underlying type must be `git_filter_source`.
/// - Returns: The filter flags of the given filter source.
///
/// ## C Equivalent
///
/// [`git_filter_source_flags()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_source_flags.html)
public func gitFilterSourceFlags(
    src: OpaquePointer
) -> GitFilterFlagT?
{
    let filterFlags: UInt32 = git_filter_source_flags(src)
    
    return GitFilterFlagT(rawValue: filterFlags)
}



/// Initializes the given `git_filter_init` instance.
/// - Parameters:
///   - filter: The `git_filter_init` instance to initialize.
///   - version: The version to use. Pass ``gitFilterVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_filter_init()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_init.html)
public func gitFilterInit(
    filter  : UnsafeMutablePointer<git_filter>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_init(
            filter,
            version
        )
    }
}



/// Registers the given filter with the given name and priority.
/// - Parameters:
///   - name: The filter name to use.
///   - filter: The filter to register.
///   - priority: The filter priority to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: The `filter` pointer will be stored by libgit2 and must remain
/// valid until the filter is unregistered or until libgit2 is shut down.
/// The pointer must be a durable allocation, meaning it must be statically
/// allocated or heap-allocated. Passing a stack-allocated pointer will result
/// in data loss or undefined behavior.
///
/// ## C Equivalent
///
/// [`git_filter_register()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_register.html)
public func gitFilterRegister(
    name        : String,
    filter      : UnsafeMutablePointer<git_filter>,
    priority    : Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_register(
            name,
            filter,
            priority
        )
    }
}



/// Unregisters the specified filter.
/// - Parameter name: The name of the filter to unregister.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The built-in libgit2 filters cannot be removed.
///
/// ## C Equivalent
///
/// [`git_filter_unregister()`](https://libgit2.org/docs/reference/main/sys/filter/git_filter_unregister.html)
public func gitFilterUnregister(
    name: String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_filter_unregister(name)
    }
}
