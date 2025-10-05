//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Foundation



extension String
{
    /// Atomically writes the contents of the receiver to the `URL` specified by `url` using UTF-8
    /// encoding. This is a convenience wrapper of `write(to:atomically:encoding:)`.
    /// - Parameter url: The URL to which to write the receiver. Only file URLs are supported.
    /// - Throws: An error if the write operation failed.
    func atomicWrite(
        to url: URL
    ) throws
    {
        try self.write(
            to:             url,
            atomically:     true,
            encoding:       .utf8
        )
    }
}
