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



/// Tests for Remote bindings.
///
/// ## Discussion
///
/// The remote URLs used in these tests are not actual Git repositories.
/// Connection attempts and operations that depend on a connected remote
/// are expected to fail.
final class RemoteTests: XCTestCaseStopOnFail
{
    func testGitFetchDepthT() throws
    {
        XCTAssertEqual(GitFetchDepthT.gitFetchDepthFull.rawValue, GIT_FETCH_DEPTH_FULL.rawValue)
        XCTAssertEqual(GitFetchDepthT.gitFetchDepthUnshallow.rawValue, GIT_FETCH_DEPTH_UNSHALLOW.rawValue)
        
        XCTAssertNil(GitFetchDepthT(rawValue: 123))
        
        XCTAssertEqual(GitFetchDepthT.gitFetchDepthFull.cValue(), GIT_FETCH_DEPTH_FULL)
        XCTAssertEqual(GitFetchDepthT.gitFetchDepthUnshallow.cValue(), GIT_FETCH_DEPTH_UNSHALLOW)
        
        XCTAssertEqual(GitFetchDepthT(cValue: GIT_FETCH_DEPTH_FULL), .gitFetchDepthFull)
        XCTAssertEqual(GitFetchDepthT(cValue: GIT_FETCH_DEPTH_UNSHALLOW), .gitFetchDepthUnshallow)
    }
    
    
    
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
    
    
    
    func testGitFetchPruneT() throws
    {
        XCTAssertEqual(GitFetchPruneT.gitFetchPruneUnspecified.rawValue, GIT_FETCH_PRUNE_UNSPECIFIED.rawValue)
        XCTAssertEqual(GitFetchPruneT.gitFetchPrune.rawValue, GIT_FETCH_PRUNE.rawValue)
        XCTAssertEqual(GitFetchPruneT.gitFetchNoPrune.rawValue, GIT_FETCH_NO_PRUNE.rawValue)
        
        XCTAssertNil(GitFetchPruneT(rawValue: 123))
        
        XCTAssertEqual(GitFetchPruneT.gitFetchPruneUnspecified.cValue(), GIT_FETCH_PRUNE_UNSPECIFIED)
        XCTAssertEqual(GitFetchPruneT.gitFetchPrune.cValue(), GIT_FETCH_PRUNE)
        XCTAssertEqual(GitFetchPruneT.gitFetchNoPrune.cValue(), GIT_FETCH_NO_PRUNE)
        
        XCTAssertEqual(GitFetchPruneT(cValue: GIT_FETCH_PRUNE_UNSPECIFIED), .gitFetchPruneUnspecified)
        XCTAssertEqual(GitFetchPruneT(cValue: GIT_FETCH_PRUNE), .gitFetchPrune)
        XCTAssertEqual(GitFetchPruneT(cValue: GIT_FETCH_NO_PRUNE), .gitFetchNoPrune)
    }
    
    
    
    func testGitPushOptions() throws
    {
        let pushOptions = GitPushOptions()
        
        XCTAssertEqual(pushOptions.version, gitPushOptionsVersion)
        XCTAssertTrue(pushOptions.pbParallelism)
        XCTAssertNotNil(pushOptions.callbacks)
        XCTAssertNotNil(pushOptions.proxyOpts)
        XCTAssertEqual(pushOptions.followRedirects, .gitRemoteRedirectNone)
        XCTAssertEqual(pushOptions.customHeaders, [])
        XCTAssertEqual(pushOptions.remotePushOptions, [])
        
        try pushOptions.withCValue
        {
            cPushOptions in
            
            XCTAssertEqual(cPushOptions.pointee.version, gitPushOptionsVersion)
            XCTAssertTrue(Bool(cPushOptions.pointee.pb_parallelism))
            XCTAssertNotNil(cPushOptions.pointee.callbacks)
            XCTAssertNotNil(cPushOptions.pointee.proxy_opts)
            XCTAssertEqual(GitRemoteRedirectT(cValue: cPushOptions.pointee.follow_redirects), .gitRemoteRedirectNone)
            XCTAssertEqual(Array(cPushOptions.pointee.custom_headers), [])
            XCTAssertEqual(Array(cPushOptions.pointee.remote_push_options), [])
        }
    }
    
    
    
    func testGitPushOptionsInit() throws
    {
        var pushOptions = git_push_options()
        
        let pushOptionsInitResult: GitErrorCode = gitPushOptionsInit(
            opts:       &pushOptions,
            version:    gitPushOptionsVersion
        )
        
        XCTAssertOK(pushOptionsInitResult)
    }
    
    
    
