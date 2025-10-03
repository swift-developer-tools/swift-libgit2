# Credential

Authentication and credential management.

## Topics

### Enums

- ``GitCredentialT``

### Callbacks

- ``GitCredentialAcquireCB``
- ``GitCredentialSSHInteractiveCB``
- ``GitCredentialSignCB``

### Functions

- ``gitCredentialFree(cred:)``
- ``gitCredentialHasUsername(cred:)``
- ``gitCredentialGetUsername(cred:)``
- ``gitCredentialUserPassPlaintextNew(out:username:password:)``
- ``gitCredentialDefaultNew(out:)``
- ``gitCredentialUsernameNew(out:username:)``
- ``gitCredentialSSHKeyNew(out:username:publicKey:privateKey:passphrase:)``
- ``gitCredentialSSHKeyMemoryNew(out:username:publicKey:privateKey:passphrase:)``
- ``gitCredentialSSHInteractiveNew(out:username:promptCallback:payload:)``
- ``gitCredentialSSHKeyFromAgent(out:username:)``
- ``gitCredentialSSHCustomNew(out:username:publicKey:publicKeyLen:signCallback:payload:)``
