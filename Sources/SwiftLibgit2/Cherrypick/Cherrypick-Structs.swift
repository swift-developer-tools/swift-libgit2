//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The options for the cherry-pick operation.
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
        
        cherrypickOptions.mainline = mainline
        
        return withComposedProperties(
            &cherrypickOptions,
            body
        )
    }
    
    
    
    /// Composes the optional properties of ``GitCherrypickOptions``, then calls the given
    /// closure with a pointer to the updated `git_cherrypick_options` instance.
    /// - Parameters:
    ///   - cherrypickOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// This function composes the following optional properties:
    /// - ``mergeOpts``
    /// - ``checkoutOpts``
    ///
    /// The composition begins by calling ``withMergeOptions(_:_:)``.
    private func withComposedProperties<T>(
        _   cherrypickOptions   : UnsafeMutablePointer<git_cherrypick_options>,
        _   body                : (UnsafeMutablePointer<git_cherrypick_options>?) -> T
    ) -> T
    {
        return withMergeOptions(
            cherrypickOptions,
            body
        )
    }
    
    
    
    /// Updates the given `git_cherrypick_options` instance with the value of ``mergeOpts``,
    /// then continues the composition by calling ``withCheckoutOptions(_:_:)``.
    /// - Parameters:
    ///   - cherrypickOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``mergeOpts`` is `nil`, this function will proceed directly to the next step in the composition.
    ///
    /// If ``GitMergeOptions.withCValue(_:)`` fails, this function will call the given closure
    /// with `nil`.
    private func withMergeOptions<T>(
        _   cherrypickOptions   : UnsafeMutablePointer<git_cherrypick_options>,
        _   body                : (UnsafeMutablePointer<git_cherrypick_options>?) -> T
    ) -> T
    {
        guard let mergeOpts: GitMergeOptions = mergeOpts
        else
        {
            return withCheckoutOptions(
                cherrypickOptions,
                body
            )
        }
        
        return mergeOpts.withCValue
        {
            cMergeOpts in
            
            guard let cMergeOpts: UnsafeMutablePointer<git_merge_options> = cMergeOpts
            else
            {
                return body(nil)
            }
            
            cherrypickOptions.pointee.merge_opts = cMergeOpts.pointee
            
            return withCheckoutOptions(
                cherrypickOptions,
                body
            )
        }
    }
    
    
    
    /// Updates the given `git_cherrypick_options` instance with the value of
    /// ``checkoutOpts``, then finishes the composition by calling the given closure.
    /// - Parameters:
    ///   - cherrypickOptions: The options to update.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// If ``checkoutOpts`` is `nil`, this function will proceed directly to calling the given closure.
    ///
    /// If ``GitCheckoutOptions.withCValue(_:)`` fails, this function will call the given closure
    /// with `nil`.
    private func withCheckoutOptions<T>(
        _   cherrypickOptions   : UnsafeMutablePointer<git_cherrypick_options>,
        _   body                : (UnsafeMutablePointer<git_cherrypick_options>?) -> T
    ) -> T
    {
        guard let checkoutOpts: GitCheckoutOptions = checkoutOpts
        else
        {
            return body(cherrypickOptions)
        }
        
        return checkoutOpts.withCValue
        {
            cCheckoutOpts in
            
            guard let cCheckoutOpts: UnsafeMutablePointer<git_checkout_options> = cCheckoutOpts
            else
            {
                return body(nil)
            }
            
            cherrypickOptions.pointee.checkout_opts = cCheckoutOpts.pointee
            
            return body(cherrypickOptions)
        }
    }
}
