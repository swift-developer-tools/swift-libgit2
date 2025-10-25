# Tag

A nearly-immutable pointer to a commit.

## Topics

### Callbacks

- ``GitTagForEachCB``

### Functions

- ``gitTagLookup(out:repo:id:)``
- ``gitTagLookupPrefix(out:repo:id:len:)``
- ``gitTagFree(tag:)``
- ``gitTagID(tag:)``
- ``gitTagOwner(tag:)``
- ``gitTagTarget(targetOut:tag:)``
- ``gitTagTargetID(tag:)``
- ``gitTagTargetType(tag:)``
- ``gitTagName(tag:)``
- ``gitTagTagger(tag:)``
- ``gitTagMessage(tag:)``
- ``gitTagCreate(oid:repo:tagName:target:tagger:message:force:)``
- ``gitTagAnnotationCreate(oid:repo:tagName:target:tagger:message:)``
- ``gitTagCreateFromBuffer(oid:repo:buffer:force:)``
- ``gitTagCreateLightweight(oid:repo:tagName:target:force:)``
- ``gitTagDelete(repo:tagName:)``
- ``gitTagList(tagNames:repo:)``
- ``gitTagListMatch(tagNames:pattern:repo:)``
- ``gitTagForEach(repo:callback:payload:)``
- ``gitTagPeel(out:tag:)``
- ``gitTagDup(out:source:)``
- ``gitTagNameIsValid(valid:name:)``
