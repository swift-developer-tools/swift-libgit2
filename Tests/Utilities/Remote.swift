//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import XCTest
@testable import SwiftLibgit2



/// Remote-related test utilities.
enum Remote
{
    /// Looks up the given remote and validates its properties.
    /// - Parameters:
    ///   - remotePointer: The remote to validate. The underlying type must be
    ///   `git_remote`.
    ///   - repository: The repository containing the given remote.
    ///   - remoteName: The expected remote name.
    ///   - remoteURL: The expected remote URL.
    /// - Throws: An error if an operation fails.
    static func validateRemote(
        _       remotePointer   : OpaquePointer?,
        in      repository      : Repository,
        name    remoteName      : String            = Repository.remoteName,
        url     remoteURL       : String            = Repository.remoteURL
    ) throws
    {
        guard remotePointer != nil
        else
        {
            XCTFail("The remote pointer was nil.")
            return
        }
        
        
        
        var retrievedRemotePointer: OpaquePointer? = nil
        
        defer
        {
            gitRemoteFree(remote: retrievedRemotePointer)
        }
        
        
        
        let remoteLookupResult: GitErrorCode = gitRemoteLookup(
            out:    &retrievedRemotePointer,
            repo:   repository.pointer,
            name:   remoteName
        )
        
        XCTAssertOK(remoteLookupResult)
        
        guard let retrievedRemotePointer
        else
        {
            XCTFail( "The retrieved remote pointer was nil.")
            return
        }
        
        
        
        let retrievedName: String?
            = gitRemoteName(remote: retrievedRemotePointer)
        
        XCTAssertNotNil(retrievedName)
        XCTAssertEqual(retrievedName, remoteName)
        
        
        
        let retrievedURL: String?
            = gitRemoteURL(remote: retrievedRemotePointer)
        
        XCTAssertNotNil(retrievedURL)
        XCTAssertEqual(retrievedURL, remoteURL)
        
        
        
        let ownerPointer: OpaquePointer
            = gitRemoteOwner(remote: retrievedRemotePointer)
        
        XCTAssertEqual(ownerPointer, repository.pointer)
    }
}
