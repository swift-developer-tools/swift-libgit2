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
    var int32Value: Int32
    {
        return self ? 1 : 0
    }
    
    
    
    /// The equivalent C 8-bit unsigned integer value.
    var uint8Value: UInt8
    {
        return self ? 1 : 0
    }
    
    
    
    /// The equivalent C 32-bit unsigned integer value.
    var uint32Value: UInt32
    {
        return self ? 1 : 0
    }
    
    
    
    /// Creates a `Bool` from a signed 32-bit integer using the C convention
    /// that `0` is `false` and anything else is `true`.
    /// - Parameter cValue: The signed 32-bit integer to use.
    init(
        _ cValue: Int32
    )
    {
        self = cValue != 0
    }
    
    
    
    /// Creates a `Bool` from an unsigned 8-bit integer using the C convention
    /// that `0` is `false` and anything else is `true`.
    /// - Parameter cValue: The unsigned 8-bit integer to use.
    init(
        _ cValue: UInt8
    )
    {
        self = cValue != 0
    }
    
    
    
    /// Creates a `Bool` from an unsigned 32-bit integer using the C convention
    /// that `0` is `false` and anything else is `true`.
    /// - Parameter cValue: The unsigned 32-bit integer to use.
    init(
        _ cValue: UInt32
    )
    {
        self = cValue != 0
    }
    
    
    
    /// Creates a `Bool` from a C character using the C convention that
    /// `0` is `false` and anything else is `true`.
    /// - Parameter cValue: The C character to use.
    init(
        _ cValue: CChar
    )
    {
        self = cValue != 0
    }
}
