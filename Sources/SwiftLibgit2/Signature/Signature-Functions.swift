//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a new signature.
/// - Parameters:
///   - out: The ``GitSignature`` instance in which to store the new signature.
///   - name: The name of the actor to use.
///   - email: The email of the actor to use.
///   - time: The UNIX timestamp in seconds to use.
///   - offset: The timezone offset in minutes to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_signature_new()`](https://libgit2.org/docs/reference/main/signature/git_signature_new.html)
public func gitSignatureNew(
    out     : inout GitSignature,
    name    : String,
    email   : String,
    time    : GitTimeT,
    offset  : Int32
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_signature_new(
                cOut,
                name,
                email,
                time,
                offset
            )
        }
    }
}



/// Creates a new signature with a timestamp representing the current time.
/// - Parameters:
///   - out: The ``GitSignature`` instance in which to store the new signature.
///   - name: The name of the actor to use.
///   - email: The email of the actor to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_signature_now()`](https://libgit2.org/docs/reference/main/signature/git_signature_now.html)
public func gitSignatureNow(
    out     : inout GitSignature,
    name    : String,
    email   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_signature_now(
                cOut,
                name,
                email
            )
        }
    }
}



/// Creates new author and/or committer signatures with default information
/// based on the configuration and environment variables.
/// - Parameters:
///   - authorOut: The ``GitSignature`` instance in which to store the new
///   author signature.
///   - committerOut: The ``GitSignature`` instance in which to store the
///   new committer signature.
///   - repo: The repository to use. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// At least one of `authorOut` or `committerOut` must not be `nil`. If both
/// are `nil`, this function will return ``GitErrorCode/gitEUser``.
///
/// If `authorOut` is not `nil`, it will be populated with the author
/// information. The `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` environment
/// variables will be honored. The `user.name` and `user.email` configuration
/// options will be honored if the environment variables are unset.
/// For timestamps, `GIT_AUTHOR_DATE` will be used, otherwise the current time
/// will be used.
///
/// If `committerOut` is not `nil`, it will be populated with the committer
/// information. The `GIT_COMMITTER_NAME` and `GIT_COMMITTER_EMAIL` environment
/// variables will be honored. The `user.name` and `user.email` configuration
/// options will be honored if the environment variables are unset.
/// For timestamps, `GIT_COMMITTER_DATE` will be used, otherwise the current
/// time will be used.
///
/// If neither `GIT_AUTHOR_DATE` nor `GIT_COMMITTER_DATE` are set, both
/// timestamps will be set to the same time.
///
/// The return value will be ``GitErrorCode/gitENotFound`` if either `user.name`
/// or `user.email `are not set, and there is no fallback from an environment
/// variable.
///
/// ## C Equivalent
///
/// [`git_signature_default_from_env()`](https://libgit2.org/docs/reference/main/signature/git_signature_default_from_env.html)
public func gitSignatureDefaultFromEnv(
    authorOut       : inout GitSignature?,
    committerOut    : inout GitSignature?,
    repo            : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        guard
            authorOut != nil
            || committerOut != nil
        else
        {
            return GitErrorCode.gitEUser.rawValue
        }
        
        
        
        var author      : UnsafeMutablePointer<git_signature>?  = nil
        var committer   : UnsafeMutablePointer<git_signature>?  = nil
        
        defer
        {
            if author != nil
            {
                gitSignatureFree(sig: author)
            }
            
            if committer != nil
            {
                gitSignatureFree(sig: committer)
            }
        }
        
        
        
        let signatureDefaultFromEnvResult: Int32
        
        switch (authorOut != nil, committerOut != nil)
        {
            case (true, true):
                
                signatureDefaultFromEnvResult = git_signature_default_from_env(
                    &author,
                    &committer,
                    repo
                )
                
            case (true, false):
                
                signatureDefaultFromEnvResult = git_signature_default_from_env(
                    &author,
                    nil,
                    repo
                )
                
            case (false, true):
                
                signatureDefaultFromEnvResult = git_signature_default_from_env(
                    nil,
                    &committer,
                    repo
                )
                
            case (false, false):
                
                return GitErrorCode.gitEUser.rawValue
        }
        
        
        
        if signatureDefaultFromEnvResult == GitErrorCode.gitOK.rawValue
        {
            if let authorSignature: git_signature = author?.pointee
            {
                authorOut = GitSignature(cValue: authorSignature)
            }
            
            if let committerSignature: git_signature = committer?.pointee
            {
                committerOut = GitSignature(cValue: committerSignature)
            }
        }
        
        
        
        return signatureDefaultFromEnvResult
    }
}



/// Creates a new signature with the default user and a timestamp representing
/// the current time.
/// - Parameters:
///   - out: The ``GitSignature`` instance in which to store the new signature.
///   - repo: The repository. The underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function looks up the `user.name` and `user.email` from the
/// configuration, uses the current time as the timestamp, and creates a new
/// signature based on that information.
///
/// The return value will be ``GitErrorCode/gitENotFound`` if either `user.name`
/// or `user.email` are not set.
///
/// - Note: This function does not examine environment variables. It examines
/// only the configuration files. Use
/// ``gitSignatureDefaultFromEnv(authorOut:committerOut:repo:)`` to consider
/// the environment variables.
///
/// ## C Equivalent
///
/// [`git_signature_default()`](https://libgit2.org/docs/reference/main/signature/git_signature_default.html)
public func gitSignatureDefault(
    out     : inout GitSignature,
    repo    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_signature_default(
                cOut,
                repo
            )
        }
    }
}



/// Creates a new signature by parsing the given string.
/// - Parameters:
///   - out: The ``GitSignature`` instance in which to store the new signature.
///   - buf: The signature string to parse.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The string is expected to be in the format
/// `Real Name <email> timestamp tzoffset`, where `timestamp` is the number
/// of seconds since the UNIX epoch and `tzoffset` is the timezone offset in
/// `hhmm` format (without colon separators).
///
/// ## C Equivalent
///
/// [`git_signature_from_buffer()`](https://libgit2.org/docs/reference/main/signature/git_signature_from_buffer.html)
public func gitSignatureFromBuffer(
    out : inout GitSignature,
    buf : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withMutatingCValue
        {
            cOut in
            
            return git_signature_from_buffer(
                cOut,
                buf
            )
        }
    }
}



/// Creates a copy of an existing signature.
/// - Parameters:
///   - dest: The ``GitSignature`` instance in which to store the copied
///   signature.
///   - sig: The signature to copy.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// All internal strings are also duplicated.
///
/// ## C Equivalent
///
/// [`git_signature_dup()`](https://libgit2.org/docs/reference/main/signature/git_signature_dup.html)
public func gitSignatureDup(
    dest    : inout GitSignature,
    sig     : GitSignature
) -> GitErrorCode
{
    return withCConversion
    {
        return try dest.withMutatingCValue
        {
            cDest in
            
            return try sig.withCValue
            {
                cSig in
                
                return git_signature_dup(
                    cDest,
                    cSig
                )
            }
        }
    }
}



/// Frees the memory allocated for the given `git_signature` instance.
/// - Parameter sig: The signature to free.
///
/// ## Discussion
///
/// Since `git_signature` is not an opaque object, it is legal to free it
/// manually, but be sure to free the `name` and `email` strings in addition
/// to the `git_signature` struct itself.
///
/// ## C Equivalent
///
/// [`git_signature_free()`](https://libgit2.org/docs/reference/main/signature/git_signature_free.html)
public func gitSignatureFree(
    sig: UnsafeMutablePointer<git_signature>?
)
{
    guard let sig
    else
    {
        return
    }
    
    git_signature_free(sig)
}
