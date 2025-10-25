# Transaction

Transactional reference handling.

## Topics

### Functions

- ``gitTransactionNew(out:repo:)``
- ``gitTransactionLockRef(tx:refName:)``
- ``gitTransactionSetTarget(tx:refName:target:sig:msg:)``
- ``gitTransactionSetSymbolicTarget(tx:refName:target:sig:msg:)``
- ``gitTransactionSetReflog(tx:refName:reflog:)``
- ``gitTransactionRemove(tx:refName:)``
- ``gitTransactionCommit(tx:)``
- ``gitTransactionFree(tx:)``
