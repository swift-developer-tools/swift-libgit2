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



/// Parses the given ID hex string into the given ``GitOID`` instance.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID.
///   - str: The ID hex string to parse. This must have at least 40 bytes for
///   SHA-1 or 256 bytes for SHA-256.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_oid_fromstr()`](https://libgit2.org/docs/reference/main/oid/git_oid_fromstr.html)
public func gitOIDFromStr(
    out : inout GitOID,
    str : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_oid_fromstr(
                cOut,
                str
            )
        }
    }
}



/// Parses the given ID hex string into the given ``GitOID`` instance.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID.
///   - str: The ID hex string to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_oid_fromstrp()`](https://libgit2.org/docs/reference/main/oid/git_oid_fromstrp.html)
public func gitOIDFromStrP(
    out : inout GitOID,
    str : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_oid_fromstrp(
                cOut,
                str
            )
        }
    }
}



/// Parses the specified number of characters of the given ID hex string into
/// the given ``GitOID`` instance.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID.
///   - str: The ID hex string to parse. This must have at least
///   the number of characters specified by `length`.
///   - length: The number of characters of `str` to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function supports parsing partial IDs. If `length` is odd, the final
/// byte of the ID will have its high nibble set from the last character and
/// its low nibble set to zero.
///
/// ## C Equivalent
///
/// [`git_oid_fromstrn()`](https://libgit2.org/docs/reference/main/oid/git_oid_fromstrn.html)
public func gitOIDFromStrN(
    out     : inout GitOID,
    str     : String,
    length  : Int
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_oid_fromstrn(
                cOut,
                str,
                length
            )
        }
    }
}



/// Copies the given raw ID into the given ``GitOID`` instance.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the ID.
///   - raw: The raw input bytes to copy.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_oid_fromraw()`](https://libgit2.org/docs/reference/main/oid/git_oid_fromraw.html)
public func gitOIDFromRaw(
    out : inout GitOID,
    raw : Data
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return try raw.withCString
            {
                cRaw, _ in
                
                return git_oid_fromraw(
                    cOut,
                    cRaw
                )
            }
        }
    }
}



/// Formats the given ID into a hex string.
/// - Parameters:
///   - out: The pointer in which to store the hex string. This must point to
///   the start of the hex sequence, and must have at least 40 bytes for SHA-1
///   or 256 bytes for SHA-256.
///   - id: The ID to format.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: Only the ID digits will be written to the given pointer. The
/// caller must add a terminator if necessary.
///
/// ## C Equivalent
///
/// [`git_oid_fmt()`](https://libgit2.org/docs/reference/main/oid/git_oid_fmt.html)
public func gitOIDFmt(
    out : UnsafeMutablePointer<CChar>,
    id  : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_oid_fmt(
                out,
                cID
            )
        }
    }
}



/// Formats the given ID into a partial hex string.
/// - Parameters:
///   - out: The pointer in which to store the partial hex string.
///   - n: The number of characters to write.
///   - id: The ID to format.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// - Important: If `n` is less than ``gitOIDSHA1HexSize``, the extra bytes
/// will be zeroed. Otherwise, a null terminator will not be added.
///
/// ## C Equivalent
///
/// [`git_oid_nfmt()`](https://libgit2.org/docs/reference/main/oid/git_oid_nfmt.html)
public func gitOIDNFmt(
    out : UnsafeMutablePointer<CChar>,
    n   : Int,
    id  : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_oid_nfmt(
                out,
                n,
                cID
            )
        }
    }
}



/// Formats the given ID into a loose-object path string.
/// - Parameters:
///   - out: The pointer in which to store the loose-object path string. This
///   must point to the start of the hex sequence, and must have at least 40
///   bytes for SHA-1 or 256 bytes for SHA-256.
///   - id: The ID to format.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The resulting string will be `aa/...`, where `aa` represents the first two
/// hex digits of the ID, and the ellipsis (`...`) represents the remaining
/// 38 digits.
///
/// - Important: Only the ID digits will be written to the given pointer. The
/// caller must add a terminator if necessary.
///
/// ## C Equivalent
///
/// [`git_oid_pathfmt()`](https://libgit2.org/docs/reference/main/oid/git_oid_pathfmt.html)
public func gitOIDPathFmt(
    out : UnsafeMutablePointer<CChar>,
    id  : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return id.withCValue
        {
            cID in
            
            return git_oid_pathfmt(
                out,
                cID
            )
        }
    }
}



