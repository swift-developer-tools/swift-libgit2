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



/// The options for the cherry-pick operation.
///
/// ## C Equivalent
///
/// [`git_cherrypick_options`](https://libgit2.org/docs/reference/main/cherrypick/git_cherrypick_options.html)
public struct GitCherrypickOptions: GitStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCherrypickOptionsVersion``.
    public var version      : UInt32                = gitCherrypickOptionsVersion
    
    /// The parent for merge commits.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var mainline     : UInt32                = 0
    
    /// The options for the merge operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the
    /// default merge options.
    public var mergeOpts    : GitMergeOptions?      = nil
    
    /// The options for the checkout operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the
    /// default checkout options.
    public var checkoutOpts : GitCheckoutOptions?   = nil
    
    
    
    /// Creates a ``GitCherrypickOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitCherrypickOptions`` instance from a `git_cherrypick_options`
    /// instance.
    /// - Parameter cherrypickOptions: The `git_cherrypick_options` instance to use.
    internal init(
        cValue cherrypickOptions: git_cherrypick_options
    )
    {
        self.version        = cherrypickOptions.version
        self.mainline       = cherrypickOptions.mainline
        self.mergeOpts      = GitMergeOptions(cValue: cherrypickOptions.merge_opts)
        self.checkoutOpts   = GitCheckoutOptions(cValue: cherrypickOptions.checkout_opts)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_cherrypick_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_cherrypick_options>) throws -> T
    ) throws -> T
    {
        var cherrypickOptions = git_cherrypick_options()
        
        let cherrypickOptionsInitResult: GitErrorCode = gitCherrypickOptionsInit(
            opts:       &cherrypickOptions,
            version:    version
        )
        
        if cherrypickOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        cherrypickOptions.mainline = mainline
        
        return try mergeOpts.withOptionalCValue
        {
            cMergeOpts in
            
            if let cMergeOpts: UnsafeMutablePointer<git_merge_options> = cMergeOpts
            {
                cherrypickOptions.merge_opts = cMergeOpts.pointee
            }
            
            return try checkoutOpts.withOptionalCValue
            {
                cCheckoutOpts in
                
                if let cCheckoutOpts: UnsafeMutablePointer<git_checkout_options> = cCheckoutOpts
                {
                    cherrypickOptions.checkout_opts = cCheckoutOpts.pointee
                }
                
                return try body(&cherrypickOptions)
            }
        }
    }
}
