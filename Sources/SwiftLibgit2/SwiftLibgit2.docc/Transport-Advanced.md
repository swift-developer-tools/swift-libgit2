# Transport (Advanced)

Custom transports.

## Topics

### Structs

- ``GitFetchNegotiation``
- ``GitTransport``
- ``GitSmartSubtransportStream``
- ``GitSmartSubtransport``
- ``GitSmartSubtransportDefinition``

### Macros

- ``gitTransportVersion``

### Enums

- ``GitSmartServiceT``

### Callbacks

- ``GitSmartSubtransportCB``

### Functions

- ``gitTransportInit(transport:version:)``
- ``gitTransportNew(out:owner:url:)``
- ``gitTransportSSHWithPaths(out:owner:payload:)``
- ``gitTransportRegister(prefix:cb:param:)``
- ``gitTransportUnregister(prefix:)``
- ``gitTransportLocal(out:owner:payload:)``
- ``gitTransportSmart(out:owner:payload:)``
- ``gitTransportSmartCertificateCheck(transport:cert:valid:hostName:)``
- ``gitTransportSmartCredentials(out:transport:user:methods:)``
- ``gitTransportRemoteConnectOptions(out:transport:)``
- ``gitSmartSubtransportHTTP(out:owner:param:)``
- ``gitSmartSubtransportGit(out:owner:param:)``
- ``gitSmartSubtransportSSH(out:owner:param:)``
