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



/// Opens and validates a commit graph from the specified objects directory.
/// - Parameters:
///   - cGraphOut: The pointer in which to store the commit graph. The
///   underlying type must be `git_commit_graph`.
///   - objectsDir: The path to the objects directory from which to open the
///   commit graph.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_graph_open()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_open.html)
public func gitCommitGraphOpen(
    cGraphOut   : UnsafeMutablePointer<OpaquePointer?>,
    objectsDir  : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_graph_open(
            cGraphOut,
            objectsDir
        )
    }
}



/// Frees the memory allocated for the given `git_commit_graph` instance.
/// - Parameter cGraph: The commit graph to free. The underlying type must
/// be `git_commit_graph`.
///
/// ## Discussion
///
/// - Important: This function must be used only when the memory allocated
/// using ``gitCommitGraphOpen(cGraphOut:objectsDir:)`` is not returned to
/// libgit2, because it was not associated with the object database through
/// a successful call to ``gitODBSetCommitGraph(odb:cGraph:)``.
///
/// ## C Equivalent
///
/// [`git_commit_graph_free()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_free.html)
public func gitCommitGraphFree(
    cGraph: OpaquePointer?
)
{
    guard let cGraph: OpaquePointer = cGraph
    else
    {
        return
    }
    
    git_commit_graph_free(cGraph)
}



/// Initializes the given `git_commit_graph_writer_options` instance.
/// - Parameters:
///   - opts: The `git_commit_graph_writer_options` instance to initialize.
///   - version: The version to use. Pass ``gitCommitGraphWriterOptionsVersion``.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_options_init()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_options_init.html)
public func gitCommitGraphWriterOptionsInit(
    opts    : UnsafeMutablePointer<git_commit_graph_writer_options>,
    version : UInt32
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_graph_writer_options_init(
            opts,
            version
        )
    }
}



/// Creates a new commit graph writer.
/// - Parameters:
///   - out: The pointer in which to store the commit graph writer. The
///   underlying type must be `git_commit_graph_writer`.
///   - objectsInfoDir: The path to the objects information directory in which
///   to write the commit graph files.
///   - options: The commit graph writer options to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_new()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_new.html)
public func gitCommitGraphWriterNew(
    out             : UnsafeMutablePointer<OpaquePointer?>,
    objectsInfoDir  : String,
    options         : GitCommitGraphWriterOptions?
) -> GitErrorCode
{
    return withCConversion
    {
        return try options.withOptionalCValue
        {
            cOptions in
            
            return git_commit_graph_writer_new(
                out,
                objectsInfoDir,
                cOptions
            )
        }
    }
}



/// Frees the memory allocated for the given `git_commit_graph_writer` instance.
/// - Parameter w: The commit graph writer to free. The underlying type must
/// be `git_commit_graph_writer`.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_free()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_free.html)
public func gitCommitGraphWriterFree(
    w: OpaquePointer?
)
{
    guard let w: OpaquePointer = w
    else
    {
        return
    }
    
    git_commit_graph_writer_free(w)
}



/// Adds the specified index file to the given commit graph writer.
/// - Parameters:
///   - w: The commit graph writer to update. The underlying type must be
///   `git_commit_graph_writer`.
///   - repo: The repository containing the index file. The underlying type
///   must be `git_repository`.
///   - idxPath: The path to the index file to add.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_add_index_file()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_add_index_file.html)
public func gitCommitGraphWriterAddIndexFile(
    w       : OpaquePointer,
    repo    : OpaquePointer,
    idxPath : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_graph_writer_add_index_file(
            w,
            repo,
            idxPath
        )
    }
}



/// Adds the given revision walker to the given commit graph writer.
/// - Parameters:
///   - w: The commit graph writer to update. The underlying type must be
///   `git_commit_graph_writer`.
///   - walk: The revision walker to add. The underlying type must be
///   `git_revwalk`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_add_revwalk()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_add_revwalk.html)
public func gitCommitGraphWriterAddRevwalk(
    w       : OpaquePointer,
    walk    : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_graph_writer_add_revwalk(
            w,
            walk
        )
    }
}



/// Writes the given commit graph writer to a file.
/// - Parameter w: The commit graph writer to write. The underlying type must
/// be `git_commit_graph_writer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_commit()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_commit.html)
public func gitCommitGraphWriterCommit(
    w: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_commit_graph_writer_commit(w)
    }
}



/// Writes the contents of the given commit graph writer to the given buffer.
/// - Parameters:
///   - buffer: The `Data` instance in which to store the contents of the
///   given commit graph writer.
///   - w: The commit graph writer to write.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_commit_graph_writer_dump()`](https://libgit2.org/docs/reference/main/sys/commit_graph/git_commit_graph_writer_dump.html)
public func gitCommitGraphWriterDump(
    buffer  : inout Data,
    w       : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try buffer.withMutatingGitBuf
        {
            cBuffer in
            
            return git_commit_graph_writer_dump(
                cBuffer,
                w
            )
        }
    }
}
