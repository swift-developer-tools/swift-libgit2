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



/// Checkout performance data.
///
/// ## C Equivalent
///
/// [`git_checkout_perfdata`](https://libgit2.org/docs/reference/main/checkout/git_checkout_perfdata.html)
public struct GitCheckoutPerfData
{
    /// The number of times `mkdir` was called during the checkout process.
    public let mkdirCalls   : Int
    
    /// The number of times `stat` was called during the checkout process.
    public let statCalls    : Int
    
    /// The number of times `chmod` was called during the checkout process.
    public let chmodCalls   : Int
    
    
    
    /// Creates a ``GitCheckoutPerfData`` instance from a `git_checkout_perfdata`
    /// instance.
    /// - Parameter checkoutPerfData: The `git_checkout_perfdata` instance to use.
    internal init(
        cValue checkoutPerfData: git_checkout_perfdata
    )
    {
        self.mkdirCalls     = checkoutPerfData.mkdir_calls
        self.statCalls      = checkoutPerfData.stat_calls
        self.chmodCalls     = checkoutPerfData.chmod_calls
    }
}



/// The options for the checkout process.
///
/// ## C Equivalent
///
/// [`git_checkout_options`](https://libgit2.org/docs/reference/main/checkout/git_checkout_options.html)
public struct GitCheckoutOptions
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCheckoutOptionsVersion``.
    public var version          : UInt32
    
    /// The checkout strategy.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitCheckoutStrategyT/gitCheckoutSafe``.
    public var checkoutStrategy : GitCheckoutStrategyT
    
    /// Whether filters like CRLF conversion should be disabled.
    public var disableFilters   : Bool
    
    /// The directory mode.
    ///
    /// ## Discussion
    ///
    /// The default value is `0755`.
    public var dirMode          : UInt32
    
    /// The file mode.
    ///
    /// ## Discussion
    ///
    /// The default value is `0644` or `0755` as dictated by the blob.
    public var fileMode         : UInt32
    
    /// Flags controlling the file opening process.
    ///
    /// ## Discussion
    ///
    /// The default value is `O_CREAT | O_TRUNC | O_WRONLY`.
    public var fileOpenFlags    : Int32
    
    /// Flags controlling the behavior of checkout notifications.
    public var notifyFlags      : GitCheckoutNotifyT
    
    /// The callback for checkout notifications.
    public var notifyCB         : GitCheckoutNotifyCB?
    
    /// The caller-specified payload passed to ``notifyCB``.
    public var notifyPayload    : UnsafeMutableRawPointer?
    
    /// The callback for checkout progress.
    public var progressCB       : GitCheckoutProgressCB?
    
    /// The caller-specified payload passed to ``progressCB``.
    public var progressPayload  : UnsafeMutableRawPointer?
    
    /// A list of wildmatch patterns or paths.
    ///
    /// ## Discussion
    ///
    /// The default behavior is to process all paths. If an array of wildmatch patterns is provided,
    /// those patterns will be used to determine which paths should be taken into account.
    ///
    /// Use ``GitCheckoutStrategyT/gitCheckoutDisablePathspecMatch`` to treat
    /// this as a simple list.
    public var paths            : [String]
    
    /// The expected content of the working directory. The underlying type should be `git_tree`.
    ///
    /// ## Discussion
    ///
    /// The default value is HEAD.
    ///
    /// A checkout conflict will occur if the working directory does not match this baseline information.
    public var baseline         : OpaquePointer?
    
    /// The expected content of the working directory, expressed as an index. The underlying type
    /// should be `git_index`.
    ///
    /// ## Discussion
    ///
    /// This overrides ``baseline``.
    public var baselineIndex    : OpaquePointer?
    
    /// The alternative checkout path to the working directory.
    public var targetDirectory  : UnsafePointer<CChar>?
    
    /// The name of the common ancestor side of conflicts.
    public var ancestorLabel    : UnsafePointer<CChar>?
    
    /// The name of the "our" side of conflicts.
    public var ourLabel         : UnsafePointer<CChar>?
    
    /// The name of the "theirr" side of conflicts.
    public var theirLabel       : UnsafePointer<CChar>?
    
    /// The callback for reporting checkout performance data.
    public var perfDataCB       : GitCheckoutPerfDataCB?
    
    /// The caller-specified payload passed to ``perfDataCB``.
    public var perfDataPayload  : UnsafeMutableRawPointer?
    
    
    
    /// Creates a ``GitCheckoutOptions`` instance from a version number.
    /// - Parameter version: The version to use. Defaults to
    /// ``gitCheckoutOptionsVersion``.
    /// - Throws: An `NSError` if initialization failed.
    public init(
        version: UInt32 = gitCheckoutOptionsVersion
    ) throws
    {
        var checkoutOptions = git_checkout_options()
        
        let checkoutOptionsInitResult: Int32 = git_checkout_options_init(
            &checkoutOptions,
            version
        )
        
        if checkoutOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.create(
                code:       Int(checkoutOptionsInitResult),
                message:    "Failed to initialize GitCheckoutOptions."
            )
        }
        
        self.init(cValue: checkoutOptions)
    }
    
    
    
    /// Creates a ``GitCheckoutOptions`` instance from a `git_checkout_options` instance.
    /// - Parameter checkoutOptions: The `git_checkout_options` instance to use.
    internal init(
        cValue checkoutOptions: git_checkout_options
    )
    {
        self.version            = checkoutOptions.version
        self.checkoutStrategy   = GitCheckoutStrategyT(rawValue: checkoutOptions.checkout_strategy)
        self.disableFilters     = checkoutOptions.disable_filters == 1
        self.dirMode            = checkoutOptions.dir_mode
        self.fileMode           = checkoutOptions.file_mode
        self.fileOpenFlags      = checkoutOptions.file_open_flags
        self.notifyFlags        = GitCheckoutNotifyT(rawValue: checkoutOptions.notify_flags)
        self.notifyCB           = checkoutOptions.notify_cb
        self.notifyPayload      = checkoutOptions.notify_payload
        self.progressCB         = checkoutOptions.progress_cb
        self.progressPayload    = checkoutOptions.progress_payload
        self.paths              = Array(checkoutOptions.paths)
        self.baseline           = checkoutOptions.baseline
        self.baselineIndex      = checkoutOptions.baseline_index
        self.targetDirectory    = checkoutOptions.target_directory
        self.ancestorLabel      = checkoutOptions.ancestor_label
        self.ourLabel           = checkoutOptions.our_label
        self.theirLabel         = checkoutOptions.their_label
        self.perfDataCB         = checkoutOptions.perfdata_cb
        self.perfDataPayload    = checkoutOptions.perfdata_payload
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_checkout_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the initialization failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_checkout_options>?) -> T
    ) -> T
    {
        return paths.withGitStrarray
        {
            cPaths in
            
            var checkoutOptions = git_checkout_options()
            
            let checkoutOptionsInitResult: Int32 = git_checkout_options_init(
                &checkoutOptions,
                version
            )
            
            if checkoutOptionsInitResult != GIT_OK.rawValue
            {
                return body(nil)
            }
            
            checkoutOptions.version             = version
            checkoutOptions.checkout_strategy   = checkoutStrategy.rawValue
            checkoutOptions.disable_filters     = disableFilters.cValue
            checkoutOptions.dir_mode            = dirMode
            checkoutOptions.file_mode           = fileMode
            checkoutOptions.file_open_flags     = fileOpenFlags
            checkoutOptions.notify_flags        = notifyFlags.rawValue
            checkoutOptions.notify_cb           = notifyCB
            checkoutOptions.notify_payload      = notifyPayload
            checkoutOptions.progress_cb         = progressCB
            checkoutOptions.progress_payload    = progressPayload
            checkoutOptions.paths               = cPaths.pointee
            checkoutOptions.baseline            = baseline
            checkoutOptions.baseline_index      = baselineIndex
            checkoutOptions.target_directory    = targetDirectory
            checkoutOptions.ancestor_label      = ancestorLabel
            checkoutOptions.our_label           = ourLabel
            checkoutOptions.their_label         = theirLabel
            checkoutOptions.perfdata_cb         = perfDataCB
            checkoutOptions.perfdata_payload    = perfDataPayload
            
            return body(&checkoutOptions)
        }
    }
}
