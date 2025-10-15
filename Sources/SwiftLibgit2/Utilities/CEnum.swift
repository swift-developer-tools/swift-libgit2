//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A sendable type that can be converted to and from an associated fixed-size
/// integer raw value.
internal protocol CEnum: CConvertible, CMutable, RawRepresentable, Sendable
    where RawValue: FixedWidthInteger
{
    /// Creates an instance from the equivalent C value.
    /// - Parameter cValue: The C value to use.
    ///
    /// ## Discussion
    ///
    /// This must have an `internal` access level.
    init?(
        cValue: C
    )
}
