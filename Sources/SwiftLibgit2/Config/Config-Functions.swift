//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Frees the memory allocated for the given `git_config_entry` instance.
/// - Parameter entry: The configuration entry to free.
///
/// ## C Equivalent
///
/// [`git_config_entry_free()`](https://libgit2.org/docs/reference/main/config/git_config_entry_free.html)
public func gitConfigEntryFree(
    entry: UnsafeMutablePointer<git_config_entry>?
)
{
    guard let entry: UnsafeMutablePointer<git_config_entry> = entry
    else
    {
        return
    }
    
    git_config_entry_free(entry)
}



/// Locates the path to the global configuration file.
/// - Parameter out: The `String` instance in which to store the path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The user configuration file or global configuration file is usually
/// located in `$HOME/.gitconfig`. This function will try to guess the full
/// path to that file, if the file exists. It will not guess the path to the
/// XDG-compatible config file (`.config/git/config`).
///
/// The returned path may be used on any Git configuration-related call to
/// load the global configuration file.
///
/// ## C Equivalent
///
/// [`git_config_find_global()`](https://libgit2.org/docs/reference/main/config/git_config_find_global.html)
public func gitConfigFindGlobal(
    out: inout String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_config_find_global(cOut)
        }
    }
}



/// Locates the path to the global XDG-compatible configuration file.
/// - Parameter out: The `String` instance in which to store the path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The XDG-compatible configuration file is usually located in
/// `$HOME/.config/git/config`. This function will try to guess the full path
/// to that file, if the file exists.
///
/// The returned path may be used on any Git configuration-related call to
/// load the XDG-compatible configuration file.
///
/// ## C Equivalent
///
/// [`git_config_find_xdg()`](https://libgit2.org/docs/reference/main/config/git_config_find_xdg.html)
public func gitConfigFindXDG(
    out: inout String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_config_find_xdg(cOut)
        }
    }
}



/// Locates the path to the system configuration file.
/// - Parameter out: The `String` instance in which to store the path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The system configuration file is usually located in `/etc/gitconfig` or
/// `%PROGRAMFILES%\Git\etc\gitconfig`.
///
/// ## C Equivalent
///
/// [`git_config_find_system()`](https://libgit2.org/docs/reference/main/config/git_config_find_system.html)
public func gitConfigFindSystem(
    out: inout String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_config_find_system(cOut)
        }
    }
}



/// Locates the path to the ProgramData configuration file.
/// - Parameter out: The `String` instance in which to store the path.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The configuration file used by Portable Git is usually located in
/// `%PROGRAMDATA%\Git\config`.
///
/// ## C Equivalent
///
/// [`git_config_find_programdata()`](https://libgit2.org/docs/reference/main/config/git_config_find_programdata.html)
public func gitConfigFindProgramData(
    out: inout String?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_config_find_programdata(cOut)
        }
    }
}



/// Opens the global, XDG, and system configuration files.
/// - Parameter out: The pointer in which to store the configuration. The
/// underlying type must be `git_config`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function finds the global, XDG, and system configuration files, and
/// opens them into a single prioritized configuration that can be used when
/// accessing default configuration data outside a repository.
///
/// ## C Equivalent
///
/// [`git_config_open_default()`](https://libgit2.org/docs/reference/main/config/git_config_open_default.html)
public func gitConfigOpenDefault(
    out: UnsafeMutablePointer<OpaquePointer?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_open_default(out)
    }
}



/// Allocates a new configuration.
/// - Parameter out: The pointer in which to store the configuration. The
/// underlying type must be `git_config`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting configuration will be empty. A file must be added to it
/// before it can be used.
///
/// ## C Equivalent
///
/// [`git_config_new()`](https://libgit2.org/docs/reference/main/config/git_config_new.html)
public func gitConfigNew(
    out: UnsafeMutablePointer<OpaquePointer?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_new(out)
    }
}



