//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Gets the value type for the given attribute.
/// - Parameter attr: The attribute.
/// - Returns: The value type for the attribute.
///
/// ## Discussion
///
/// If the attribute has a ``GitAttrValueT/gitAttrValueString`` type, it can
/// be accessed normally as a null-terminated C string.
///
/// ## C Equivalent
///
/// [`git_attr_value()`](https://libgit2.org/docs/reference/main/attr/git_attr_value.html)
public func gitAttrValue(
    attr: UnsafePointer<CChar>?
) -> GitAttrValueT?
{
    let attributeValue: git_attr_value_t = git_attr_value(attr)
    
    return GitAttrValueT(cValue: attributeValue)
}



/// Looks up the value of one attribute for the given path.
/// - Parameters:
///   - valueOut: The pointer in which to store the value of the attribute.
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - flags: The flags to use when querying the attributes.
///   - path: The path within the repository to check for attributes.
///   - name: The name of the attribute to look up.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Use attribute macros to test whether the attribute value is set, unset,
/// or unspecified, or use the string value for attributes set to a value.
///
/// Relative paths will be interpreted relative to the repository root. The
/// specified file does not have to exist, but if it does not, then it will be
/// treated as a plain file (not as a directory).
///
/// - Important: Do not modify or free the returned attribute value.
///
/// ## C Equivalent
///
/// [`git_attr_get()`](https://libgit2.org/docs/reference/main/attr/git_attr_get.html)
public func gitAttrGet(
    valueOut    : UnsafeMutablePointer<UnsafePointer<CChar>?>,
    repo        : OpaquePointer,
    flags       : GitAttrCheckFlagsT,
    path        : String,
    name        : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_attr_get(
            valueOut,
            repo,
            flags.rawValue,
            path,
            name
        )
    }
}



/// Looks up the value of one attribute for the given path, with extended
/// options.
/// - Parameters:
///   - valueOut: The pointer in which to store the value of the attribute.
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - opts: The options to use when querying the attributes.
///   - path: The path within the repository to check for attributes.
///   - name: The name of the attribute to look up.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Use attribute macros to test whether the attribute value is set, unset,
/// or unspecified, or use the string value for attributes set to a value.
///
/// Relative paths will be interpreted relative to the repository root. The
/// specified file does not have to exist, but if it does not, then it will be
/// treated as a plain file (not as a directory).
///
/// - Important: Do not modify or free the returned attribute value.
///
/// ## C Equivalent
///
/// [`git_attr_get_ext()`](https://libgit2.org/docs/reference/main/attr/git_attr_get_ext.html)
public func gitAttrGetExt(
    valueOut    : UnsafeMutablePointer<UnsafePointer<CChar>?>,
    repo        : OpaquePointer,
    opts        : GitAttrOptions?,
    path        : String,
    name        : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_attr_get_ext(
                valueOut,
                repo,
                cOpts,
                path,
                name
            )
        }
    }
}



/// Looks up the values of a list of attributes for the given path.
/// - Parameters:
///   - valueOut: An array of length `numAttr`, into which the attribute values
///   should be written.
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - flags: The flags to use when querying the attributes.
///   - path: The path within the repository to check for attributes.
///   - numAttr: The number of attributes to look up.
///   - names: An array of length `numAttr`, containing the attribute names.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Relative paths will be interpreted relative to the repository root. The
/// specified file does not have to exist, but if it does not, then it will be
/// treated as a plain file (not as a directory).
///
/// - Important: Do not modify or free the values that are written into the
/// array, but do free the array itself if it was not allocated by libgit2.
///
/// ## C Equivalent
///
/// [`git_attr_get_many()`](https://libgit2.org/docs/reference/main/attr/git_attr_get_many.html)
public func gitAttrGetMany(
    valueOut    : UnsafeMutablePointer<UnsafePointer<CChar>?>,
    repo        : OpaquePointer,
    flags       : GitAttrCheckFlagsT,
    path        : String,
    numAttr     : Int,
    names       : [String]
) -> GitErrorCode
{
    return withCConversion
    {
        return try names.withArrayOfImmutableCStrings
        {
            cNames in
                
            return git_attr_get_many(
                valueOut,
                repo,
                flags.rawValue,
                path,
                numAttr,
                cNames
            )
        }
    }
}



