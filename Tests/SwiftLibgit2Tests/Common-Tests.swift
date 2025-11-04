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
@testable import SwiftLibgit2TestUtilities



final class CommonTests: XCTestCaseStopOnFail
{
    func testGitLibgitFeatureBackend() throws
    {
        let backend             : String?   = gitLibgit2FeatureBackend(feature: .gitFeatureHTTPParser)
        let backendSecondCall   : String?   = gitLibgit2FeatureBackend(feature: .gitFeatureHTTPParser)
        
        XCTAssertEqual(backend, backendSecondCall)
        XCTAssertEqual(backend, "builtin")
        XCTAssertEqual(gitLibgit2FeatureBackend(feature: .gitFeatureRegex), "builtin")
        XCTAssertEqual(gitLibgit2FeatureBackend(feature: .gitFeatureCompression), "builtin")
        XCTAssertEqual(gitLibgit2FeatureBackend(feature: .gitFeatureSHA1), "builtin")
    }
    
    
    
    func testGitLibgitFeatures() throws
    {
        guard
            let featuresFirstCall   : GitFeatureT   = gitLibgit2Features(),
            let featuresSecondCall  : GitFeatureT   = gitLibgit2Features()
        else
        {
            XCTFail("The features were nil.")
            return
        }
        
        XCTAssertEqual(featuresFirstCall, featuresSecondCall)
        XCTAssertGreaterThanOrEqual(featuresFirstCall.rawValue, 0)
        XCTAssertTrue(featuresFirstCall.contains(.gitFeatureHTTPParser))
        XCTAssertTrue(featuresFirstCall.contains(.gitFeatureRegex))
        XCTAssertTrue(featuresFirstCall.contains(.gitFeatureCompression))
        XCTAssertTrue(featuresFirstCall.contains(.gitFeatureSHA1))
    }
    
    
    
