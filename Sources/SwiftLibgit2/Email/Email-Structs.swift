//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The options for formatting generated emails.
///
/// ## C Equivalent
///
/// [`git_email_create_options`](https://libgit2.org/docs/reference/main/email/git_email_create_options.html)
public struct GitEmailCreateOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitEmailCreateOptionsVersion``.
    public var version          : UInt32
    
    /// The flags controlling the formatting of generated emails.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags            : GitEmailCreateFlagsT
    
    /// The diff options.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitDiffOptions`` instance.
    public var diffOpts         : GitDiffOptions
    
    /// The diff rename and copy detection options.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitDiffFindOptions``
    /// instance.
    public var diffFindOpts     : GitDiffFindOptions
    
    /// The subject prefix.
    ///
    /// ## Discussion
    ///
    /// The default value is `PATCH`.
    ///
    /// If the subject prefix is set to an empty string, only the patch
    /// numbers will be shown in the prefix. If patch numbers are not being
    /// shown, the prefix will be omitted entirely.
    public var subjectPrefix    : String
    
    /// The starting patch number.
    ///
    /// ## Discussion
    ///
    /// The default value is `1`.
    ///
    /// - Important: The starting patch number must not be `0`.
    public var startNumber      : Int
    
    /// The reroll number.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var rerollNumber     : Int
    
    
    
    /// Initializes a ``GitEmailCreateOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32                = gitEmailCreateOptionsVersion,
        flags           : GitEmailCreateFlagsT  = [],
        diffOpts        : GitDiffOptions        = GitDiffOptions(),
        diffFindOpts    : GitDiffFindOptions    = GitDiffFindOptions(),
        subjectPrefix   : String                = "PATCH",
        startNumber     : Int                   = 1,
        rerollNumber    : Int                   = 0
    )
    {
        self.version        = version
        self.flags          = flags
        self.diffOpts       = diffOpts
        self.diffFindOpts   = diffFindOpts
        self.subjectPrefix  = subjectPrefix
        self.startNumber    = startNumber
        self.rerollNumber   = rerollNumber
    }
    
    
    
    /// Initializes a ``GitEmailCreateOptions`` instance from the given
    /// `git_email_create_options` instance.
    /// - Parameter emailCreateOptions: The `git_email_create_options` instance
    /// to use.
    internal init(
        cValue emailCreateOptions: git_email_create_options
    )
    {
        self.version        = emailCreateOptions.version
        self.flags          = GitEmailCreateFlagsT(rawValue: emailCreateOptions.flags)
        self.diffOpts       = GitDiffOptions(cValue: emailCreateOptions.diff_opts)
        self.diffFindOpts   = GitDiffFindOptions(cValue: emailCreateOptions.diff_find_opts)
        self.subjectPrefix  = String(optionalCString: emailCreateOptions.subject_prefix) ?? "PATCH"
        self.startNumber    = emailCreateOptions.start_number
        self.rerollNumber   = emailCreateOptions.reroll_number
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_email_create_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_email_create_options>) throws -> T
    ) throws -> T
    {
        var emailCreateOptions = git_email_create_options()
        
        emailCreateOptions.version          = version
        emailCreateOptions.flags            = flags.rawValue
        emailCreateOptions.diff_find_opts   = try diffFindOpts.cValue()
        emailCreateOptions.start_number     = startNumber
        emailCreateOptions.reroll_number    = rerollNumber
        
        return try diffOpts.withCValue
        {
            cDiffOpts in
            
            emailCreateOptions.diff_opts = cDiffOpts.pointee
            
            return try subjectPrefix.withCString
            {
                cSubjectPrefix in
                
                emailCreateOptions.subject_prefix = cSubjectPrefix
                
                return try body(&emailCreateOptions)
            }
        }
    }
}