/// Adds an on-disk configuration file to an existing configuration.
/// - Parameters:
///   - cfg: The configuration to which to add the file. The underlying type
///   must be `git_config`.
///   - path: The path to the configuration file to add.
///   - level: The priority level of the backend.
///   - repo: The optional repository to allow parsing of conditional includes.
///   The underlying type must be `git_repository`.
///   - force: Whether to replace the configuration file at the given priority
///   level.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The on-disk file pointed at by `path` will be opened and parsed. The file
/// must be a native Git configuration file following the default Git
/// configuration syntax (see the `git-config` documentation).
///
/// If the file pointed at by `path` does not exist, the file will still be
/// added and it will be created during the first write operation.
///
/// Further queries on the configuration will access each of the configuration
/// files in order (files with a higher priority level will be accessed first).
///
/// - Important: The configuration will free the file automatically.
///
/// ## C Equivalent
///
/// [`git_config_add_file_ondisk()`](https://libgit2.org/docs/reference/main/config/git_config_add_file_ondisk.html)
public func gitConfigAddFileOnDisk(
    cfg     : OpaquePointer,
    path    : String,
    level   : GitConfigLevelT,
    repo    : OpaquePointer?,
    force   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_add_file_ondisk(
            cfg,
            path,
            level.cValue(),
            repo,
            force.int32Value
        )
    }
}



/// Creates a new configuration containing a single on-disk file.
/// - Parameters:
///   - out: The pointer in which to store the configuration. The underlying
///   type must be `git_config`.
///   - path: The path to the on-disk file to open.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is equivalent to sequentially calling the following functions:
///
/// - ``gitConfigNew(out:)``
/// - ``gitConfigAddFileOnDisk(cfg:path:level:repo:force:)``
///
/// ## C Equivalent
///
/// [`git_config_open_ondisk()`](https://libgit2.org/docs/reference/main/config/git_config_open_ondisk.html)
public func gitConfigOpenOnDisk(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_open_ondisk(
            out,
            path
        )
    }
}



/// Builds a single-level focused configuration from a multi-level
/// configuration.
/// - Parameters:
///   - out: The pointer in which to store the configuration. The underlying
///   type must be `git_config`.
///   - parent: The multi-level configuration to search for the given level.
///   The underlying type must be `git_config`.
///   - level: The configuration level for which to search.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting configuration can be used to perform get, set, or delete
/// operations on a single specific level.
///
/// Getting the same level multiple times from the same parent multi-level
/// configuration will return different configurations, each containing the
/// same configuration file instance.
///
/// ## C Equivalent
///
/// [`git_config_open_level()`](https://libgit2.org/docs/reference/main/config/git_config_open_level.html)
public func gitConfigOpenLevel(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    parent  : OpaquePointer,
    level   : GitConfigLevelT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_open_level(
            out,
            parent,
            level.cValue()
        )
    }
}



/// Opens the global/XDG configuration file according to Git's rules.
/// - Parameters:
///   - out: The pointer in which to store the configuration. The underlying
///   type must be `git_config`.
///   - config: The configuration to search. The underlying type must be
///   `git_config`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Git allows the global configuration to be stored at `$HOME/.gitconfig` or
/// `$XDG_CONFIG_HOME/git/config`. For backwards compatibility, the XDG file
/// should not be used unless it was created explicitly. This function opens
/// the correct file to use when writing.
///
/// ## C Equivalent
///
/// [`git_config_open_global()`](https://libgit2.org/docs/reference/main/config/git_config_open_global.html)
public func gitConfigOpenGlobal(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    config  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_open_global(
            out,
            config
        )
    }
}



