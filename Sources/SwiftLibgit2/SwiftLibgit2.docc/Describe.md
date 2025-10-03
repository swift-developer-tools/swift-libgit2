# Describe

Describe a commit in reference to a tag.

## Topics

### Structs

- ``GitDescribeOptions``
- ``GitDescribeFormatOptions``

### Macros

- ``gitDescribeDefaultMaxCandidatesTags``
- ``gitDescribeDefaultAbbreviatedSize``
- ``gitDescribeOptionsVersion``
- ``gitDescribeFormatOptionsVersion``

### Enums

- ``GitDescribeStrategyT``

### Functions

- ``gitDescribeOptionsInit(opts:version:)``
- ``gitDescribeCommit(result:committish:opts:)``
- ``gitDescribeWorkdir(out:repo:opts:)``
- ``gitDescribeFormat(out:result:opts:)``
- ``gitDescribeResultFree(result:)``