    func testGitFeatureT() throws
    {
        XCTAssertEqual(GitFeatureT.gitFeatureThreads.rawValue, GIT_FEATURE_THREADS.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureHTTPS.rawValue, GIT_FEATURE_HTTPS.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureSSH.rawValue, GIT_FEATURE_SSH.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureNSEC.rawValue, GIT_FEATURE_NSEC.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureHTTPParser.rawValue, GIT_FEATURE_HTTP_PARSER.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureRegex.rawValue, GIT_FEATURE_REGEX.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureI18N.rawValue, GIT_FEATURE_I18N.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureAuthNTLM.rawValue, GIT_FEATURE_AUTH_NTLM.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureAuthNegotiate.rawValue, GIT_FEATURE_AUTH_NEGOTIATE.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureCompression.rawValue, GIT_FEATURE_COMPRESSION.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureSHA1.rawValue, GIT_FEATURE_SHA1.rawValue)
        XCTAssertEqual(GitFeatureT.gitFeatureSHA256.rawValue, GIT_FEATURE_SHA256.rawValue)
        
        XCTAssertEqual(GitFeatureT(rawValue: 123).cValue().rawValue, 123)
        
        XCTAssertEqual(GitFeatureT.gitFeatureThreads.cValue(), GIT_FEATURE_THREADS)
        XCTAssertEqual(GitFeatureT.gitFeatureHTTPS.cValue(), GIT_FEATURE_HTTPS)
        XCTAssertEqual(GitFeatureT.gitFeatureSSH.cValue(), GIT_FEATURE_SSH)
        XCTAssertEqual(GitFeatureT.gitFeatureNSEC.cValue(), GIT_FEATURE_NSEC)
        XCTAssertEqual(GitFeatureT.gitFeatureHTTPParser.cValue(), GIT_FEATURE_HTTP_PARSER)
        XCTAssertEqual(GitFeatureT.gitFeatureRegex.cValue(), GIT_FEATURE_REGEX)
        XCTAssertEqual(GitFeatureT.gitFeatureI18N.cValue(), GIT_FEATURE_I18N)
        XCTAssertEqual(GitFeatureT.gitFeatureAuthNTLM.cValue(), GIT_FEATURE_AUTH_NTLM)
        XCTAssertEqual(GitFeatureT.gitFeatureAuthNegotiate.cValue(), GIT_FEATURE_AUTH_NEGOTIATE)
        XCTAssertEqual(GitFeatureT.gitFeatureCompression.cValue(), GIT_FEATURE_COMPRESSION)
        XCTAssertEqual(GitFeatureT.gitFeatureSHA1.cValue(), GIT_FEATURE_SHA1)
        XCTAssertEqual(GitFeatureT.gitFeatureSHA256.cValue(), GIT_FEATURE_SHA256)
        
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_THREADS), .gitFeatureThreads)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_HTTPS), .gitFeatureHTTPS)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_SSH), .gitFeatureSSH)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_NSEC), .gitFeatureNSEC)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_HTTP_PARSER), .gitFeatureHTTPParser)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_REGEX), .gitFeatureRegex)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_I18N), .gitFeatureI18N)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_AUTH_NTLM), .gitFeatureAuthNTLM)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_AUTH_NEGOTIATE), .gitFeatureAuthNegotiate)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_COMPRESSION), .gitFeatureCompression)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_SHA1), .gitFeatureSHA1)
        XCTAssertEqual(GitFeatureT(cValue: GIT_FEATURE_SHA256), .gitFeatureSHA256)
        
        
        
        let flags: GitFeatureT =
        [
            .gitFeatureHTTPS,
            .gitFeatureI18N
        ]
        
        XCTAssertTrue(flags.contains(.gitFeatureHTTPS))
        XCTAssertTrue(flags.contains(.gitFeatureI18N))
        XCTAssertFalse(flags.contains(.gitFeatureSHA256))
    }
    
    
    
    /// Tests that the C bindings compile and communicate correctly with
    /// libgit2.
    ///
    /// The main purpose of this is to test that the C bindings around the
    /// variadic `git_libgit2_opts()` function compile and work correctly,
    /// not to test libgit2 behavior with specific option values. The "get"
    /// calls are sufficient for this purpose. The "set" calls are not tested
    /// since not all options have a corresponding "get" method to ensure a
    /// safe get/set/restore pattern.
    func testGitLibgit2OptFunctions() throws
    {
        var int1    : Int       = 0
        var int2    : Int       = 0
        var int32   : Int32     = 0
        var uint    : UInt      = 0
        var bool    : Bool      = false
        var string  : String?   = nil
        var strings : [String]  = []
        
        XCTAssertOK(gitLibgit2OptGetMWindowSize(size: &int1))
        XCTAssertOK(gitLibgit2OptGetMWindowMappedLimit(limit: &int1))
        XCTAssertOK(gitLibgit2OptGetSearchPath(level: .gitConfigLevelSystem, buf: &string))
        XCTAssertOK(gitLibgit2OptGetCachedMemory(current: &int1, allowed: &int2))
        XCTAssertOK(gitLibgit2OptGetTemplatePath(out: &string))
        XCTAssertOK(gitLibgit2OptGetUserAgent(out: &string))
        XCTAssertOK(gitLibgit2OptGetWindowsShareMode(value: &uint))
        XCTAssertOK(gitLibgit2OptGetPackMaxObjects(out: &int1))
        XCTAssertOK(gitLibgit2OptGetMWindowFileLimit(limit: &int1))
        XCTAssertOK(gitLibgit2OptGetExtensions(out: &strings))
        XCTAssertOK(gitLibgit2OptGetOwnerValidation(enabled: &bool))
        XCTAssertOK(gitLibgit2OptGetHomeDir(out: &string))
        XCTAssertOK(gitLibgit2OptGetServerConnectTimeout(timeout: &int32))
        XCTAssertOK(gitLibgit2OptGetServerTimeout(timeout: &int32))
        XCTAssertOK(gitLibgit2OptGetUserAgentProduct(out: &string))
    }
    
    
    
    func testGitLibgit2OptT() throws
    {
        XCTAssertEqual(GitLibgit2OptT.gitOptGetMWindowSize.rawValue, GIT_OPT_GET_MWINDOW_SIZE.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetMWindowSize.rawValue, GIT_OPT_SET_MWINDOW_SIZE.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetMWindowMappedLimit.rawValue, GIT_OPT_GET_MWINDOW_MAPPED_LIMIT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetMWindowMappedLimit.rawValue, GIT_OPT_SET_MWINDOW_MAPPED_LIMIT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetSearchPath.rawValue, GIT_OPT_GET_SEARCH_PATH.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetSearchPath.rawValue, GIT_OPT_SET_SEARCH_PATH.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetCacheObjectLimit.rawValue, GIT_OPT_SET_CACHE_OBJECT_LIMIT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetCacheMaxSize.rawValue, GIT_OPT_SET_CACHE_MAX_SIZE.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableCaching.rawValue, GIT_OPT_ENABLE_CACHING.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetCachedMemory.rawValue, GIT_OPT_GET_CACHED_MEMORY.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetTemplatePath.rawValue, GIT_OPT_GET_TEMPLATE_PATH.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetTemplatePath.rawValue, GIT_OPT_SET_TEMPLATE_PATH.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetSSLCertLocations.rawValue, GIT_OPT_SET_SSL_CERT_LOCATIONS.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetUserAgent.rawValue, GIT_OPT_SET_USER_AGENT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableStrictObjectCreation.rawValue, GIT_OPT_ENABLE_STRICT_OBJECT_CREATION.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableStrictSymbolicRefCreation.rawValue, GIT_OPT_ENABLE_STRICT_SYMBOLIC_REF_CREATION.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetSSLCiphers.rawValue, GIT_OPT_SET_SSL_CIPHERS.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetUserAgent.rawValue, GIT_OPT_GET_USER_AGENT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableOFSDelta.rawValue, GIT_OPT_ENABLE_OFS_DELTA.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableFSyncGitDir.rawValue, GIT_OPT_ENABLE_FSYNC_GITDIR.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetWindowsShareMode.rawValue, GIT_OPT_GET_WINDOWS_SHAREMODE.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetWindowsShareMode.rawValue, GIT_OPT_SET_WINDOWS_SHAREMODE.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableStrictHashVerification.rawValue, GIT_OPT_ENABLE_STRICT_HASH_VERIFICATION.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetAllocator.rawValue, GIT_OPT_SET_ALLOCATOR.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableUnsavedIndexSafety.rawValue, GIT_OPT_ENABLE_UNSAVED_INDEX_SAFETY.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetPackMaxObjects.rawValue, GIT_OPT_GET_PACK_MAX_OBJECTS.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetPackMaxObjects.rawValue, GIT_OPT_SET_PACK_MAX_OBJECTS.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptDisablePackKeepFileChecks.rawValue, GIT_OPT_DISABLE_PACK_KEEP_FILE_CHECKS.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableHTTPExpectContinue.rawValue, GIT_OPT_ENABLE_HTTP_EXPECT_CONTINUE.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetMWindowFileLimit.rawValue, GIT_OPT_GET_MWINDOW_FILE_LIMIT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetMWindowFileLimit.rawValue, GIT_OPT_SET_MWINDOW_FILE_LIMIT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetODBPackedPriority.rawValue, GIT_OPT_SET_ODB_PACKED_PRIORITY.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetODBLoosePriority.rawValue, GIT_OPT_SET_ODB_LOOSE_PRIORITY.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetExtensions.rawValue, GIT_OPT_GET_EXTENSIONS.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetExtensions.rawValue, GIT_OPT_SET_EXTENSIONS.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetOwnerValidation.rawValue, GIT_OPT_GET_OWNER_VALIDATION.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetOwnerValidation.rawValue, GIT_OPT_SET_OWNER_VALIDATION.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetHomeDir.rawValue, GIT_OPT_GET_HOMEDIR.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetHomeDir.rawValue, GIT_OPT_SET_HOMEDIR.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetServerConnectTimeout.rawValue, GIT_OPT_SET_SERVER_CONNECT_TIMEOUT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetServerConnectTimeout.rawValue, GIT_OPT_GET_SERVER_CONNECT_TIMEOUT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetServerTimeout.rawValue, GIT_OPT_SET_SERVER_TIMEOUT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetServerTimeout.rawValue, GIT_OPT_GET_SERVER_TIMEOUT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetUserAgentProduct.rawValue, GIT_OPT_SET_USER_AGENT_PRODUCT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetUserAgentProduct.rawValue, GIT_OPT_GET_USER_AGENT_PRODUCT.rawValue)
        XCTAssertEqual(GitLibgit2OptT.gitOptAddSSLX509Cert.rawValue, GIT_OPT_ADD_SSL_X509_CERT.rawValue)
        
        XCTAssertNil(GitLibgit2OptT(rawValue: 123))
        
        XCTAssertEqual(GitLibgit2OptT.gitOptGetMWindowSize.cValue(), GIT_OPT_GET_MWINDOW_SIZE)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetMWindowSize.cValue(), GIT_OPT_SET_MWINDOW_SIZE)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetMWindowMappedLimit.cValue(), GIT_OPT_GET_MWINDOW_MAPPED_LIMIT)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetMWindowMappedLimit.cValue(), GIT_OPT_SET_MWINDOW_MAPPED_LIMIT)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetSearchPath.cValue(), GIT_OPT_GET_SEARCH_PATH)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetSearchPath.cValue(), GIT_OPT_SET_SEARCH_PATH)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetCacheObjectLimit.cValue(), GIT_OPT_SET_CACHE_OBJECT_LIMIT)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetCacheMaxSize.cValue(), GIT_OPT_SET_CACHE_MAX_SIZE)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableCaching.cValue(), GIT_OPT_ENABLE_CACHING)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetCachedMemory.cValue(), GIT_OPT_GET_CACHED_MEMORY)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetTemplatePath.cValue(), GIT_OPT_GET_TEMPLATE_PATH)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetTemplatePath.cValue(), GIT_OPT_SET_TEMPLATE_PATH)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetSSLCertLocations.cValue(), GIT_OPT_SET_SSL_CERT_LOCATIONS)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetUserAgent.cValue(), GIT_OPT_SET_USER_AGENT)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableStrictObjectCreation.cValue(), GIT_OPT_ENABLE_STRICT_OBJECT_CREATION)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableStrictSymbolicRefCreation.cValue(), GIT_OPT_ENABLE_STRICT_SYMBOLIC_REF_CREATION)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetSSLCiphers.cValue(), GIT_OPT_SET_SSL_CIPHERS)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetUserAgent.cValue(), GIT_OPT_GET_USER_AGENT)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableOFSDelta.cValue(), GIT_OPT_ENABLE_OFS_DELTA)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableFSyncGitDir.cValue(), GIT_OPT_ENABLE_FSYNC_GITDIR)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetWindowsShareMode.cValue(), GIT_OPT_GET_WINDOWS_SHAREMODE)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetWindowsShareMode.cValue(), GIT_OPT_SET_WINDOWS_SHAREMODE)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableStrictHashVerification.cValue(), GIT_OPT_ENABLE_STRICT_HASH_VERIFICATION)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetAllocator.cValue(), GIT_OPT_SET_ALLOCATOR)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableUnsavedIndexSafety.cValue(), GIT_OPT_ENABLE_UNSAVED_INDEX_SAFETY)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetPackMaxObjects.cValue(), GIT_OPT_GET_PACK_MAX_OBJECTS)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetPackMaxObjects.cValue(), GIT_OPT_SET_PACK_MAX_OBJECTS)
        XCTAssertEqual(GitLibgit2OptT.gitOptDisablePackKeepFileChecks.cValue(), GIT_OPT_DISABLE_PACK_KEEP_FILE_CHECKS)
        XCTAssertEqual(GitLibgit2OptT.gitOptEnableHTTPExpectContinue.cValue(), GIT_OPT_ENABLE_HTTP_EXPECT_CONTINUE)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetMWindowFileLimit.cValue(), GIT_OPT_GET_MWINDOW_FILE_LIMIT)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetMWindowFileLimit.cValue(), GIT_OPT_SET_MWINDOW_FILE_LIMIT)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetODBPackedPriority.cValue(), GIT_OPT_SET_ODB_PACKED_PRIORITY)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetODBLoosePriority.cValue(), GIT_OPT_SET_ODB_LOOSE_PRIORITY)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetExtensions.cValue(), GIT_OPT_GET_EXTENSIONS)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetExtensions.cValue(), GIT_OPT_SET_EXTENSIONS)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetOwnerValidation.cValue(), GIT_OPT_GET_OWNER_VALIDATION)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetOwnerValidation.cValue(), GIT_OPT_SET_OWNER_VALIDATION)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetHomeDir.cValue(), GIT_OPT_GET_HOMEDIR)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetHomeDir.cValue(), GIT_OPT_SET_HOMEDIR)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetServerConnectTimeout.cValue(), GIT_OPT_SET_SERVER_CONNECT_TIMEOUT)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetServerConnectTimeout.cValue(), GIT_OPT_GET_SERVER_CONNECT_TIMEOUT)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetServerTimeout.cValue(), GIT_OPT_SET_SERVER_TIMEOUT)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetServerTimeout.cValue(), GIT_OPT_GET_SERVER_TIMEOUT)
        XCTAssertEqual(GitLibgit2OptT.gitOptSetUserAgentProduct.cValue(), GIT_OPT_SET_USER_AGENT_PRODUCT)
        XCTAssertEqual(GitLibgit2OptT.gitOptGetUserAgentProduct.cValue(), GIT_OPT_GET_USER_AGENT_PRODUCT)
        XCTAssertEqual(GitLibgit2OptT.gitOptAddSSLX509Cert.cValue(), GIT_OPT_ADD_SSL_X509_CERT)
        
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_MWINDOW_SIZE), .gitOptGetMWindowSize)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_MWINDOW_SIZE), .gitOptSetMWindowSize)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_MWINDOW_MAPPED_LIMIT), .gitOptGetMWindowMappedLimit)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_MWINDOW_MAPPED_LIMIT), .gitOptSetMWindowMappedLimit)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_SEARCH_PATH), .gitOptGetSearchPath)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_SEARCH_PATH), .gitOptSetSearchPath)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_CACHE_OBJECT_LIMIT), .gitOptSetCacheObjectLimit)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_CACHE_MAX_SIZE), .gitOptSetCacheMaxSize)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_CACHING), .gitOptEnableCaching)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_CACHED_MEMORY), .gitOptGetCachedMemory)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_TEMPLATE_PATH), .gitOptGetTemplatePath)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_TEMPLATE_PATH), .gitOptSetTemplatePath)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_SSL_CERT_LOCATIONS), .gitOptSetSSLCertLocations)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_USER_AGENT), .gitOptSetUserAgent)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_STRICT_OBJECT_CREATION), .gitOptEnableStrictObjectCreation)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_STRICT_SYMBOLIC_REF_CREATION), .gitOptEnableStrictSymbolicRefCreation)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_SSL_CIPHERS), .gitOptSetSSLCiphers)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_USER_AGENT), .gitOptGetUserAgent)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_OFS_DELTA), .gitOptEnableOFSDelta)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_FSYNC_GITDIR), .gitOptEnableFSyncGitDir)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_WINDOWS_SHAREMODE), .gitOptGetWindowsShareMode)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_WINDOWS_SHAREMODE), .gitOptSetWindowsShareMode)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_STRICT_HASH_VERIFICATION), .gitOptEnableStrictHashVerification)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_ALLOCATOR), .gitOptSetAllocator)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_UNSAVED_INDEX_SAFETY), .gitOptEnableUnsavedIndexSafety)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_PACK_MAX_OBJECTS), .gitOptGetPackMaxObjects)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_PACK_MAX_OBJECTS), .gitOptSetPackMaxObjects)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_DISABLE_PACK_KEEP_FILE_CHECKS), .gitOptDisablePackKeepFileChecks)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ENABLE_HTTP_EXPECT_CONTINUE), .gitOptEnableHTTPExpectContinue)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_MWINDOW_FILE_LIMIT), .gitOptGetMWindowFileLimit)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_MWINDOW_FILE_LIMIT), .gitOptSetMWindowFileLimit)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_ODB_PACKED_PRIORITY), .gitOptSetODBPackedPriority)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_ODB_LOOSE_PRIORITY), .gitOptSetODBLoosePriority)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_EXTENSIONS), .gitOptGetExtensions)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_EXTENSIONS), .gitOptSetExtensions)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_OWNER_VALIDATION), .gitOptGetOwnerValidation)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_OWNER_VALIDATION), .gitOptSetOwnerValidation)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_HOMEDIR), .gitOptGetHomeDir)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_HOMEDIR), .gitOptSetHomeDir)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_SERVER_CONNECT_TIMEOUT), .gitOptSetServerConnectTimeout)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_SERVER_CONNECT_TIMEOUT), .gitOptGetServerConnectTimeout)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_SERVER_TIMEOUT), .gitOptSetServerTimeout)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_SERVER_TIMEOUT), .gitOptGetServerTimeout)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_SET_USER_AGENT_PRODUCT), .gitOptSetUserAgentProduct)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_GET_USER_AGENT_PRODUCT), .gitOptGetUserAgentProduct)
        XCTAssertEqual(GitLibgit2OptT(cValue: GIT_OPT_ADD_SSL_X509_CERT), .gitOptAddSSLX509Cert)
    }
    
    
    
    func testGitLibgitPrerelease() throws
    {
        let prerelease              : String?   = gitLibgit2Prerelease()
        let prereleaseSecondCall    : String?   = gitLibgit2Prerelease()
        
        XCTAssertEqual(prerelease, prereleaseSecondCall)
        
        
        
        if let prerelease
        {
            XCTAssertFalse(prerelease.isEmpty)
            
            let hasValidPrefix: Bool = ["alpha", "beta", "rc"].contains
            {
                prerelease.lowercased().hasPrefix($0)
            }
            
            XCTAssertTrue(hasValidPrefix)
        }
    }
    
    
    
    func testGitLibgit2Version() throws
    {
        var major       : Int32    = -1
        var minor       : Int32    = -1
        var revision    : Int32    = -1
        
        let libgit2VersionResult: GitErrorCode = gitLibgit2Version(
            major:  &major,
            minor:  &minor,
            rev:    &revision
        )
        
        XCTAssertOK(libgit2VersionResult)
        XCTAssertGreaterThanOrEqual(major, 0)
        XCTAssertGreaterThanOrEqual(minor, 0)
        XCTAssertGreaterThanOrEqual(revision, 0)
    }
    
    
    
    func testGitPathListSeparator() throws
    {
        XCTAssertEqual(gitPathListSeparator, ":")
    }
    
    
    
    func testGitPathMax() throws
    {
        XCTAssertEqual(Int32(gitPathMax), GIT_PATH_MAX)
    }
}
