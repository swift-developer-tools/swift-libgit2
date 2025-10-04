# Checkout

Update the contents of the working directory to point to the data in a specific 
index or commit.

## Topics

### Structs

- ``GitCheckoutPerfData``
- ``GitCheckoutOptions``

### Macros

- ``gitCheckoutOptionsVersion``

### Enums

- ``GitCheckoutStrategyT``
- ``GitCheckoutNotifyT``

### Callbacks

- ``GitCheckoutNotifyCB``
- ``GitCheckoutProgressCB``
- ``GitCheckoutPerfDataCB``

### Functions

- ``gitCheckoutOptionsInit(opts:version:)``
- ``gitCheckoutHEAD(repo:opts:)``
- ``gitCheckoutIndex(repo:index:opts:)``
- ``gitCheckoutTree(repo:treeish:opts:)``
