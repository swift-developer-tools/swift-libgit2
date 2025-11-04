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



/// Creates a new mailmap.
///
/// - Note: The created mailmap will be empty. Add a mailmap file before
/// using it.
///
/// - Parameter out: The pointer in which to store the mailmap. The underlying
/// type must be `git_mailmap`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_mailmap_new()`](https://libgit2.org/docs/reference/main/mailmap/git_mailmap_new.html)
public func gitMailmapNew(
    out: UnsafeMutablePointer<OpaquePointer?>
) -> GitErrorCode
{
    return withCConversion
    {
        return git_mailmap_new(out)
    }
}



/// Frees the memory allocated for the given `git_mailmap` instance.
/// - Parameter mm: The mailmap to free. The underlying type must be
/// `git_mailmap`.
///
/// ## C Equivalent
///
/// [`git_mailmap_free()`](https://libgit2.org/docs/reference/main/mailmap/git_mailmap_free.html)
public func gitMailmapFree(
    mm: OpaquePointer?
)
{
    guard let mm
    else
    {
        return
    }
    
    git_mailmap_free(mm)
}



/// Adds an entry to the given mailmap, or replaces an existing entry.
/// - Parameters:
///   - mm: The mailmap to update. The underlying type must be `git_mailmap`.
///   - realName: The real name to use.
///   - realEmail: The real email to use.
///   - replaceName: The name to replace.
///   - replaceEmail: The email to replace.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_mailmap_add_entry()`](https://libgit2.org/docs/reference/main/mailmap/git_mailmap_add_entry.html)
public func gitMailmapAddEntry(
    mm              : OpaquePointer,
    realName        : String?,
    realEmail       : String?,
    replaceName     : String?,
    replaceEmail    : String?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_mailmap_add_entry(
            mm,
            realName,
            realEmail,
            replaceName,
            replaceEmail
        )
    }
}



/// Creates a new mailmap containing a single mailmap file.
/// - Parameters:
///   - out: The pointer in which to store the mailmap. The underlying type
///   must be `git_mailmap`.
///   - buf: The data from which to parse the mailmap.
///   - len: The length of `buf`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_mailmap_from_buffer()`](https://libgit2.org/docs/reference/main/mailmap/git_mailmap_from_buffer.html)
public func gitMailmapFromBuffer(
    out : UnsafeMutablePointer<OpaquePointer?>,
    buf : Data,
    len : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try buf.withCString
        {
            cBuf, cBufCount in
            
            return git_mailmap_from_buffer(
                out,
                cBuf,
                cBufCount
            )
        }
    }
}



/// Creates a new mailmap from the given repository, loading mailmap files
/// based on the repository's configuration.
///
/// Mailmaps will be loaded in the following order:
///
/// 1. From `.mailmap` in the root of the given repository's working directory,
/// if present.
/// 2. From the blob specified by the `mailmap.blob` configuration entry,
/// if set. This entry defaults to `HEAD:.mailmap` in bare repositories.
/// 3. The path in the `mailmap.file` configuration entry, if set.
///
/// - Parameters:
///   - out: The pointer in which to store the mailmap. The underlying type
///   must be `git_mailmap`.
///   - repo: The repository from which to load mailmap information.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_mailmap_from_repository()`](https://libgit2.org/docs/reference/main/mailmap/git_mailmap_from_repository.html)
public func gitMailmapFromRepository(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_mailmap_from_repository(
            out,
            repo
        )
    }
}



/// Resolves the given name and email to the given real name and real email.
/// - Parameters:
///   - realName: The `String` instance in which to store the real name.
///   - realEmail: The `String` instance in which to store the real email.
///   - mm: The mailmap with which to perform a lookup.
///   - name: The name to resolve.
///   - email: The email to resolve.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_mailmap_resolve()`](https://libgit2.org/docs/reference/main/mailmap/git_mailmap_resolve.html)
public func gitMailmapResolve(
    realName    : inout String?,
    realEmail   : inout String?,
    mm          : OpaquePointer?,
    name        : String,
    email       : String
) -> GitErrorCode
{
    return withCConversion
    {
        return realName.withOptionalMutatingCString
        {
            cRealName in
            
            return realEmail.withOptionalMutatingCString
            {
                cRealEmail in
                
                return git_mailmap_resolve(
                    cRealName,
                    cRealEmail,
                    mm,
                    name,
                    email
                )
            }
        }
    }
}



/// Resolves the given signature to the real name and real email.
/// - Parameters:
///   - out: The ``GitSignature`` instance in which to store the resolved
///   signature.
///   - mm: The mailmap with which to resolve the signature. The underlying
///   type must be `git_mailmap`.
///   - sig: The signature to resolve.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_mailmap_resolve_signature()`](https://libgit2.org/docs/reference/main/mailmap/git_mailmap_resolve_signature.html)
public func gitMailmapResolveSignature(
    out : inout GitSignature,
    mm  : OpaquePointer,
    sig : GitSignature
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try sig.withCValue
            {
                cSig in
                
                return git_mailmap_resolve_signature(
                    cOut,
                    mm,
                    cSig
                )
            }
        }
    }
}