/// Sets the write order for configuration backends.
/// - Parameters:
///   - cfg: The configuration to update. The underlying type must be
///   `git_config`.
///   - levels: The ordering of levels to use.
///   - len: The length of `levels`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// By default, the write ordering does not match the read ordering.
/// For example, the worktree configuration is a high-priority for reading,
/// but is not written to unless explicitly chosen.
///
/// ## C Equivalent
///
/// [`git_config_set_writeorder()`](https://libgit2.org/docs/reference/main/config/git_config_set_writeorder.html)
public func gitConfigSetWriteOrder(
    cfg     : OpaquePointer,
    levels  : [GitConfigLevelT],
    len     : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try levels.withArrayOfGitConfigLevels
        {
            cLevels, cLevelsCount in
            
            return git_config_set_writeorder(
                cfg,
                cLevels,
                cLevelsCount
            )
        }
    }
}



/// Creates a snapshot of the configuration.
/// - Parameters:
///   - out: The pointer in which to store the configuration. The underlying
///   type must be `git_config`.
///   - config: The configuration to snapshot. The underlying type must be
///   `git_config`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A snapshot of the current state of a configuration is a consistent view
/// of the configuration for looking up complex values (for example, a remote
/// or submodule).
///
/// - Important: The string returned when querying such a configuration will
/// be valid until it is freed.
///
/// ## C Equivalent
///
/// [`git_config_snapshot()`](https://libgit2.org/docs/reference/main/config/git_config_snapshot.html)
public func gitConfigSnapshot(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    config  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_snapshot(
            out,
            config
        )
    }
}



/// Frees the memory allocated for the given `git_config` instance.
/// - Parameter cfg: The configuration to free. The underlying type must be
/// `git_config`.
///
/// ## C Equivalent
///
/// [`git_config_free()`](https://libgit2.org/docs/reference/main/config/git_config_free.html)
public func gitConfigFree(
    cfg: OpaquePointer?
)
{
    guard let cfg: OpaquePointer = cfg
    else
    {
        return
    }
    
    git_config_free(cfg)
}



/// Gets the configuration entry of the specified configuration variable.
/// - Parameters:
///   - out: The ``GitConfigEntry`` instance in which to store the
///   configuration entry.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the
///   configuration entry.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_config_get_entry()`](https://libgit2.org/docs/reference/main/config/git_config_get_entry.html)
public func gitConfigGetEntry(
    out     : inout GitConfigEntry,
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_config_get_entry(
                cOut,
                cfg,
                name
            )
        }
    }
}



/// Gets the value of the specified 32-bit integer configuration variable.
/// - Parameters:
///   - out: The pointer in which to store the resulting integer.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All configuration files will be searched in the order of their defined
/// level. A higher level means a higher priority. The first occurrence of the
/// entry will be returned.
///
/// ## C Equivalent
///
/// [`git_config_get_int32()`](https://libgit2.org/docs/reference/main/config/git_config_get_int32.html)
public func gitConfigGetInt32(
    out     : UnsafeMutablePointer<Int32>,
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_get_int32(
            out,
            cfg,
            name
        )
    }
}



/// Gets the value of the specified 64-bit integer configuration variable.
/// - Parameters:
///   - out: The pointer in which to store the resulting integer.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All configuration files will be searched in the order of their defined
/// level. A higher level means a higher priority. The first occurrence of the
/// entry will be returned.
///
/// ## C Equivalent
///
/// [`git_config_get_int64()`](https://libgit2.org/docs/reference/main/config/git_config_get_int64.html)
public func gitConfigGetInt64(
    out     : UnsafeMutablePointer<Int64>,
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_get_int64(
            out,
            cfg,
            name
        )
    }
}



/// Gets the value of the specified boolean configuration variable.
/// - Parameters:
///   - out: The `Bool` instance in which to store the value of the specified
///   boolean configuration variable.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All configuration files will be searched in the order of their defined
/// level. A higher level means a higher priority. The first occurrence of the
/// entry will be returned.
///
/// ## C Equivalent
///
/// [`git_config_get_bool()`](https://libgit2.org/docs/reference/main/config/git_config_get_bool.html)
public func gitConfigGetBool(
    out     : inout Bool,
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingBool
        {
            cOut in
            
            return git_config_get_bool(
                cOut,
                cfg,
                name
            )
        }
    }
}



