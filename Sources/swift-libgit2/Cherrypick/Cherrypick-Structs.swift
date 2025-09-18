//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import Foundation



/// The options for the cherry-pick process.
///
/// ## C Equivalent
///
/// [`git_cherrypick_options`](https://libgit2.org/docs/reference/main/cherrypick/git_cherrypick_options.html)
public struct GitCherrypickOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCherrypickOptionsVersion``.
    public var version      : UInt32
    
    /// The parent for merge commits.
    public var mainline     : UInt32
    
    /// The options for the merge process.
    public var mergeOpts    : git_merge_options?
    
    /// The options for the checkout process.
    public var checkoutOpts : GitCheckoutOptions?
    
    
    
    /// Creates a ``GitCherrypickOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to
    /// ``gitCherrypickOptionsVersion``.
    /// - Throws: An `NSError` if initialization failed.
    public init(
        version: UInt32 = gitCherrypickOptionsVersion
    ) throws
    {
        var cherrypickOptions = git_cherrypick_options()
        
        let cherrypickOptionsInitResult: Int32 = git_cherrypick_options_init(
            &cherrypickOptions,
            version
        )
        
        if cherrypickOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.create(
                code:       Int(cherrypickOptionsInitResult),
                message:    "Failed to initialize GitCherrypickOptions."
            )
        }
        
        self.version        = cherrypickOptions.version
        self.mainline       = cherrypickOptions.mainline
        self.mergeOpts      = cherrypickOptions.merge_opts
        self.checkoutOpts   = GitCheckoutOptions(cValue: cherrypickOptions.checkout_opts)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_cherrypick_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the initialization failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_cherrypick_options>?) -> T
    ) -> T
    {
        var cherrypickOptions = git_cherrypick_options()
        
        let cherrypickOptionsInitResult: Int32 = git_cherrypick_options_init(
            &cherrypickOptions,
            version
        )
        
        if cherrypickOptionsInitResult != GIT_OK.rawValue
        {
            return body(nil)
        }
        
        
        
        cherrypickOptions.version   = version
        cherrypickOptions.mainline  = mainline
        
        
        
        // TODO: This should change once `GitMergeOptions` is added.
        if let mergeOpts: git_merge_options = mergeOpts
        {
            cherrypickOptions.merge_opts = mergeOpts
        }
        
        
        
        guard let checkoutOpts: GitCheckoutOptions = checkoutOpts
        else
        {
            return body(&cherrypickOptions)
        }
        
        
        
        return checkoutOpts.withCValue
        {
            cCheckoutOpts in
            
            guard let cCheckoutOpts: UnsafeMutablePointer<git_checkout_options> = cCheckoutOpts
            else
            {
                return body(nil)
            }
            
            cherrypickOptions.checkout_opts = cCheckoutOpts.pointee
            
            return body(&cherrypickOptions)
        }
    }
}
