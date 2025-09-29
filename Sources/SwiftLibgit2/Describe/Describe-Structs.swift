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



/// The options for describing a commit.
///
/// ## C Equivalent
///
/// [`git_describe_options`](https://libgit2.org/docs/reference/main/describe/git_describe_options.html)
public struct GitDescribeOptions: GitStructMutable, WithThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDescribeOptionsVersion``.
    public var version                  : UInt32                = gitDescribeOptionsVersion
    
    /// The maximum number of candidate tags.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDescribeDefaultMaxCandidatesTags``.
    public var maxCandidatesTags        : UInt32                = gitDescribeDefaultMaxCandidatesTags
    
    /// The reference lookup strategy.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitDescribeStrategyT/gitDescribeDefault``.
    public var describeStrategy         : GitDescribeStrategyT  = .gitDescribeDefault
    
    /// The pattern to match.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var pattern                  : String?               = nil
    
    /// Whether to walk down only the first parent's ancestry when calculating the distance from
    /// the matching tag or reference.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var onlyFollowFirstParent    : Bool                  = false
    
    /// Whether the full commit ID should be shown if no matching tag or reference is found.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    ///
    /// The describe operation will fail if this is `false` and no matching tag or reference is found.
    public var showCommitOIDAsFallback  : Bool                  = false
    
    
    
    /// Creates a ``GitDescribeOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitDescribeOptions`` instance from a `git_describe_options` instance.
    /// - Parameter describeOptions: The `git_describe_options` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``describeStrategy`` defaults to ``GitDescribeStrategyT/gitDescribeDefault``
    /// if an unexpected value is encountered, although this should never occur.
    internal init(
        cValue describeOptions: git_describe_options
    )
    {
        self.version                    = describeOptions.version
        self.maxCandidatesTags          = describeOptions.max_candidates_tags
        self.describeStrategy           = GitDescribeStrategyT.makeStrategy(rawValue: describeOptions.describe_strategy) ?? .gitDescribeDefault
        self.pattern                    = String(optionalCString: describeOptions.pattern)
        self.onlyFollowFirstParent      = Bool(describeOptions.only_follow_first_parent)
        self.showCommitOIDAsFallback    = Bool(describeOptions.show_commit_oid_as_fallback)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_describe_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_describe_options>) throws -> T
    ) throws -> T
    {
        var describeOptions = git_describe_options()
        
        let describeOptionsInitResult: Int32 = git_describe_options_init(
            &describeOptions,
            version
        )
        
        if describeOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.makeCConversionError()
        }
        
        describeOptions.max_candidates_tags             = maxCandidatesTags
        describeOptions.describe_strategy               = describeStrategy.rawValue
        describeOptions.only_follow_first_parent        = onlyFollowFirstParent.cValue()
        describeOptions.show_commit_oid_as_fallback     = showCommitOIDAsFallback.cValue()
        
        return try pattern.withOptionalCString
        {
            cPattern in
            
            describeOptions.pattern = cPattern
            
            return try body(&describeOptions)
        }
    }
}



/// The options for formatting commit descriptions.
///
/// ## C Equivalent
///
/// [`git_describe_format_options`](https://libgit2.org/docs/reference/main/describe/git_describe_format_options.html)
public struct GitDescribeFormatOptions: GitStructMutable, WithThrowingCConvertible
{
    /// The version to use.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDescribeFormatOptionsVersion``.
    public var version              : UInt32    = gitDescribeFormatOptionsVersion
    
    /// The lower bound of the size of the abbreviated commit ID.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitDescribeDefaultAbbreviatedSize``.
    public var abbreviatedSize      : UInt32    = gitDescribeDefaultAbbreviatedSize
    
    /// Whether the long format should always be used even when a shorter name is possible.
    ///
    /// ## Discussion
    ///
    /// The default value is `false`.
    public var alwaysUseLongFormat  : Bool      = false
    
    /// The suffix to append to the description if the working directory is dirty.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    public var dirtySuffix          : String?   = nil
    
    
    
    /// Creates a ``GitDescribeFormatOptions`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitDescribeFormatOptions`` instance from a
    /// `git_describe_format_options` instance.
    /// - Parameter describeFormatOptions: The `git_describe_format_options`
    /// instance to use.
    internal init(
        cValue describeFormatOptions: git_describe_format_options
    )
    {
        self.version                = describeFormatOptions.version
        self.abbreviatedSize        = describeFormatOptions.abbreviated_size
        self.alwaysUseLongFormat    = Bool(describeFormatOptions.always_use_long_format)
        self.dirtySuffix            = String(optionalCString: describeFormatOptions.dirty_suffix)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_describe_format_options` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `NSError` if the conversion failed.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_describe_format_options>) throws -> T
    ) throws -> T
    {
        var describeFormatOptions = git_describe_format_options()
        
        let describeFormatOptionsInitResult: Int32 = git_describe_format_options_init(
            &describeFormatOptions,
            version
        )
        
        if describeFormatOptionsInitResult != GIT_OK.rawValue
        {
            throw NSError.makeCConversionError()
        }
        
        describeFormatOptions.abbreviated_size          = abbreviatedSize
        describeFormatOptions.always_use_long_format    = alwaysUseLongFormat.cValue()
        
        return try dirtySuffix.withOptionalCString
        {
            cDirtySuffix in
            
            describeFormatOptions.dirty_suffix = cDirtySuffix
            
            return try body(&describeFormatOptions)
        }
    }
}
