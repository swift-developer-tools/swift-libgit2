# OID

Object IDs.

## Topics

### Structs

- ``GitOID``

### Macros

- ``gitOIDDefault``
- ``gitOIDSHA1Size``
- ``gitOIDSHA1HexSize``
- ``gitOIDSHA1Zero``
- ``gitOIDSHA1HexZero``
- ``gitOIDSHA256Size``
- ``gitOIDSHA256HexSize``
- ``gitOIDSHA256HexZero``
- ``gitOIDMaxSize``
- ``gitOIDMaxHexSize``
- ``gitOIDMinPrefixLen``

### Enums

- ``GitOIDT``

### Functions

- ``gitOIDFromStr(out:str:)``
- ``gitOIDFromStrP(out:str:)``
- ``gitOIDFromStrN(out:str:length:)``
- ``gitOIDFromRaw(out:raw:)``
- ``gitOIDFmt(out:id:)``
- ``gitOIDNFmt(out:n:id:)``
- ``gitOIDPathFmt(out:id:)``
- ``gitOIDToStrS(oid:)``
- ``gitOIDToStr(out:n:id:)``
- ``gitOIDCpy(out:src:)``
- ``gitOIDCmp(a:b:)``
- ``gitOIDEqual(a:b:)``
- ``gitOIDNCmp(a:b:len:)``
- ``gitOIDStrEq(id:str:)``
- ``gitOIDStrCmp(id:str:)``
- ``gitOIDIsZero(id:)``
- ``gitOIDShortenNew(minLength:)``
- ``gitOIDShortenAdd(os:textID:)``
- ``gitOIDShortenFree(os:)``
