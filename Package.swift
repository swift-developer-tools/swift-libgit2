// swift-tools-version: 6.1

//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import PackageDescription



let package = Package(
    name: "swift-libgit2",
    products:
    [
        .library(
            name:       "SwiftLibgit2",
            targets:    ["SwiftLibgit2"]
        )
    ],
    dependencies:
    [
        .package(
            name:   "swift-libgit2-base",
            path:   "swift-libgit2-base"
        )
    ],
    targets:
    [
        .target(
            name: "SwiftLibgit2",
            dependencies:
            [
                .product(
                    name:       "Clibgit2",
                    package:    "swift-libgit2-base"
                )
            ]
        ),
        
        .testTarget(
            name:           "SwiftLibgit2Tests",
            dependencies:   ["SwiftLibgit2"]
        )
    ]
)
