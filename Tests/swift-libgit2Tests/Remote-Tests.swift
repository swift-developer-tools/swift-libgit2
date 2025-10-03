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



final class RemoteTests: XCTestCaseStopOnFail
{
    func testGitFetchOptions() throws
    {
        let fetchOptions = GitFetchOptions()
        
        XCTAssertEqual(fetchOptions.version, gitFetchOptionsVersion)
        XCTAssertNil(fetchOptions.callbacks)
        XCTAssertEqual(fetchOptions.prune, .gitFetchPruneUnspecified)
        XCTAssertEqual(fetchOptions.updateFetchHEAD, .gitRemoteUpdateFetchHEAD)
        XCTAssertEqual(fetchOptions.downloadTags, .gitRemoteDownloadTagsAuto)
        XCTAssertNil(fetchOptions.proxyOpts)
        XCTAssertEqual(fetchOptions.depth, .gitFetchDepthFull)
        XCTAssertEqual(fetchOptions.followRedirects, .gitRemoteRedirectNone)
        XCTAssertEqual(fetchOptions.customHeaders, [])
        
        XCTAssertEqual(gitFetchOptionsVersion, UInt32(GIT_FETCH_OPTIONS_VERSION))
        
        try fetchOptions.withCValue
        {
            cFetchOptions in
            
            XCTAssertEqual(cFetchOptions.pointee.version, Int32(gitFetchOptionsVersion))
            XCTAssertNotNil(cFetchOptions.pointee.callbacks)
            XCTAssertEqual(GitFetchPruneT(cValue: cFetchOptions.pointee.prune), .gitFetchPruneUnspecified)
            XCTAssertEqual(GitRemoteUpdateFlags(rawValue: cFetchOptions.pointee.update_fetchhead), .gitRemoteUpdateFetchHEAD)
            XCTAssertEqual(GitRemoteAutoTagOptionT(cValue: cFetchOptions.pointee.download_tags), .gitRemoteDownloadTagsAuto)
            XCTAssertNotNil(cFetchOptions.pointee.proxy_opts)
            XCTAssertEqual(GitFetchDepthT(rawValue: UInt32(cFetchOptions.pointee.depth)), .gitFetchDepthFull)
            XCTAssertEqual(GitRemoteRedirectT(cValue: cFetchOptions.pointee.follow_redirects), .gitRemoteRedirectNone)
            XCTAssertEqual(Array(cFetchOptions.pointee.custom_headers), [])
        }
    }
    
    
    
    func testGitRemoteCallbacks() throws
    {
        let remoteCallbacks = GitRemoteCallbacks()
        
        XCTAssertEqual(remoteCallbacks.version, gitRemoteCallbacksVersion)
        XCTAssertNil(remoteCallbacks.sidebandProgress)
        XCTAssertNil(remoteCallbacks.completion)
        XCTAssertNil(remoteCallbacks.credentials)
        XCTAssertNil(remoteCallbacks.certificateCheck)
        XCTAssertNil(remoteCallbacks.transferProgress)
        XCTAssertNil(remoteCallbacks.updateTips)
        XCTAssertNil(remoteCallbacks.packProgress)
        XCTAssertNil(remoteCallbacks.pushTransferProgress)
        XCTAssertNil(remoteCallbacks.pushUpdateReference)
        XCTAssertNil(remoteCallbacks.pushNegotation)
        XCTAssertNil(remoteCallbacks.transport)
        XCTAssertNil(remoteCallbacks.remoteReady)
        XCTAssertNil(remoteCallbacks.payload)
        XCTAssertNil(remoteCallbacks.resolveURL)
        XCTAssertNil(remoteCallbacks.updateRefs)
        
        let cRemoteCallbacks: git_remote_callbacks = try remoteCallbacks.cValue()
        
        XCTAssertEqual(cRemoteCallbacks.version, gitRemoteCallbacksVersion)
        XCTAssertNil(cRemoteCallbacks.sideband_progress)
        XCTAssertNil(cRemoteCallbacks.completion)
        XCTAssertNil(cRemoteCallbacks.credentials)
        XCTAssertNil(cRemoteCallbacks.certificate_check)
        XCTAssertNil(cRemoteCallbacks.transfer_progress)
        XCTAssertNil(cRemoteCallbacks.update_tips)
        XCTAssertNil(cRemoteCallbacks.pack_progress)
        XCTAssertNil(cRemoteCallbacks.push_transfer_progress)
        XCTAssertNil(cRemoteCallbacks.push_update_reference)
        XCTAssertNil(cRemoteCallbacks.push_negotiation)
        XCTAssertNil(cRemoteCallbacks.transport)
        XCTAssertNil(cRemoteCallbacks.remote_ready)
        XCTAssertNil(cRemoteCallbacks.payload)
        XCTAssertNil(cRemoteCallbacks.resolve_url)
        XCTAssertNil(cRemoteCallbacks.update_refs)
    }
}

