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
    /// This initializer handles C string pointers that may be `nil` in cases
    /// where libgit2 returns `nil` for absent or inapplicable values, such as
    /// optional struct fields or context-dependent return values.
    ///
    /// libgit2's nullability annotations in its headers do not always reflect
    /// actual runtime behavior. libgit2 functions annotated as returning
    /// non-`nil` pointers may return `nil` under certain conditions.
    /// For example, `git_annotated_commit_ref()` returns `nil` if the given
    /// commit was created from a revspec.
    ///
    /// - Important: When converting C string pointers to Swift strings,
    /// always use this initializer to prevent runtime crashes, unless an
    /// explicit `guard` statement has been used to verify that the pointer
    /// is not `nil`.
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
