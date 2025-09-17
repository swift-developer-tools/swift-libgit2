//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2



/// The description of one side of a diff delta.
///
/// ## Discussion
///
/// Although this is called a "file", it could represent a file, a symbolic link, a submodule commit ID,
/// or even a tree (when tracking type changes or ignored or untracked directories).
///
/// ## C Equivalent
///
/// [`git_diff_file`](https://libgit2.org/docs/reference/main/diff/git_diff_file.html)
public struct GitDiffFile
{
    /// The ID of the item.
    ///
    /// ## Discussion
    ///
    /// If the entry represents an absent side of a diff (for example, the `old_file` of a
    /// ``GitDeltaT/gitDeltaAdded`` delta), then the ID will be all zeros.
    public let id       : GitOID
    
    /// The null-terminated path to the entry relative to the working directory of the repository.
    public let path     : String
    
    /// The size of the entry in bytes.
    public let size     : GitObjectSizeT
    
    /// The flags for the delta object and the file objects on each side of the delta.
    public let flags    : GitDiffFlagT
    
    /// Approximately the `stat() st_mode` value for the item.
    public let mode     : GitFileModeT
    
    // TODO: Replace `GIT_OID_SHA1_HEXSIZE` in documentation.
    /// The known length of the ID field, when converted to a hex string.
    ///
    /// ## Discussion
    ///
    /// This is generally `GIT_OID_SHA1_HEXSIZE`, unless this delta was created from reading
    /// a patch file, in which case it may be abbreviated to something reasonable, like seven characters.
    public let idAbbrev : UInt16
    
    
    
    /// Creates a ``GitDiffFile`` instance from a `git_diff_file` instance.
    /// - Parameter diffFile: The `git_diff_file` instance to use.
    internal init(
        cValue diffFile: git_diff_file
    )
    {
        self.id         = GitOID(cValue: diffFile.id)
        self.path       = String(cString: diffFile.path)
        self.size       = diffFile.size
        self.flags      = GitDiffFlagT(rawValue: diffFile.flags)
        self.idAbbrev   = diffFile.id_abbrev
        
        // TODO: If this becomes a common pattern, `GitFileModeT` should handle it.
        switch diffFile.mode
        {
            case GitFileModeT.gitFileModeUnreadable.rawValue        : self.mode = .gitFileModeUnreadable
            case GitFileModeT.gitFileModeTree.rawValue              : self.mode = .gitFileModeTree
            case GitFileModeT.gitFileModeBlob.rawValue              : self.mode = .gitFileModeBlob
            case GitFileModeT.gitFileModeBlobExecutable.rawValue    : self.mode = .gitFileModeBlobExecutable
            case GitFileModeT.gitFileModeLink.rawValue              : self.mode = .gitFileModeLink
            case GitFileModeT.gitFileModeCommit.rawValue            : self.mode = .gitFileModeCommit
            default                                                 : self.mode = .gitFileModeUnreadable
        }
    }
}



// TODO: Replace `GIT_DIFF_REVERSE` and `git_diff_find_similar()` in documentation.
/// The description of changes to an entry.
///
/// ## Discussion
///
/// A delta is a file pair with old and new versions. The old version may be absent if the file was just
/// created and the new version may be absent if the file was deleted. A diff is mostly just a list of deltas.
///
/// When iterating over a diff, this will be passed to most callbacks and so the contents may be used to
/// understand exactly what has changed.
///
/// ``GitDiffDelta/oldFile`` represents the "from" side of the diff and
/// ``GitDiffDelta/newFile`` represents to "to" side of the diff. What those means depend on
/// the function that was used to generate the diff and is explained below. The `GIT_DIFF_REVERSE`
/// flag may be used to reverse this relationship.
///
/// Although the two sides of the delta are named ``GitDiffDelta/oldFile`` and
/// ``GitDiffDelta/newFile``, they actually may correspond to entries that represent a file,
/// a symbolic link, a submodule commit ID, or even a tree (when tracking type changes or ignored or
/// untracked directories).
///
/// Under some circumstances, in the name of efficiency, not all properties will be filled in, but generally
/// as much as possible will be filled in. For example, ``GitDiffDelta/flags`` may not have either
/// the ``GitDiffFlagT/gitDiffFlagBinary`` or the
/// ``GitDiffFlagT/gitDiffFlagNotBinary`` flag set to avoid examining file contents when no
/// hunk and/or line callbacks are passed in. In this case, the diff iteration process will use the Git attributes
/// for those files.
///
/// ``GitDiffDelta/similarity`` will be zero unless `git_diff_find_similar()` is called,
/// which performs a similarity analysis of files in the diff. That function may be used to perform rename
/// and copy detection, and to split heavily modified files into add/delete pairs. After that call, deltas with
/// a status of ``GitDeltaT/gitDeltaRenamed`` or ``GitDeltaT/gitDeltaCopied`` will
/// have a similarity score between 0 and 100 indicating the similarity between the old version and the
/// new version.
///
/// If `git_diff_find_similar()` is used to find heavily modified files to break, but to not actually
/// break the records, then ``GitDeltaT/gitDeltaModified`` records may have a non-zero
/// similarity score if the self-similarity is below the split threshold. To display this value like core Git,
/// invert the score by subtracting it from 100.
///
/// ## C Equivalent
///
/// [`git_diff_delta`](https://libgit2.org/docs/reference/main/diff/git_diff_delta.html)
public struct GitDiffDelta
{
    /// The type of change described by a diff delta.
    public let status       : GitDeltaT
    
    /// The flags for the delta object and the file objects on each side of the delta.
    public let flags        : GitDiffFlagT
    
    /// The similarity threshold (0 - 100) of the item for ``GitDeltaT/gitDeltaRenamed``
    /// and ``GitDeltaT/gitDeltaCopied`` changes.
    public let similarity   : UInt16
    
    /// The number of files in this delta.
    public let nFiles       : UInt16
    
    /// The old version of the file.
    public let oldFile      : GitDiffFile?
    
    /// The new version of the file.
    public let newFile      : GitDiffFile?
    
    
    
    /// Creates a ``GitDiffDelta`` instance from a `git_diff_delta` instance.
    /// - Parameter diffDelta: The `git_diff_delta` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``GitDiffDelta/status`` defaults to ``GitDeltaT/gitDeltaUnreadable`` if
    /// an unexpected value is encountered, although this should never occur.
    internal init(
        cValue diffDelta: git_diff_delta
    )
    {
        self.status         = GitDeltaT(rawValue: diffDelta.status.rawValue) ?? .gitDeltaUnreadable
        self.flags          = GitDiffFlagT(rawValue: diffDelta.flags)
        self.similarity     = diffDelta.similarity
        self.nFiles         = diffDelta.nfiles
        self.oldFile        = GitDiffFile(cValue: diffDelta.old_file)
        self.newFile        = GitDiffFile(cValue: diffDelta.new_file)
    }
}
