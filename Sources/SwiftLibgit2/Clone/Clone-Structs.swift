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



/// The options for the clone operation.
///
/// ## C Equivalent
///
/// [`git_clone_options`](https://libgit2.org/docs/reference/main/clone/git_clone_options.html)
public struct GitCloneOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCloneOptionsVersion``.
    public var version              : UInt32
    
    /// The options for the checkout operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using the default checkout options.
    public var checkoutOpts         : GitCheckoutOptions?
    
    /// The options for the fetch operation, including callbacks.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using the default fetch options.
    ///
    /// The callbacks are used for reporting fetch progress and for acquiring
    ///  credentials in the event that they are needed.
    public var fetchOpts            : GitFetchOptions?
    
    /// Whether a bare repository should be created.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var bare                 : Bool
    
    /// The option for bypassing the Git-aware transport on clone.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitCloneLocalT/gitCloneLocalAuto``.
    public var local                : GitCloneLocalT
    
    /// The name of the branch to checkout.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using the remote's default branch.
    public var checkoutBranch       : String?
    
    /// A callback used to create the new repository into which to clone.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using ``bare`` property to determine whether to create a
    /// bare repository.
    public var repositoryCB         : GitRepositoryCreateCB?
    
    /// The caller-specified payload passed to ``repositoryCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This property will be ignored unless ``repositoryCB`` is not `nil`.
    public var repositoryCBPayload  : UnsafeMutableRawPointer?
    
    /// A callback used to create the remote, prior to its being used to
    /// perform the clone operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var remoteCB             : GitRemoteCreateCB?
    
    /// The caller-specified payload passed to ``remoteCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This property will be ignored unless ``remoteCB`` is not `nil`.
    public var remoteCBPayload      : UnsafeMutableRawPointer?
    
    
    
    /// Initializes a ``GitCloneOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version             : UInt32                    = gitCloneOptionsVersion,
        checkoutOpts        : GitCheckoutOptions?       = nil,
        fetchOpts           : GitFetchOptions?          = nil,
        bare                : Bool                      = false,
        local               : GitCloneLocalT            = .gitCloneLocalAuto,
        checkoutBranch      : String?                   = nil,
        repositoryCB        : GitRepositoryCreateCB?    = nil,
        repositoryCBPayload : UnsafeMutableRawPointer?  = nil,
        remoteCB            : GitRemoteCreateCB?        = nil,
        remoteCBPayload     : UnsafeMutableRawPointer?  = nil
    )
    {
        self.version                = version
        self.checkoutOpts           = checkoutOpts
        self.fetchOpts              = fetchOpts
        self.bare                   = bare
        self.local                  = local
        self.checkoutBranch         = checkoutBranch
        self.repositoryCB           = repositoryCB
        self.repositoryCBPayload    = repositoryCBPayload
        self.remoteCB               = remoteCB
        self.remoteCBPayload        = remoteCBPayload
    }
    
    
    
    /// Initializes a ``GitCloneOptions`` instance from the given
    /// `git_clone_options` instance.
    /// - Parameter cloneOptions: The `git_clone_options` instance to use.
    internal init(
        cValue cloneOptions: git_clone_options
    )
    {
        self.version                = cloneOptions.version
        self.checkoutOpts           = GitCheckoutOptions(cValue: cloneOptions.checkout_opts)
        self.fetchOpts              = GitFetchOptions(cValue: cloneOptions.fetch_opts)
        self.bare                   = Bool(cloneOptions.bare)
        self.local                  = GitCloneLocalT(cValue: cloneOptions.local) ?? .gitCloneLocal
        self.checkoutBranch         = String(optionalCString: cloneOptions.checkout_branch)
        self.repositoryCB           = cloneOptions.repository_cb
        self.repositoryCBPayload    = cloneOptions.repository_cb_payload
        self.remoteCB               = cloneOptions.remote_cb
        self.remoteCBPayload        = cloneOptions.remote_cb_payload
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_clone_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_clone_options>) throws -> T
    ) throws -> T
    {
        var cloneOptions = git_clone_options()
        
        let cloneOptionsInitResult: GitErrorCode = gitCloneOptionsInit(
            opts:       &cloneOptions,
            version:    version
        )
        
        if cloneOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        cloneOptions.bare                   = bare.int32Value
        cloneOptions.local                  = local.cValue()
        cloneOptions.repository_cb          = repositoryCB
        cloneOptions.repository_cb_payload  = repositoryCBPayload
        cloneOptions.remote_cb              = remoteCB
        cloneOptions.remote_cb_payload      = remoteCBPayload
        
        return try checkoutBranch.withOptionalCString
        {
            cCheckoutBranch in
            
            cloneOptions.checkout_branch = cCheckoutBranch
            
            return try checkoutOpts.withOptionalCValue
            {
                cCheckoutOpts in
                
                if let cCheckoutOpts: UnsafeMutablePointer<git_checkout_options>
                    = cCheckoutOpts
                {
                    cloneOptions.checkout_opts = cCheckoutOpts.pointee
                }
                
                return try fetchOpts.withOptionalCValue
                {
                    cFetchOpts in
                    
                    if let cFetchOpts: UnsafeMutablePointer<git_fetch_options>
                        = cFetchOpts
                    {
                        cloneOptions.fetch_opts = cFetchOpts.pointee
                    }
                    
                    return try body(&cloneOptions)
                }
            }
        }
    }
}
