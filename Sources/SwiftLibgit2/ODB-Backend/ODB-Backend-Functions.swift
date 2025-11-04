//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a backend from the specified directory containing packfiles.
/// - Parameters:
///   - out: The pointer in which to store the backend object.
///   - objectsDir: The path to the Objects directory of the repository.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_odb_backend_pack()`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_backend_pack.html)
public func gitODBBackendPack(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_odb_backend>?>,
    objectsDir  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_backend_pack(
            out,
            objectsDir
        )
    }
}



/// Creates a backend from the specified packfile.
///
/// Creating a backend from a packfile can be useful for inspecting the
/// contents of that packfile.
///
/// - Parameters:
///   - out: The pointer in which to store the backend object.
///   - indexFile: The path to the packfile's `.idx` file.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_odb_backend_one_pack()`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_backend_one_pack.html)
public func gitODBBackendOnePack(
    out         : UnsafeMutablePointer<UnsafeMutablePointer<git_odb_backend>?>,
    indexFile   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_backend_one_pack(
            out,
            indexFile
        )
    }
}



/// Creates a backend for loose objects.
/// - Parameters:
///   - out: The pointer in which to store the backend object.
///   - objectsDir: The path to the Objects directory of the repository.
///   - compressionLevel: The ZLib compression level (0-9). Pass `-1` to use
///   the default compression level.
///   - doFSync: Whether to perform an `fsync` on write.
///   - dirMode: The permission to use when creating directories. Pass `0` to
///   use the default permission.
///   - fileMode: The permission to use when creating files. Pass `0` to use
///   the default permission.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_odb_backend_loose()`](https://libgit2.org/docs/reference/main/odb_backend/git_odb_backend_loose.html)
public func gitODBBackendLoose(
    out                 : UnsafeMutablePointer<UnsafeMutablePointer<git_odb_backend>?>,
    objectsDir          : String,
    compressionLevel    : Int32,
    doFSync             : Bool,
    dirMode             : UInt32,
    fileMode            : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_odb_backend_loose(
            out,
            objectsDir,
            compressionLevel,
            doFSync.int32Value,
            dirMode,
            fileMode
        )
    }
}