/// Gets the value of the specified path configuration variable.
/// - Parameters:
///   - out: The `String` instance in which to store the path value.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A leading tilde (`~`) will be expanded to the global search path.
/// The global search path defaults to the user's home directory, but can be
/// overridden using ``gitLibgit2OptSetHomeDir(path:)``.
///
/// All configuration files will be searched in the order of their defined
/// level. A higher level means a higher priority. The first occurrence of the
/// entry will be returned.
///
/// ## C Equivalent
///
/// [`git_config_get_path()`](https://libgit2.org/docs/reference/main/config/git_config_get_path.html)
public func gitConfigGetPath(
    out     : inout String?,
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_config_get_path(
                cOut,
                cfg,
                name
            )
        }
    }
}



/// Gets the value of the specified string configuration variable.
/// - Parameters:
///   - out: The `String` instance in which to store the value of the
///   specified string configuration variable.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All configuration files will be searched in the order of their defined
/// level. A higher level means a higher priority. The first occurrence of the
/// entry will be returned.
///
/// - Important: This function can only be used on snapshot configurations.
///
/// ## C Equivalent
///
/// [`git_config_get_string()`](https://libgit2.org/docs/reference/main/config/git_config_get_string.html)
public func gitConfigGetString(
    out     : inout String?,
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withOptionalMutatingString
        {
            cOut in
            
            return git_config_get_string(
                cOut,
                cfg,
                name
            )
        }
    }
}



/// Gets the value of the specified string configuration variable.
/// - Parameters:
///   - out: The `String` instance in which to store the string.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All configuration files will be searched in the order of their defined
/// level. A higher level means a higher priority. The first occurrence of the
/// entry will be returned.
///
/// ## C Equivalent
///
/// [`git_config_get_string_buf()`](https://libgit2.org/docs/reference/main/config/git_config_get_string_buf.html)
public func gitConfigGetStringBuf(
    out     : inout String?,
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_config_get_string_buf(
                cOut,
                cfg,
                name
            )
        }
    }
}



/// Gets each value of the specified multivar entry in a for-each callback.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
///   - regExp: The regular expression used to filter values.
///   - callback: The ``GitConfigForEachCB`` callback to invoke for each
///   configuration entry.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The regular expression will be applied case-sensitively on the normalized
/// form of the variable name. The section and variable parts will be
/// lower-cased, and the subsection part will be left unchanged.
///
/// ## C Equivalent
///
/// [`git_config_get_multivar_foreach()`](https://libgit2.org/docs/reference/main/config/git_config_get_multivar_foreach.html)
public func gitConfigGetMultivarForEach(
    cfg         : OpaquePointer,
    name        : String,
    regExp      : String?,
    callback    : GitConfigForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_get_multivar_foreach(
            cfg,
            name,
            regExp,
            callback,
            payload
        )
    }
}



/// Gets each value of the specified multivar entry.
/// - Parameters:
///   - out: The pointer in which to store the resulting iterator.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to get the value.
///   - regExp: The regular expression used to filter values.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The regular expression will be applied case-sensitively on the normalized
/// form of the variable name. The section and variable parts will be
/// lower-cased, and the subsection part will be left unchanged.
///
/// ## C Equivalent
///
/// [`git_config_multivar_iterator_new()`](https://libgit2.org/docs/reference/main/config/git_config_multivar_iterator_new.html)
public func gitConfigMultivarIteratorNew(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_config_iterator>?>,
    cfg     : OpaquePointer,
    name    : String,
    regExp  : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_multivar_iterator_new(
            out,
            cfg,
            name,
            regExp
        )
    }
}