    func testGitPushOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitPushOptionsVersion), GIT_PUSH_OPTIONS_VERSION)
    }
    
    
    
    func testGitPushUpdate() throws
    {
        let pushUpdate = GitPushUpdate()
        
        XCTAssertNil(pushUpdate.srcRefName)
        XCTAssertNil(pushUpdate.dstRefName)
        XCTAssertZeroOID(pushUpdate.src)
        XCTAssertZeroOID(pushUpdate.dst)
        
        try pushUpdate.withCValue
        {
            cPushUpdate in
            
            XCTAssertNil(cPushUpdate.pointee.src_refname)
            XCTAssertNil(cPushUpdate.pointee.dst_refname)
            XCTAssertZeroOID(GitOID(cValue: cPushUpdate.pointee.src))
            XCTAssertZeroOID(GitOID(cValue: cPushUpdate.pointee.dst))
        }
    }
    
    
    
    func testGitRemoteAddFetch() throws
    {
        try withRemotePointer(type: .fetchspec)
        {
            repository, _ in
            
            let remoteAddFetchResult: GitErrorCode = gitRemoteAddFetch(
                repo:       repository.pointer,
                remote:     Self.remoteName,
                refspec:    "refs/heads/*:refs/remotes/something/*"
            )
            
            XCTAssertOK(remoteAddFetchResult)
        }
    }
    
    
    
    func testGitRemoteAddPushAndGetPushRefspecs() throws
    {
        try withRemotePointer
        {
            repository, _ in
            
            let remoteAddPushResult: GitErrorCode = gitRemoteAddPush(
                repo:       repository.pointer,
                remote:     Self.remoteName,
                refspec:    Repository.pushRefspec
            )
            
            XCTAssertOK(remoteAddPushResult)
            
            
            
            var remotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: remotePointer)
            }
            
            
            
            let remoteLookupResult: GitErrorCode = gitRemoteLookup(
                out:    &remotePointer,
                repo:   repository.pointer,
                name:   Self.remoteName
            )
            
            XCTAssertOK(remoteLookupResult)
            
            guard let remotePointer: OpaquePointer = remotePointer
            else
            {
                XCTFail("The remote pointer was nil.")
                return
            }
            
            
            
            var pushRefspecs: [String] = []
            
            let getPushRefspecsResult: GitErrorCode
                = gitRemoteGetPushRefspecs(
                    array:      &pushRefspecs,
                    remote:     remotePointer
                )
            
            XCTAssertOK(getPushRefspecsResult)
            XCTAssertGreaterThanOrEqual(pushRefspecs.count, 1)
            XCTAssertTrue(pushRefspecs.contains(Repository.pushRefspec))
        }
    }
    
    
    
    func testGitRemoteAutoTag() throws
    {
        try withRemotePointer
        {
            repository, _ in
            
            let remoteSetAutoTagResult: GitErrorCode = gitRemoteSetAutoTag(
                repo:       repository.pointer,
                remote:     Self.remoteName,
                value:      .gitRemoteDownloadTagsAll
            )
            
            XCTAssertOK(remoteSetAutoTagResult)
            
            
            
            var remotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: remotePointer)
            }
            
            
            
            let remoteLookupResult: GitErrorCode = gitRemoteLookup(
                out:    &remotePointer,
                repo:   repository.pointer,
                name:   Self.remoteName
            )
            
            XCTAssertOK(remoteLookupResult)
            
            guard let remotePointer: OpaquePointer = remotePointer
            else
            {
                XCTFail("The remote pointer was nil.")
                return
            }
            
            
            
            let remoteAutoTagOption: GitRemoteAutoTagOptionT?
                = gitRemoteAutoTag(remote: remotePointer)
            
            XCTAssertNotNil(remoteAutoTagOption)
            XCTAssertEqual(remoteAutoTagOption, .gitRemoteDownloadTagsAll)
        }
    }
    
    
    
    func testGitRemoteAutoTagOptionT() throws
    {
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsUnspecified.rawValue, GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED.rawValue)
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsAuto.rawValue, GIT_REMOTE_DOWNLOAD_TAGS_AUTO.rawValue)
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsNone.rawValue, GIT_REMOTE_DOWNLOAD_TAGS_NONE.rawValue)
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsAll.rawValue, GIT_REMOTE_DOWNLOAD_TAGS_ALL.rawValue)
        
        XCTAssertNil(GitRemoteAutoTagOptionT(rawValue: 123))
        
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsUnspecified.cValue(), GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED)
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsAuto.cValue(), GIT_REMOTE_DOWNLOAD_TAGS_AUTO)
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsNone.cValue(), GIT_REMOTE_DOWNLOAD_TAGS_NONE)
        XCTAssertEqual(GitRemoteAutoTagOptionT.gitRemoteDownloadTagsAll.cValue(), GIT_REMOTE_DOWNLOAD_TAGS_ALL)
        
        XCTAssertEqual(GitRemoteAutoTagOptionT(cValue: GIT_REMOTE_DOWNLOAD_TAGS_UNSPECIFIED), .gitRemoteDownloadTagsUnspecified)
        XCTAssertEqual(GitRemoteAutoTagOptionT(cValue: GIT_REMOTE_DOWNLOAD_TAGS_AUTO), .gitRemoteDownloadTagsAuto)
        XCTAssertEqual(GitRemoteAutoTagOptionT(cValue: GIT_REMOTE_DOWNLOAD_TAGS_NONE), .gitRemoteDownloadTagsNone)
        XCTAssertEqual(GitRemoteAutoTagOptionT(cValue: GIT_REMOTE_DOWNLOAD_TAGS_ALL), .gitRemoteDownloadTagsAll)
    }
    
    
    
    func testGitRemoteCallbackInvocations() throws
    {
        let pushTransferProgressCB: GitPushTransferProgressCB =
        {
            _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let pushTransferCBResult: Int32 = pushTransferProgressCB(
            0,
            0,
            0,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: pushTransferCBResult))
        
        
        
        let pushNegotiationCB: GitPushNegotiationCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let pushNegotiationCBResult: Int32 = pushNegotiationCB(
            nil,
            0,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: pushNegotiationCBResult))
        
        
        
        let pushUpdateReferenceCB: GitPushUpdateReferenceCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let pushUpdateReferenceCBResult: Int32 = pushUpdateReferenceCB(
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: pushUpdateReferenceCBResult))
        
        
        
        let urlResolveCB: GitURLResolveCB =
        {
            _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let urlResolveCBResult: Int32 = urlResolveCB(
            nil,
            nil,
            0,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: urlResolveCBResult))
        
        
        
        let remoteReadyCB: GitRemoteReadyCB =
        {
            _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let remoteReadyCBResult: Int32 = remoteReadyCB(
            nil,
            0,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: remoteReadyCBResult))
        
        
        
        let remoteCompletionCB: GitRemoteCallbacks.CompletionCB =
        {
            _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let remoteCompletionCBResult: Int32 = remoteCompletionCB(
            GIT_REMOTE_COMPLETION_DOWNLOAD,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: remoteCompletionCBResult))
        
        
        
        let remoteUpdateTipsCB: GitRemoteCallbacks.UpdateTipsCB =
        {
            _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let remoteUpdateTipsCBResult: Int32 = remoteUpdateTipsCB(
            nil,
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: remoteUpdateTipsCBResult))
        
        
        
        let remoteUpdateRefsCB: GitRemoteCallbacks.UpdateRefsCB =
        {
            _, _, _, _, _ in
            
            return GitErrorCode.gitOK.rawValue
        }
        
        let remoteUpdateRefsCBResult: Int32 = remoteUpdateRefsCB(
            nil,
            nil,
            nil,
            nil,
            nil
        )
        
        XCTAssertOK(GitErrorCode(rawValue: remoteUpdateRefsCBResult))
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
    
    
    
    func testGitRemoteCompletionT() throws
    {
        XCTAssertEqual(GitRemoteCompletionT.gitRemoteCompletionDownload.rawValue, GIT_REMOTE_COMPLETION_DOWNLOAD.rawValue)
        XCTAssertEqual(GitRemoteCompletionT.gitRemoteCompletionIndexing.rawValue, GIT_REMOTE_COMPLETION_INDEXING.rawValue)
        XCTAssertEqual(GitRemoteCompletionT.gitRemoteCompletionError.rawValue, GIT_REMOTE_COMPLETION_ERROR.rawValue)
        
        XCTAssertNil(GitRemoteCompletionT(rawValue: 123))
        
        XCTAssertEqual(GitRemoteCompletionT.gitRemoteCompletionDownload.cValue(), GIT_REMOTE_COMPLETION_DOWNLOAD)
        XCTAssertEqual(GitRemoteCompletionT.gitRemoteCompletionIndexing.cValue(), GIT_REMOTE_COMPLETION_INDEXING)
        XCTAssertEqual(GitRemoteCompletionT.gitRemoteCompletionError.cValue(), GIT_REMOTE_COMPLETION_ERROR)
        
        XCTAssertEqual(GitRemoteCompletionT(cValue: GIT_REMOTE_COMPLETION_DOWNLOAD), .gitRemoteCompletionDownload)
        XCTAssertEqual(GitRemoteCompletionT(cValue: GIT_REMOTE_COMPLETION_INDEXING), .gitRemoteCompletionIndexing)
        XCTAssertEqual(GitRemoteCompletionT(cValue: GIT_REMOTE_COMPLETION_ERROR), .gitRemoteCompletionError)
    }
    
    
    
    func testGitRemoteConnectAndDefaultBranch() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteConnectResult: GitErrorCode = gitRemoteConnect(
                remote:         remotePointer,
                direction:      .gitDirectionFetch,
                callbacks:      GitRemoteCallbacks(),
                proxyOpts:      nil,
                customHeaders:  []
            )
            
            XCTAssertEqual(remoteConnectResult, .gitECertificate)
            
            
            
            let remoteIsConnected: Bool
                = gitRemoteConnected(remote: remotePointer)
            
            XCTAssertFalse(remoteIsConnected)
            
            
            
            var defaultBranchData = Data()
            
            let remoteDefaultBranchResult: GitErrorCode
                = gitRemoteDefaultBranch(
                    out:        &defaultBranchData,
                    remote:     remotePointer
                )
            
            XCTAssertNeverConnected(remoteDefaultBranchResult)
        }
    }
    
    
    
    func testGitRemoteConnectExt() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteConnectExtResult: GitErrorCode = gitRemoteConnectExt(
                remote:     remotePointer,
                direction:  .gitDirectionFetch,
                opts:       nil
            )
            
            XCTAssertEqual(remoteConnectExtResult, .gitECertificate)
            
            
            
            let remoteIsConnected: Bool
                = gitRemoteConnected(remote: remotePointer)
            
            XCTAssertFalse(remoteIsConnected)
        }
    }
    
    
    
    func testGitRemoteConnectOptions() throws
    {
        let remoteConnectOptions = GitRemoteConnectOptions()
        
        XCTAssertEqual(remoteConnectOptions.version, gitPushOptionsVersion)
        XCTAssertNotNil(remoteConnectOptions.callbacks)
        XCTAssertNotNil(remoteConnectOptions.proxyOpts)
        XCTAssertEqual(remoteConnectOptions.followRedirects, .gitRemoteRedirectNone)
        XCTAssertEqual(remoteConnectOptions.customHeaders, [])
        
        try remoteConnectOptions.withCValue
        {
            cRemoteConnectOptions in
            
            XCTAssertEqual(cRemoteConnectOptions.pointee.version, gitPushOptionsVersion)
            XCTAssertNotNil(cRemoteConnectOptions.pointee.callbacks)
            XCTAssertNotNil(cRemoteConnectOptions.pointee.proxy_opts)
            XCTAssertEqual(GitRemoteRedirectT(cValue: cRemoteConnectOptions.pointee.follow_redirects), .gitRemoteRedirectNone)
            XCTAssertEqual(Array(cRemoteConnectOptions.pointee.custom_headers), [])
        }
    }
    
    
    
    func testGitRemoteConnectOptionsInit() throws
    {
        var remoteConnectOptions = git_remote_connect_options()
        
        let remoteConnectOptionsInitResult: GitErrorCode
            = gitRemoteConnectOptionsInit(
                opts:       &remoteConnectOptions,
                version:    gitRemoteConnectOptionsVersion
            )
        
        XCTAssertOK(remoteConnectOptionsInitResult)
    }
    
    
    
    func testGitRemoteConnectOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitRemoteConnectOptionsVersion), GIT_REMOTE_CONNECT_OPTIONS_VERSION)
    }
    
    
    
    func testGitRemoteCreateAndLookup() throws
    {
        try withRemotePointer
        {
            _, _ in
            
        }
    }
    
    
    
    func testGitRemoteCreateAnonymous() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var remotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: remotePointer)
            }
            
            
            
            let remoteCreateAnonymousResult: GitErrorCode
                = gitRemoteCreateAnonymous(
                    out:    &remotePointer,
                    repo:   repository.pointer,
                    url:    Self.remoteURL
                )
            
            XCTAssertOK(remoteCreateAnonymousResult)
            
            guard let remotePointer: OpaquePointer = remotePointer
            else
            {
                XCTFail("The remote pointer was nil.")
                return
            }
            
            
            
            let remoteName: String?
                = gitRemoteName(remote: remotePointer)
            
            XCTAssertNil(remoteName)
            
            
            
            let remoteURL: String?
                = gitRemoteURL(remote: remotePointer)
            
            XCTAssertNotNil(remoteURL)
            XCTAssertEqual(remoteURL, Self.remoteURL)
        }
    }
    
    
    
    func testGitRemoteCreateDetached() throws
    {
        var remotePointer: OpaquePointer? = nil
        
        defer
        {
            gitRemoteFree(remote: remotePointer)
        }
        
        
        
        let remoteCreateDetachedResult: GitErrorCode
            = gitRemoteCreateDetached(
                out:    &remotePointer,
                url:    Self.remoteURL
            )
        
        XCTAssertOK(remoteCreateDetachedResult)
        
        guard let remotePointer: OpaquePointer = remotePointer
        else
        {
            XCTFail("The remote pointer was nil.")
            return
        }
        
        
        
        let remoteName: String?
            = gitRemoteName(remote: remotePointer)
        
        XCTAssertNil(remoteName)
        
        
        
        let remoteURL: String?
            = gitRemoteURL(remote: remotePointer)
        
        XCTAssertNotNil(remoteURL)
        XCTAssertEqual(remoteURL, Self.remoteURL)
    }
    
    
    
    func testGitRemoteCreateFlags() throws
    {
        XCTAssertEqual(GitRemoteCreateFlags.gitRemoteCreateSkipInsteadOf.rawValue, GIT_REMOTE_CREATE_SKIP_INSTEADOF.rawValue)
        XCTAssertEqual(GitRemoteCreateFlags.gitRemoteCreateSkipDefaultFetchspec.rawValue, GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC.rawValue)
        
        XCTAssertEqual(GitRemoteCreateFlags(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitRemoteCreateFlags.gitRemoteCreateSkipInsteadOf.cValue(), GIT_REMOTE_CREATE_SKIP_INSTEADOF)
        XCTAssertEqual(GitRemoteCreateFlags.gitRemoteCreateSkipDefaultFetchspec.cValue(), GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC)
        
        XCTAssertEqual(GitRemoteCreateFlags(cValue: GIT_REMOTE_CREATE_SKIP_INSTEADOF), .gitRemoteCreateSkipInsteadOf)
        XCTAssertEqual(GitRemoteCreateFlags(cValue: GIT_REMOTE_CREATE_SKIP_DEFAULT_FETCHSPEC), .gitRemoteCreateSkipDefaultFetchspec)
        
        
        
        let flags: GitRemoteCreateFlags =
        [
            .gitRemoteCreateSkipInsteadOf
        ]
        
        XCTAssertTrue(flags.contains(.gitRemoteCreateSkipInsteadOf))
        XCTAssertFalse(flags.contains(.gitRemoteCreateSkipDefaultFetchspec))
    }
    
    
    
    func testGitRemoteCreateOptions() throws
    {
        let remoteCreateOptions = GitRemoteCreateOptions()
        
        XCTAssertEqual(remoteCreateOptions.version, gitRemoteCreateOptionsVersion)
        XCTAssertNil(remoteCreateOptions.repository)
        XCTAssertNil(remoteCreateOptions.name)
        XCTAssertNil(remoteCreateOptions.fetchspec)
        XCTAssertEqual(remoteCreateOptions.flags, [])
        
        try remoteCreateOptions.withCValue
        {
            cRemoteCreateOptions in
            
            XCTAssertEqual(cRemoteCreateOptions.pointee.version, gitRemoteCreateOptionsVersion)
            XCTAssertNil(cRemoteCreateOptions.pointee.repository)
            XCTAssertNil(cRemoteCreateOptions.pointee.name)
            XCTAssertNil(cRemoteCreateOptions.pointee.fetchspec)
            XCTAssertEqual(cRemoteCreateOptions.pointee.flags, 0)
        }
    }
    
    
    
    func testGitRemoteCreateOptionsInit() throws
    {
        var remoteCreateOptions = git_remote_create_options()
        
        let remoteCreateOptionsInitResult: GitErrorCode
            = gitRemoteCreateOptionsInit(
                opts:       &remoteCreateOptions,
                version:    gitRemoteCreateOptionsVersion
            )
        
        XCTAssertOK(remoteCreateOptionsInitResult)
    }
    
    
    
    func testGitRemoteCreateOptionsVersion() throws
    {
        XCTAssertEqual(Int32(gitRemoteCreateOptionsVersion), GIT_REMOTE_CREATE_OPTIONS_VERSION)
    }
    
    
    
    func testGitRemoteCreateWithFetchspec() throws
    {
        try withRemotePointer(type: .fetchspec)
        {
            _, remotePointer in
            
            var fetchRefspecs: [String] = []
            
            let getFetchRefspecsResult: GitErrorCode
                = gitRemoteGetFetchRefspecs(
                    array:      &fetchRefspecs,
                    remote:     remotePointer
                )
            
            XCTAssertOK(getFetchRefspecsResult)
            XCTAssertGreaterThanOrEqual(fetchRefspecs.count, 1)
            XCTAssertTrue(fetchRefspecs.contains(Repository.fetchRefspec))
        }
    }
    
    
    
    func testGitRemoteCreateWithOpts() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var remotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: remotePointer)
            }
            
            
            
            var remoteCreateOptions = GitRemoteCreateOptions()
            
            remoteCreateOptions.repository  = repository.pointer
            remoteCreateOptions.name        = Self.remoteName
            remoteCreateOptions.fetchspec   = Repository.fetchRefspec
            
            
            
            let remoteCreateWithOptsResult: GitErrorCode
                = gitRemoteCreateWithOpts(
                    out:    &remotePointer,
                    url:    Self.remoteURL,
                    opts:   remoteCreateOptions
                )
            
            XCTAssertOK(remoteCreateWithOptsResult)
            
            
            
            try validateRemote(
                remotePointer,
                in: repository
            )
        }
    }
    
    
    
    func testGitRemoteDelete() throws
    {
        try withRemotePointer
        {
            repository, _ in
            
            let remoteDeleteResult: GitErrorCode = gitRemoteDelete(
                repo:   repository.pointer,
                name:   Self.remoteName
            )
            
            XCTAssertOK(remoteDeleteResult)
            
            
            
            var remotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: remotePointer)
            }
            
            
            
            let remoteLookupResult: GitErrorCode = gitRemoteLookup(
                out:    &remotePointer,
                repo:   repository.pointer,
                name:   Self.remoteName
            )
            
            XCTAssertNotOK(remoteLookupResult)
            XCTAssertNil(remotePointer)
        }
    }
    
    
    
    func testGitRemoteDisconnect() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteDisconnectResult: GitErrorCode
                = gitRemoteDisconnect(remote: remotePointer)
            
            XCTAssertOK(remoteDisconnectResult)
            
            
            
            let remoteIsConnected: Bool
                = gitRemoteConnected(remote: remotePointer)
            
            XCTAssertFalse(remoteIsConnected)
        }
    }
    
    
    
    func testGitRemoteDownload() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteDownloadResult: GitErrorCode = gitRemoteDownload(
                remote:     remotePointer,
                refspecs:   [Repository.fetchRefspec],
                opts:       nil
            )
            
            XCTAssertEqual(remoteDownloadResult, .gitECertificate)
        }
    }
    
    
    
    func testGitRemoteDup() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            var duplicatedRemotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: duplicatedRemotePointer)
            }
            
            
            
            let remoteDupResult: GitErrorCode = gitRemoteDup(
                out:        &duplicatedRemotePointer,
                source:     remotePointer
            )
            
            XCTAssertOK(remoteDupResult)
            XCTAssertNotNil(duplicatedRemotePointer)
        }
    }
    
    
    
    func testGitRemoteFetch() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteFetchResult: GitErrorCode = gitRemoteFetch(
                remote:         remotePointer,
                refspecs:       [Repository.fetchRefspec],
                opts:           nil,
                reflogMessage:  nil
            )
            
            XCTAssertEqual(remoteFetchResult, .gitECertificate)
        }
    }
    
    
    
    func testGitRemoteFree() throws
    {
        gitRemoteFree(remote: nil)
    }
    
    
    
    func testGitRemoteGetRefspec() throws
    {
        try withRemotePointer(type: .fetchspec)
        {
            _, remotePointer in
            
            let refspecPointer: OpaquePointer
                = gitRemoteGetRefspec(
                    remote:     remotePointer,
                    n:          0
                )
            
            let refspecString: String?
                = gitRefspecString(refspec: refspecPointer)
            
            XCTAssertNotNil(refspecString)
            XCTAssertEqual(refspecString, Repository.fetchRefspec)
        }
    }
    
    
    
    func testGitRemoteInitCallbacks() throws
    {
        var remoteCallbacks = git_remote_callbacks()
        
        let remoteInitCallbacksResult: GitErrorCode = gitRemoteInitCallbacks(
            opts:       &remoteCallbacks,
            version:    gitRemoteCallbacksVersion
        )
        
        XCTAssertOK(remoteInitCallbacksResult)
    }
    
    
    
    func testGitRemoteList() throws
    {
        try withRemotePointer
        {
            repository, _ in
            
            var remoteNames: [String] = []
            
            let remoteListResult: GitErrorCode = gitRemoteList(
                out:    &remoteNames,
                repo:   repository.pointer
            )
            
            XCTAssertOK(remoteListResult)
            XCTAssertGreaterThan(remoteNames.count, 0)
            XCTAssertTrue(remoteNames.contains(Self.remoteName))
        }
    }
    
    
    
    func testGitRemoteLS() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            var remoteHEADs: [GitRemoteHEAD] = []
            
            let remoteLSResult: GitErrorCode = gitRemoteLS(
                out:        &remoteHEADs,
                size:       remoteHEADs.count,
                remote:     remotePointer
            )
            
            XCTAssertNeverConnected(remoteLSResult)
        }
    }
    
    
    
    func testGitRemoteNameIsValid() throws
    {
        let remoteNamesAndValidity: [String : Bool] =
        [
            "hello-world"   : true,
            "hello..world"  : false,
            "hello~world"   : false,
            "hello@{world"  : false,
            "-hello-world"  : true
        ]
        
        
        
        var isValid: Bool = false
        
        for (remoteName, validity) in remoteNamesAndValidity
        {
            isValid = !validity
            
            let remoteNameIsValidResult: GitErrorCode = gitRemoteNameIsValid(
                valid:  &isValid,
                name:   remoteName
            )
            
            XCTAssertOK(remoteNameIsValidResult)
            XCTAssertEqual(isValid, validity)
        }
    }
    
    
    
    func testGitRemotePrune() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remotePruneResult: GitErrorCode = gitRemotePrune(
                remote:     remotePointer,
                callbacks:  GitRemoteCallbacks()
            )
            
            XCTAssertNeverConnected(remotePruneResult)
        }
    }
    
    
    
    func testGitRemotePruneRefs() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            _ = gitRemotePruneRefs(remote: remotePointer)
        }
    }
    
    
    
    func testGitRemotePush() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remotePushResult: GitErrorCode = gitRemotePush(
                remote:     remotePointer,
                refspecs:   [Self.remotePushURL],
                opts:       nil
            )
            
            XCTAssertEqual(remotePushResult, .gitECertificate)
        }
    }
    
    
    
    func testGitRemoteRedirectT() throws
    {
        XCTAssertEqual(GitRemoteRedirectT.gitRemoteRedirectNone.rawValue, GIT_REMOTE_REDIRECT_NONE.rawValue)
        XCTAssertEqual(GitRemoteRedirectT.gitRemoteRedirectInitial.rawValue, GIT_REMOTE_REDIRECT_INITIAL.rawValue)
        XCTAssertEqual(GitRemoteRedirectT.gitRemoteRedirectAll.rawValue, GIT_REMOTE_REDIRECT_ALL.rawValue)
        
        XCTAssertNil(GitRemoteRedirectT(rawValue: 123))
        
        XCTAssertEqual(GitRemoteRedirectT.gitRemoteRedirectNone.cValue(), GIT_REMOTE_REDIRECT_NONE)
        XCTAssertEqual(GitRemoteRedirectT.gitRemoteRedirectInitial.cValue(), GIT_REMOTE_REDIRECT_INITIAL)
        XCTAssertEqual(GitRemoteRedirectT.gitRemoteRedirectAll.cValue(), GIT_REMOTE_REDIRECT_ALL)
        
        XCTAssertEqual(GitRemoteRedirectT(cValue: GIT_REMOTE_REDIRECT_NONE), .gitRemoteRedirectNone)
        XCTAssertEqual(GitRemoteRedirectT(cValue: GIT_REMOTE_REDIRECT_INITIAL), .gitRemoteRedirectInitial)
        XCTAssertEqual(GitRemoteRedirectT(cValue: GIT_REMOTE_REDIRECT_ALL), .gitRemoteRedirectAll)
    }
    
    
    
    func testGitRemoteRefspecCount() throws
    {
        try withRemotePointer(type: .fetchspec)
        {
            _, remotePointer in
            
            let refspecCount: Int
                = gitRemoteRefspecCount(remote: remotePointer)
            
            XCTAssertGreaterThanOrEqual(refspecCount, 1)
        }
    }
    
    
    
    func testGitRemoteRename() throws
    {
        try withRemotePointer(type: .fetchspec)
        {
            repository, _ in
            
            let newRemoteName   : String    = "origin2"
            var refspecProblems : [String]  = []
            
            let remoteRenameResult: GitErrorCode = gitRemoteRename(
                problems:   &refspecProblems,
                repo:       repository.pointer,
                name:       Self.remoteName,
                newName:    newRemoteName
            )
            
            XCTAssertOK(remoteRenameResult)
            
            
            
            var remotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: remotePointer)
            }
            
            
            
            var remoteLookupResult: GitErrorCode = gitRemoteLookup(
                out:    &remotePointer,
                repo:   repository.pointer,
                name:   Self.remoteName
            )
            
            XCTAssertNotOK(remoteLookupResult)
            XCTAssertNil(remotePointer)
            
            
            
            remoteLookupResult = gitRemoteLookup(
                out:    &remotePointer,
                repo:   repository.pointer,
                name:   newRemoteName
            )
            
            XCTAssertOK(remoteLookupResult)
            
            guard let remotePointer: OpaquePointer = remotePointer
            else
            {
                XCTFail("The remote pointer was nil.")
                return
            }
            
            
            
            let remoteName: String? = gitRemoteName(remote: remotePointer)
            
            XCTAssertNotNil(remoteName)
            XCTAssertEqual(remoteName, newRemoteName)
        }
    }
    
    
    
    func testGitRemoteSetInstancePushURL() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteSetInstancePushURLResult: GitErrorCode
                = gitRemoteSetInstancePushURL(
                    remote:     remotePointer,
                    url:        Self.remotePushURL
                )
            
            XCTAssertOK(remoteSetInstancePushURLResult)
            
            
            
            let remotePushURL: String?
                = gitRemotePushURL(remote: remotePointer)
            
            XCTAssertNotNil(remotePushURL)
            XCTAssertEqual(remotePushURL, Self.remotePushURL)
        }
    }
    
    
    
    func testGitRemoteSetInstanceURL() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let instanceURL: String = "https://fetch2.example.com/example.git"
            
            let remoteSetInstanceURLResult: GitErrorCode
                = gitRemoteSetInstanceURL(
                    remote:     remotePointer,
                    url:        instanceURL
                )
            
            XCTAssertOK(remoteSetInstanceURLResult)
            
            
            
            let remoteURL: String? = gitRemoteURL(remote: remotePointer)
            
            XCTAssertNotNil(remoteURL)
            XCTAssertEqual(remoteURL, instanceURL)
        }
    }
    
    
    
    func testGitRemoteSetPushURL() throws
    {
        try withRemotePointer
        {
            repository, _ in
            
            let remoteSetPushURLResult: GitErrorCode = gitRemoteSetPushURL(
                repo:       repository.pointer,
                remote:     Self.remoteName,
                url:        Self.remotePushURL
            )
            
            XCTAssertOK(remoteSetPushURLResult)
        }
    }
    
    
    
    func testGitRemoteSetURL() throws
    {
        try withRemotePointer
        {
            repository, _ in
            
            let remoteSetURLResult: GitErrorCode = gitRemoteSetURL(
                repo:       repository.pointer,
                remote:     Self.remoteName,
                url:        "https://fetch2.example.com/example.git"
            )
            
            XCTAssertOK(remoteSetURLResult)
        }
    }
    
    
    
    func testGitRemoteStats() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let indexerProgress: GitIndexerProgress?
                = gitRemoteStats(remote: remotePointer)
            
            XCTAssertNotNil(indexerProgress)
        }
    }
    
    
    
    func testGitRemoteStop() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteStopResult: GitErrorCode
                = gitRemoteStop(remote: remotePointer)
            
            XCTAssertOK(remoteStopResult)
        }
    }
    
    
    
    func testGitRemoteUpdateFlags() throws
    {
        XCTAssertEqual(GitRemoteUpdateFlags.gitRemoteUpdateFETCHHEAD.rawValue, GIT_REMOTE_UPDATE_FETCHHEAD.rawValue)
        XCTAssertEqual(GitRemoteUpdateFlags.gitRemoteUpdateReportUnchanged.rawValue, GIT_REMOTE_UPDATE_REPORT_UNCHANGED.rawValue)
        
        XCTAssertEqual(GitRemoteUpdateFlags(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitRemoteUpdateFlags.gitRemoteUpdateFETCHHEAD.cValue(), GIT_REMOTE_UPDATE_FETCHHEAD)
        XCTAssertEqual(GitRemoteUpdateFlags.gitRemoteUpdateReportUnchanged.cValue(), GIT_REMOTE_UPDATE_REPORT_UNCHANGED)
        
        XCTAssertEqual(GitRemoteUpdateFlags(cValue: GIT_REMOTE_UPDATE_FETCHHEAD), .gitRemoteUpdateFETCHHEAD)
        XCTAssertEqual(GitRemoteUpdateFlags(cValue: GIT_REMOTE_UPDATE_REPORT_UNCHANGED), .gitRemoteUpdateReportUnchanged)
        
        
        
        let flags: GitRemoteUpdateFlags =
        [
            .gitRemoteUpdateFETCHHEAD
        ]
        
        XCTAssertTrue(flags.contains(.gitRemoteUpdateFETCHHEAD))
        XCTAssertFalse(flags.contains(.gitRemoteUpdateReportUnchanged))
    }
    
    
    
    func testGitRemoteUpdateTips() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteUpdateTipsResult: GitErrorCode = gitRemoteUpdateTips(
                remote:         remotePointer,
                callbacks:      GitRemoteCallbacks(),
                updateFlags:    .gitRemoteUpdateFETCHHEAD,
                downloadTags:   .gitRemoteDownloadTagsAuto,
                reflogMessage:  nil
            )
            
            XCTAssertNeverConnected(remoteUpdateTipsResult)
        }
    }
    
    
    
    func testGitRemoteUpload() throws
    {
        try withRemotePointer
        {
            _, remotePointer in
            
            let remoteUploadResult: GitErrorCode = gitRemoteUpload(
                remote:     remotePointer,
                refspecs:   [Repository.pushRefspec],
                opts:       nil
            )
            
            XCTAssertEqual(remoteUploadResult, .gitECertificate)
        }
    }
}



