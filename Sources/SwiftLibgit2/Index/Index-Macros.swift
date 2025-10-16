//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// The index name length mask.
///
/// ## C Equivalent
///
/// [`GIT_INDEX_ENTRY_NAMEMASK`](https://libgit2.org/docs/reference/main/index/GIT_INDEX_ENTRY_NAMEMASK.html)
public let gitIndexEntryNameMask: UInt32 = 0x0fff



/// The index entry stage mask.
///
/// ## C Equivalent
///
/// [`GIT_INDEX_ENTRY_STAGEMASK`](https://libgit2.org/docs/reference/main/index/GIT_INDEX_ENTRY_STAGEMASK.html)
public let gitIndexEntryStageMask: UInt32 = 0x3000



/// The index entry stage shift bits.
///
/// ## C Equivalent
///
/// [`GIT_INDEX_ENTRY_STAGESHIFT`](https://libgit2.org/docs/reference/main/index/GIT_INDEX_ENTRY_STAGESHIFT.html)
public let gitIndexEntryStageShift: Int = 12



/// Sets the stage value for the given index entry.
/// - Parameters:
///   - entry: The ``GitIndexEntry`` for which to set the stage.
///   - stage: The stage value (`0` for the main index, or a conflict value).
///
/// ## Discussion
///
/// If `stage` is ``GitIndexStageT/gitIndexStageAny``, this function returns
/// without modifying the given index entry.
///
/// ## C Equivalent
///
/// [`GIT_INDEX_ENTRY_STAGE_SET`](https://libgit2.org/docs/reference/main/index/GIT_INDEX_ENTRY_STAGE_SET.html)
public func gitIndexEntryStageSet(
    entry   : inout GitIndexEntry,
    stage   : GitIndexStageT
)
{
    guard stage != .gitIndexStageAny
    else
    {
        return
    }
    
    /// Clear the existing stage bits (positions 12-13), while preserving
    /// the other bits.
    let clearedFlags: UInt32 = entry.flags.rawValue & ~gitIndexEntryStageMask
    
    /// Use only the last two bits of `stage` and shift to positions 12-13.
    let stageMasked = UInt32(stage.rawValue & 0x03) << gitIndexEntryStageShift
    
    entry.flags = GitIndexEntryFlagT(rawValue: clearedFlags | stageMasked)
}