/// Gets the next configuration entry from the given configuration iterator.
/// - Parameters:
///   - entry: The ``GitConfigEntry`` instance in which to store the
///   configuration entry.
///   - iter: The configuration iterator to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: The `iter` pointer will be valid until the next call to
/// ``gitConfigNext(entry:iter:)``, or until it is freed.
///
/// ## C Equivalent
///
/// [`git_config_next()`](https://libgit2.org/docs/reference/main/config/git_config_next.html)
public func gitConfigNext(
    entry   : inout GitConfigEntry,
    iter    : UnsafeMutablePointer<git_config_iterator>
) -> GitErrorCode
{
    return withCConversion
    {
        return try entry.withBorrowingCValue
        {
            cEntry in
            
            return git_config_next(
                cEntry,
                iter
            )
        }
    }
}



/// Frees the memory allocated for the given `git_config_iterator`  instance.
/// - Parameter iter: The configuration iterator to free.
///
/// ## C Equivalent
///
/// [`git_config_iterator_free()`](https://libgit2.org/docs/reference/main/config/git_config_iterator_free.html)
public func gitConfigIteratorFree(
    iter: UnsafeMutablePointer<git_config_iterator>?
)
{
    guard let iter: UnsafeMutablePointer<git_config_iterator> = iter
    else
    {
        return
    }
    
    git_config_iterator_free(iter)
}



/// Sets the value of the specified 32-bit integer configuration variable.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to set the value.
///   - value: The integer value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The value will be set in the configuration file with the highest priority
/// level, which is usually the local file.
///
/// ## C Equivalent
///
/// [`git_config_set_int32()`](https://libgit2.org/docs/reference/main/config/git_config_set_int32.html)
public func gitConfigSetInt32(
    cfg     : OpaquePointer,
    name    : String,
    value   : Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_set_int32(
            cfg,
            name,
            value
        )
    }
}



/// Sets the value of the specified 64-bit integer configuration variable.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to set the value.
///   - value: The integer value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The value will be set in the configuration file with the highest priority
/// level, which is usually the local file.
///
/// ## C Equivalent
///
/// [`git_config_set_int64()`](https://libgit2.org/docs/reference/main/config/git_config_set_int64.html)
public func gitConfigSetInt64(
    cfg     : OpaquePointer,
    name    : String,
    value   : Int64
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_set_int64(
            cfg,
            name,
            value
        )
    }
}



/// Sets the value of the specified boolean configuration variable.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to set the value.
///   - value: The boolean value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The value will be set in the configuration file with the highest priority
/// level, which is usually the local file.
///
/// ## C Equivalent
///
/// [`git_config_set_bool()`](https://libgit2.org/docs/reference/main/config/git_config_set_bool.html)
public func gitConfigSetBool(
    cfg     : OpaquePointer,
    name    : String,
    value   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_set_bool(
            cfg,
            name,
            value.int32Value
        )
    }
}



/// Sets the value of the specified string configuration variable.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to set the value.
///   - value: The string value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The value will be set in the configuration file with the highest priority
/// level, which is usually the local file.
///
/// ## C Equivalent
///
/// [`git_config_set_string()`](https://libgit2.org/docs/reference/main/config/git_config_set_string.html)
public func gitConfigSetString(
    cfg     : OpaquePointer,
    name    : String,
    value   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_set_string(
            cfg,
            name,
            value
        )
    }
}



/// Sets the value of the specified mutlivar in the local configuration file.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to set the value.
///   - regExp: The regular expression indicating which values to replace.
///   - value: The string value to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The regular expression will be applied case-sensitively on the given value.
///
/// ## C Equivalent
///
/// [`git_config_set_multivar()`](https://libgit2.org/docs/reference/main/config/git_config_set_multivar.html)
public func gitConfigSetMultivar(
    cfg     : OpaquePointer,
    name    : String,
    regExp  : String,
    value   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_set_multivar(
            cfg,
            name,
            regExp,
            value
        )
    }
}



