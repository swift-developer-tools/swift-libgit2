# ``SwiftLibgit2``

Direct Swift bindings to libgit2.



## Overview

swift-libgit2 provides direct Swift bindings to [libgit2](https://libgit2.org).
libgit2 is a pure C implementation of core [Git](https://git-scm.com) methods.

Swift bindings are provided for almost every API available in libgit2. Direct
access to the libgit2 C library is also provided by the package. There are no
Swift bindings for opaque structs, initialization functions and macros, or 
variadic functions that do not use `va_list` for their arguments, but these may 
be accessed by importing the C library. See the Usage section below for an 
example of how to import and use either library.

The Swift bindings use the same signatures and parameter names as 
their C equivalents, but are written using 
[camel case](https://en.wikipedia.org/wiki/Camel_case) rather than 
[snake case](https://en.wikipedia.org/wiki/Snake_case).

Similar to libgit2, the Swift bindings do not use 
[namespaces](https://en.wikipedia.org/wiki/Namespace). All Swift bindings are
available globally.

The Swift bindings use native Swift types wherever possible, while preserving 
libgit2's behavior and semantics. For example, some functions and structs are 
translated to use Swift types like `String` instead of `UnsafePointer<CChar>`.

Some bindings must use C types to maintain compatibility with libgit2's 
memory management and calling conventions. This includes callbacks invoked by 
libgit2 internally, output parameters where libgit2 owns the returned memory, 
and other cases where C types cannot be accurately represented in Swift.

The Swift bindings for some C enums are represented as structs, but remain in 
their respective "Enums" documentation section to match libgit2's API 
organization.



## Installation

swift-libgit2 may be installed through 
[Swift Package Manager](https://docs.swift.org/swiftpm/documentation/packagemanagerdocs/) 
by entering the following URL: 
[https://github.com/swift-developer-tools/swift-libgit2.git](https://github.com/swift-developer-tools/swift-libgit2.git).

See the Xcode documentation for step-by-step instructions on how to 
[add package dependencies](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app).

All necessary dependencies are handled by the package, which includes compiled 
builds of libgit2, [libssh2](https://libssh2.org), and 
[OpenSSL](https://www.openssl.org). See the Bundled Dependencies section below 
for more information.

swift-libgit2 has been built to run on the following iOS and macOS platforms, 
on both devices and simulators:

| Platform        | Minimum Version |
|-----------------|-----------------|
| iOS             | 15.0            |
| macOS           | 11.0            |

The macOS builds support both Apple Silicon and Intel.



## Usage

Below is a brief example showing how to import both the Swift and C libraries 
into a Swift project, and then use them to initialize and shut down the 
global libgit2 state.

```swift
// Import the Swift library.
import SwiftLibgit2

// Import the C library.
import Clibgit2

// Initialize and shut down the global libgit2 state using the Swift library.
let swiftInitResult     : Int32 = gitLibgit2Init()
let swiftShutdownResult : Int32 = gitLibgit2Shutdown()

// Initialize and shut down the global libgit2 state using the C library.
let cInitResult     : Int32 = git_libgit2_init()
let cShutdownResult : Int32 = git_libgit2_shutdown()
```



## Best Practices

### Error Handling

Most Swift function bindings return an `Int32` libgit2 result code.
A value of `0` represents success, while any negative value represents an error. 
Handle errors gracefully before moving on to the next step of the process.

### Memory Management

By default, Swift is 
[memory safe](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/memorysafety).
However, this applies only to pure Swift code. When using swift-libgit2, Swift 
is directly calling C code, and the caller is generally responsible for 
managing the memory.

Some APIs manage memory internally, and in these cases the caller is not 
responsible for freeing the memory. In other cases, consider using 
[`defer`](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/statements/#Defer-Statement)
statements in tandem with built-in memory-freeing functions to consistently and 
safely free memory.

### Thread Safety

libgit2 objects cannot be safely accessed by multiple threads simultaneously. 
Doing so may result in data loss or other undefined behavior. Consider using 
threading APIs such as 
[`DispatchQueue`](https://developer.apple.com/documentation/dispatch/dispatchqueue) 
to ensure thread-safe access to libgit2.

### Concurrency

Some libgit2 APIs are asynchronous, but are not exposed as asynchronous. 
Generally, any API which interacts with a remote repository will be 
asynchronous. Since swift-libgit2 provides direct bindings to libgit2, no 
Swift methods are asynchronous either. Consider using an appropriate 
[concurrency](https://docs.swift.org/swift-book/documentation/the-swift-programming-language/concurrency/) 
API to handle these cases and other synchronous work which may be better 
performed off the main thread.

### Secure Storage

libgit2 supports the use of personal access tokens and SSH credentials to 
authenticate when accessing remote repositories. swift-libgit2 has been built 
to support these authentication methods, including in-memory SSH. Consider using 
[iCloud Keychain](https://developer.apple.com/documentation/security/storing-keys-in-the-keychain) 
or other cryptographic APIs to securely store authentication data with 
end-to-end encryption.



## Attribution

See the [`Licenses`](https://github.com/swift-developer-tools/swift-libgit2/tree/main/Licenses) 
folder for the complete license texts.

### Documentation

<!-- TODO: Link to GitHub Pages -->
swift-libgit2 documentation is adapted from libgit2 under the
MIT License.

Copyright &copy; 2013 The libgit2 contributors

### Source Code

swift-libgit2 includes source code adapted from the Swift.org open source 
project under the Apache License, Version 2.0, with Runtime Library Exception.

Copyright &copy; 2014 - 2016 Apple Inc. and the Swift project authors.

See [https://swift.org/LICENSE.txt](https://swift.org/LICENSE.txt) for license 
information.

See [https://swift.org/CONTRIBUTORS.txt](https://swift.org/CONTRIBUTORS.txt) for 
the list of Swift project authors.

### Bundled Dependencies

swift-libgit2 includes the following compiled libraries:

| Library | Version | Source  | License |
|---------|---------|---------|---------|
| libgit2 | 1.9.1   | [https://github.com/libgit2/libgit2](https://github.com/libgit2/libgit2) | GNU GPL, Version 2, with linking exception |
| libssh2 | 1.11.1  | [https://github.com/libssh2/libssh2](https://github.com/libssh2/libssh2) | BSD-3-Clause License |
| OpenSSL | 3.5.2   | [https://github.com/openssl/openssl](https://github.com/openssl/openssl) | Apache License, Version 2.0 |



## Topics

### Annotated Commit Functions

- ``gitAnnotatedCommitFromRef(out:repo:ref:)``
- ``gitAnnotatedCommitFromFetchhead(out:repo:branchName:remoteURL:id:)``
- ``gitAnnotatedCommitLookup(out:repo:id:)``
- ``gitAnnotatedCommitFromRevspec(out:repo:revspec:)``
- ``gitAnnotatedCommitID(commit:)``
- ``gitAnnotatedCommitRef(commit:)``
- ``gitAnnotatedCommitFree(commit:)``

### Apply Structs

- ``GitApplyOptions``

### Apply Macros

- ``gitApplyOptionsVersion``

### Apply Enums

- ``GitApplyFlagsT``
- ``GitApplyLocationT``

### Apply Callbacks

- ``GitApplyDeltaCB``
- ``GitApplyHunkCB``

### Apply Functions

- ``gitApplyToTree(out:repo:preimage:diff:options:)``
- ``gitApply(repo:diff:location:options:)``

### Attr Structs

- ``GitAttrOptions``

### Attr Macros

- ``gitAttrIsTrue(attr:)``
- ``gitAttrIsFalse(attr:)``
- ``gitAttrIsUnspecified(attr:)``
- ``gitAttrHasValue(attr:)``
- ``gitAttrOptionsVersion``

### Attr Enums

- ``GitAttrCheckFlagsT``
- ``GitAttrValueT``

### Attr Callbacks

- ``GitAttrForEachCB``

### Attr Functions

- ``gitAttrValue(attr:)``
- ``gitAttrGet(valueOut:repo:flags:path:name:)``
- ``gitAttrGetExt(valueOut:repo:opts:path:name:)``
- ``gitAttrGetMany(valueOut:repo:flags:path:numAttr:names:)``
- ``gitAttrGetManyExt(valueOut:repo:opts:path:numAttr:names:)``
- ``gitAttrForEach(repo:flags:path:callback:payload:)``
- ``gitAttrForEachExt(repo:opts:path:callback:payload:)``
- ``gitAttrCacheFlush(repo:)``
- ``gitAttrAddMacro(repo:name:values:)``

### Blame Structs

- ``GitBlameOptions``
- ``GitBlameHunk``
- ``GitBlameLine``

### Blame Macros

- ``gitBlameOptionsVersion``

### Blame Enums

- ``GitBlameFlagT``

### Blame Functions

- ``gitBlameLineCount(blame:)``
- ``gitBlameHunkCount(blame:)``
- ``gitBlameHunkByIndex(blame:index:)``
- ``gitBlameHunkByLine(blame:lineNo:)``
- ``gitBlameLineByIndex(blame:idx:)``
- ``gitBlameGetHunkCount(blame:)``
- ``gitBlameGetHunkByIndex(blame:index:)``
- ``gitBlameGetHunkByLine(blame:lineNo:)``
- ``gitBlameFile(out:repo:path:options:)``
<!-- ``gitBlameFileFromBuffer(out:repo:path:contents:contentsLen:options:)``-->
- ``gitBlameBuffer(out:base:buffer:bufferLen:)``
- ``gitBlameFree(blame:)``

### Blob Structs

- ``GitBlobFilterOptions``

### Blob Macros

- ``gitBlobFilterOptionsVersion``

### Blob Enums

- ``GitBlobFilterFlagT``

### Blob Functions

- ``gitBlobLookup(blob:repo:id:)``
- ``gitBlobLookupPrefix(blob:repo:id:len:)``
- ``gitBlobFree(blob:)``
- ``gitBlobID(blob:)``
- ``gitBlobOwner(blob:)``
- ``gitBlobRawContent(blob:)``
- ``gitBlobRawSize(blob:)``
- ``gitBlobFilter(out:blob:asPath:opts:)``
- ``gitBlobCreateFromWorkdir(id:repo:relativePath:)``
- ``gitBlobCreateFromDisk(id:repo:path:)``
- ``gitBlobCreateFromStream(out:repo:hintPath:)``
- ``gitBlobCreateFromStreamCommit(out:stream:)``
- ``gitBlobCreateFromBuffer(id:repo:buffer:len:)``
- ``gitBlobIsBinary(blob:)``
- ``gitBlobDataIsBinary(data:len:)``
- ``gitBlobDup(out:source:)``

### Branch Enums

- ``GitBranchT``

### Branch Functions

- ``gitBranchCreate(out:repo:branchName:target:force:)``
- ``gitBranchCreateFromAnnotated(refOut:repo:branchName:target:force:)``
- ``gitBranchDelete(branch:)``
- ``gitBranchIteratorNew(out:repo:listFlags:)``
- ``gitBranchNext(out:outType:iter:)``
- ``gitBranchIteratorFree(iter:)``
- ``gitBranchMove(out:branch:newBranchName:force:)``
- ``gitBranchLookup(out:repo:branchName:branchType:)``
- ``gitBranchName(out:ref:)``
- ``gitBranchUpstream(out:ref:)``
- ``gitBranchSetUpstream(branch:branchName:)``
- ``gitBranchUpstreamName(out:repo:refName:)``
- ``gitBranchIsHEAD(branch:)``
- ``gitBranchIsCheckedOut(branch:)``
- ``gitBranchRemoteName(out:repo:refName:)``
- ``gitBranchUpstreamRemote(buf:repo:refName:)``
- ``gitBranchUpstreamMerge(buf:repo:refName:)``
- ``gitBranchIsValid(valid:name:)``

### Buffer Structs

- ``GitBuf``

### Buffer Functions

- ``gitBufDispose(buffer:)``

### Cert Structs

- ``GitCert``
- ``GitCertHostKey``
- ``GitCertX509``

### Cert Enums

- ``GitCertT``
- ``GitCertSSHT``
- ``GitCertSSHRawTypeT``

### Cert Callbacks

- ``GitTransportCertificateCheckCB``

### Checkout Structs

- ``GitCheckoutPerfData``
- ``GitCheckoutOptions``

### Checkout Macros

- ``gitCheckoutOptionsVersion``

### Checkout Enums

- ``GitCheckoutStrategyT``
- ``GitCheckoutNotifyT``

### Checkout Callbacks

- ``GitCheckoutNotifyCB``
- ``GitCheckoutProgressCB``
- ``GitCheckoutPerfDataCB``

### Checkout Functions

- ``gitCheckoutHEAD(repo:opts:)``
- ``gitCheckoutIndex(repo:index:opts:)``
- ``gitCheckoutTree(repo:treeish:opts:)``

### Cherry-Pick Structs

- ``GitCherrypickOptions``

### Cherry-Pick Macros

- ``gitCherrypickOptionsVersion``

### Cherry-Pick Functions

- ``gitCherrypickCommit(out:repo:cherrypickCommit:ourCommit:mainline:mergeOptions:)``
- ``gitCherrypick(repo:commit:cherrypickOptions:)``

### Clone Structs

- ``GitCloneOptions``

### Clone Macros

- ``gitCloneOptionsVersion``

### Clone Enums

- ``GitCloneLocalT``

### Clone Callbacks

- ``GitRemoteCreateCB``
- ``GitRepositoryCreateCB``

### Clone Functions

- ``gitClone(out:url:localPath:options:)``

### Commit Structs

- ``GitCommitCreateOptions``
- ``GitCommitArray``

### Commit Macros

- ``gitCommitCreateOptionsVersion``

### Commit Callbacks

- ``GitCommitCreateCB``

### Commit Functions

- ``gitCommitLookup(commit:repo:id:)``
- ``gitCommitLookupPrefix(commit:repo:id:len:)``
- ``gitCommitFree(commit:)``
- ``gitCommitID(commit:)``
- ``gitCommitOwner(commit:)``
- ``gitCommitMessageEncoding(commit:)``
- ``gitCommitMessage(commit:)``
- ``gitCommitMessageRaw(commit:)``
- ``gitCommitSummary(commit:)``
- ``gitCommitBody(commit:)``
- ``gitCommitTime(commit:)``
- ``gitCommitTimeOffset(commit:)``
- ``gitCommitCommitter(commit:)``
- ``gitCommitAuthor(commit:)``
- ``gitCommitCommitterWithMailmap(out:commit:mailmap:)``
- ``gitCommitAuthorWithMailmap(out:commit:mailmap:)``
- ``gitCommitRawHeader(commit:)``
- ``gitCommitTree(out:commit:)``
- ``gitCommitTreeID(commit:)``
- ``gitCommitParentCount(commit:)``
- ``gitCommitParent(out:commit:n:)``
- ``gitCommitParentID(commit:n:)``
- ``gitCommitNthGenAncestor(ancestor:commit:n:)``
- ``gitCommitHeaderField(out:commit:field:)``
- ``gitCommitExtractSignature(signature:signedData:repo:commitID:field:)``
- ``gitCommitCreate(id:repo:updateRef:author:committer:messageEncoding:message:tree:parentCount:parents:)``
- ``gitCommitCreateFromStage(id:repo:message:opts:)``
- ``gitCommitAmend(id:commitToAmend:updateRef:author:committer:messageEncoding:message:tree:)``
- ``gitCommitCreateBuffer(out:repo:author:committer:messageEncoding:message:tree:parentCount:parents:)``
- ``gitCommitCreateWithSignature(out:repo:commitContent:signature:signatureField:)``
- ``gitCommitDup(out:source:)``
- ``gitCommitArrayDispose(array:)``

### Credential Enums

- ``GitCredentialT``

### Credential Callbacks

- ``GitCredentialAcquireCB``

### Diff Structs

- ``GitDiffFile``
- ``GitDiffDelta``
- ``GitDiffSimilarityMetric``

### Diff Enums

- ``GitDeltaT``
- ``GitDiffFlagT``

### Global Functions

- ``gitLibgit2Init()``
- ``gitLibgit2Shutdown()``

### Indexer Callbacks

- ``GitIndexerProgressCB``

### Merge Structs

- ``GitMergeOptions``

### Merge Macros

- ``gitMergeOptionsVersion``

### Merge Enums

- ``GitMergeFlagT``
- ``GitMergeFileFavorT``
- ``GitMergeFileFlagT``

### Object Aliases

- ``GitObjectSizeT``

### OID Structs

- ``GitOID``

### OID Functions

- ``gitOIDEqual(a:b:)``

### Pack Callbacks

- ``GitPackbuilderForEachCB``
- ``GitPackbuilderProgressCB``

### Proxy Structs

- ``GitProxyOptions``

### Proxy Macros

- ``gitProxyOptionsVersion``

### Proxy Enums

- ``GitProxyT``

### Remote Structs

- ``GitRemoteCallbacks``
- ``GitFetchOptions``

### Remote Macros

- ``gitRemoteCreateOptionsVersion``
- ``gitRemoteCallbacksVersion``
- ``gitFetchOptionsVersion``
- ``gitPushOptionsVersion``
- ``gitRemoteConnectOptionsVersion``

### Remote Enums

- ``GitRemoteRedirectT``
- ``GitRemoteCreateFlags``
- ``GitRemoteUpdateFlags``
- ``GitRemoteCompletionT``
- ``GitFetchPruneT``
- ``GitRemoteAutoTagOptionT``
- ``GitFetchDepthT``

### Remote Callbacks

- ``GitPushTransferProgressCB``
- ``GitPushNegotiationCB``
- ``GitPushUpdateReferenceCB``
- ``GitURLResolveCB``
- ``GitRemoteReadyCB``
- ``GitRemoteCompletionCB``
- ``GitRemoteUpdateTipsCB``
- ``GitRemoteUpdateRefsCB``

### Signature Structs

- ``GitSignature``

### Signature Functions

- ``gitSignatureNew(out:name:email:time:offset:)``
- ``gitSignatureNow(out:name:email:)``
- ``gitSignatureDefaultFromEnv(authorOut:committerOut:repo:)``
- ``gitSignatureDefault(out:repo:)``
- ``gitSignatureFromBuffer(out:buf:)``
- ``gitSignatureDup(dest:sig:)``
- ``gitSignatureFree(sig:)``

### Strarray Structs

- ``GitStrArray``

### Strarray Functions

- ``gitStrArrayDispose(array:)``

### Transport Callbacks

- ``GitTransportMessageCB``
- ``GitTransportCB``

### Tree Enums

- ``GitFileModeT``

### Types Aliases

- ``GitOffT``
- ``GitTimeT``

### Types Structs

- ``GitTime``
- ``GitWritestream``

### Credential (Advanced)

- ``GitCredential``