// MARK: - Extensions

private extension RemoteTests
{
    static let remoteName       : String    = "origin1"
    static let remoteURL        : String    = "https://example.com/fetch.git"
    static let remotePushURL    : String    = "https://example.com/push.git"
    
    
    
    enum RemoteCreationType
    {
        case standard
        case fetchspec
    }
    
    
    
    /// Asserts that the given libgit2 operation result code is
    /// ``GitErrorCode/gitError``, and that the error is because the remote
    /// has never connected.
    /// - Parameter result: The libgit2 operation result code.
    func XCTAssertNeverConnected(
        _ result: GitErrorCode
    )
    {
        guard result == .gitError
        else
        {
            XCTFail("The result was \(result).")
            return
        }
        
        let error   : UnsafePointer<git_error>?     = git_error_last()
        var message : String                        = "Unknown error."
        
        if let errorMessage = String(optionalCString: error?.pointee.message)
        {
            message = errorMessage
        }
        
        XCTAssertEqual(message, "this remote has never connected")
    }
    
    
    
    /// Calls the given closure with a ``Repository`` instance and a pointer
    /// to a remote.
    /// - Parameters:
    ///   - type: How to create the remote.
    ///   - body: The closure to call.
    /// - Throws: An error if an operation fails.
    func withRemotePointer(
        type    : RemoteCreationType = .standard,
        _ body  : (Repository, OpaquePointer) throws -> Void
    ) throws
    {
        try Repository.withRepository
        {
            repository in
            
            var remotePointer: OpaquePointer? = nil
            
            defer
            {
                gitRemoteFree(remote: remotePointer)
            }
            
            
            
            let remoteCreateResult: GitErrorCode
            
            switch type
            {
                case .standard:
                    
                    remoteCreateResult = gitRemoteCreate(
                        out:    &remotePointer,
                        repo:   repository.pointer,
                        name:   Self.remoteName,
                        url:    Self.remoteURL
                    )
                    
                case .fetchspec:
                    
                    remoteCreateResult = gitRemoteCreateWithFetchspec(
                        out:    &remotePointer,
                        repo:   repository.pointer,
                        name:   Self.remoteName,
                        url:    Self.remoteURL,
                        fetch:  Repository.fetchRefspec
                    )
            }
            
            XCTAssertOK(remoteCreateResult)
            
            guard let remotePointer: OpaquePointer = remotePointer
            else
            {
                throw NSError.makeError("The remote pointer was nil.")
            }
            
            
            
            try validateRemote(
                remotePointer,
                in: repository
            )
            
            
            
            try body(
                repository,
                remotePointer
            )
        }
    }
    
    
    
