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



/// The options for opening a commit graph writer.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_options`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_options.html)
public struct GitCommitGraphWriterOptions: CStructMutable, ThrowingCConvertible, Sendable
{
    /// The struct version.
    ///
    /// ## Discussion
    ///
    /// The default value is ``gitCommitGraphWriterOptionsVersion``.
    public var version      : UInt32
    
    /// The split stategy.
    ///
    /// ## Discussion
    ///
    /// The default value is
    /// ``GitCommitGraphSplitStrategyT/gitCommitGraphSplitStrategySingleFile``.
    public var splitStategy : GitCommitGraphSplitStrategyT
    
    /// The ratio between consecutive levels.
    ///
    /// ## Discussion
    ///
    /// The default value is `2`.
    ///
    /// The number of commits in level `n` is less than this value times the
    /// number of commits in level `n + 1`.
    public var sizeMultiple : Float
    
    /// The maximum number of commits in a level.
    ///
    /// ## Discussion
    ///
    /// The default value is `64,000`.
    ///
    /// The number of commits in level `n + 1` is more than this value.
    public var maxCommits   : Int
    
    
    
    /// Initializes a ``GitCommitGraphWriterOptions`` instance, optionally
    /// specifying values for its properties.
    public init(
        version         : UInt32                        = gitCommitGraphWriterOptionsVersion,
        splitStategy    : GitCommitGraphSplitStrategyT  = .gitCommitGraphSplitStrategySingleFile,
        sizeMultiple    : Float                         = 2,
        maxCommits      : Int                           = 64_000
    )
    {
        self.version        = version
        self.splitStategy   = splitStategy
        self.sizeMultiple   = sizeMultiple
        self.maxCommits     = maxCommits
    }
    
    
    
    /// Initializes a ``GitCommitGraphWriterOptions`` instance from the given
    /// `git_commit_graph_writer_options` instance.
    /// - Parameter commitGraphWriterOptions: The
    /// `git_commit_graph_writer_options` instance to use.
    internal init(
        cValue commitGraphWriterOptions: git_commit_graph_writer_options
    )
    {
        self.version        = commitGraphWriterOptions.version
        self.splitStategy   = GitCommitGraphSplitStrategyT(
                                cValue: commitGraphWriterOptions.split_strategy
                            ) ?? .gitCommitGraphSplitStrategySingleFile
        self.sizeMultiple   = commitGraphWriterOptions.size_multiple
        self.maxCommits     = commitGraphWriterOptions.max_commits
    }
    
    
    
    /// Converts the ``GitCommitGraphWriterOptions`` instance into a
    /// `git_commit_graph_writer_options` instance.
    /// - Returns: The `git_commit_graph_writer_options` instance.
    /// - Throws: An error if the conversion fails.
    internal func cValue() throws -> git_commit_graph_writer_options
    {
        var commitGraphWriterOptions = git_commit_graph_writer_options()
        
        let commitGraphWriterOptionsInitResult: GitErrorCode
            = gitCommitGraphWriterOptionsInit(
                opts:       &commitGraphWriterOptions,
                version:    version
            )
        
        if commitGraphWriterOptionsInitResult != .gitOK
        {
            throw NSError.makeCConversionError()
        }
        
        commitGraphWriterOptions.split_strategy     = splitStategy.cValue()
        commitGraphWriterOptions.size_multiple      = sizeMultiple
        commitGraphWriterOptions.max_commits        = maxCommits
        
        return commitGraphWriterOptions
    }
}
