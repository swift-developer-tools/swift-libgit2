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
        XCTAssertNotNil(fetchOptions.callbacks)
        XCTAssertEqual(fetchOptions.prune, .gitFetchPruneUnspecified)
        XCTAssertEqual(fetchOptions.updateFETCHHEAD, [])
        XCTAssertEqual(fetchOptions.downloadTags, .gitRemoteDownloadTagsAuto)
        XCTAssertNotNil(fetchOptions.proxyOpts)
        XCTAssertEqual(fetchOptions.depth, .gitFetchDepthFull)
        XCTAssertEqual(fetchOptions.followRedirects, .gitRemoteRedirectNone)
        XCTAssertEqual(fetchOptions.customHeaders, [])
        
        try fetchOptions.withCValue
        {
            cFetchOptions in
            
            XCTAssertEqual(cFetchOptions.pointee.version, gitFetchOptionsVersion)
            XCTAssertNotNil(cFetchOptions.pointee.callbacks)
            XCTAssertEqual(GitFetchPruneT(cValue: cFetchOptions.pointee.prune), .gitFetchPruneUnspecified)
            XCTAssertEqual(GitRemoteUpdateFlags(rawValue: cFetchOptions.pointee.update_fetchhead), [])
            XCTAssertEqual(GitRemoteAutoTagOptionT(cValue: cFetchOptions.pointee.download_tags), .gitRemoteDownloadTagsAuto)
            XCTAssertNotNil(cFetchOptions.pointee.proxy_opts)
            XCTAssertEqual(GitFetchDepthT(rawValue: UInt32(cFetchOptions.pointee.depth)), .gitFetchDepthFull)
            XCTAssertEqual(GitRemoteRedirectT(cValue: cFetchOptions.pointee.follow_redirects), .gitRemoteRedirectNone)
            XCTAssertEqual(Array(cFetchOptions.pointee.custom_headers), [])
        }
    }
    
    
    
    func testGitFetchOptionsInit() throws
    {
        var fetchOptions = git_fetch_options()
        
        let fetchOptionsInitResult: GitErrorCode = gitFetchOptionsInit(
            opts:       &fetchOptions,
            version:    UInt32(gitFetchOptionsVersion)
        )
        
        XCTAssertOK(fetchOptionsInitResult)
    }
    
    
    
    func testGitFetchOptionsVersion() throws
    {
        XCTAssertEqual(gitFetchOptionsVersion, GIT_FETCH_OPTIONS_VERSION)
    }
    
    
    
    func testGitPushOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitPushOptionsVersion), GIT_PUSH_OPTIONS_VERSION)
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
    
    
    
    func testGitRemoteCallbacksVersion() throws
    {
        XCTAssertEqual(Int32(gitRemoteCallbacksVersion), GIT_REMOTE_CALLBACKS_VERSION)
    }
    
    
    
    func testGitRemoteConnectOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitRemoteConnectOptionsVersion), GIT_REMOTE_CONNECT_OPTIONS_VERSION)
    }
    
    
    
    func testGitRemoteCreateOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitRemoteCreateOptionsVersion), GIT_REMOTE_CREATE_OPTIONS_VERSION)
    }
}

