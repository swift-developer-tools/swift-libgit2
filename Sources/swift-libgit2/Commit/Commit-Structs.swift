//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The options for commit creation.
///
/// ## C Equivalent
///
/// [`git_commit_create_options`](https://libgit2.org/docs/reference/main/commit/git_commit_create_options.html)
public struct GitCommitCreateOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCommitCreateOptionsVersion``.
    public var version          : UInt32
    
    /// Whether a commit with no changes from the prior commit (an empty commit) should be allowed.
    public var allowEmptyCommit : Bool
    
    /// The commit author.
    public var author           : GitSignature?
    
    /// The committer.
    public var committer        : GitSignature?
    
    /// The encoding for the commit message.
    ///
    /// ## Discussion
    ///
    /// The default value is UTF-8.
    public var messageEncoding  : String?
    
    
    
    /// Creates a ``GitCommitCreateOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to
    /// ``gitCommitCreateOptionsVersion``.
    public init(
        version: UInt32 = gitCommitCreateOptionsVersion
    )
    {
        /// libgit2 does not provide an initialization function for `git_commit_create_options`.
        /// The C macro `GIT_COMMIT_CREATE_OPTIONS_INIT` would initialize all fields other than
        /// `version` to `0` or `NULL`, so that approach is mirrored here.
        self.version            = version
        self.allowEmptyCommit   = false
        self.author             = nil
        self.committer          = nil
        self.messageEncoding    = nil
    }
    
    
    
    /// Creates a ``GitCommitCreateOptions`` instance from a
    /// `git_commit_create_options` instance.
    /// - Parameter commitCreateOptions: The `git_commit_create_options` instance
    /// to use.
    internal init(
        cValue commitCreateOptions: git_commit_create_options
    )
    {
        self.version            = commitCreateOptions.version
        self.allowEmptyCommit   = commitCreateOptions.allow_empty_commit == 1
        self.author             = GitSignature(cValue: commitCreateOptions.author.pointee)
        self.committer          = GitSignature(cValue: commitCreateOptions.committer.pointee)
        self.messageEncoding    = String(optionalCString: commitCreateOptions.message_encoding)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_commit_create_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_commit_create_options>) -> T
    ) -> T
    {
        var commitCreateOptions = git_commit_create_options()
        
        commitCreateOptions.version             = version
        commitCreateOptions.allow_empty_commit  = UInt32(bitPattern: allowEmptyCommit.cValue)
        
        return withComposedProperties(
            &commitCreateOptions,
            body
        )
    }
    
    
    
    /// Composes the optional properties of ``GitCommitCreateOptions``, then calls the given
    /// closure with a pointer to the updated `git_commit_create_options` instance.
    /// - Parameters:
    ///   - commitCreateOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This function composes the following optional properties:
    /// - ``author``
    /// - ``committer``
    /// - ``messageEncoding``
    ///
    /// The composition begins by calling ``withAuthor(_:_:)``.
    private func withComposedProperties<T>(
        _   commitCreateOptions : UnsafeMutablePointer<git_commit_create_options>,
        _   body                : (UnsafeMutablePointer<git_commit_create_options>) -> T
    ) -> T
    {
        return withAuthor(
            commitCreateOptions,
            body
        )
    }
    
    
    
    /// Updates the given `git_commit_create_options` instance with the value of ``author``,
    /// then continues the composition by calling ``withCommitter(_:_:)``.
    /// - Parameters:
    ///   - commitCreateOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``author`` is `nil`, this function will proceed directly to the next step in the composition.
    private func withAuthor<T>(
        _   commitCreateOptions : UnsafeMutablePointer<git_commit_create_options>,
        _   body                : (UnsafeMutablePointer<git_commit_create_options>) -> T
    ) -> T
    {
        guard let author: GitSignature = author
        else
        {
            return withCommitter(
                commitCreateOptions,
                body
            )
        }
        
        return author.withCValue
        {
            cAuthor in
            
            commitCreateOptions.pointee.author = UnsafePointer(cAuthor)
            
            return withCommitter(
                commitCreateOptions,
                body
            )
        }
    }
    
    
    
    /// Updates the given `git_commit_create_options` instance with the value of
    /// ``committer``, then continues the composition by calling
    /// ``withMessageEncoding(_:_:)``.
    /// - Parameters:
    ///   - commitCreateOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``committer`` is `nil`, this function will proceed directly to the next step in the composition.
    private func withCommitter<T>(
        _   commitCreateOptions : UnsafeMutablePointer<git_commit_create_options>,
        _   body                : (UnsafeMutablePointer<git_commit_create_options>) -> T
    ) -> T
    {
        guard let committer: GitSignature = committer
        else
        {
            return withMessageEncoding(
                commitCreateOptions,
                body
            )
        }
        
        return committer.withCValue
        {
            cCommitter in
            
            commitCreateOptions.pointee.committer = UnsafePointer(cCommitter)
            
            return withMessageEncoding(
                commitCreateOptions,
                body
            )
        }
    }
    
    
    
    /// Updates the given `git_commit_create_options` instance with the value of
    /// ``messageEncoding``, then finishes the composition by calling the given closure.
    /// - Parameters:
    ///   - commitCreateOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``messageEncoding`` is `nil`, this function will proceed directly to calling the given closure.
    private func withMessageEncoding<T>(
        _   commitCreateOptions : UnsafeMutablePointer<git_commit_create_options>,
        _   body                : (UnsafeMutablePointer<git_commit_create_options>) -> T
    ) -> T
    {
        guard let messageEncoding: String = messageEncoding
        else
        {
            return body(commitCreateOptions)
        }
        
        return messageEncoding.withCString
        {
            cMessageEncoding in
            
            commitCreateOptions.pointee.message_encoding = cMessageEncoding
            
            return body(commitCreateOptions)
        }
    }
}



/// An array of commits.
///
/// ## Discussion
///
/// This struct is provided for documentation purposes, but is not used by other bindings.
///
/// All bindings use `[OpaquePointer]` instead of `git_commitarray`.
///
/// ## C Equivalent
///
/// [`git_commitarray`](https://libgit2.org/docs/reference/main/commit/git_commitarray.html)
public struct GitCommitArray
{
    /// The array of commits.
    public let commits  : [OpaquePointer]
    
    /// The number of commits in the array.
    public let count    : Int
}