/// Formats the given ID into a string.
/// - Parameter oid: The ID to format.
/// - Returns: The formatted string representation of the given ID.
///
/// ## C Equivalent
///
/// [`git_oid_tostr_s()`](https://libgit2.org/docs/reference/main/oid/git_oid_tostr_s.html)
public func gitOIDToStrS(
    oid: GitOID
) -> String?
{
    let oidString: UnsafeMutablePointer<CChar>? = oid.withCValue
    {
        cOID in
        
        return git_oid_tostr_s(cOID)
    }
    
    return String(optionalCString: oidString)
}



/// Formats the given ID into a hex string.
/// - Parameters:
///   - out: The pointer in which to store the hex string.
///   - n: The number of characters to write.
///   - id: The ID to format.
/// - Returns: The formatted string representation of the given ID.
///
/// ## Discussion
///
/// If the given buffer is smaller than the size of an ID hex string plus
/// an additional byte, then the resulting ID hex string will be truncated
/// to `n - 1` characters, but will still be null terminated.
///
/// ## C Equivalent
///
/// [`git_oid_tostr()`](https://libgit2.org/docs/reference/main/oid/git_oid_tostr.html)
public func gitOIDToStr(
    out : UnsafeMutablePointer<CChar>,
    n   : Int,
    id  : GitOID
) -> String?
{
    let oidString: UnsafeMutablePointer<CChar>? = id.withCValue
    {
        cID in
        
        return git_oid_tostr(
            out,
            n,
            cID
        )
    }
    
    return String(optionalCString: oidString)
}



/// Copies the given ID.
/// - Parameters:
///   - out: The ``GitOID`` instance in which to store the copied ID.
///   - src: The ID to copy.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_oid_cpy()`](https://libgit2.org/docs/reference/main/oid/git_oid_cpy.html)
public func gitOIDCpy(
    out : inout GitOID,
    src : GitOID
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return src.withCValue
            {
                cSrc in
                
                return git_oid_cpy(
                    cOut,
                    cSrc
                )
            }
        }
    }
}



/// Compares the given IDs.
/// - Parameters:
///   - a: The first ID to compare.
///   - b: The second ID to compare.
/// - Returns: `-1` if `a` is less than `b`, `1` if `a` is greater than `b`,
/// or `0` if `a` and `b` are equal.
///
/// ## C Equivalent
///
/// [`git_oid_cmp()`](https://libgit2.org/docs/reference/main/oid/git_oid_cmp.html)
public func gitOIDCmp(
    a   : GitOID,
    b   : GitOID
) -> Int
{
    let oidCmpResult: Int32 = a.withCValue
    {
        cA in
        
        return b.withCValue
        {
            cB in
            
            return git_oid_cmp(
                cA,
                cB
            )
        }
    }
    
    let sign: Int32 = oidCmpResult.signum()
    
    return Int(sign)
}




/// Checks whether the given IDs are equal.
/// - Parameters:
///   - a: The first ID to compare.
///   - b: The second ID to compare.
/// - Returns: Whether the given IDs are equal.
///
/// ## C Equivalent
///
/// [`git_oid_equal()`](https://libgit2.org/docs/reference/main/oid/git_oid_equal.html)
public func gitOIDEqual(
    a   : GitOID,
    b   : GitOID
) -> Bool
{
    let isEqual: Int32 = a.withCValue
    {
        cA in
        
        return b.withCValue
        {
            cB in
            
            return git_oid_equal(
                cA,
                cB
            )
        }
    }
    
    return Bool(isEqual)
}



/// Checks whether the specified number of hex characters from the start of
/// the given IDs are equal.
/// - Parameters:
///   - a: The first ID to compare.
///   - b: The second ID to compare.
///   - len: The number of hex characters from the start of the IDs to compare.
/// - Returns: Whether the specified number of hex characters from the start of
/// the given IDs are equal.
///
/// ## C Equivalent
///
/// [`git_oid_ncmp()`](https://libgit2.org/docs/reference/main/oid/git_oid_ncmp.html)
public func gitOIDNCmp(
    a   : GitOID,
    b   : GitOID,
    len : Int
) -> Bool
{
    let isEqual: Int32 = a.withCValue
    {
        cA in
        
        return b.withCValue
        {
            cB in
            
            return git_oid_ncmp(
                cA,
                cB,
                len
            )
        }
    }
    
    /// The `Bool` initializer treats `0` as `false`. This function
    /// uses `memcmp()`, which returns `0` when memory blocks match.
    return !Bool(isEqual)
}



