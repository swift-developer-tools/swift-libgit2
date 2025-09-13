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
    ) throws(NSError)
    {
        var cherrypickOptions = git_cherrypick_options()
        
        let cherrypickOptionsInitResult: Int32 = git_cherrypick_options_init(
            &cherrypickOptions,
            version
        )
        
        if cherrypickOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError(
                domain:     "GitCherrypickOptions.\(#function)",
                code:       Int(cherrypickOptionsInitResult),
                userInfo:   nil
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
    /// - Throws: An `NSError` if initialization failed.
    internal func withCStruct<T>(
        _ body: (UnsafeMutablePointer<git_cherrypick_options>) -> T
    ) throws(NSError) -> T
    {
        var cherrypickOptions = git_cherrypick_options()
        
        let cherrypickOptionsInitResult: Int32 = git_cherrypick_options_init(
            &cherrypickOptions,
            version
        )
        
        if cherrypickOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError(
                domain:     "GitCherrypickOptions.\(#function)",
                code:       Int(cherrypickOptionsInitResult),
                userInfo:   nil
            )
        }
        
        cherrypickOptions.version   = version
        cherrypickOptions.mainline  = mainline
        
        // TODO: This should change once `GitMergeOptions` is added.
        if let mergeOpts: git_merge_options = mergeOpts
        {
            cherrypickOptions.merge_opts = mergeOpts
        }
        
        if let checkoutOpts: GitCheckoutOptions = checkoutOpts
        {
            return try checkoutOpts.withCStruct
            {
                cCheckoutOpts in
                
                cherrypickOptions.checkout_opts = cCheckoutOpts.pointee
                
                return body(&cherrypickOptions)
            }
        }
        
        return body(&cherrypickOptions)
    }
}
