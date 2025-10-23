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



/// The options for the revert operation.
///
/// ## C Equivalent
///
/// [`git_revert_options`](https://libgit2.org/docs/reference/main/revert/git_revert_options.html)
public struct GitRevertOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitRevertOptionsVersion``.
    public var version      : UInt32
    
    /// The parent of the revert commit, if it is a merge commit.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var mainline     : UInt32
    
    /// The options for the merge operation.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitMergeOptions``
    /// instance.
    public var mergeOpts    : GitMergeOptions
    
    /// The options for the checkout operation.
    ///
    /// ## Discussion
    ///
    /// The default value is a default-initialized ``GitCheckoutOptions``
    /// instance.
    public var checkoutOpts : GitCheckoutOptions
    
    
    
    /// Initializes a ``GitRevertOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version         : UInt32                = gitRevertOptionsVersion,
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
    
    
    
    /// Initializes a ``GitRevertOptions`` instance from the given
    /// `git_revert_options` instance.
    /// - Parameter revertOptions: The `git_revert_options` instance to use.
    internal init(
        cValue revertOptions: git_revert_options
    )
    {
        self.version        = revertOptions.version
        self.mainline       = revertOptions.mainline
        self.mergeOpts      = GitMergeOptions(cValue: revertOptions.merge_opts)
        self.checkoutOpts   = GitCheckoutOptions(cValue: revertOptions.checkout_opts)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_revert_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_revert_options>) throws -> T
    ) throws -> T
    {
        var revertOptions = git_revert_options()
        
        let revertOptionsInitResult: GitErrorCode = gitRevertOptionsInit(
            opts:       &revertOptions,
            version:    version
        )
        
        if revertOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        revertOptions.mainline = mainline
        
        return try mergeOpts.withCValue
        {
            cMergeOpts in
            
            revertOptions.merge_opts = cMergeOpts.pointee
            
            return try checkoutOpts.withCValue
            {
                cCheckoutOpts in
                
                revertOptions.checkout_opts = cCheckoutOpts.pointee
                
                return try body(&revertOptions)
            }
        }
    }
}
