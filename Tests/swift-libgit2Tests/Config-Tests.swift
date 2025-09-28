//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import Clibgit2
import XCTest
@testable import SwiftLibgit2



/// Operations in these tests may succeed or fail depending on the environment.
/// `XCTAssertOK(_:)` is not used to check operation results when this is the case.
final class ConfigTests: XCTestCaseStopOnFail
{
    func testGitConfigBackendForEachMatch() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var configBackend: UnsafeMutablePointer<git_config_backend>? = nil
            
            defer
            {
                Free.freeConfigBackend(configBackend)
            }
            
            
            
            let configBackendContent: String =
            """
            [backend]
                test1 = value1
                test2 = value2
                special = special_value
            [other]
                key = other_value
            [backend]
                test3 = value3
            """
            
            let configBackendFromStringResult: Int32 = git_config_backend_from_string(
                &configBackend,
                configBackendContent,
                configBackendContent.count,
                nil
            )
            
            XCTAssertOK(configBackendFromStringResult)
            
            guard let configBackend: UnsafeMutablePointer<git_config_backend> = configBackend
            else
            {
                XCTFail("The configuration backend pointer was nil.")
                return
            }
            
            
            
            guard let open: (@convention(c)
             (
                UnsafeMutablePointer<git_config_backend>?,
                git_config_level_t,
                OpaquePointer?
            ) -> Int32) = configBackend.pointee.open
            else
            {
                XCTFail("The configuration backend open function was nil.")
                return
            }
            
            let openBackendResult: Int32 = open(
                configBackend,
                GitConfigLevelT.gitConfigLevelLocal.cValue,
                nil
            )
            
            XCTAssertOK(openBackendResult)
            
            
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let configForEachResult: Int32 = gitConfigBackendForEachMatch(
                    backend:    configBackend,
                    regExp:     "backend.*",
                    callback:   Self.configForEachCB,
                    payload:    callbackDataPointer
                )
                
