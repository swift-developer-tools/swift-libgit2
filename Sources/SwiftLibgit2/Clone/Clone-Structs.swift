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
public struct GitCloneOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCloneOptionsVersion``.
    public var version              : UInt32
    
    /// The options for the checkout operation.
    public var checkoutOpts         : GitCheckoutOptions?
    
    /// The options for the fetch operation, including callbacks.
    ///
    /// ## Discussion
    ///
    /// The callbacks are used for reporting fetch progress and for acquiring credentials in the event
    /// that they are needed.
    public var fetchOpts            : GitFetchOptions?
    
    /// Whether a bare repository should be created.
    public var bare                 : Bool
    
    /// The options for bypassing the Git-aware transport on clone.
    public var local                : GitCloneLocalT
    
    /// The name of the branch to checkout.
    ///
    /// ## Discussion
    ///
    /// Pass `nil` to use the remote's default branch.
    public var checkoutBranch       : String?
    
    /// A callback used to create the new repository into which to clone.
    ///
    /// ## Discussion
    ///
    /// If this is `nil`, then the ``bare`` property will be used to determine whether to create a
    /// bare repository.
    public var repositoryCB         : GitRepositoryCreateCB?
    
    /// The caller-specified payload passed to ``repositoryCB``.
    ///
    /// ## Discussion
    ///
    /// This property will be ignored unless ``repositoryCB`` is not `nil`.
    public var repositoryCBPayload  : UnsafeMutableRawPointer?
    
    /// A callback used to create the remote, prior to its being used to perform the clone operation.
    public var remoteCB             : GitRemoteCreateCB?
    
    /// The caller-specified payload passed to ``remoteCB``.
    ///
    /// ## Discussion
    ///
    /// This property will be ignored unless ``remoteCB`` is not `nil`.
    public var remoteCBPayload      : UnsafeMutableRawPointer?
    
    
    
    /// Creates a ``GitCloneOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to ``gitCloneOptionsVersion``.
    public init?(
        version: UInt32 = gitCloneOptionsVersion
    )
    {
        var cloneOptions = git_clone_options()
        
        let cloneOptionsInitResult: Int32 = git_clone_options_init(
            &cloneOptions,
            version
        )
        
        if cloneOptionsInitResult != GIT_OK.rawValue
        {
            return nil
        }
        
        self.init(cValue: cloneOptions)
    }
    
    
    
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
            
            return withComposedProperties(
                &cloneOptions,
                body
            )
        }
    }
    
    
    
    /// Composes the optional properties of ``GitCloneOptions``, then calls the given closure
    /// with a pointer to the updated `git_clone_options` instance.
    /// - Parameters:
    ///   - cloneOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This function composes the following optional properties:
    /// - ``checkoutOpts``
    /// - ``fetchOpts``
    ///
    /// The composition begins by calling ``withCheckoutOptions(_:_:)``.
    private func withComposedProperties<T>(
        _   cloneOptions    : UnsafeMutablePointer<git_clone_options>,
        _   body            : (UnsafeMutablePointer<git_clone_options>?) -> T
    ) -> T
    {
        return withCheckoutOptions(
            cloneOptions,
            body
        )
    }
    
    
    
    /// Updates the given `git_clone_options` instance with the value of ``checkoutOpts``,
    /// then continues the composition by calling ``withFetchOptions(_:_:)``.
    /// - Parameters:
    ///   - cloneOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``checkoutOpts`` is `nil`, this function will proceed directly to the next step in the
    /// composition.
    ///
    /// If ``GitCheckoutOptions.withCValue(_:)`` fails, this function will call the given closure
    /// with `nil`.
    private func withCheckoutOptions<T>(
        _   cloneOptions    : UnsafeMutablePointer<git_clone_options>,
        _   body            : (UnsafeMutablePointer<git_clone_options>?) -> T
    ) -> T
    {
        guard let checkoutOpts: GitCheckoutOptions = checkoutOpts
        else
        {
            return withFetchOptions(
                cloneOptions,
                body
            )
        }
        
        return checkoutOpts.withCValue
        {
            cCheckoutOpts in
            
            guard let cCheckoutOpts: UnsafeMutablePointer<git_checkout_options> = cCheckoutOpts
            else
            {
                return body(nil)
            }
            
            cloneOptions.pointee.checkout_opts = cCheckoutOpts.pointee
            
            return withFetchOptions(
                cloneOptions,
                body
            )
        }
    }
    
    
    
    /// Updates the given `git_clone_options` instance with the value of ``fetchOpts``,
    /// then finishes the composition by calling the given closure.
    /// - Parameters:
    ///   - cloneOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``fetchOpts`` is `nil`, this function will proceed directly to calling the given closure.
    ///
    /// If ``GitFetchOptions.withCValue(_:)`` fails, this function will call the given closure
    /// with `nil`.
    private func withFetchOptions<T>(
        _   cloneOptions    : UnsafeMutablePointer<git_clone_options>,
        _   body            : (UnsafeMutablePointer<git_clone_options>?) -> T
    ) -> T
    {
        guard let fetchOpts: GitFetchOptions = fetchOpts
        else
        {
            return body(cloneOptions)
        }
        
        return fetchOpts.withCValue
        {
            cFetchOpts in
            
            guard let cFetchOpts: UnsafeMutablePointer<git_fetch_options> = cFetchOpts
            else
            {
                return body(nil)
            }
            
            cloneOptions.pointee.fetch_opts = cFetchOpts.pointee
            
            return body(cloneOptions)
        }
    }
}
