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



/// The options for rebase operations.
///
/// ## C Equivalent
///
/// [`git_rebase_options`](https://libgit2.org/docs/reference/main/rebase/git_rebase_options.html)
public struct GitRebaseOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRebaseOptionsVersion``.
    public var version          : UInt32
    
    /// Whether to perform a quiet rebase.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    ///
    /// - Note: This does not effect libgit2, but is provided for
    /// interoperability with Git.
    public var quiet            : Bool
    
    /// Whether to perform an in-memory rebase.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    ///
    /// An in-memory rebase allows callers to step through the rebase
    /// operations and commit the rebased changes, but will not rewind HEAD or
    /// update the repository to be in a rebasing state. This will not
    /// interfere with the working directory, if there is one.
    public var inMemory         : Bool
    
    /// The name of the notes reference used to rewrite notes for rebased
    /// commits.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// If this is `nil`, the contents of the configuration option
    /// `notes.rewriteRef` will be examined, unless the configuration option
    /// `notes.rewrite.rebase` is `false`. If `notes.rewriteRef` is also `nil`,
    /// no notes will be rewritten.
    public var rewriteNotesRef  : String?
    
    /// The options for the merge operation.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitMergeOptions``
    /// instance.
    public var mergeOptions     : GitMergeOptions
    
    /// The options for the checkout operation.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitCheckoutOptions``
    /// instance.
    public var checkoutOptions  : GitCheckoutOptions
    
    /// The callback invoked to create a commit.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This can be used to override commit creation during the rebase
    /// operation.
    public var commitCreateCB   : GitCommitCreateCB?
    
    /// The callback invoked to add a signature to the rebase commit.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// - Warning: This is deprecated in libgit2 and will be removed in the
    /// next major release. Use ``commitCreateCB`` instead.
    public var signingCB        : GitRebaseSigningCB?
    
    /// The payload passed to ``commitCreateCB`` and ``signingCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload          : UnsafeMutableRawPointer?
    
    
    
    /// Initializes a ``GitRebaseOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32                    = gitRebaseOptionsVersion,
        quiet           : Bool                      = false,
        inMemory        : Bool                      = false,
        rewriteNotesRef : String?                   = nil,
        mergeOptions    : GitMergeOptions           = GitMergeOptions(),
        checkoutOptions : GitCheckoutOptions        = GitCheckoutOptions(),
        commitCreateCB  : GitCommitCreateCB?        = nil,
        signingCB       : GitRebaseSigningCB?       = nil,
        payload         : UnsafeMutableRawPointer?  = nil
    )
    {
        self.version            = version
        self.quiet              = quiet
        self.inMemory           = inMemory
        self.rewriteNotesRef    = rewriteNotesRef
        self.mergeOptions       = mergeOptions
        self.checkoutOptions    = checkoutOptions
        self.commitCreateCB     = commitCreateCB
        self.signingCB          = signingCB
        self.payload            = payload
    }
    
    
    
    /// Initializes a ``GitRebaseOptions`` instance from the given
    /// `git_rebase_options` instance.
    /// - Parameter rebaseOptions: The `git_rebase_options` instance to use.
    internal init(
        cValue rebaseOptions: git_rebase_options
    )
    {
        self.version            = rebaseOptions.version
        self.quiet              = Bool(rebaseOptions.quiet)
        self.inMemory           = Bool(rebaseOptions.inmemory)
        self.rewriteNotesRef    = String(optionalCString: rebaseOptions.rewrite_notes_ref)
        self.mergeOptions       = GitMergeOptions(cValue: rebaseOptions.merge_options)
        self.checkoutOptions    = GitCheckoutOptions(cValue: rebaseOptions.checkout_options)
        self.commitCreateCB     = rebaseOptions.commit_create_cb
        self.signingCB          = rebaseOptions.signing_cb
        self.payload            = rebaseOptions.payload
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_rebase_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_rebase_options>) throws -> T
    ) throws -> T
    {
        var rebaseOptions = git_rebase_options()
        
        let rebaseOptionsInitResult: GitErrorCode = gitRebaseOptionsInit(
            opts:       &rebaseOptions,
            version:    version
        )
        
        if rebaseOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        rebaseOptions.quiet             = quiet.int32Value
        rebaseOptions.inmemory          = inMemory.int32Value
        rebaseOptions.commit_create_cb  = commitCreateCB
        rebaseOptions.signing_cb        = signingCB
        rebaseOptions.payload           = payload
        
        return try rewriteNotesRef.withOptionalCString
        {
            cRewriteNotesRef in
            
            rebaseOptions.rewrite_notes_ref = cRewriteNotesRef
            
            return try mergeOptions.withCValue
            {
                cMergeOptions in
                
                rebaseOptions.merge_options = cMergeOptions.pointee
                
                return try checkoutOptions.withCValue
                {
                    cCheckoutOptions in
                    
                    rebaseOptions.checkout_options = cCheckoutOptions.pointee
                    
                    return try body(&rebaseOptions)
                }
            }
        }
    }
}



/// A rebase operation.
///
/// ## C Equivalent
///
/// [`git_rebase_operation`](https://libgit2.org/docs/reference/main/rebase/git_rebase_operation.html)
public struct GitRebaseOperation: CStructInternalMutable, WithCConvertible, Sendable
{
    /// The type of rebase operation.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitRebaseOperationT/gitRebaseOperationPick``.
    public private(set) var type    : GitRebaseOperationT   = .gitRebaseOperationPick
    
    /// The ID of the commit being cherry-picked.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitOID`` instance.
    ///
    /// This will be updated for all rebase operations, except when the
    /// operation is ``GitRebaseOperationT/gitRebaseOperationExec``.
    public private(set) var id      : GitOID                = GitOID()
    
    /// The requested executable command.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This will be updated for only when the rebase operation is
    /// ``GitRebaseOperationT/gitRebaseOperationExec``.
    public private(set) var exec    : String?               = nil
    
    
    
    
    /// Initializes a default ``GitRebaseOperation`` instance.
    public init() { }
    
    
    
    /// Initializes a ``GitRebaseOperation`` instance from the given
    /// `git_rebase_operation` instance.
    /// - Parameter rebaseOperation: The `git_rebase_operation` instance to use.
    internal init(
        cValue rebaseOperation: git_rebase_operation
    )
    {
        self.type   = GitRebaseOperationT(cValue: rebaseOperation.type) ?? .gitRebaseOperationPick
        self.id     = GitOID(cValue: rebaseOperation.id)
        self.exec   = String(optionalCString: rebaseOperation.exec)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_rebase_operation` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    ///
    /// ## Discussion
    ///
    /// - Important: `rebase_operation->id` has a type of `const git_oid`,
    /// unlike most other structs with ID properties of the type `git_oid`.
    /// Since the field is immutable and inaccessible for assignment, this
    /// method does not set its value. ``GitRebaseOperation`` is used as a
    /// read-only struct, so this currently has no impact. If the typing
    /// changes in a later version, this field must be set for consistency.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_rebase_operation>) throws -> T
    ) throws -> T
    {
        var rebaseOperation = git_rebase_operation()
        
        rebaseOperation.type = type.cValue()
        
        return try exec.withOptionalCString
        {
            cExec in
            
            rebaseOperation.exec = cExec
            
            return try body(&rebaseOperation)
        }
    }
}