/// Looks up the values of a list of attributes for the given path, with
/// extended options.
/// - Parameters:
///   - valueOut: An array of length `numAttr`, into which the attribute values
///   should be written.
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - opts: The options to use when querying the attributes.
///   - path: The path within the repository to check for attributes.
///   - numAttr: The number of attributes to look up.
///   - names: An array of length `numAttr`, containing the attribute names.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Relative paths will be interpreted relative to the repository root. The
/// specified file does not have to exist, but if it does not, then it will be
/// treated as a plain file (not as a directory).
///
/// - Important: Do not modify or free the values that are written into the
/// array, but do free the array itself if it was not allocated by libgit2.
///
/// ## C Equivalent
///
/// [`git_attr_get_many_ext()`](https://libgit2.org/docs/reference/main/attr/git_attr_get_many_ext.html)
public func gitAttrGetManyExt(
    valueOut    : UnsafeMutablePointer<UnsafePointer<CChar>?>,
    repo        : OpaquePointer,
    opts        : GitAttrOptions?,
    path        : String,
    numAttr     : Int,
    names       : [String]
) -> GitErrorCode
{
    return withCConversion
    {
        return try names.withArrayOfImmutableCStrings
        {
            cNames in
            
            return try opts.withOptionalCValue
            {
                cOpts in
                
                return git_attr_get_many_ext(
                    valueOut,
                    repo,
                    cOpts,
                    path,
                    numAttr,
                    cNames
                )
            }
        }
    }
}



/// Loops over all the attributes for the given path.
/// - Parameters:
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - flags: The flags to use when querying the attributes.
///   - path: The path within the repository to check for attributes.
///   - callback: The callback to invoke for each attribute name and value.
///   - payload: The caller-specified payload passed to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Relative paths will be interpreted relative to the repository root. The
/// specified file does not have to exist, but if it does not, then it will be
/// treated as a plain file (not as a directory).
///
/// ## C Equivalent
///
/// [`git_attr_foreach()`](https://libgit2.org/docs/reference/main/attr/git_attr_foreach.html)
public func gitAttrForEach(
    repo        : OpaquePointer,
    flags       : GitAttrCheckFlagsT,
    path        : String,
    callback    : GitAttrForEachCB?,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return git_attr_foreach(
            repo,
            flags.rawValue,
            path,
            callback,
            payload
        )
    }
}



/// Loops over all the attributes for the given path, with extended options.
/// - Parameters:
///   - repo: The repository containing the given path. The underlying type
///   must be `git_repository`.
///   - opts: The options to use when querying the attributes.
///   - path: The path within the repository to check for attributes.
///   - callback: The callback to invoke for each attribute name and value.
///   - payload: The caller-specified payload passed to `callback`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Relative paths will be interpreted relative to the repository root. The
/// specified file does not have to exist, but if it does not, then it will be
/// treated as a plain file (not as a directory).
///
/// ## C Equivalent
///
/// [`git_attr_foreach_ext()`](https://libgit2.org/docs/reference/main/attr/git_attr_foreach_ext.html)
public func gitAttrForEachExt(
    repo        : OpaquePointer,
    opts        : GitAttrOptions?,
    path        : String,
    callback    : GitAttrForEachCB?,
    payload     : UnsafeMutableRawPointer?
) -> GitErrorCode
{
    return withCConversion
    {
        return try opts.withOptionalCValue
        {
            cOpts in
            
            return git_attr_foreach_ext(
                repo,
                cOpts,
                path,
                callback,
                payload
            )
        }
    }
}



/// Flushes the `.gitattributes` cache.
/// - Parameter repo: The repository containing the `.gitattributes` cache.
/// The underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Call this function if the attributes files on the disk no longer match the
/// cached contents in memory. This will cause the attributes files to be
/// reloaded the next time an attribute access function is called.
///
/// ## C Equivalent
///
/// [`git_attr_cache_flush()`](https://libgit2.org/docs/reference/main/attr/git_attr_cache_flush.html)
public func gitAttrCacheFlush(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_attr_cache_flush(repo)
    }
}



/// Adds a macro definition.
/// - Parameters:
///   - repo: The repository in which to add the macro. The underlying type
///   must be `git_repository`.
///   - name: The name of the macro.
///   - values: The value of the macro.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// Macros will be automatically loaded from the top level `.gitattributes`
/// file of the repository (plus the built-in "binary" macro). This function
/// allows other macros to be added.
///
/// For example, call the following to add the default macro:
///
/// ```swift
/// gitArrAddMacro(
///     repo:       repositoryPointer,
///     name:       "binary",
///     values:     "-diff -crlf"
/// )
/// ```
///
/// ## C Equivalent
///
/// [`git_attr_add_macro()`](https://libgit2.org/docs/reference/main/attr/git_attr_add_macro.html)
public func gitAttrAddMacro(
    repo    : OpaquePointer,
    name    : String,
    values  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_attr_add_macro(
            repo,
            name,
            values
        )
    }
}
