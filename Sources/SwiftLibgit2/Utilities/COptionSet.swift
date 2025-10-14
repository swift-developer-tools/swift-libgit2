//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A sendable type that presents a mathematical set interface to a bitset.
internal protocol COptionSet: CConvertible, CStruct, OptionSet, Sendable
    where RawValue == UInt32
{
    /// Creates an instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    ///
    /// ## Discussion
    ///
    /// This must have a `public` access level.
    init(
        rawValue: UInt32
    )
}
