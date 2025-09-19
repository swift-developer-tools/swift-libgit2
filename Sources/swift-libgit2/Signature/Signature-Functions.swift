//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// Creates a new signature.
/// - Parameters:
///   - out: The new signature.
///   - name: The name of the actor.
///   - email: The email of the actor.
///   - time: The UNIX timestamp in seconds.
///   - offset: The timezone offset in minutes.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If an error occurs, `out` will not be updated.
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
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return name.withCString
        {
            cName in
            
            return email.withCString
            {
                cEmail in
                
                return git_signature_new(
                    cOut,
                    cName,
                    cEmail,
                    time,
                    offset
                )
            }
        }
    }
}



/// Creates a new signature with a timestamp representing the current time.
/// - Parameters:
///   - out: The new signature.
///   - name: The name of the actor.
///   - email: The email of the actor.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If an error occurs, `out` will not be updated.
///
/// ## C Equivalent
///
/// [`git_signature_now()`](https://libgit2.org/docs/reference/main/signature/git_signature_now.html)
public func gitSignatureNow(
    out     : inout GitSignature,
    name    : String,
    email   : String
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return name.withCString
        {
            cName in
            
            return email.withCString
            {
                cEmail in
                
                return git_signature_now(
                    cOut,
                    cName,
                    cEmail
                )
            }
        }
    }
}



/// Creates new author and/or committer signatures with default information based on the configuration
/// and environment variables.
/// - Parameters:
///   - authorOut: The new author signature.
///   - committerOut: The new committer signature.
///   - repo: The repository. The underlying type should be `git_repository`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// If an error occurs, `authorOut` and `committerOut` will not be updated.
///
/// At least one of `authorOut` or `committerOut` must not be `nil`. If both are `nil`,
/// this function will return `GIT_EUSER`.
///
/// If `authorOut` is not `nil`, it will be populated with the author information.
/// The `GIT_AUTHOR_NAME` and `GIT_AUTHOR_EMAIL` environment variables will be honored.
/// The `user.name` and `user.email` configuration options will be honored if the environment
/// variables are unset. For timestamps, `GIT_AUTHOR_DATE` will be used, otherwise the current time
/// will be used.
///
/// If `committerOut` is not `nil`, it will be populated with the committer information. The
/// `GIT_COMMITTER_NAME` and `GIT_COMMITTER_EMAIL` environment variables will be honored.
/// The `user.name` and `user.email` configuration options will be honored if the environment
/// variables are unset. For timestamps, `GIT_COMMITTER_DATE` will be used, otherwise the current
/// time will be used.
///
/// If neither `GIT_AUTHOR_DATE` nor `GIT_COMMITTER_DATE` are set, both timestamps will be set
/// to the same time.
///
/// The return value will be `GIT_ENOTFOUND` if either `user.name` or `user.email `are not
/// set, and there is no fallback from an environment variable.
///
/// ## C Equivalent
///
/// [`git_signature_default_from_env()`](https://libgit2.org/docs/reference/main/signature/git_signature_default_from_env.html)
public func gitSignatureDefaultFromEnv(
    authorOut       : inout GitSignature?,
    committerOut    : inout GitSignature?,
    repo            : OpaquePointer
) -> Int32
{
    guard
        authorOut != nil
        || committerOut != nil
    else
    {
        return GIT_EUSER.rawValue
    }
    
    
    
    var authorPointer       : UnsafeMutablePointer<git_signature>?  = nil
    var committerPointer    : UnsafeMutablePointer<git_signature>?  = nil
    
    defer
    {
        if authorPointer != nil
        {
            gitSignatureFree(sig: authorPointer)
        }
        
        if committerPointer != nil
        {
            gitSignatureFree(sig: committerPointer)
        }
    }
    
    
    
    let signatureDefaultFromEnvResult: Int32
    
    switch (authorOut != nil, committerOut != nil)
    {
        case (true, true):
            
            signatureDefaultFromEnvResult = git_signature_default_from_env(
                &authorPointer,
                &committerPointer,
                repo
            )
            
        case (true, false):
            
            signatureDefaultFromEnvResult = git_signature_default_from_env(
                &authorPointer,
                nil,
                repo
            )
            
        case (false, true):
            
            signatureDefaultFromEnvResult = git_signature_default_from_env(
                nil,
                &committerPointer,
                repo
            )
            
        case (false, false):
            
            return GIT_EUSER.rawValue
    }
    
    
    
    if signatureDefaultFromEnvResult == GIT_OK.rawValue
    {
        if let authorSignature: git_signature = authorPointer?.pointee
        {
            authorOut = GitSignature(cValue: authorSignature)
        }
        
        if let committerSignature: git_signature = committerPointer?.pointee
        {
            committerOut = GitSignature(cValue: committerSignature)
        }
    }
    
    
    
    return signatureDefaultFromEnvResult
}



