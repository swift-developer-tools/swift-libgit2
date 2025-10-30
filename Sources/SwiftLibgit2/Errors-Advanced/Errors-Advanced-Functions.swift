//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import CLibgit2Variadic



/// Clears the last error the occurred in the caller's thread.
///
/// ## C Equivalent
///
/// [`git_error_clear()`](https://libgit2.org/docs/reference/main/sys/errors/git_error_clear.html)
public func gitErrorClear()
{
    git_error_clear()
}



/// Sets the error message string for the caller's thread, using
/// `printf`-style formatting.
/// - Parameters:
///   - errorClass: The error category to set.
///   - fmt: The `printf`-style format string to set.
///   - args: The arguments for `fmt`. The underlying types must be C types.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function is public in libgit2 so custom object database
/// backends and other APIs can relay error messages. In most cases, any value
/// set by directly calling this function will be overwritten by internal
/// libgit2 APIs.
///
/// - Important: The underlying types of the variadic arguments must be C types.
/// For example, a Swift string must be converted to a C string that is valid
/// for the duration of the function call. Passing Swift types will result in
/// data loss or undefined behavior. Use ``gitErrorSetStr(errorClass:string:)``
/// to pass a static Swift string instead.
///
/// ## C Equivalent
///
/// [`git_error_set()`](https://libgit2.org/docs/reference/main/sys/errors/git_error_set.html)
public func gitErrorSet(
    errorClass  : GitErrorT,
    fmt         : String,
    args        : [CVarArg]
) -> GitErrorCode
{
    return withCConversion
    {
        return withVaList(args)
        {
            cArgs in
            
            return _git_error_set(
                errorClass.rawValue,
                fmt,
                cArgs
            )
        }
    }
}



/// Sets the error message string for the caller's thread.
/// - Parameters:
///   - errorClass: The error category to set.
///   - string: The error message to set.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_error_set_str()`](https://libgit2.org/docs/reference/main/sys/errors/git_error_set_str.html)
public func gitErrorSetStr(
    errorClass  : GitErrorT,
    string      : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_error_set_str(
            errorClass.rawValue,
            string
        )
    }
}



/// Sets the error message to a special value for memory allocation failure.
///
/// ## Discussion
///
/// ``gitErrorSetStr(errorClass:string:)`` calls `strdup()` with the given
/// string, but this is not ideal when the error is related to a memory
/// allocation failure. This function may be used to set the error message to
/// a known and statically allocated internal value.
///
/// ## C Equivalent
///
/// [`git_error_set_oom()`](https://libgit2.org/docs/reference/main/sys/errors/git_error_set_oom.html)
public func gitErrorSetOOM()
{
    git_error_set_oom()
}
