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



/// Creates a similarity signature for the given input.
/// - Parameters:
///   - out: The pointer in which to store the similarity signature. The
///   underlying type must be `git_hashsig`.
///   - buf: The input for which to create a similarity signature.
///   - bufLen: The length of `buf`.
///   - opts: The flags controlling similarity signature computation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_hashsig_create()`](https://libgit2.org/docs/reference/main/sys/hashsig/git_hashsig_create.html)
public func gitHashSigCreate(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    buf     : Data,
    bufLen  : Int,
    opts    : GitHashSigOptionT
) -> GitErrorCode
{
    return withCConversion
    {
        return try buf.withCString
        {
            cBuf, cBufCount in
            
            return git_hashsig_create(
                out,
                cBuf,
                cBufCount,
                opts.cValue()
            )
        }
    }
}



/// Creates a similarity signature for the specified file.
/// - Parameters:
///   - out: The pointer in which to store the similarity signature. The
///   underlying type must be `git_hashsig`.
///   - path: The path to the file for which to create a similarity signature.
///   - opts: The flags controlling similarity signature computation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function will walk through the specified file and load a maximum of
/// 4K of file data at a time. Otherwise, it behaves the same as
/// ``gitHashSigCreate(out:buf:bufLen:opts:)``.
///
/// ## C Equivalent
///
/// [`git_hashsig_create_fromfile()`](https://libgit2.org/docs/reference/main/sys/hashsig/git_hashsig_create_fromfile.html)
public func gitHashSigCreateFromFile(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    path    : String,
    opts    : GitHashSigOptionT
) -> GitErrorCode
{
    return withCConversion
    {
        return git_hashsig_create_fromfile(
            out,
            path,
            opts.cValue()
        )
    }
}



/// Frees the memory allocated for the given `git_hashsig` instance.
/// - Parameter sig: The similarity signature to free. The underlying type
/// must be `git_hashsig`.
///
/// ## C Equivalent
///
/// [`git_hashsig_free()`](https://libgit2.org/docs/reference/main/sys/hashsig/git_hashsig_free.html)
public func gitHashSigFree(
    sig: OpaquePointer?
)
{
    guard let sig: OpaquePointer = sig
    else
    {
        return
    }
    
    git_hashsig_free(sig)
}



/// Calculates the similarity score of the given similarity signatures.
/// - Parameters:
///   - a: The first similarity signature to compare. The underlying type must
///   be `git_hashsig`.
///   - b: The second similarity signature to compare. The underlying type must
///   be `git_hashsig`.
/// - Returns: A number in the range `[0, 100]` as the similarity score, or an
/// error code.
///
/// ## C Equivalent
///
/// [`git_hashsig_compare()`](https://libgit2.org/docs/reference/main/sys/hashsig/git_hashsig_compare.html)
public func gitHashSigCompare(
    a   : OpaquePointer,
    b   : OpaquePointer
) -> Int32
{
    return git_hashsig_compare(
        a,
        b
    )
}
