//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

internal extension Bool
{
    /// The equivalent C 32-bit signed integer value.
    var cValue: Int32
    {
        self ? 1 : 0
    }
}