/// Checks whether the given ID and ID hex string are equal.
/// - Parameters:
///   - id: The ID to compare.
///   - str: The ID hex string to compare.
/// - Returns: Whether the given ID and ID hex string are equal.
///
/// ## C Equivalent
///
/// [`git_oid_streq()`](https://libgit2.org/docs/reference/main/oid/git_oid_streq.html)
public func gitOIDStrEq(
    id  : GitOID,
    str : String
) -> Bool
{
    let isEqual: Int32 = id.withCValue
    {
        cID in
        
        return git_oid_streq(
            cID,
            str
        )
    }
    
    /// The `Bool` initializer treats `0` as `false`. This function
    /// uses `memcmp()`, which returns `0` when memory blocks match.
    return !Bool(isEqual)
}



/// Compares the given ID and ID hex string.
/// - Parameters:
///   - id: The ID to compare.
///   - str: The ID hex string to compare.
/// - Returns: `-1` if `str` is not valid, `1` if `id` sorts after `str`, or
/// `0` if `id` sorts before `str`.
///
/// ## C Equivalent
///
/// [`git_oid_strcmp()`](https://libgit2.org/docs/reference/main/oid/git_oid_strcmp.html)
public func gitOIDStrCmp(
    id  : GitOID,
    str : String
) -> Int
{
    let oidStrCmpResult: Int32 = id.withCValue
    {
        cID in
        
        return git_oid_strcmp(
            cID,
            str
        )
    }
    
    let sign: Int32 = oidStrCmpResult.signum()
    
    return Int(sign)
}



/// Checks whether the given ID is all zeros.
/// - Parameter id: The ID to check.
/// - Returns: Whether the given ID is all zeros.
///
/// ## C Equivalent
///
/// [`git_oid_is_zero()`](https://libgit2.org/docs/reference/main/oid/git_oid_is_zero.html)
public func gitOIDIsZero(
    id: GitOID
) -> Bool
{
    let isZero: Int32 = id.withCValue
    {
        cID in
        
        return git_oid_is_zero(cID)
    }
    
    return Bool(isZero)
}



/// Creates a new ID shortener.
/// - Parameter minLength: The minimum length to use for all IDs.
/// - Returns: The new ID shortener. The underlying type will be
/// `git_oid_shorten`.
///
/// ## Discussion
///
/// The given minimum length will be used even if shorter IDs would still
/// be unique.
///
/// ## C Equivalent
///
/// [`git_oid_shorten_new()`](https://libgit2.org/docs/reference/main/oid/git_oid_shorten_new.html)
public func gitOIDShortenNew(
    minLength: Int
) -> OpaquePointer
{
    return git_oid_shorten_new(minLength)
}



/// Adds the given ID to the given set of shortened IDs, and calculates the
/// minimum length necessary to uniquely identify all the IDs in the set.
/// - Parameters:
///   - os: The set of shortened IDs to use. The underlying type must be
///   `git_oid_shorten`.
///   - textID: The ID string to use. This must be a hex string with at least
///   40 bytes.
/// - Returns: The minimum length necessary to uniquely identify all the IDs
/// in the set, or an error code.
///
/// ## Discussion
///
/// - Note: For performance reasons, no more than about 32,000 IDs may be
/// added to a single set.
///
/// ## C Equivalent
///
/// [`git_oid_shorten_add()`](https://libgit2.org/docs/reference/main/oid/git_oid_shorten_add.html)
public func gitOIDShortenAdd(
    os      : OpaquePointer,
    textID  : String
) -> Int32
{
    return git_oid_shorten_add(
        os,
        textID
    )
}



/// Frees the memory allocated for the given `git_oid_shorten` instance.
/// - Parameter os: The ID shortener to free. The underlying type must be
/// `git_oid_shorten`.
///
/// ## C Equivalent
///
/// [`git_oid_shorten_free()`](https://libgit2.org/docs/reference/main/oid/git_oid_shorten_free.html)
public func gitOIDShortenFree(
    os: OpaquePointer?
)
{
    guard let os: OpaquePointer = os
    else
    {
        return
    }
    
    git_oid_shorten_free(os)
}