/// Deletes the specified configuration variable.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to delete the
///   value.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The variable will be deleted from the configuration file with the highest
/// priority level, which is usually the local file.
///
/// ## C Equivalent
///
/// [`git_config_delete_entry()`](https://libgit2.org/docs/reference/main/config/git_config_delete_entry.html)
public func gitConfigDeleteEntry(
    cfg     : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_delete_entry(
            cfg,
            name
        )
    }
}



/// Deletes one of several entries from the specified multivar entry in the
/// local configuration file.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable for which to delete the
///   value.
///   - regExp: The regular expression indicating which values to delete.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The regular expression will be applied case-sensitively on the given value.
///
/// ## C Equivalent
///
/// [`git_config_delete_multivar()`](https://libgit2.org/docs/reference/main/config/git_config_delete_multivar.html)
public func gitConfigDeleteMultivar(
    cfg     : OpaquePointer,
    name    : String,
    regExp  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_delete_multivar(
            cfg,
            name,
            regExp
        )
    }
}



/// Loops over all configuration variables in the configuration backend.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - callback: The ``GitConfigForEachCB`` callback to invoke for each
///   configuration entry.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The callback will receive the normalized name and value of each variable
/// in the configuration backend, and the data pointer passed to this function.
/// If the callback returns a non-zero value, the function will stop iterating
/// and will return that value to the caller.
///
/// - Important: The pointers passed to the callback are valid only as long as
/// the iteration is ongoing.
///
/// ## C Equivalent
///
/// [`git_config_foreach()`](https://libgit2.org/docs/reference/main/config/git_config_foreach.html)
public func gitConfigForEach(
    cfg         : OpaquePointer,
    callback    : GitConfigForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_foreach(
            cfg,
            callback,
            payload
        )
    }
}



/// Creates a new configuration iterator.
/// - Parameters:
///   - out: The pointer in which to store the resulting iterator.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Use ``gitConfigNext(entry:iter:)`` to advance the iteration and
/// ``gitConfigIteratorFree(iter:)`` to free the iterator.
///
/// ## C Equivalent
///
/// [`git_config_iterator_new()`](https://libgit2.org/docs/reference/main/config/git_config_iterator_new.html)
public func gitConfigIteratorNew(
    out : UnsafeMutablePointer<UnsafeMutablePointer<git_config_iterator>?>,
    cfg : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_iterator_new(
            out,
            cfg
        )
    }
}



/// Creates a new configuration iterator matching the specified glob.
/// - Parameters:
///   - out: The pointer in which to store the resulting iterator.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - regExp: The regular expression used to match the configuration names.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Use ``gitConfigNext(entry:iter:)`` to advance the iteration and
/// ``gitConfigIteratorFree(iter:)`` to free the iterator.
///
/// The regular expression will be applied case-sensitively on the normalized
/// form of the variable name. The section and variable parts will be
/// lower-cased, and the subsection part will be left unchanged.
///
/// ## C Equivalent
///
/// [`git_config_iterator_glob_new()`](https://libgit2.org/docs/reference/main/config/git_config_iterator_glob_new.html)
public func gitConfigIteratorGlobNew(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_config_iterator>?>,
    cfg     : OpaquePointer,
    regExp  : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_iterator_glob_new(
            out,
            cfg,
            regExp
        )
    }
}



/// Performs an operation on all configuration variables matching the given
/// pattern.
/// - Parameters:
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - regExp: The regular expression used to match the configuration names.
///   - callback: The ``GitConfigForEachCB`` callback to invoke for each
///   configuration entry.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function behaves like ``gitConfigForEach(cfg:callback:payload:)``,
/// with an additional regular expression that filters which configuration
/// keys are passed to `callback`.
///
/// The regular expression will be applied case-sensitively on the normalized
/// form of the variable name. The section and variable parts will be
/// lower-cased, and the subsection part will be left unchanged.
///
/// ## C Equivalent
///
/// [`git_config_foreach_match()`](https://libgit2.org/docs/reference/main/config/git_config_foreach_match.html)
public func gitConfigForEachMatch(
    cfg         : OpaquePointer,
    regExp      : String?,
    callback    : GitConfigForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_foreach_match(
            cfg,
            regExp,
            callback,
            payload
        )
    }
}



