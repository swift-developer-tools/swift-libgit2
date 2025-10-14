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



/// Checkout performance data.
///
/// ## C Equivalent
///
/// [`git_checkout_perfdata`](https://libgit2.org/docs/reference/main/checkout/git_checkout_perfdata.html)
public struct GitCheckoutPerfData: CStructReadable, CConvertible
{
    /// The number of times `mkdir` was called during the checkout operation.
    public let mkdirCalls   : Int
    
    /// The number of times `stat` was called during the checkout operation.
    public let statCalls    : Int
    
    /// The number of times `chmod` was called during the checkout operation.
    public let chmodCalls   : Int
    
    
    
    /// Creates a ``GitCheckoutPerfData`` instance from a
    /// `git_checkout_perfdata` instance.
    /// - Parameter checkoutPerfData: The `git_checkout_perfdata` instance to
    /// use.
    internal init(
        cValue checkoutPerfData: git_checkout_perfdata
    )
    {
        self.mkdirCalls     = checkoutPerfData.mkdir_calls
        self.statCalls      = checkoutPerfData.stat_calls
        self.chmodCalls     = checkoutPerfData.chmod_calls
    }
    
    
    
    /// Converts the ``GitCheckoutPerfData`` instance into a
    /// `git_checkout_perfdata` instance.
    /// - Returns: The `git_checkout_perfdata` instance.
    internal func cValue() -> git_checkout_perfdata
    {
        var checkoutPerfData = git_checkout_perfdata()
        
        checkoutPerfData.mkdir_calls    = mkdirCalls
        checkoutPerfData.stat_calls     = statCalls
        checkoutPerfData.chmod_calls    = chmodCalls
        
        return checkoutPerfData
    }
}



