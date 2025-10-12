//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// The callback invoked when iterating notes.
/// - Parameters:
///   - blobID: The ID of the blob containing the message.
///   - annotatedObjectID: The ID of the object being annotated.
///   - payload: The payload provided by the caller.
/// - Returns: `0` on success, or an error code.
///
/// ## C Equivalent
///
/// [`git_note_foreach_cb()`](https://libgit2.org/docs/reference/main/notes/git_note_foreach_cb.html)
public typealias GitNoteForEachCB = @convention(c)
(
    UnsafePointer<git_oid>?,
    UnsafePointer<git_oid>?,
    UnsafeMutableRawPointer?
) -> Int32
