//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The options for commit creation.
/// 
/// ## C Equivalent
/// 
/// [`git_commit_create_options`](https://libgit2.org/docs/reference/main/commit/git_commit_create_options.html)
public struct GitCommitCreateOptions: GitStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCommitCreateOptionsVersion``.
    public var version          : UInt32            = gitCommitCreateOptionsVersion
    
    /// Whether a commit with no changes from the prior commit (an empty commit)
    /// should be allowed.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var allowEmptyCommit : Bool              = false
    
    /// The commit author.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var author           : GitSignature?     = nil
    
    /// The committer.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var committer        : GitSignature?     = nil
    
    /// The encoding for the commit message.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using UTF-8.
    public var messageEncoding  : String?           = nil
    
    
    
    /// Creates a ``GitCommitCreateOptions`` instance with the default
    /// configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitCommitCreateOptions`` instance from a
    /// `git_commit_create_options` instance.
    /// - Parameter commitCreateOptions: The `git_commit_create_options`
    /// instance to use.
    internal init(
        cValue commitCreateOptions: git_commit_create_options
    )
    {
        self.version            = commitCreateOptions.version
        self.allowEmptyCommit   = Bool(commitCreateOptions.allow_empty_commit)
        self.author             = GitSignature(cValue: commitCreateOptions.author.pointee)
        self.committer          = GitSignature(cValue: commitCreateOptions.committer.pointee)
        self.messageEncoding    = String(optionalCString: commitCreateOptions.message_encoding)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_commit_create_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_commit_create_options>) throws -> T
    ) throws -> T
    {
        var commitCreateOptions = git_commit_create_options()
        
        commitCreateOptions.version             = version
        commitCreateOptions.allow_empty_commit  = UInt32(bitPattern: allowEmptyCommit.intValue)
        
        return try author.withOptionalCValue
        {
            cAuthor in
            
            commitCreateOptions.author = UnsafePointer(cAuthor)
            
            return try committer.withOptionalCValue
            {
                cCommitter in
                
                commitCreateOptions.committer = UnsafePointer(cCommitter)
                
                return try messageEncoding.withOptionalCString
                {
                    cMessageEncoding in
                    
                    commitCreateOptions.message_encoding = cMessageEncoding
                    
                    return try body(&commitCreateOptions)
                }
            }
        }
    }
}



/// An array of commits.
///
/// ## Discussion
///
/// - Note: This struct is provided for documentation purposes, but is not used
/// by other bindings. All bindings use `[OpaquePointer]` instead.
///
/// ## C Equivalent
///
/// [`git_commitarray`](https://libgit2.org/docs/reference/main/commit/git_commitarray.html)
public struct GitCommitArray: GitStruct
{
    /// The array of commits.
    public let commits  : [OpaquePointer]
    
    /// The length of ``commits``.
    public var count    : Int
    {
        return commits.count
    }
    
    
    
    /// Creates a ``GitCommitArray`` instance from a `git_commitarray` instance.
    /// - Parameter commitArray: The `git_commitarray` instance to use.
    internal init(
        cValue commitArray: git_commitarray
    )
    {
        self.commits = Array(commitArray)
    }
}
