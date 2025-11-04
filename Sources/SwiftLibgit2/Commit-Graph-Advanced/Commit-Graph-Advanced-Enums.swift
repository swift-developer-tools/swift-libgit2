//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The strategy when adding a new set of commits to an existing commit graph.
///
/// ## C Equivalent
///
/// [`git_commit_graph_split_strategy_t`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_split_strategy_t.html)
public enum GitCommitGraphSplitStrategyT: UInt32, CEnum
{
    /// Do not split commit graph files, and ignore all other split strategies.
    case gitCommitGraphSplitStrategySingleFile = 0
    
    
    
    /// Initializes a ``GitCommitGraphSplitStrategyT`` instance from the given
    /// `git_commit_graph_split_strategy_t` instance.
    /// - Parameter commitGraphSplitStrategy: The
    /// `git_commit_graph_split_strategy_t` instance to use.
    internal init?(
        cValue commitGraphSplitStrategy: git_commit_graph_split_strategy_t
    )
    {
        switch commitGraphSplitStrategy
        {
            case GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE    : self = .gitCommitGraphSplitStrategySingleFile
            default                                             : return nil
        }
    }
    
    
    
    /// Converts the ``GitCommitGraphSplitStrategyT`` instance into a
    /// `git_commit_graph_split_strategy_t` instance.
    /// - Returns: The `git_commit_graph_split_strategy_t` instance.
    internal func cValue() -> git_commit_graph_split_strategy_t
    {
        switch self
        {
            case .gitCommitGraphSplitStrategySingleFile: return GIT_COMMIT_GRAPH_SPLIT_STRATEGY_SINGLE_FILE
        }
    }
}
