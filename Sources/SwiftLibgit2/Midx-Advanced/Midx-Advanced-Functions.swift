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



/// Creates a new multi-pack index writer.
/// - Parameters:
///   - out: The pointer in which to store the multi-pack index writer. The
///   underlying type must be `git_midx_writer`.
///   - packDir: The path to the directory in which to write the multi-pack
///   index file. The specified directory must contain the `.pack` and `.idx`
///   files.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_midx_writer_new()`](https://libgit2.org/docs/reference/main/sys/midx/git_midx_writer_new.html)
public func gitMidxWriterNew(
    out     : UnsafeMutablePointer<OpaquePointer?>,
    packDir : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_midx_writer_new(
            out,
            packDir
        )
    }
}



/// Frees the memory allocated for the given `git_midx_writer` instance.
/// - Parameter w: The multi-pack index writer to free. The underlying
/// type must be `git_midx_writer`.
///
/// ## C Equivalent
///
/// [`git_midx_writer_free()`](https://libgit2.org/docs/reference/main/sys/midx/git_midx_writer_free.html)
public func gitMidxWriterFree(
    w: OpaquePointer?
)
{
    guard let w: OpaquePointer = w
    else
    {
        return
    }
    
    git_midx_writer_free(w)
}



/// Adds the specified `.idx` file to the given multi-pack index writer.
/// - Parameters:
///   - w: The multi-pack index writer to update. The underlying type must be
///   `git_midx_writer`.
///   - idxPath: The path to `.idx` file to add.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_midx_writer_add()`](https://libgit2.org/docs/reference/main/sys/midx/git_midx_writer_add.html)
public func gitMidxWriterAdd(
    w       : OpaquePointer,
    idxPath : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_midx_writer_add(
            w,
            idxPath
        )
    }
}



/// Writes the specified multi-pack index to a file.
/// - Parameter w: The multi-pack index writer to use. The underlying type
/// must be `git_midx_writer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_midx_writer_commit()`](https://libgit2.org/docs/reference/main/sys/midx/git_midx_writer_commit.html)
public func gitMidxWriterCommit(
    w: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_midx_writer_commit(w)
    }
}



/// Gets the contents of the given multi-pack index writer.
/// - Parameters:
///   - midx: The `Data` instance in which to store the contents of the
///   given multi-pack index writer.
///   - w: The multi-pack index writer to write. The underlying type must be
///   `git_midx_writer`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_midx_writer_dump()`](https://libgit2.org/docs/reference/main/sys/midx/git_midx_writer_dump.html)
public func gitMidxWriterDump(
    midx    : inout Data,
    w       : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return try midx.withMutatingGitBuf
        {
            cMidx in
            
            return git_midx_writer_dump(
                cMidx,
                w
            )
        }
    }
}
