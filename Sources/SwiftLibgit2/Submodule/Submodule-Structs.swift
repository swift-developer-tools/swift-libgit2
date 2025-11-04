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



/// The options for submodule updates.
///
/// ## C Equivalent
///
/// [`git_submodule_update_options`](https://libgit2.org/docs/reference/main/submodule/git_submodule_update_options.html)
public struct GitSubmoduleUpdateOptions: CStructMutable, WithCConvertible
{
    /// The struct version.
    ///
    /// The default value is ``gitSubmoduleUpdateOptionsVersion``.
    public var version      : UInt32
    
    /// The checkout options.
    ///
    /// The default value is a default-initialized ``GitCheckoutOptions``
    /// instance.
    public var checkoutOpts : GitCheckoutOptions
    
    /// The fetch options.
    ///
    /// The default value is a default-initialized ``GitFetchOptions``
    /// instance.
    ///
    /// The callbacks are used for reporting fetch progress and for acquiring
    ///  credentials in the event that they are needed.
    public var fetchOpts    : GitFetchOptions
    
    /// Whether to allow fetching from the submodule's default remote, if
    /// the target commit is not found.
    ///
    /// The default value is `true`.
    public var allowFetch   : Bool
    
    
    
    /// Initializes a ``GitSubmoduleUpdateOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version         : UInt32                = gitSubmoduleUpdateOptionsVersion,
        checkoutOpts    : GitCheckoutOptions    = GitCheckoutOptions(),
        fetchOpts       : GitFetchOptions       = GitFetchOptions(),
        allowFetch      : Bool                  = true
    )
    {
        self.version        = version
        self.checkoutOpts   = checkoutOpts
        self.fetchOpts      = fetchOpts
        self.allowFetch     = allowFetch
    }
    
    
    
    /// Initializes a ``GitSubmoduleUpdateOptions`` instance from the given
    /// `git_submodule_update_options` instance.
    /// - Parameter submoduleUpdateOptions: The `git_submodule_update_options`
    /// instance to use.
    internal init(
        cValue submoduleUpdateOptions: git_submodule_update_options
    )
    {
        self.version        = submoduleUpdateOptions.version
        self.checkoutOpts   = GitCheckoutOptions(cValue: submoduleUpdateOptions.checkout_opts)
        self.fetchOpts      = GitFetchOptions(cValue: submoduleUpdateOptions.fetch_opts)
        self.allowFetch     = Bool(submoduleUpdateOptions.allow_fetch)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_submodule_update_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_submodule_update_options>) throws -> T
    ) throws -> T
    {
        var submoduleUpdateOptions = git_submodule_update_options()
        
        let submoduleUpdateOptionsInitResult: GitErrorCode
            = gitSubmoduleUpdateOptionsInit(
                opts:       &submoduleUpdateOptions,
                version:    version
            )
        
        if submoduleUpdateOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        submoduleUpdateOptions.allow_fetch = allowFetch.int32Value
        
        return try checkoutOpts.withCValue
        {
            cCheckoutOpts in
            
            submoduleUpdateOptions.checkout_opts = cCheckoutOpts.pointee
            
            return try fetchOpts.withCValue
            {
                cFetchOpts in
                
                submoduleUpdateOptions.fetch_opts = cFetchOpts.pointee
                
                return try body(&submoduleUpdateOptions)
            }
        }
    }
}