                XCTAssertOK(configForEachResult)
            }
            
            XCTAssertGreaterThan(callbackData.count, 0)
            XCTAssertEqual(callbackData.values.count, 4)
            
            for entry in callbackData.values
            {
                XCTAssertTrue(entry.hasPrefix("backend."))
            }
        }
    }
    
    
    
    func testGitConfigFindPaths() throws
    {
        var buffer = GitBuf()
        
        defer
        {
            gitBufDispose(buffer: &buffer)
        }
        
        
        
        _ = gitConfigFindGlobal(out: &buffer)
        _ = gitConfigFindXDG(out: &buffer)
        _ = gitConfigFindSystem(out: &buffer)
        _ = gitConfigFindProgramData(out: &buffer)
    }
    
    
    
    func testGitConfigIteratorOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                let testValueCount: Int = 3
                
                for index in 0..<testValueCount
                {
                    let configSetStringResult: Int32 = gitConfigSetString(
                        cfg:    configPointer,
                        name:   "test.iter\(index)",
                        value:  "value\(index)"
                    )
                    
                    XCTAssertOK(configSetStringResult)
                }
                
                
                
                var allCallbackData = CallbackData()
                
                withUnsafeMutablePointer(to: &allCallbackData)
                {
                    callbackDataPointer in
                    
                    let configForEachResult: Int32 = gitConfigForEach(
                        cfg:        configPointer,
                        callback:   Self.configForEachCB,
                        payload:    callbackDataPointer
                    )
                    
                    XCTAssertOK(configForEachResult)
                }
                
                XCTAssertGreaterThan(allCallbackData.count, 0)
                
                
                
                var matchCallbackData = CallbackData()
                
                withUnsafeMutablePointer(to: &matchCallbackData)
                {
                    callbackDataPointer in
                    
                    let configForEachMatchResult: Int32 = gitConfigForEachMatch(
                        cfg:        configPointer,
                        regExp:     "test.*",
                        callback:   Self.configForEachCB,
                        payload:    callbackDataPointer
                    )
                    
                    XCTAssertOK(configForEachMatchResult)
                }
                
                XCTAssertEqual(matchCallbackData.count, testValueCount)
                XCTAssertLessThanOrEqual(matchCallbackData.count, allCallbackData.count)
                
                
                
                var configIterator: UnsafeMutablePointer<git_config_iterator>? = nil
                
                defer
                {
                    Free.freeConfigIterator(configIterator)
                }
                
                
                
                let configIteratorNewResult: Int32 = gitConfigIteratorNew(
                    out:    &configIterator,
                    cfg:    configPointer
                )
                
                XCTAssertOK(configIteratorNewResult)
                
                guard let configIterator: UnsafeMutablePointer<git_config_iterator> = configIterator
                else
                {
                    XCTFail("The configuration iterator was nil.")
                    return
                }
                
                
                
                var totalCount  : Int               = 0
                var configEntry : GitConfigEntry    = GitConfigEntry()
                
                while true
                {
                    let configNextResult: Int32 = gitConfigNext(
                        entry:  &configEntry,
                        iter:   configIterator
                    )
                    
                    if configNextResult == GIT_ITEROVER.rawValue
                    {
                        break
                    }
                    
                    XCTAssertOK(configNextResult)
                    
                    totalCount += 1
                }
                
                XCTAssertGreaterThan(totalCount, 0)
                
                
                
                var configGlobIterator: UnsafeMutablePointer<git_config_iterator>? = nil
                
                defer
                {
                    Free.freeConfigIterator(configGlobIterator)
                }
                
                
                
                let configIteratorGlobNewResult: Int32 = gitConfigIteratorGlobNew(
                    out:        &configGlobIterator,
                    cfg:        configPointer,
                    regExp:     "test.*"
                )
                
                XCTAssertOK(configIteratorGlobNewResult)
                
                guard let configGlobIterator: UnsafeMutablePointer<git_config_iterator> = configGlobIterator
                else
                {
                    XCTFail("The configuration glob iterator was nil.")
                    return
                }
                
                
                
                var filteredCount: Int = 0
                
                while true
                {
                    let configNextResult: Int32 = gitConfigNext(
                        entry:  &configEntry,
                        iter:   configGlobIterator
                    )
                    
                    if configNextResult == GIT_ITEROVER.rawValue
                    {
                        break
                    }
                    
                    XCTAssertOK(configNextResult)
                    XCTAssertNotNil(configEntry.name)
                    XCTAssertNotNil(configEntry.value)
                    XCTAssertNotNil(configEntry.backendType)
                    XCTAssertNotNil(configEntry.originPath)
                    XCTAssertTrue(configEntry.name?.hasPrefix("test.") ?? false)
                    
                    filteredCount += 1
                }
                
                XCTAssertEqual(filteredCount, testValueCount)
                XCTAssertLessThanOrEqual(filteredCount, totalCount)
            }
        }
    }
    
    
    
    func testGitConfigLevelOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            var parentConfigPointer : OpaquePointer?    = nil
            var levelConfigPointer  : OpaquePointer?    = nil
            var globalConfigPointer : OpaquePointer?    = nil
            
            defer
            {
                Free.freeConfig(parentConfigPointer)
                Free.freeConfig(levelConfigPointer)
                Free.freeConfig(globalConfigPointer)
            }
            
            
            
            let configOpenDefaultResult: Int32 = gitConfigOpenDefault(out: &parentConfigPointer)
            
            guard
                isOK(configOpenDefaultResult),
                let parentConfigPointer: OpaquePointer = parentConfigPointer
            else
            {
                /// This may succeed or fail depending on the environment.
                /// If it fails, the test cannot continue, but it is not necessarily a binding failure.
                return
            }
            
            
            
            let configOpenLevelResult: Int32 = gitConfigOpenLevel(
                out:        &levelConfigPointer,
                parent:     parentConfigPointer,
                level:      .gitConfigLevelGlobal
            )
            
            if isOK(configOpenLevelResult)
            {
                XCTAssertNotNil(levelConfigPointer)
            }
            
            
            
            let configOpenGlobalResult: Int32 = gitConfigOpenGlobal(
                out:        &globalConfigPointer,
                config:     parentConfigPointer
            )
            
            if isOK(configOpenGlobalResult)
            {
                XCTAssertNotNil(globalConfigPointer)
            }
        }
    }
    
    
    
    func testGitConfigLevelT() throws
    {
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelProgramData.rawValue, GIT_CONFIG_LEVEL_PROGRAMDATA.rawValue)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelSystem.rawValue, GIT_CONFIG_LEVEL_SYSTEM.rawValue)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelXDG.rawValue, GIT_CONFIG_LEVEL_XDG.rawValue)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelGlobal.rawValue, GIT_CONFIG_LEVEL_GLOBAL.rawValue)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelLocal.rawValue, GIT_CONFIG_LEVEL_LOCAL.rawValue)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelWorktree.rawValue, GIT_CONFIG_LEVEL_WORKTREE.rawValue)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelApp.rawValue, GIT_CONFIG_LEVEL_APP.rawValue)
        XCTAssertEqual(GitConfigLevelT.gitConfigHighestLevel.rawValue, GIT_CONFIG_HIGHEST_LEVEL.rawValue)
        XCTAssertNil(GitConfigLevelT(rawValue: 123))
        
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelProgramData.cValue, GIT_CONFIG_LEVEL_PROGRAMDATA)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelSystem.cValue, GIT_CONFIG_LEVEL_SYSTEM)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelXDG.cValue, GIT_CONFIG_LEVEL_XDG)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelGlobal.cValue, GIT_CONFIG_LEVEL_GLOBAL)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelLocal.cValue, GIT_CONFIG_LEVEL_LOCAL)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelWorktree.cValue, GIT_CONFIG_LEVEL_WORKTREE)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelApp.cValue, GIT_CONFIG_LEVEL_APP)
        XCTAssertEqual(GitConfigLevelT.gitConfigHighestLevel.cValue, GIT_CONFIG_HIGHEST_LEVEL)
    }
    
    
    
    func testGitConfigLock() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                var transactionPointer: OpaquePointer? = nil
                
                defer
                {
                    Free.freeTransaction(transactionPointer)
                }
                
                
                
                let configLockResult: Int32 = gitConfigLock(
                    tx:     &transactionPointer,
                    cfg:    configPointer
                )
                
                XCTAssertOK(configLockResult)
                XCTAssertNotNil(transactionPointer)
            }
        }
    }
    
    
    
    func testGitConfigMappingOperations() throws
    {
        var configMap1 = GitConfigMap()
        
        configMap1.type         = .gitConfigMapFalse
        configMap1.strMatch     = nil
        configMap1.mapValue     = 0
        
        var configMap2 = GitConfigMap()
        
        configMap2.type         = .gitConfigMapTrue
        configMap2.strMatch     = nil
        configMap2.mapValue     = 1
        
        var configMap3 = GitConfigMap()
        
        configMap3.type         = .gitConfigMapString
        configMap3.strMatch     = "custom"
        configMap3.mapValue     = 2
        
        let configMaps: [GitConfigMap] =
        [
            configMap1,
            configMap2,
            configMap3
        ]
        
        
        
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                let configSetBoolResult: Int32 = gitConfigSetBool(
                    cfg:    configPointer,
                    name:   "map.bool",
                    value:  true
                )
                
                XCTAssertOK(configSetBoolResult)
                
                
                
                var mappedValue: Int32 = -1
                
                let configGetMappedBoolResult: Int32 = gitConfigGetMapped(
                    out:    &mappedValue,
                    cfg:    configPointer,
                    name:   "map.bool",
                    maps:   configMaps,
                    mapN:   configMaps.count
                )
                
                XCTAssertOK(configGetMappedBoolResult)
                XCTAssertEqual(mappedValue, 1)
                
                
                
                let configSetStringResult: Int32 = gitConfigSetString(
                    cfg:    configPointer,
                    name:   "map.string",
                    value:  "custom"
                )
                
                XCTAssertOK(configSetStringResult)
                
                
                
                let configGetMappedStringResult: Int32 = gitConfigGetMapped(
                    out:    &mappedValue,
                    cfg:    configPointer,
                    name:   "map.string",
                    maps:   configMaps,
                    mapN:   configMaps.count
                )
                
                XCTAssertOK(configGetMappedStringResult)
                XCTAssertEqual(mappedValue, 2)
                
                
                
                var lookupValue: Int32 = -1
                
                let configLookupMapValueResult: Int32 = gitConfigLookupMapValue(
                    out:    &lookupValue,
                    maps:   configMaps,
                    mapN:   configMaps.count,
                    value:  "true"
                )
                
                XCTAssertOK(configLookupMapValueResult)
                XCTAssertEqual(lookupValue, 1)
            }
        }
    }
    
    
    
    func testGitConfigMapT() throws
    {
        XCTAssertEqual(GitConfigMapT.gitConfigMapFalse.rawValue, GIT_CONFIGMAP_FALSE.rawValue)
        XCTAssertEqual(GitConfigMapT.gitConfigMapTrue.rawValue, GIT_CONFIGMAP_TRUE.rawValue)
        XCTAssertEqual(GitConfigMapT.gitConfigMapInt32.rawValue, GIT_CONFIGMAP_INT32.rawValue)
        XCTAssertEqual(GitConfigMapT.gitConfigMapString.rawValue, GIT_CONFIGMAP_STRING.rawValue)
        XCTAssertNil(GitConfigMapT(rawValue: 123))
        
        XCTAssertEqual(GitConfigMapT.gitConfigMapFalse.cValue, GIT_CONFIGMAP_FALSE)
        XCTAssertEqual(GitConfigMapT.gitConfigMapTrue.cValue, GIT_CONFIGMAP_TRUE)
        XCTAssertEqual(GitConfigMapT.gitConfigMapInt32.cValue, GIT_CONFIGMAP_INT32)
        XCTAssertEqual(GitConfigMapT.gitConfigMapString.cValue, GIT_CONFIGMAP_STRING)
    }
    
    
    
    func testGitConfigMultivarOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                let multivarName    : String    = "test.multivar"
                let testValueCount  : Int       = 3
                
                for index in 0..<testValueCount
                {
                    var configSetMultivarResult: Int32 = gitConfigSetMultivar(
                        cfg:        configPointer,
                        name:       multivarName,
                        regExp:     "",
                        value:      "value\(index)"
                    )
                    
                    XCTAssertOK(configSetMultivarResult)
                    
                    
                    
                    let configDeleteMultivarResult: Int32 = gitConfigDeleteMultivar(
                        cfg:        configPointer,
                        name:       multivarName,
                        regExp:     "test.multivar*"
                    )
                    
                    XCTAssertOK(configDeleteMultivarResult)
                    
                    
                    
                    configSetMultivarResult = gitConfigSetMultivar(
                        cfg:        configPointer,
                        name:       multivarName,
                        regExp:     "",
                        value:      "value\(index)"
                    )
                    
                    XCTAssertOK(configSetMultivarResult)
                }
                
                
                
                var callbackData = CallbackData()
                
                withUnsafeMutablePointer(to: &callbackData)
                {
                    callbackDataPointer in
                    
                    let configGetMultivarForEachResult: Int32 = gitConfigGetMultivarForEach(
                        cfg:        configPointer,
                        name:       multivarName,
                        regExp:     nil,
                        callback:   Self.configForEachCB,
                        payload:    callbackDataPointer
                    )
                    
                    XCTAssertOK(configGetMultivarForEachResult)
                }
                
                XCTAssertGreaterThan(callbackData.count, 0)
                XCTAssertEqual(callbackData.values.count, 1)
                
                for entry in callbackData.values
                {
                    XCTAssertTrue(entry.hasPrefix("test."))
                }
                
                
                
                var configIterator: UnsafeMutablePointer<git_config_iterator>? = nil
                
                defer
                {
                    Free.freeConfigIterator(configIterator)
                }
                
                
                
                let configMultivarIteratorNewResult: Int32 = gitConfigMultivarIteratorNew(
                    out:        &configIterator,
                    cfg:        configPointer,
                    name:       multivarName,
                    regExp:     nil
                )
                
                XCTAssertOK(configMultivarIteratorNewResult)
                
                guard let configIterator: UnsafeMutablePointer<git_config_iterator> = configIterator
                else
                {
                    XCTFail("The configuration iterator was nil.")
                    return
                }
                
                
                
                var valueCount  : Int               = 0
                var configEntry : GitConfigEntry    = GitConfigEntry()
                
                while true
                {
                    let configNextResult: Int32 = gitConfigNext(
                        entry:  &configEntry,
                        iter:   configIterator
                    )
                    
                    if configNextResult == GIT_ITEROVER.rawValue
                    {
                        break
                    }
                    
                    XCTAssertOK(configNextResult)
                    XCTAssertNotNil(configEntry.name)
                    XCTAssertNotNil(configEntry.value)
                    XCTAssertNotNil(configEntry.backendType)
                    XCTAssertNotNil(configEntry.originPath)
                    XCTAssertTrue(configEntry.name?.hasPrefix("test.") ?? false)
                    
                    valueCount += 1
                }
                
                XCTAssertGreaterThan(valueCount, 0)
            }
        }
    }
    
    
    
    func testGitConfigNew() throws
    {
        var configPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeConfig(configPointer)
        }
        
        
        
        let configNewResult: Int32 = gitConfigNew(out: &configPointer)
        
        XCTAssertOK(configNewResult)
        XCTAssertNotNil(configPointer)
    }
    
    
    
    func testGitConfigOpenDefault() throws
    {
        var configPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeConfig(configPointer)
        }
        
        
        
        let configOpenDefaultResult: Int32 = gitConfigOpenDefault(out: &configPointer)
        
        if isOK(configOpenDefaultResult)
        {
            XCTAssertNotNil(configPointer)
        }
    }
    
    
    
    func testGitConfigOnDiskOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                var newConfigPointer: OpaquePointer? = nil
                
                defer
                {
                    Free.freeConfig(newConfigPointer)
                }
                
                
                
                let configNewResult: Int32 = gitConfigNew(out: &newConfigPointer)
                
                XCTAssertOK(configNewResult)
                
                guard let newConfigPointer: OpaquePointer = newConfigPointer
                else
                {
                    XCTFail("The new configuration pointer was nil.")
                    return
                }
                
                
                
                let configAddFileOnDiskResult: Int32 = gitConfigAddFileOnDisk(
                    cfg:    newConfigPointer,
                    path:   repository.configPath,
                    level:  .gitConfigLevelLocal,
                    repo:   repository.pointer,
                    force:  false
                )
                
                XCTAssertOK(configAddFileOnDiskResult)
            }
        }
    }
    
    
    
    func testGitConfigParsingOperations() throws
    {
        var boolResult: Bool = false
        
        let configParseTrueResult: Int32 = gitConfigParseBool(
            out:    &boolResult,
            value:  "yes"
        )
        
        XCTAssertOK(configParseTrueResult)
        XCTAssertTrue(boolResult)
        
        
        
        let configParseFalseResult: Int32 = gitConfigParseBool(
            out:    &boolResult,
            value:  "no"
        )
        
        XCTAssertOK(configParseFalseResult)
        XCTAssertFalse(boolResult)
        
        
        
        var int32Result: Int32 = 0
        
        let configParseInt32Result: Int32 = gitConfigParseInt32(
            out:    &int32Result,
            value:  "123"
        )
        
        XCTAssertOK(configParseInt32Result)
        XCTAssertEqual(int32Result, 123)
        
        
        
        let configParseInt32SuffixResult: Int32 = gitConfigParseInt32(
            out:    &int32Result,
            value:  "1k"
        )
        
        XCTAssertOK(configParseInt32SuffixResult)
        XCTAssertEqual(int32Result, 1024)
        
        
        
        var int64Result: Int64 = 0
        
        let configParseInt64Result: Int32 = gitConfigParseInt64(
            out:    &int64Result,
            value:  "123"
        )
        
        XCTAssertOK(configParseInt64Result)
        XCTAssertEqual(int64Result, 123)
        
        
        
        let configParseInt64SuffixResult: Int32 = gitConfigParseInt64(
            out:    &int64Result,
            value:  "1k"
        )
        
        XCTAssertOK(configParseInt64SuffixResult)
        XCTAssertEqual(int64Result, 1024)
        
        
        
        var pathBuffer = GitBuf()
        
        defer
        {
            gitBufDispose(buffer: &pathBuffer)
        }
        
        
        
        let configParsePathResult: Int32 = gitConfigParsePath(
            out:    &pathBuffer,
            value:  "~/test"
        )
        
        XCTAssertOK(configParsePathResult)
        
        guard let pathBufferPointer: UnsafeMutablePointer<CChar> = pathBuffer.ptr
        else
        {
            XCTFail("The path buffer pointer was nil.")
            return
        }
        
        guard let pathBufferContent = String(optionalCString: pathBufferPointer)
        else
        {
            XCTFail("The path buffer content was nil.")
            return
        }
        
        /// The path should be expanded. The exact value depends on the environment.
        XCTAssertNotEqual(pathBufferContent, "~/test")
        XCTAssertTrue(pathBufferContent.hasSuffix("/test"))
    }
    
    
    
    func testGitConfigSetAndGetOperations() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                let stringExpectedValue : String    = "hello world"
                let stringName          : String    = "test.string"
                
                var configSetStringResult: Int32 = gitConfigSetString(
                    cfg:    configPointer,
                    name:   stringName,
                    value:  stringExpectedValue
                )
                
                XCTAssertOK(configSetStringResult)
                
                
                
                let configDeleteEntryResult: Int32 = gitConfigDeleteEntry(
                    cfg:    configPointer,
                    name:   stringName
                )
                
                XCTAssertOK(configDeleteEntryResult)
                
                
                
                var configEntry = GitConfigEntry()
                
                var configGetEntryResult: Int32 = gitConfigGetEntry(
                    out:    &configEntry,
                    cfg:    configPointer,
                    name:   stringName
                )
                
                /// The entry was deleted.
                XCTAssertNotOK(configGetEntryResult)
                
                
                
                configSetStringResult = gitConfigSetString(
                    cfg:    configPointer,
                    name:   stringName,
                    value:  stringExpectedValue
                )
                
                XCTAssertOK(configSetStringResult)
                
                
                
                configGetEntryResult = gitConfigGetEntry(
                    out:    &configEntry,
                    cfg:    configPointer,
                    name:   stringName
                )
                
                XCTAssertOK(configGetEntryResult)
                XCTAssertNotNil(configEntry.name)
                XCTAssertNotNil(configEntry.value)
                XCTAssertNotNil(configEntry.backendType)
                XCTAssertNotNil(configEntry.originPath)
                XCTAssertEqual(configEntry.name, stringName)
                XCTAssertEqual(configEntry.value, stringExpectedValue)
                XCTAssertEqual(configEntry.level, .gitConfigLevelLocal)
                
                
                
                /// Test freeing a `git_config_entry`.
                var cConfigEntry: UnsafeMutablePointer<git_config_entry>? = nil
                
                defer
                {
                    if cConfigEntry != nil
                    {
                        gitConfigEntryFree(entry: cConfigEntry)
                    }
                }
                
                configGetEntryResult = git_config_get_entry(
                    &cConfigEntry,
                    configPointer,
                    stringName
                )
                
                XCTAssertOK(configGetEntryResult)
                XCTAssertNotNil(cConfigEntry)
                
                
                
                var stringBuffer: GitBuf = GitBuf()
                
                defer
                {
                    gitBufDispose(buffer: &stringBuffer)
                }
                
                
                
                let configGetStringBufResult: Int32 = gitConfigGetStringBuf(
                    out:    &stringBuffer,
                    cfg:    configPointer,
                    name:   stringName
                )
                
                XCTAssertOK(configGetStringBufResult)
                
                guard let stringBufferPointer: UnsafeMutablePointer<CChar> = stringBuffer.ptr
                else
                {
                    XCTFail("The string buffer pointer was nil.")
                    return
                }
                
                guard let stringBufferContent = String(optionalCString: stringBufferPointer)
                else
                {
                    XCTFail("The string buffer content was nil.")
                    return
                }
                
                XCTAssertEqual(stringBufferContent, stringExpectedValue)
                
                
                
                let int32ExpectedValue  : Int32     = 123
                let int32Name           : String    = "test.int32"
                
                let configSetInt32Result: Int32 = gitConfigSetInt32(
                    cfg:    configPointer,
                    name:   int32Name,
                    value:  int32ExpectedValue
                )
                
                XCTAssertOK(configSetInt32Result)
                
                
                
                var int32Value: Int32 = 0
                
                let configGetInt32Result: Int32 = gitConfigGetInt32(
                    out:    &int32Value,
                    cfg:    configPointer,
                    name:   int32Name
                )
                
                XCTAssertOK(configGetInt32Result)
                XCTAssertEqual(int32Value, int32ExpectedValue)
                
                
                
                let int64ExpectedValue  : Int64     = 1234567891234567890
                let int64Name           : String    = "test.int64"
                
                let configSetInt64Result: Int32 = gitConfigSetInt64(
                    cfg:    configPointer,
                    name:   int64Name,
                    value:  int64ExpectedValue
                )
                
                XCTAssertOK(configSetInt64Result)
                
                
                
                var int64Value: Int64 = 0
                
                let configGetInt64Result: Int32 = gitConfigGetInt64(
                    out:    &int64Value,
                    cfg:    configPointer,
                    name:   int64Name
                )
                
                XCTAssertOK(configGetInt64Result)
                XCTAssertEqual(int64Value, int64ExpectedValue)
                
                
                
                let boolExpectedValue   : Bool      = true
                let boolName            : String    = "test.bool"
                
                let configSetBoolResult: Int32 = gitConfigSetBool(
                    cfg:    configPointer,
                    name:   boolName,
                    value:  boolExpectedValue
                )
                
                XCTAssertOK(configSetBoolResult)
                
                
                
                var boolValue: Bool = false
                
                let configGetBoolResult: Int32 = gitConfigGetBool(
                    out:    &boolValue,
                    cfg:    configPointer,
                    name:   boolName
                )
                
                XCTAssertOK(configGetBoolResult)
                XCTAssertEqual(boolValue, boolExpectedValue)
                
                
                
                let pathExpectedValue   : String    = "~/Documents"
                let pathName            : String    = "test.path"
                
                let configSetPathResult: Int32 = gitConfigSetString(
                    cfg:    configPointer,
                    name:   pathName,
                    value:  pathExpectedValue
                )
                
                XCTAssertOK(configSetPathResult)
                
                
                
                var pathBuffer = GitBuf()
                
                defer
                {
                    gitBufDispose(buffer: &pathBuffer)
                }
                
                
                
                let configGetPathResult: Int32 = gitConfigGetPath(
                    out:    &pathBuffer,
                    cfg:    configPointer,
                    name:   pathName
                )
                
                XCTAssertOK(configGetPathResult)
                
                guard let pathBufferPointer: UnsafeMutablePointer<CChar> = pathBuffer.ptr
                else
                {
                    XCTFail("The path buffer pointer was nil.")
                    return
                }
                
                guard let pathBufferContent = String(optionalCString: pathBufferPointer)
                else
                {
                    XCTFail("The path buffer content was nil.")
                    return
                }
                
                /// The path should be expanded. The exact value depends on the environment.
                XCTAssertNotEqual(pathBufferContent, pathExpectedValue)
                XCTAssertTrue(pathBufferContent.hasSuffix("/Documents"))
            }
        }
    }
    
    
    
    func testGitConfigSnapshotAndWriteOrder() throws
    {
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                var snapshotPointer: OpaquePointer? = nil
                
                defer
                {
                    Free.freeConfig(snapshotPointer)
                }
                
                
                
                let stringExpectedValue : String    = "hello world"
                let stringName          : String    = "test.string"
                
                let configSetStringResult: Int32 = gitConfigSetString(
                    cfg:    configPointer,
                    name:   stringName,
                    value:  stringExpectedValue
                )
                
                XCTAssertOK(configSetStringResult)
                
                
                
                let configSnapshotResult: Int32 = gitConfigSnapshot(
                    out:        &snapshotPointer,
                    config:     configPointer
                )
                
                XCTAssertOK(configSnapshotResult)
                
                guard let snapshotPointer: OpaquePointer = snapshotPointer
                else
                {
                    XCTFail("The configuration snapshot pointer was nil.")
                    return
                }
                
                
                
                var stringValue: String? = nil
                
                let invalidConfigGetStringResult: Int32 = gitConfigGetString(
                    out:    &stringValue,
                    cfg:    configPointer,
                    name:   stringName
                )
                
                /// This should fail since it attempts to get the string value from a live configuration object.
                XCTAssertNotOK(invalidConfigGetStringResult)
                
                
                
                stringValue = nil
                
                let configGetStringResult: Int32 = gitConfigGetString(
                    out:    &stringValue,
                    cfg:    snapshotPointer,
                    name:   stringName
                )
                
                XCTAssertOK(configGetStringResult)
                XCTAssertNotNil(stringValue)
                XCTAssertEqual(stringValue, stringExpectedValue)
                
                
                
                let configSetWriteOrderResult: Int32 = gitConfigSetWriteOrder(
                    cfg:        configPointer,
                    levels:     [.gitConfigLevelLocal, .gitConfigLevelGlobal],
                    len:        2
                )
                
                XCTAssertOK(configSetWriteOrderResult)
            }
        }
    }
}



