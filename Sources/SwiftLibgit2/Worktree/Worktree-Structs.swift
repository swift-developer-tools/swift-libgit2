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



/// The options for adding worktrees.
///
/// ## C Equivalent
///
/// [`git_worktree_add_options`](https://libgit2.org/docs/reference/main/worktree/git_worktree_add_options.html)
public struct GitWorktreeAddOptions: CStructMutable, WithCConvertible
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitWorktreeAddOptionsVersion``.
    public var version          : UInt32
    
    /// Whether to lock the worktree.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var lock             : Bool
    
    /// Whether to allow checkout of an existing branch matching the
    /// worktree name.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var checkoutExisting : Bool
    
    /// The reference to use for the worktree HEAD.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var ref              : OpaquePointer?
    
    /// The checkout options.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitCheckoutOptions``
    /// instance.
    public var checkoutOpts     : GitCheckoutOptions
    
    
    
    /// Initializes a ``GitWorktreeAddOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version             : UInt32                = gitWorktreeAddOptionsVersion,
        lock                : Bool                  = false,
        checkoutExisting    : Bool                  = false,
        ref                 : OpaquePointer?        = nil,
        checkoutOpts        : GitCheckoutOptions    = GitCheckoutOptions()
    )
    {
        self.version            = version
        self.lock               = lock
        self.checkoutExisting   = checkoutExisting
        self.ref                = ref
        self.checkoutOpts       = checkoutOpts
    }
    
    
    
    /// Initializes a ``GitWorktreeAddOptions`` instance from the given
    /// `git_worktree_add_options` instance.
    /// - Parameter worktreeAddOptions: The `git_worktree_add_options`
    /// instance to use.
    internal init(
        cValue worktreeAddOptions: git_worktree_add_options
    )
    {
        self.version            = worktreeAddOptions.version
        self.lock               = Bool(worktreeAddOptions.lock)
        self.checkoutExisting   = Bool(worktreeAddOptions.checkout_existing)
        self.ref                = worktreeAddOptions.ref
        self.checkoutOpts       = GitCheckoutOptions(cValue: worktreeAddOptions.checkout_options)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_worktree_add_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_worktree_add_options>) throws -> T
    ) throws -> T
    {
        var worktreeAddOptions = git_worktree_add_options()
        
        let worktreeAddOptionsInitResult: GitErrorCode
            = gitWorktreeAddOptionsInit(
                opts:       &worktreeAddOptions,
                version:    version
            )
        
        if worktreeAddOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        worktreeAddOptions.lock                 = lock.int32Value
        worktreeAddOptions.checkout_existing    = checkoutExisting.int32Value
        worktreeAddOptions.ref                  = ref
        
        return try checkoutOpts.withCValue
        {
            cCheckoutOpts in
            
            worktreeAddOptions.checkout_options = cCheckoutOpts.pointee
            
            return try body(&worktreeAddOptions)
        }
    }
}



/// The options for pruning worktrees.
///
/// ## C Equivalent
///
/// [`git_worktree_prune_options`](https://libgit2.org/docs/reference/main/worktree/git_worktree_prune_options.html)
public struct GitWorktreePruneOptions: CStructMutable, WithCConvertible, Sendable
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitWorktreePruneOptionsVersion``.
    public var version  : UInt32
    
    /// The flags controlling worktree pruning.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags    : GitWorktreePruneT
    
    
    
    /// Initializes a ``GitWorktreePruneOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version : UInt32                = gitWorktreePruneOptionsVersion,
        flags   : GitWorktreePruneT     = []
    )
    {
        self.version    = version
        self.flags      = flags
    }
    
    
    
    /// Initializes a ``GitWorktreePruneOptions`` instance from the given
    /// `git_worktree_prune_options` instance.
    /// - Parameter worktreePruneOptions: The `git_worktree_prune_options`
    /// instance to use.
    internal init(
        cValue worktreePruneOptions: git_worktree_prune_options
    )
    {
        self.version    = worktreePruneOptions.version
        self.flags      = GitWorktreePruneT(rawValue: worktreePruneOptions.flags)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_worktree_prune_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_worktree_prune_options>) throws -> T
    ) throws -> T
    {
        var worktreePruneOptions = git_worktree_prune_options()
        
        let worktreePruneOptionsInitResult: GitErrorCode
            = gitWorktreePruneOptionsInit(
                opts:       &worktreePruneOptions,
                version:    version
            )
        
        if worktreePruneOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        worktreePruneOptions.flags = flags.rawValue
        
        return try body(&worktreePruneOptions)
    }
}