/// Creates a new signature with the default user and a timestamp representing the current time.
/// - Parameters:
///   - out: The new signature.
///   - repo: The repository. The underlying type should be `git_repository`.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// This function looks up the `user.name` and `user.email` from the configuration, uses the
/// current time as the timestamp, and creates a new signature based on that information.
///
/// The return value will be `GIT_ENOTFOUND` if either `user.name` or `user.email` are not set.
///
/// This function does not examine environment variables. It examines only the configuration files.
/// Use ``gitSignatureDefaultFromEnv(authorOut:committerOut:repo:)`` to consider
/// the environment variables.
///
/// ## C Equivalent
///
/// [`git_signature_default()`](https://libgit2.org/docs/reference/main/signature/git_signature_default.html)
public func gitSignatureDefault(
    out     : inout GitSignature,
    repo    : OpaquePointer
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return git_signature_default(
            cOut,
            repo
        )
    }
}



/// Creates a new signature by parsing the given buffer.
/// - Parameters:
///   - out: The new signature.
///   - buf: The signature string.
/// - Returns: `0` on success, or an error code.
///
/// ## Discussion
///
/// The buffer is expected to be in the format `Real Name <email> timestamp tzoffset`,
/// where `timestamp` is the number of seconds since the UNIX epoch and `tzoffset` is the
/// timezone offset in `hhmm` format (without colon separators).
///
/// ## C Equivalent
///
/// [`git_signature_from_buffer()`](https://libgit2.org/docs/reference/main/signature/git_signature_from_buffer.html)
public func gitSignatureFromBuffer(
    out : inout GitSignature,
    buf : String
) -> Int32
{
    return out.withMutatingCValue
    {
        cOut in
        
        return git_signature_from_buffer(
            cOut,
            buf
        )
    }
}



/// Creates a copy of an existing signature.
/// - Parameters:
///   - dest: The new signature.
///   - sig: The signature to duplicate.
/// - Returns: `0` on success, or an error code.
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
) -> Int32
{
    return dest.withMutatingCValue
    {
        cDest in
        
        return sig.withCValue
        {
            cSig in
            
            return git_signature_dup(
                cDest,
                cSig
            )
        }
    }
}



/// Frees an existing signature.
/// - Parameter sig: The signature to free.
///
/// ## Discussion
///
/// This function is only needed when working directly with `git_signature` instances allocated by
/// libgit2. ``GitSignature`` instances do not need to be freed.
///
/// Since `git_signature` is not an opaque struct, it is legal to free it manually, but be sure to
/// free the `name` and `email` strings in addition to the `git_signature` struct itself.
///
/// ## C Equivalent
///
/// [`git_signature_free()`](https://libgit2.org/docs/reference/main/signature/git_signature_free.html)
public func gitSignatureFree(
    sig: UnsafeMutablePointer<git_signature>?
)
{
    git_signature_free(sig)
}