/// Queries the value of the specified configuration variable and maps it to
/// an integer constant.
/// - Parameters:
///   - out: The pointer in which to store the resulting map.
///   - cfg: The configuration to search. The underlying type must be
///   `git_config`.
///   - name: The name of the configuration variable to query.
///   - maps: The configuration maps specifying the possible mappings.
///   - mapN: The length of `maps`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Below is an example of a mapping array in C:
///
/// ```c
/// git_configmap autocrlf_mapping[] =
/// {
///     { GIT_CVAR_FALSE, NULL, GIT_AUTO_CRLF_FALSE },
///     { GIT_CVAR_TRUE, NULL, GIT_AUTO_CRLF_TRUE },
///     { GIT_CVAR_STRING, "input", GIT_AUTO_CRLF_INPUT },
///     { GIT_CVAR_STRING, "default", GIT_AUTO_CRLF_DEFAULT }
/// };
/// ```
///
/// On any "false" value for the variable, the mapping will store
/// `GIT_AUTO_CRLF_FALSE` in the `out` parameter.
///
/// On any "true" value for the variable, the mapping will store
/// `GIT_AUTO_CRLF_TRUE` in the `out` parameter.
///
/// Otherwise, if the value matches the strings `input` or `default`
/// (with case-insensitive comparison), the given constant will be stored in
/// the `out` parameter.
///
/// An error code will be returned if no matches are found.
///
/// ## C Equivalent
///
/// [`git_config_get_mapped()`](https://libgit2.org/docs/reference/main/config/git_config_get_mapped.html)
public func gitConfigGetMapped(
    out     : UnsafeMutablePointer<Int32>,
    cfg     : OpaquePointer,
    name    : String,
    maps    : [GitConfigMap],
    mapN    : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try maps.withArrayOfGitConfigMaps
        {
            cMaps, cMapsCount in
            
            return git_config_get_mapped(
                out,
                cfg,
                name,
                cMaps,
                cMapsCount
            )
        }
    }
}



/// Maps the given string value to an integer constant.
/// - Parameters:
///   - out: The pointer in which to store the resulting map.
///   - maps: The configuration maps specifying the possible mappings.
///   - mapN: The length of `maps`.
///   - value: The value to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_config_lookup_map_value()`](https://libgit2.org/docs/reference/main/config/git_config_lookup_map_value.html)
public func gitConfigLookupMapValue(
    out     : UnsafeMutablePointer<Int32>,
    maps    : [GitConfigMap],
    mapN    : Int,
    value   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try maps.withArrayOfGitConfigMaps
        {
            cMaps, cMapsCount in
            
            return git_config_lookup_map_value(
                out,
                cMaps,
                cMapsCount,
                value
            )
        }
    }
}



/// Parses the given string value as a boolean.
/// - Parameters:
///   - out: The `Bool` instance in which to store the given string value as
///   a boolean.
///   - value: The value to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Boolean true values include `true`, `TRUE`, `yes`, `on`, `1`, and other
/// similar values.
///
/// Boolean false values include `false`, `FALSE`, `no`, `off`, `0`, and other
/// similar values.
///
/// ## C Equivalent
///
/// [`git_config_parse_bool()`](https://libgit2.org/docs/reference/main/config/git_config_parse_bool.html)
public func gitConfigParseBool(
    out     : inout Bool,
    value   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return out.withMutatingBool
        {
            cOut in
            
            return git_config_parse_bool(
                cOut,
                value
            )
        }
    }
}



