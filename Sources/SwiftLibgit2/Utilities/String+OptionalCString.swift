//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

internal extension String
{
    /// Creates a new string from the given optional C string pointer.
    /// - Parameter cString: The optional C string pointer.
    ///
    /// ## Discussion
    ///
    /// Use this initializer to convert C string pointers that may be `nil` due
    /// to zero-initialized fields, optional fields, or error conditions where
    /// libgit2 may not populate string fields.
    ///
    /// Although it is not always strictly necessary, use this initializer
    /// consistently to prevent runtime crashes if assumptions about non-`nil`
    /// strings prove to be incorrect, or if libgit2 behavior changes in
    /// subsequent versions.
    init?(
        optionalCString cString: UnsafePointer<CChar>?
    )
    {
        guard let cString: UnsafePointer<CChar> = cString
        else
        {
            return nil
        }
        
        self.init(cString: cString)
    }
}
