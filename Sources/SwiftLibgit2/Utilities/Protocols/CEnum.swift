//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A type that can be converted to and from a fixed-size integer raw value.
internal protocol CEnum: CConvertible, CMutable, RawValueMutable
    where RawValue: FixedWidthInteger
{
    /// Creates an instance from the equivalent C value.
    ///
    /// This must have an `internal` access level.
    ///
    /// - Parameter cValue: The C value to use.
    init?(
        cValue: C
    )
}
