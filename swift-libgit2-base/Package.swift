// swift-tools-version: 6.1

//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2-base project.
//
// Copyright (c) Margins Technologies LLC.
//
//===----------------------------------------------------------------------===//

import PackageDescription



/// The `swift-libgit2-base` library isn't exposed, since it doesn't do anything.
/// This package only provides access to `Clibgit2`.
let package = Package(
    name: "swift-libgit2-base",
    platforms:
    [
        .iOS(.v15),
        .macOS(.v11)
    ],
    products:
    [
        .library(
            name:       "Clibgit2",
            targets:    ["Clibgit2"]
        )
    ],
    targets:
    [
        /// C API module.
        .target(
            name:           "Clibgit2",
            dependencies:   ["libgit2", "libssh2", "libssl", "libcrypto"]),
        
        /// Binary frameworks.
        .binaryTarget(
            name:   "libgit2",
            path:   "lib/libgit2.zip"
        ),
        .binaryTarget(
            name:   "libssh2",
            path:   "lib/libssh2.zip"
        ),
        .binaryTarget(
            name:   "libssl",
            path:   "lib/libssl.zip"
        ),
        .binaryTarget(
            name:   "libcrypto",
            path:   "lib/libcrypto.zip"
        )
    ]
)
