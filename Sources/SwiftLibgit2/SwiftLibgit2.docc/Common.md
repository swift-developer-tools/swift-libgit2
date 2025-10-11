# Common

Common platform functionality, including libgit2 itself.

## Topics

### Macros

- ``gitPathListSeparator``
- ``gitPathMax``

### Enums

- ``GitFeatureT``
- ``GitLibgit2OptT``

### Functions

- ``gitLibgit2Version(major:minor:rev:)``
- ``gitLibgit2Prerelease()``
- ``gitLibgit2Features()``
- ``gitLibgit2FeatureBackend(feature:)``
- ``gitLibgit2OptGetMWindowSize(size:)``
- ``gitLibgit2OptSetMWindowSize(size:)``
- ``gitLibgit2OptGetMWindowMappedLimit(limit:)``
- ``gitLibgit2OptSetMWindowMappedLimit(limit:)``
- ``gitLibgit2OptGetSearchPath(level:buf:)``
- ``gitLibgit2OptSetSearchPath(level:path:)``
- ``gitLibgit2OptSetCacheObjectLimit(type:size:)``
- ``gitLibgit2OptSetCacheMaxSize(maxStorageBytes:)``
- ``gitLibgit2OptEnableCaching(enabled:)``
- ``gitLibgit2OptGetCachedMemory(current:allowed:)``
- ``gitLibgit2OptGetTemplatePath(out:)``
- ``gitLibgit2OptSetTemplatePath(path:)``
- ``gitLibgit2OptSetSSLCertLocations(file:path:)``
- ``gitLibgit2OptSetUserAgent(userAgent:)``
- ``gitLibgit2OptEnableStrictObjectCreation(enabled:)``
- ``gitLibgit2OptEnableStrictSymbolicRefCreation(enabled:)``
- ``gitLibgit2OptSetSSLCiphers(ciphers:)``
- ``gitLibgit2OptGetUserAgent(out:)``
- ``gitLibgit2OptEnableOFSDelta(enabled:)``
- ``gitLibgit2OptEnableFSyncGitDir(enabled:)``
- ``gitLibgit2OptGetWindowsShareMode(value:)``
- ``gitLibgit2OptSetWindowsShareMode(value:)``
- ``gitLibgit2OptEnableStrictHashVerification(enabled:)``
- ``gitLibgit2OptSetAllocator(allocator:)``
- ``gitLibgit2OptEnableUnsavedIndexSafety(enabled:)``
- ``gitLibgit2OptGetPackMaxObjects(out:)``
- ``gitLibgit2OptSetPackMaxObjects(objects:)``
- ``gitLibgit2OptDisablePackKeepFileChecks(enabled:)``
- ``gitLibgit2OptEnableHTTPExpectContinue(enabled:)``
- ``gitLibgit2OptGetMWindowFileLimit(limit:)``
- ``gitLibgit2OptSetMWindowFileLimit(limit:)``
- ``gitLibgit2OptSetODBPackedPriority(priority:)``
- ``gitLibgit2OptSetODBLoosePriority(priority:)``
- ``gitLibgit2OptGetExtensions(out:)``
- ``gitLibgit2OptSetExtensions(extensions:len:)``
- ``gitLibgit2OptGetOwnerValidation(enabled:)``
- ``gitLibgit2OptSetOwnerValidation(enabled:)``
- ``gitLibgit2OptGetHomeDir(out:)``
- ``gitLibgit2OptSetHomeDir(path:)``
- ``gitLibgit2OptSetServerConnectTimeout(timeout:)``
- ``gitLibgit2OptGetServerConnectTimeout(timeout:)``
- ``gitLibgit2OptSetServerTimeout(timeout:)``
- ``gitLibgit2OptGetServerTimeout(timeout:)``
- ``gitLibgit2OptSetUserAgentProduct(userAgent:)``
- ``gitLibgit2OptGetUserAgentProduct(out:)``
- ``gitLibgit2OptAddSSLX509Cert(cert:)``
