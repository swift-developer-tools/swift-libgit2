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



/// Initializes the given `git_config_backend` instance.
/// - Parameters:
///   - backend: The `git_config_backend` instance to initialize.
///   - version: The version to use. Pass ``gitConfigBackendVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_config_init_backend()`](https://libgit2.org/docs/reference/main/sys/config/git_config_init_backend.html)
public func gitConfigInitBackend(
    backend : UnsafeMutablePointer<git_config_backend>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_init_backend(
            backend,
            version
        )
    }
}



/// Adds a generic configuration file to the given configuration.
///
/// Further queries on the configuration will access each of the configuration
/// files in order (files with a higher priority level will be accessed first).
///
/// - Important: The configuration will free the file automatically.
///
/// - Parameters:
///   - cfg: The configuration to update. The underlying type must be
///   `git_config`.
///   - file: The configuration file to add.
///   - level: The priority level of the configuration file.
///   - repo: The repository to use to parse conditional includes. The
///   underlying type must be `git_repository`.
///   - force: Whether to overwrite an existing configuration file.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_config_add_backend()`](https://libgit2.org/docs/reference/main/sys/config/git_config_add_backend.html)
public func gitConfigAddBackend(
    cfg     : OpaquePointer,
    file    : UnsafeMutablePointer<git_config_backend>,
    level   : GitConfigLevelT,
    repo    : OpaquePointer?,
    force   : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_config_add_backend(
            cfg,
            file,
            level.cValue(),
            repo,
            force.int32Value
        )
    }
}



/// Creates an in-memory configuration backend from the given configuration.
/// - Parameters:
///   - out: The pointer in which to store the configuration backend.
///   - cfg: The configuration to parse. This must use the standard Git
///   configuration file format.
///   - len: The length of `cfg`.
///   - opts: The in-memory configuration backend options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_config_backend_from_string()`](https://libgit2.org/docs/reference/main/sys/config/git_config_backend_from_string.html)
public func gitConfigBackendFromString(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_config_backend>?>,
    cfg     : String,
    len     : Int,
    opts    : GitConfigBackendMemoryOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try cfg.withCString
        {
            cCfg in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_config_backend_from_string(
                    out,
                    cCfg,
                    cfg.count,
                    cOpts
                )
            }
        }
    }
}



/// Creates an in-memory configuration backend from the given configuration.
/// - Parameters:
///   - out: The pointer in which to store the configuration backend.
///   - values: The configuration to parse. Each element of the array must be
///   a key/value pair in `key = value` format.
///   - len: The length of `values`.
///   - opts: The in-memory configuration backend options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_config_backend_from_values()`](https://libgit2.org/docs/reference/main/sys/config/git_config_backend_from_values.html)
public func gitConfigBackendFromValues(
    out     : UnsafeMutablePointer<UnsafeMutablePointer<git_config_backend>?>,
    values  : [String],
    len     : Int,
    opts    : GitConfigBackendMemoryOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try values.withArrayOfImmutableCStrings
        {
            cValues in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_config_backend_from_values(
                    out,
                    cValues,
                    values.count,
                    cOpts
                )
            }
        }
    }
}
