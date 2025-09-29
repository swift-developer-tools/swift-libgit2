//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The reference lookup strategy.
///
/// ## C Equivalent
///
/// [`git_describe_strategy_t`](https://libgit2.org/docs/reference/main/describe/git_describe_strategy_t.html)
public enum GitDescribeStrategyT: UInt32, GitEnum
{
    /// Show any annotated tag reference.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git-describe`.
    case gitDescribeDefault     = 0
    
    /// Show any reference in the `refs/tags/` namespace.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git-describe --tags`
    case gitDescribeTags        = 1
    
    /// Show any reference in the `refs/` namespace.
    ///
    /// ## Discussion
    ///
    /// This is equivalent to `git-describe --all`
    case gitDescribeAll         = 2
    
    
    
    /// Creates a ``GitDescribeStrategyT`` instance from a `git_describe_strategy_t`
    /// instance.
    /// - Parameter describeStrategy: The `git_describe_strategy_t` instance to use.
    internal init?(
        cValue describeStrategy: git_describe_strategy_t
    )
    {
        switch describeStrategy
        {
            case GIT_DESCRIBE_DEFAULT   : self = .gitDescribeDefault
            case GIT_DESCRIBE_TAGS      : self = .gitDescribeTags
            case GIT_DESCRIBE_ALL       : self = .gitDescribeAll
            default                     : return nil
        }
    }
    
    
    
    /// Creates a ``GitDescribeStrategyT`` instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    /// - Returns: The equivalent ``GitDescribeStrategyT`` instance.
    ///
    /// ## Discussion
    ///
    /// This method is necessary since `git_describe_options->describe_strategy`
    /// does not use the `git_describe_strategy_t` type, but uses `unsigned int` instead.
    ///
    /// This is a factory method  instead of an initializer since `init(rawValue:)` matches a
    /// requirement in the public `RawRepresentable` protocol, and the initializer would need to be
    /// public as well. ``GitEnum`` initializers are required to be internal.
    internal static func makeStrategy(
        rawValue: UInt32
    ) -> GitDescribeStrategyT?
    {
        switch rawValue
        {
            case GIT_DESCRIBE_DEFAULT.rawValue  : return .gitDescribeDefault
            case GIT_DESCRIBE_TAGS.rawValue     : return .gitDescribeTags
            case GIT_DESCRIBE_ALL.rawValue      : return .gitDescribeAll
            default                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitDescribeStrategyT`` instance into a `git_describe_strategy_t`
    /// instance.
    /// - Returns: The `git_describe_strategy_t` instance.
    internal func cValue() -> git_describe_strategy_t
    {
        switch self
        {
            case .gitDescribeDefault    : return GIT_DESCRIBE_DEFAULT
            case .gitDescribeTags       : return GIT_DESCRIBE_TAGS
            case .gitDescribeAll        : return GIT_DESCRIBE_ALL
        }
    }
}
