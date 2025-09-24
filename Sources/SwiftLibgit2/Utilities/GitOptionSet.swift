//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A sendable type that presents a mathematical set interface to a bit set.
internal protocol GitOptionSet: OptionSet, Sendable where RawValue == UInt32
{
    /// The equivalent C value.
    associatedtype T
    
    /// Creates an instance from a raw value.
    /// - Parameter rawValue: The raw value to use.
    init(
        rawValue: UInt32
    )
    
    /// The equivalent C value.
    var cValue: T { get }
}
