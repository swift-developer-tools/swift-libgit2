//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The options for the clone operation.
///
/// ## C Equivalent
///
/// [`git_clone_options`](https://libgit2.org/docs/reference/main/clone/git_clone_options.html)
public struct GitCloneOptions: GitStructMutable, OptionalWithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCloneOptionsVersion``.
    public var version              : UInt32                    = gitCloneOptionsVersion
    
    /// The options for the checkout operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the
    /// default checkout options.
    public var checkoutOpts         : GitCheckoutOptions?       = nil
    
    /// The options for the fetch operation, including callbacks.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the
    /// default fetch options.
    ///
    /// The callbacks are used for reporting fetch progress and for acquiring credentials in the event
    /// that they are needed.
    public var fetchOpts            : GitFetchOptions?          = nil
    
    /// Whether a bare repository should be created.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var bare                 : Bool                      = false
    
    /// The option for bypassing the Git-aware transport on clone.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitCloneLocalT/gitCloneLocalAuto``.
    public var local                : GitCloneLocalT            = .gitCloneLocalAuto
    
    /// The name of the branch to checkout.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using the
    /// remote's default branch.
    public var checkoutBranch       : String?                   = nil
    
    /// A callback used to create the new repository into which to clone.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2 defaults to using ``bare``
    /// property to determine whether to create a bare repository.
    public var repositoryCB         : GitRepositoryCreateCB?    = nil
    
    /// The caller-specified payload passed to ``repositoryCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This property will be ignored unless ``repositoryCB`` is not `nil`.
    public var repositoryCBPayload  : UnsafeMutableRawPointer?  = nil
    
    /// A callback used to create the remote, prior to its being used to perform the clone operation.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var remoteCB             : GitRemoteCreateCB?        = nil
    
    /// The caller-specified payload passed to ``remoteCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// This property will be ignored unless ``remoteCB`` is not `nil`.
    public var remoteCBPayload      : UnsafeMutableRawPointer?  = nil
    
    
    
    /// Creates a ``GitCloneOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitCloneOptions`` instance from a `git_clone_options` instance.
    /// - Parameter cloneOptions: The `git_clone_options` instance to use.
    internal init(
        cValue cloneOptions: git_clone_options
    )
    {
        self.version                = cloneOptions.version
        self.checkoutOpts           = GitCheckoutOptions(cValue: cloneOptions.checkout_opts)
        self.fetchOpts              = GitFetchOptions(cValue: cloneOptions.fetch_opts)
        self.bare                   = cloneOptions.bare == 1
        self.local                  = GitCloneLocalT(cValue: cloneOptions.local) ?? .gitCloneLocal
        self.checkoutBranch         = String(optionalCString: cloneOptions.checkout_branch)
        self.repositoryCB           = cloneOptions.repository_cb
        self.repositoryCBPayload    = cloneOptions.repository_cb_payload
        self.remoteCB               = cloneOptions.remote_cb
        self.remoteCBPayload        = cloneOptions.remote_cb_payload
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_clone_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the initialization failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_clone_options>?) -> T
    ) -> T
    {
        var cloneOptions = git_clone_options()
        
        let cloneOptionsInitResult: Int32 = git_clone_options_init(
            &cloneOptions,
            version
        )
        
        if cloneOptionsInitResult != GIT_OK.rawValue
        {
            return body(nil)
        }
        
        
        
        cloneOptions.bare                   = bare.cValue
        cloneOptions.local                  = local.cValue
        cloneOptions.repository_cb          = repositoryCB
        cloneOptions.repository_cb_payload  = repositoryCBPayload
        cloneOptions.remote_cb              = remoteCB
        cloneOptions.remote_cb_payload      = remoteCBPayload
        
        return checkoutBranch.withOptionalCString
        {
            cCheckoutBranch in
            
            cloneOptions.checkout_branch = cCheckoutBranch
            
            return checkoutOpts.withOptionalCValue
            {
                cCheckoutOpts in
                
                if let cCheckoutOpts: UnsafeMutablePointer<git_checkout_options> = cCheckoutOpts
                {
                    cloneOptions.checkout_opts = cCheckoutOpts.pointee
                }
                
                return fetchOpts.withOptionalCValue
                {
                    cFetchOpts in
                    
                    if let cFetchOpts: UnsafeMutablePointer<git_fetch_options> = cFetchOpts
                    {
                        cloneOptions.fetch_opts = cFetchOpts.pointee
                    }
                    
                    return body(&cloneOptions)
                }
            }
        }
    }
}
