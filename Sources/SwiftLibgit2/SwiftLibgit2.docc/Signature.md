# Signature

Information about an actor in a repository.

## Topics

### Structs

- ``GitSignature``

### Functions

- ``gitSignatureNew(out:name:email:time:offset:)``
- ``gitSignatureNow(out:name:email:)``
- ``gitSignatureDefaultFromEnv(authorOut:committerOut:repo:)``
- ``gitSignatureDefault(out:repo:)``
- ``gitSignatureFromBuffer(out:buf:)``
- ``gitSignatureDup(dest:sig:)``
- ``gitSignatureFree(sig:)``
