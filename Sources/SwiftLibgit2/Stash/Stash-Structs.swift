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



/// The options for saving stashes.
///
/// ## C Equivalent
///
/// [`git_stash_save_options`](https://libgit2.org/docs/reference/main/stash/git_stash_save_options.html)
public struct GitStashSaveOptions: CStructMutable, WithCConvertible, Sendable
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitStashSaveOptionsVersion``.
    public var version  : UInt32
    
    /// The flags controlling stash saving.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags    : GitStashFlags
    
    /// The actor performing the stash.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitSignature`` instance.
    public var stasher  : GitSignature
    
    /// The stash message.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var message  : String?
    
    /// The paths controlling which files are stashed.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array.
    public var paths    : [String]
    
    
    
    /// Initializes a ``GitStashSaveOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version : UInt32            = gitStashSaveOptionsVersion,
        flags   : GitStashFlags     = [],
        stasher : GitSignature      = GitSignature(),
        message : String?           = nil,
        paths   : [String]          = []
    )
    {
        self.version    = version
        self.flags      = flags
        self.stasher    = stasher
        self.message    = message
        self.paths      = paths
    }
    
    
    
    /// Initializes a ``GitStashSaveOptions`` instance from the given
    /// `git_stash_save_options` instance.
    /// - Parameter stashSaveOptions: The `git_stash_save_options` instance
    /// to use.
    internal init(
        cValue stashSaveOptions: git_stash_save_options
    )
    {
        self.version    = stashSaveOptions.version
        self.flags      = GitStashFlags(rawValue: stashSaveOptions.flags)
        self.stasher    = GitSignature(cValue: stashSaveOptions.stasher.pointee)
        self.message    = String(optionalCString: stashSaveOptions.message)
        self.paths      = Array(stashSaveOptions.paths)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_stash_save_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_stash_save_options>) throws -> T
    ) throws -> T
    {
        var stashSaveOptions = git_stash_save_options()
        
        let stashSaveOptionsInitResult: GitErrorCode
            = gitStashSaveOptionsInit(
                opts:       &stashSaveOptions,
                version:    version
            )
        
        if stashSaveOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        stashSaveOptions.flags = flags.rawValue
        
        return try stasher.withCValue
        {
            cStasher in
            
            stashSaveOptions.stasher = UnsafePointer(cStasher)
            
            return try message.withOptionalCString
            {
                cMessage in
                
                stashSaveOptions.message = cMessage
                
                return try paths.withGitStrArray
                {
                    cPaths in
                    
                    stashSaveOptions.paths = cPaths.pointee
                    
                    return try body(&stashSaveOptions)
                }
            }
        }
    }
}



/// The options for stash application.
///
/// ## C Equivalent
///
/// [`git_stash_apply_options`](https://libgit2.org/docs/reference/main/stash/git_stash_apply_options.html)
public struct GitStashApplyOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitStashApplyOptionsVersion``.
    public var version          : UInt32
    
    /// The type of stash application.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitStashApplyFlags/gitStashApplyDefault``.
    public var flags            : GitStashApplyFlags
    
    /// The checkout options.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitCheckoutOptions``
    /// instance.
    public var checkoutOptions  : GitCheckoutOptions
    
    /// The callback invoked to report stash application progress.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressCB       : GitStashApplyProgressCB?
    
    /// The payload passed to ``progressCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressPayload  : UnsafeMutableRawPointer?
    
    
    
    /// Initializes a ``GitStashSaveOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32                    = gitStashApplyOptionsVersion,
        flags           : GitStashApplyFlags        = .gitStashApplyDefault,
        checkoutOptions : GitCheckoutOptions        = GitCheckoutOptions(),
        progressCB      : GitStashApplyProgressCB?  = nil,
        progressPayload : UnsafeMutableRawPointer?  = nil
    )
    {
        self.version            = version
        self.flags              = flags
        self.checkoutOptions    = checkoutOptions
        self.progressCB         = progressCB
        self.progressPayload    = progressPayload
    }
    
    
    
    /// Initializes a ``GitStashSaveOptions`` instance from the given
    /// `git_stash_apply_options` instance.
    /// - Parameter stashApplyOptions: The `git_stash_apply_options` instance
    /// to use.
    internal init(
        cValue stashApplyOptions: git_stash_apply_options
    )
    {
        self.version            = stashApplyOptions.version
        self.flags              = GitStashApplyFlags(rawValue: stashApplyOptions.flags) ?? .gitStashApplyDefault
        self.checkoutOptions    = GitCheckoutOptions(cValue: stashApplyOptions.checkout_options)
        self.progressCB         = stashApplyOptions.progress_cb
        self.progressPayload    = stashApplyOptions.progress_payload
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_stash_apply_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_stash_apply_options>) throws -> T
    ) throws -> T
    {
        var stashApplyOptions = git_stash_apply_options()
        
        let stashApplyOptionsInitResult: GitErrorCode
            = gitStashApplyOptionsInit(
                opts:       &stashApplyOptions,
                version:    version
            )
        
        if stashApplyOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        stashApplyOptions.flags             = flags.rawValue
        stashApplyOptions.progress_cb       = progressCB
        stashApplyOptions.progress_payload  = progressPayload
        
        return try checkoutOptions.withCValue
        {
            cCheckoutOptions in
            
            stashApplyOptions.checkout_options = cCheckoutOptions.pointee
            
            return try body(&stashApplyOptions)
        }
    }
}