// MARK: - Extensions

extension ConfigTests
{
    private struct CallbackData
    {
        var count   : Int       = 0
        var values  : [String]  = []
    }
    
    
    
    private static let configForEachCB: GitConfigForEachCB =
    {
        entry, payload in
        
        if entry == nil
        {
            return 1
        }
        
        guard let payload: UnsafeMutableRawPointer = payload
        else
        {
            return GIT_OK.rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.count += 1
        
        if
            let name    = String(optionalCString: entry?.pointee.name),
            let value   = String(optionalCString: entry?.pointee.value)
        {
            payloadPointer.pointee.values.append("\(name)=\(value)")
        }
        
        return GIT_OK.rawValue
    }
    
    
    
    /// Calls the closure with a pointer to an on-disk configuraiton object.
    /// - Parameters:
    ///   - repository: The repository in which to create the configuration object.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An `Error` if the configuration creation failed.
    private func withConfigOnDisk<T>(
        in  repository  : Repository,
        _   body        : (OpaquePointer) -> T
    ) throws -> T
    {
        var configPointer: OpaquePointer? = nil
        
        defer
        {
            Free.freeConfig(configPointer)
        }
        
        
        
        let configOpenOnDiskResult: Int32 = gitConfigOpenOnDisk(
            out:    &configPointer,
            path:   repository.configPath
        )
        
        XCTAssertOK(configOpenOnDiskResult)
        
        guard let configPointer: OpaquePointer = configPointer
        else
        {
            XCTFail("The configuration pointer was nil.")
            
            throw NSError.create(
                code:       Int(GIT_EUSER.rawValue),
                message:    "The configuration pointer was nil."
            )
        }
        
        return body(configPointer)
    }
}