/// The options for the checkout operation.
///
/// ## C Equivalent
///
/// [`git_checkout_options`](https://libgit2.org/docs/reference/main/checkout/git_checkout_options.html)
public struct GitCheckoutOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCheckoutOptionsVersion``.
    public var version          : UInt32                    = gitCheckoutOptionsVersion
    
    /// The checkout strategy.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitCheckoutStrategyT/gitCheckoutSafe``.
    public var checkoutStrategy : GitCheckoutStrategyT      = .gitCheckoutSafe
    
    /// Whether filters like CRLF conversion should be disabled.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var disableFilters   : Bool                      = false
    
    /// The directory mode.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`. If this is `0` at runtime, libgit2 defaults
    /// to using `0o755`.
    public var dirMode          : UInt32                    = 0
    
    /// The file mode.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`. If this is `0` at runtime, libgit2 defaults
    /// to using `0o644` or `0o755`, as dictated by the blob.
    public var fileMode         : UInt32                    = 0
    
    /// The flags controlling the file opening process.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`. If this is `0` at runtime, libgit2 defaults
    /// to using `O_CREAT | O_TRUNC | O_WRONLY`.
    public var fileOpenFlags    : Int32                     = 0
    
    /// The flags controlling the behavior of checkout notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitCheckoutNotifyT/gitCheckoutNotifyNone``.
    public var notifyFlags      : GitCheckoutNotifyT        = .gitCheckoutNotifyNone
    
    /// The callback for checkout notifications.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var notifyCB         : GitCheckoutNotifyCB?      = nil
    
    /// The caller-specified payload passed to ``notifyCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var notifyPayload    : UnsafeMutableRawPointer?  = nil
    
    /// The callback for checkout progress.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressCB       : GitCheckoutProgressCB?    = nil
    
    /// The caller-specified payload passed to ``progressCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var progressPayload  : UnsafeMutableRawPointer?  = nil
    
    /// A list of wildmatch patterns or paths.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty array. If this is empty at runtime,
    /// libgit2 defaults to processing all paths. If an array of wildmatch
    /// patterns is provided, those patterns will be used to determine which
    /// paths should be taken into account.
    ///
    /// Use ``GitCheckoutStrategyT/gitCheckoutDisablePathspecMatch`` to treat
    /// this as a simple list.
    public var paths            : [String]                  = []
    
    /// The expected content of the working directory. The underlying type
    /// must be `git_tree`.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`. If this is `nil` at runtime, libgit2
    /// defaults to using HEAD.
    ///
    /// A checkout conflict will occur if the working directory does not match
    /// this baseline information.
    public var baseline         : OpaquePointer?            = nil
    
    /// The expected content of the working directory, expressed as an index.
    /// The underlying type must be `git_index`.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    /// 
    /// This overrides ``baseline``.
    public var baselineIndex    : OpaquePointer?            = nil
    
    /// The alternative checkout path to the working directory.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var targetDirectory  : String?                   = nil
    
    /// The name of the common ancestor of conflicts.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var ancestorLabel    : String?                   = nil
    
    /// The name of "our" side of conflicts.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var ourLabel         : String?                   = nil
    
    /// The name of "their" side of conflicts.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var theirLabel       : String?                   = nil
    
    /// The callback for reporting checkout performance data.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var perfDataCB       : GitCheckoutPerfDataCB?    = nil
    
    /// The caller-specified payload passed to ``perfDataCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var perfDataPayload  : UnsafeMutableRawPointer?  = nil
    
    
    
    /// Creates a ``GitCheckoutOptions`` instance with the default
    /// configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitCheckoutOptions`` instance from a `git_checkout_options`
    /// instance.
    /// - Parameter checkoutOptions: The `git_checkout_options` instance to use.
    internal init(
        cValue checkoutOptions: git_checkout_options
    )
    {
        self.version            = checkoutOptions.version
        self.checkoutStrategy   = GitCheckoutStrategyT(rawValue: checkoutOptions.checkout_strategy)
        self.disableFilters     = Bool(checkoutOptions.disable_filters)
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
        self.targetDirectory    = String(optionalCString: checkoutOptions.target_directory)
        self.ancestorLabel      = String(optionalCString: checkoutOptions.ancestor_label)
        self.ourLabel           = String(optionalCString: checkoutOptions.our_label)
        self.theirLabel         = String(optionalCString: checkoutOptions.their_label)
        self.perfDataCB         = checkoutOptions.perfdata_cb
        self.perfDataPayload    = checkoutOptions.perfdata_payload
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a
    /// `git_checkout_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_checkout_options>) throws -> T
    ) throws -> T
    {
        var checkoutOptions = git_checkout_options()
        
        let checkoutOptionsInitResult: GitErrorCode = gitCheckoutOptionsInit(
            opts:       &checkoutOptions,
            version:    version
        )
        
        if checkoutOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        checkoutOptions.checkout_strategy   = checkoutStrategy.rawValue
        checkoutOptions.disable_filters     = disableFilters.int32Value
        checkoutOptions.dir_mode            = dirMode
        checkoutOptions.file_mode           = fileMode
        checkoutOptions.file_open_flags     = fileOpenFlags
        checkoutOptions.notify_flags        = notifyFlags.rawValue
        checkoutOptions.notify_cb           = notifyCB
        checkoutOptions.notify_payload      = notifyPayload
        checkoutOptions.progress_cb         = progressCB
        checkoutOptions.progress_payload    = progressPayload
        checkoutOptions.baseline            = baseline
        checkoutOptions.baseline_index      = baselineIndex
        checkoutOptions.perfdata_cb         = perfDataCB
        checkoutOptions.perfdata_payload    = perfDataPayload
        
        return try paths.withGitStrArray
        {
            cPaths in
            
            checkoutOptions.paths = cPaths.pointee
            
            return try targetDirectory.withOptionalCString
            {
                cTargetDirectory in
                
                checkoutOptions.target_directory = cTargetDirectory
                
                return try ancestorLabel.withOptionalCString
                {
                    cAncestorLabel in
                    
                    checkoutOptions.ancestor_label = cAncestorLabel
                    
                    return try ourLabel.withOptionalCString
                    {
                        cOurLabel in
                        
                        checkoutOptions.our_label = cOurLabel
                        
                        return try theirLabel.withOptionalCString
                        {
                            cTheirLabel in
                            
                            checkoutOptions.their_label = cTheirLabel
                            
                            return try body(&checkoutOptions)
                        }
                    }
                }
            }
        }
    }
}
