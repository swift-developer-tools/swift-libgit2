//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Cleans up excess whitespace in the given message, and adds a trailing
/// newline if necessary.
/// - Parameters:
///   - out: The `String` instance in which to store the prettified message.
///   - message: The message to prettify.
///   - stripComments: Whether to remove comment lines.
///   - commentChar: The comment character at the start of lines to remove,
///   if `stripComments` is `true`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If `stripComments` is `true`, `commentChar` must not be `nil`. Otherwise,
/// this function will return ``GitErrorCode/gitEUser``.
///
/// ## C Equivalent
///
/// [`git_message_prettify()`](https://libgit2.org/docs/reference/main/message/git_message_prettify.html)
public func gitMessagePrettify(
    out             : inout String?,
    message         : String,
    stripComments   : Bool,
    commentChar     : CChar?
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            if
                stripComments,
                commentChar == nil
            {
                return GitErrorCode.gitEUser.rawValue
            }
            
            return git_message_prettify(
                cOut,
                message,
                stripComments.int32Value,
                commentChar ?? 0
            )
        }
    }
}



/// Parses message trailers out of the given message.
/// - Parameters:
///   - arr: The array of ``GitMessageTrailer`` instances in which to store
///   the message trailers.
///   - message: The message to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_message_trailers()`](https://libgit2.org/docs/reference/main/message/git_message_trailers.html)
public func gitMessageTrailers(
    arr     : inout [GitMessageTrailer],
    message : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try arr.withMutatingGitMessageTrailerArray
        {
            cArr in
            
            return git_message_trailers(
                cArr,
                message
            )
        }
    }
}



/// Frees the memory allocated for the given `git_message_trailer_array`
/// instance.
/// - Parameter arr: The message trailer array to free.
///
/// ## C Equivalent
///
/// [`git_message_trailer_array_free()`](https://libgit2.org/docs/reference/main/message/git_message_trailer_array_free.html)
public func gitMessageTrailerArrayFree(
    arr: UnsafeMutablePointer<git_message_trailer_array>?
)
{
    guard let arr: UnsafeMutablePointer<git_message_trailer_array> = arr
    else
    {
        return
    }
    
    git_message_trailer_array_free(arr)
}
