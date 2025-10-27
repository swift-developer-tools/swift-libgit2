//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Gets the object specified by the given revision string.
/// - Parameters:
///   - out: The pointer in which to store the object. The underlying type
///   must be `git_object`.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
///   - spec: The revision string to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revparse_single()`](https://libgit2.org/docs/reference/main/revparse/git_revparse_single.html)
public func gitRevparseSingle(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    repo    : OpaquePointer,
    spec    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revparse_single(
            out,
            repo,
            spec
        )
    }
}



/// Gets the object and intermediate reference specified by the given revision
/// string.
/// - Parameters:
///   - objectOut: The pointer in which to store the object. The underlying
///   type must be `git_object`.
///   - referenceOut: The pointer in which to store the reference. The
///   underlying type must be `git_reference`.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
///   - spec: The revision string to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revparse_ext()`](https://libgit2.org/docs/reference/main/revparse/git_revparse_ext.html)
public func gitRevparseExt(
    objectOut       : UnsafeMutablePointer<OpaquePointer?>,
    referenceOut    : UnsafeMutablePointer<OpaquePointer?>,
    repo            : OpaquePointer,
    spec            : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_revparse_ext(
            objectOut,
            referenceOut,
            repo,
            spec
        )
    }
}



/// Parses the given revision string.
/// - Parameters:
///   - revspec: The ``GitRevspec`` instance in which to store the revspec
///   elements.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
///   - spec: The revision string to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_revparse()`](https://libgit2.org/docs/reference/main/revparse/git_revparse.html)
public func gitRevparse(
    revspec : inout GitRevspec,
    repo    : OpaquePointer,
    spec    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try revspec.withMutatingCValue
        {
            cRevspec in
            
            return git_revparse(
                cRevspec,
                repo,
                spec
            )
        }
    }
}
