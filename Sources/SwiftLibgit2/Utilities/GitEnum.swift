//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

/// A sendable type that can be converted to and from an associated fixed-size integer raw value.
internal protocol GitEnum: RawRepresentable, Sendable where RawValue: FixedWidthInteger
{
    /// The equivalent C value.
    associatedtype T
    
    /// Creates an instance from the equivalent C value.
    /// - Parameter cValue: The C value to use.
    ///
    /// ## Discussion
    ///
    /// This initializer should have an `internal` access level.
    init?(
        cValue: T
    )
    
    /// The equivalent C value.
    ///
    /// ## Discussion
    ///
    /// This computed property should have an `internal` access level.
    var cValue: T { get }
}
