# Config

System-level, repository-level, and user-level Git configuration.

## Topics

### Structs

- ``GitConfigEntry``
- ``GitConfigMap``

### Enums

- ``GitConfigLevelT``
- ``GitConfigMapT``

### Callbacks

- ``GitConfigForEachCB``

### Functions

- ``gitConfigEntryFree(entry:)``
- ``gitConfigFindGlobal(out:)``
- ``gitConfigFindXDG(out:)``
- ``gitConfigFindSystem(out:)``
- ``gitConfigFindProgramData(out:)``
- ``gitConfigOpenDefault(out:)``
- ``gitConfigNew(out:)``
- ``gitConfigAddFileOnDisk(cfg:path:level:repo:force:)``
- ``gitConfigOpenOnDisk(out:path:)``
- ``gitConfigOpenLevel(out:parent:level:)``
- ``gitConfigOpenGlobal(out:config:)``
- ``gitConfigSetWriteOrder(cfg:levels:len:)``
- ``gitConfigSnapshot(out:config:)``
- ``gitConfigFree(cfg:)``
- ``gitConfigGetEntry(out:cfg:name:)``
- ``gitConfigGetInt32(out:cfg:name:)``
- ``gitConfigGetInt64(out:cfg:name:)``
- ``gitConfigGetBool(out:cfg:name:)``
- ``gitConfigGetPath(out:cfg:name:)``
- ``gitConfigGetString(out:cfg:name:)``
- ``gitConfigGetStringBuf(out:cfg:name:)``
- ``gitConfigGetMultivarForEach(cfg:name:regExp:callback:payload:)``
- ``gitConfigMultivarIteratorNew(out:cfg:name:regExp:)``
- ``gitConfigNext(entry:iter:)``
- ``gitConfigIteratorFree(iter:)``
- ``gitConfigSetInt32(cfg:name:value:)``
- ``gitConfigSetInt64(cfg:name:value:)``
- ``gitConfigSetBool(cfg:name:value:)``
- ``gitConfigSetString(cfg:name:value:)``
- ``gitConfigSetMultivar(cfg:name:regExp:value:)``
- ``gitConfigDeleteEntry(cfg:name:)``
- ``gitConfigDeleteMultivar(cfg:name:regExp:)``
- ``gitConfigForEach(cfg:callback:payload:)``
- ``gitConfigIteratorNew(out:cfg:)``
- ``gitConfigIteratorGlobNew(out:cfg:regExp:)``
- ``gitConfigForEachMatch(cfg:regExp:callback:payload:)``
- ``gitConfigGetMapped(out:cfg:name:maps:mapN:)``
- ``gitConfigLookupMapValue(out:maps:mapN:value:)``
- ``gitConfigParseBool(out:value:)``
- ``gitConfigParseInt32(out:value:)``
- ``gitConfigParseInt64(out:value:)``
- ``gitConfigParsePath(out:value:)``
- ``gitConfigBackendForEachMatch(backend:regExp:callback:payload:)``
- ``gitConfigLock(tx:cfg:)``