    /// Looks up the given remote and validates its properties.
    /// - Parameters:
    ///   - remotePointer: The remote to validate. The underlying type must be
    ///   `git_remote`.
    ///   - repository: The repository containing the given remote. The
    ///   underlying type must be `git_repository`.
    /// - Throws: An error if an operation fails.
    func validateRemote(
        _   remotePointer   : OpaquePointer?,
        in  repository      : Repository
    ) throws
    {
        guard remotePointer != nil
        else
        {
            throw NSError.makeError("The remote pointer was nil.")
        }
        
        
        
        var lookedUpRemotePointer: OpaquePointer? = nil
        
        defer
        {
            gitRemoteFree(remote: lookedUpRemotePointer)
        }
        
        
        
        let remoteLookupResult: GitErrorCode = gitRemoteLookup(
            out:    &lookedUpRemotePointer,
            repo:   repository.pointer,
            name:   Self.remoteName
        )
        
        XCTAssertOK(remoteLookupResult)
        
        guard let lookedUpRemotePointer: OpaquePointer
                = lookedUpRemotePointer
        else
        {
            throw NSError.makeError(
                "The looked-up remote pointer was nil."
            )
        }
        
        
        
        let remoteName: String? = gitRemoteName(remote: lookedUpRemotePointer)
        
        XCTAssertNotNil(remoteName)
        XCTAssertEqual(remoteName, Self.remoteName)
        
        
        
        let remoteURL: String? = gitRemoteURL(remote: lookedUpRemotePointer)
        
        XCTAssertNotNil(remoteURL)
        XCTAssertEqual(remoteURL, Self.remoteURL)
        
        
        
        let ownerPointer: OpaquePointer
            = gitRemoteOwner(remote: lookedUpRemotePointer)
        
        XCTAssertEqual(ownerPointer, repository.pointer)
    }
}
