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



/// The options for the apply operation.
///
/// ## C Equivalent
///
/// [`git_apply_options`](https://libgit2.org/docs/reference/main/apply/git_apply_options.html)
public struct GitApplyOptions: CStructMutable, WithCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitApplyOptionsVersion``.
    public var version : UInt32
    
    /// The callback invoked for each delta (file).
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var deltaCB : GitApplyDeltaCB?
    
    /// The callback invoked for each hunk.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var hunkCB  : GitApplyHunkCB?
    
    /// The payload passed to ``deltaCB`` and ``hunkCB``.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var payload : UnsafeMutableRawPointer?
    
    /// The flags to use when applying.
    ///
    /// ## Discussion
    ///
    /// The default value is an empty option set.
    public var flags   : GitApplyFlagsT
    
    
    
    /// Initializes a ``GitApplyOptions`` instance, optionally specifying
    /// values for its properties.
    public init(
        version : UInt32                    = gitApplyOptionsVersion,
        deltaCB : GitApplyDeltaCB?          = nil,
        hunkCB  : GitApplyHunkCB?           = nil,
        payload : UnsafeMutableRawPointer?  = nil,
        flags   : GitApplyFlagsT            = []
    )
    {
        self.version    = version
        self.deltaCB    = deltaCB
        self.hunkCB     = hunkCB
        self.payload    = payload
        self.flags      = flags
    }
    
    
    
    /// Initializes a ``GitApplyOptions`` instance from the given
    /// `git_apply_options` instance.
    /// - Parameter applyOptions: The `git_apply_options` instance to use.
    internal init(
        cValue applyOptions: git_apply_options
    )
    {
        self.version    = applyOptions.version
        self.deltaCB    = applyOptions.delta_cb
        self.hunkCB     = applyOptions.hunk_cb
        self.payload    = applyOptions.payload
        self.flags      = GitApplyFlagsT(rawValue: applyOptions.flags)
    }
    
    
    
    /// Calls the given closure with a mutable pointer to a `git_apply_options`
    /// instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the conversion fails.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_apply_options>) throws -> T
    ) throws -> T
    {
        var applyOptions = git_apply_options()
        
        let applyOptionsInitResult: GitErrorCode = gitApplyOptionsInit(
            opts:       &applyOptions,
            version:    version
        )
        
        if applyOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        applyOptions.delta_cb   = deltaCB
        applyOptions.hunk_cb    = hunkCB
        applyOptions.payload    = payload
        applyOptions.flags      = flags.rawValue
        
        return try body(&applyOptions)
    }
}
