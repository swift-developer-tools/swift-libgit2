# Remote

Remote repositories.

## Topics

### Structs

- ``GitRemoteCreateOptions``
- ``GitPushUpdate``
- ``GitRemoteCallbacks``
- ``GitFetchOptions``
- ``GitPushOptions``
- ``GitRemoteConnectOptions``

### Macros

- ``gitRemoteCreateOptionsVersion``
- ``gitRemoteCallbacksVersion``
- ``gitFetchOptionsVersion``
- ``gitPushOptionsVersion``
- ``gitRemoteConnectOptionsVersion``

### Enums

- ``GitRemoteRedirectT``
- ``GitRemoteCreateFlags``
- ``GitRemoteUpdateFlags``
- ``GitRemoteCompletionT``
- ``GitFetchPruneT``
- ``GitRemoteAutoTagOptionT``
- ``GitFetchDepthT``

### Callbacks

- ``GitPushTransferProgressCB``
- ``GitPushNegotiationCB``
- ``GitPushUpdateReferenceCB``
- ``GitURLResolveCB``
- ``GitRemoteReadyCB``
- ``GitRemoteCompletionCB``
- ``GitRemoteUpdateTipsCB``
- ``GitRemoteUpdateRefsCB``

### Functions

- ``gitRemoteCreate(out:repo:name:url:)``
- ``gitRemoteCreateOptionsInit(opts:version:)``
- ``gitRemoteCreateWithOpts(out:url:opts:)``
- ``gitRemoteCreateWithFetchspec(out:repo:name:url:fetch:)``
- ``gitRemoteCreateAnonymous(out:repo:url:)``
- ``gitRemoteCreateDetached(out:url:)``
- ``gitRemoteLookup(out:repo:name:)``
- ``gitRemoteDup(out:source:)``
- ``gitRemoteOwner(remote:)``
- ``gitRemoteName(remote:)``
- ``gitRemoteURL(remote:)``
- ``gitRemotePushURL(remote:)``
- ``gitRemoteSetURL(repo:remote:url:)``
- ``gitRemoteSetPushURL(repo:remote:url:)``
- ``gitRemoteSetInstanceURL(remote:url:)``
- ``gitRemoteSetInstancePushURL(remote:url:)``
- ``gitRemoteAddFetch(repo:remote:refspec:)``
- ``gitRemoteGetFetchRefspecs(array:remote:)``
- ``gitRemoteAddPush(repo:remote:refspec:)``
- ``gitRemoteGetPushRefspecs(array:remote:)``
- ``gitRemoteRefspecCount(remote:)``
- ``gitRemoteGetRefspec(remote:n:)``
- ``gitRemoteLS(out:size:remote:)``
- ``gitRemoteConnected(remote:)``
- ``gitRemoteStop(remote:)``
- ``gitRemoteDisconnect(remote:)``
- ``gitRemoteFree(remote:)``
- ``gitRemoteList(out:repo:)``
- ``gitRemoteInitCallbacks(opts:version:)``
- ``gitFetchOptionsInit(opts:version:)``
- ``gitPushOptionsInit(opts:version:)``
- ``gitRemoteConnectOptionsInit(opts:version:)``
- ``gitRemoteConnect(remote:direction:callbacks:proxyOpts:customHeaders:)``
- ``gitRemoteConnectExt(remote:direction:opts:)``
- ``gitRemoteDownload(remote:refspecs:opts:)``
- ``gitRemoteUpload(remote:refspecs:opts:)``
- ``gitRemoteUpdateTips(remote:callbacks:updateFlags:downloadTags:reflogMessage:)``
- ``gitRemoteFetch(remote:refspecs:opts:reflogMessage:)``
- ``gitRemotePrune(remote:callbacks:)``
- ``gitRemotePush(remote:refspecs:opts:)``
- ``gitRemoteStats(remote:)``
- ``gitRemoteAutoTag(remote:)``
- ``gitRemoteSetAutoTag(repo:remote:value:)``
- ``gitRemotePruneRefs(remote:)``
- ``gitRemoteRename(problems:repo:name:newName:)``
- ``gitRemoteNameIsValid(valid:name:)``
- ``gitRemoteDelete(repo:name:)``
- ``gitRemoteDefaultBranch(out:remote:)``
