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



/// The options for cherry-pick operations.
///
/// ## C Equivalent
///
/// [`git_cherrypick_options`](https://libgit2.org/docs/reference/main/cherrypick/git_cherrypick_options.html)
public struct GitCherrypickOptions: CStructMutable, WithCConvertible
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCherrypickOptionsVersion``.
    public var version      : UInt32
    
    /// The parent for merge commits.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var mainline     : UInt32
    
    /// The merge options.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitMergeOptions``
    /// instance.
    public var mergeOpts    : GitMergeOptions
    
    /// The checkout options.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitCheckoutOptions``
    /// instance.
    public var checkoutOpts : GitCheckoutOptions
    
    
    
    /// Initializes a ``GitCherrypickOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version         : UInt32                = gitCherrypickOptionsVersion,
        mainline        : UInt32                = 0,
        mergeOpts       : GitMergeOptions       = GitMergeOptions(),
        checkoutOpts    : GitCheckoutOptions    = GitCheckoutOptions()
    )
    {
        self.version        = version
        self.mainline       = mainline
        self.mergeOpts      = mergeOpts
        self.checkoutOpts   = checkoutOpts
    }
    
    
    
    /// Initializes a ``GitCherrypickOptions`` instance from the given
    /// `git_cherrypick_options` instance.
    /// - Parameter cherrypickOptions: The `git_cherrypick_options` instance
    /// to use.
    internal init(
        cValue cherrypickOptions: git_cherrypick_options
    )
    {
        self.version        = cherrypickOptions.version
        self.mainline       = cherrypickOptions.mainline
        self.mergeOpts      = GitMergeOptions(cValue: cherrypickOptions.merge_opts)
        self.checkoutOpts   = GitCheckoutOptions(cValue: cherrypickOptions.checkout_opts)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_cherrypick_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_cherrypick_options>) throws -> T
    ) throws -> T
    {
        var cherrypickOptions = git_cherrypick_options()
        
        let cherrypickOptionsInitResult: GitErrorCode
            = gitCherrypickOptionsInit(
                opts:       &cherrypickOptions,
                version:    version
            )
        
        if cherrypickOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        cherrypickOptions.mainline = mainline
        
        return try mergeOpts.withCValue
        {
            cMergeOpts in
            
            cherrypickOptions.merge_opts = cMergeOpts.pointee
            
            return try checkoutOpts.withCValue
            {
                cCheckoutOpts in
                
                cherrypickOptions.checkout_opts = cCheckoutOpts.pointee
                
                return try body(&cherrypickOptions)
            }
        }
    }
}