/// Parses the given string value as a signed 32-bit integer.
/// - Parameters:
///   - out: The pointer in which to store the resulting integer.
///   - value: The value to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// An optional suffix may be added to `value` to multiply it prior to output:
///
/// | Suffix | Multiplier |
/// |--- |---|
/// | k | 1,024 |
/// | m | 1,048,576 |
/// | g | 1,073,741,824 |
///
/// ## C Equivalent
///
/// [`git_config_parse_int32()`](https://libgit2.org/docs/reference/main/config/git_config_parse_int32.html)
public func gitConfigParseInt32(
    out     : UnsafeMutablePointer<Int32>,
    value   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_parse_int32(
            out,
            value
        )
    }
}



/// Parses the given string value as a signed 64-bit integer.
/// - Parameters:
///   - out: The pointer in which to store the resulting integer.
///   - value: The value to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// An optional suffix may be added to `value` to multiply it prior to output:
///
/// | Suffix | Multiplier |
/// |--- |---|
/// | k | 1,024 |
/// | m | 1,048,576 |
/// | g | 1,073,741,824 |
///
/// ## C Equivalent
///
/// [`git_config_parse_int64()`](https://libgit2.org/docs/reference/main/config/git_config_parse_int64.html)
public func gitConfigParseInt64(
    out     : UnsafeMutablePointer<Int64>,
    value   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_parse_int64(
            out,
            value
        )
    }
}



/// Parses the given string value as a path.
/// - Parameters:
///   - out: The `String` instance in which to store the path.
///   - value: The value to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// A leading tilde (`~`) will be expanded to the global search path. The
/// global search path defaults to the user's home directory, but can be
/// overridden using ``gitLibgit2OptSetHomeDir(path:)``.
///
/// If `value` does not begin with a tilde, the input will be returned.
///
/// ## C Equivalent
///
/// [`git_config_parse_path()`](https://libgit2.org/docs/reference/main/config/git_config_parse_path.html)
public func gitConfigParsePath(
    out     : inout String?,
    value   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_config_parse_path(
                cOut,
                value
            )
        }
    }
}



/// Performs an operation on all configuration variables matching the given
/// pattern.
/// - Parameters:
///   - backend: The configuration backend to search.
///   - regExp: The regular expression used to match the configuration names.
///   - callback: The ``GitConfigForEachCB`` callback to invoke for each
///   configuration entry.
///   - payload: The payload to pass to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function behaves like
/// ``gitConfigForEachMatch(cfg:regExp:callback:payload:)``, except that only
/// configuration entries from the given `backend` entry will be enumerated.
///
/// The regular expression will be applied case-sensitively on the normalized
/// form of the variable name. The section and variable parts will be
/// lower-cased, and the subsection part will be left unchanged.
///
/// ## C Equivalent
///
/// [`git_config_backend_foreach_match()`](https://libgit2.org/docs/reference/main/config/git_config_backend_foreach_match.html)
public func gitConfigBackendForEachMatch(
    backend     : UnsafeMutablePointer<git_config_backend>,
    regExp      : String?,
    callback    : GitConfigForEachCB,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_backend_foreach_match(
            backend,
            regExp,
            callback,
            payload
        )
    }
}



/// Locks the configuration backend with the highest priority.
/// - Parameters:
///   - tx: The pointer in which to store the transaction. The underlying
///   value must be `git_transaction`.
///   - cfg: The configuration to lock. The underlying value must be
///   `git_config`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Locking the configuration backend disallows write operations. Any updates
/// made after locking will not be visible to a reader, unless the file is
/// unlocked.
///
/// The resulting transaction may be used to commit or undo changes. Changes
/// may be applied by calling ``gitTransactionCommit(tx:)`` before freeing the
/// transaction. Either of these actions will unlock the configuration backend.
///
/// ## C Equivalent
///
/// [`git_config_lock()`](https://libgit2.org/docs/reference/main/config/git_config_lock.html)
public func gitConfigLock(
    tx  : UnsafeMutablePointer<OpaquePointer?>,
    cfg : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_lock(
            tx,
            cfg
        )
    }
}
