//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2
import XCTest
@testable import SwiftLibgit2



/// Operations in these tests may succeed or fail depending on the environment.
/// ``XCTAssertOK(_:)`` is not used to check operation results when this is the
/// case.
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
                if configBackend != nil
                {
                    configBackend?.pointee.free(configBackend)
                }
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
            
            let configBackendFromStringResult: Int32
                = git_config_backend_from_string(
                    &configBackend,
                    configBackendContent,
                    configBackendContent.count,
                    nil
                )
            
            XCTAssertOK(GitErrorCode(rawValue: configBackendFromStringResult))
            
            guard let configBackend: UnsafeMutablePointer<git_config_backend>
                    = configBackend
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
                GitConfigLevelT.gitConfigLevelLocal.cValue(),
                nil
            )
            
            XCTAssertOK(GitErrorCode(rawValue: openBackendResult))
            
            
            
            var callbackData = CallbackData()
            
            withUnsafeMutablePointer(to: &callbackData)
            {
                callbackDataPointer in
                
                let configForEachResult: GitErrorCode
                    = gitConfigBackendForEachMatch(
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
    
    
    
    func testGitConfigEntry() throws
    {
        let configEntry = GitConfigEntry()
        
        XCTAssertNil(configEntry.name)
        XCTAssertNil(configEntry.value)
        XCTAssertNil(configEntry.backendType)
        XCTAssertNil(configEntry.originPath)
        XCTAssertEqual(configEntry.includeDepth, 0)
        XCTAssertEqual(configEntry.level, .gitConfigLevelLocal)
        
        configEntry.withCValue
        {
            cConfigEntry in
            
            XCTAssertNil(cConfigEntry.pointee.name)
            XCTAssertNil(cConfigEntry.pointee.value)
            XCTAssertNil(cConfigEntry.pointee.backend_type)
            XCTAssertNil(cConfigEntry.pointee.origin_path)
            XCTAssertEqual(cConfigEntry.pointee.include_depth, 0)
            XCTAssertEqual(GitConfigLevelT(cValue: cConfigEntry.pointee.level), .gitConfigLevelLocal)
        }
    }
    
    
    
    func testGitConfigEntryFree() throws
    {
        gitConfigEntryFree(entry: nil)
    }
    
    
    
    func testGitConfigFindPaths() throws
    {
        var buffer = GitBuf()
        
        defer
        {
            XCTAssertOK(gitBufDispose(buffer: &buffer))
        }
        
        
        
        _ = gitConfigFindGlobal(out: &buffer)
        _ = gitConfigFindXDG(out: &buffer)
        _ = gitConfigFindSystem(out: &buffer)
        _ = gitConfigFindProgramData(out: &buffer)
    }
    
    
    
    func testGitConfigFree() throws
    {
        gitConfigFree(cfg: nil)
    }
    
    
    
    func testGitConfigIteratorFree() throws
    {
        gitConfigIteratorFree(iter: nil)
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
                    let configSetStringResult: GitErrorCode
                        = gitConfigSetString(
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
                    
                    let configForEachResult: GitErrorCode = gitConfigForEach(
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
                    
                    let configForEachMatchResult: GitErrorCode
                        = gitConfigForEachMatch(
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
                    gitConfigIteratorFree(iter: configIterator)
                }
                
                
                
                let configIteratorNewResult: GitErrorCode = gitConfigIteratorNew(
                    out:    &configIterator,
                    cfg:    configPointer
                )
                
                XCTAssertOK(configIteratorNewResult)
                
                guard let configIterator: UnsafeMutablePointer<git_config_iterator>
                        = configIterator
                else
                {
                    XCTFail("The configuration iterator was nil.")
                    return
                }
                
                
                
                var totalCount  : Int               = 0
                var configEntry : GitConfigEntry    = GitConfigEntry()
                
                while true
                {
                    let configNextResult: GitErrorCode = gitConfigNext(
                        entry:  &configEntry,
                        iter:   configIterator
                    )
                    
                    if configNextResult == .gitIterOver
                    {
                        break
                    }
                    
                    XCTAssertOK(configNextResult)
                    
                    totalCount += 1
                }
                
                XCTAssertGreaterThan(totalCount, 0)
                
                
                
                var configGlobIterator: UnsafeMutablePointer<git_config_iterator>?
                    = nil
                
                defer
                {
                    gitConfigIteratorFree(iter: configGlobIterator)
                }
                
                
                
                let configIteratorGlobNewResult: GitErrorCode = gitConfigIteratorGlobNew(
                    out:        &configGlobIterator,
                    cfg:        configPointer,
                    regExp:     "test.*"
                )
                
                XCTAssertOK(configIteratorGlobNewResult)
                
                guard let configGlobIterator: UnsafeMutablePointer<git_config_iterator>
                        = configGlobIterator
                else
                {
                    XCTFail("The configuration glob iterator was nil.")
                    return
                }
                
                
                
                var filteredCount: Int = 0
                
                while true
                {
                    let configNextResult: GitErrorCode = gitConfigNext(
                        entry:  &configEntry,
                        iter:   configGlobIterator
                    )
                    
                    if configNextResult == .gitIterOver
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
                gitConfigFree(cfg: parentConfigPointer)
                gitConfigFree(cfg: levelConfigPointer)
                gitConfigFree(cfg: globalConfigPointer)
            }
            
            
            
            let configOpenDefaultResult: GitErrorCode
                = gitConfigOpenDefault(out: &parentConfigPointer)
            
            guard
                isOK(configOpenDefaultResult),
                let parentConfigPointer: OpaquePointer = parentConfigPointer
            else
            {
                /// This may succeed or fail depending on the environment.
                /// If it fails, the test cannot continue, but it is not
                /// necessarily a binding failure.
                return
            }
            
            
            
            let configOpenLevelResult: GitErrorCode = gitConfigOpenLevel(
                out:        &levelConfigPointer,
                parent:     parentConfigPointer,
                level:      .gitConfigLevelGlobal
            )
            
            if isOK(configOpenLevelResult)
            {
                XCTAssertNotNil(levelConfigPointer)
            }
            
            
            
            let configOpenGlobalResult: GitErrorCode = gitConfigOpenGlobal(
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
        
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelProgramData.cValue(), GIT_CONFIG_LEVEL_PROGRAMDATA)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelSystem.cValue(), GIT_CONFIG_LEVEL_SYSTEM)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelXDG.cValue(), GIT_CONFIG_LEVEL_XDG)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelGlobal.cValue(), GIT_CONFIG_LEVEL_GLOBAL)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelLocal.cValue(), GIT_CONFIG_LEVEL_LOCAL)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelWorktree.cValue(), GIT_CONFIG_LEVEL_WORKTREE)
        XCTAssertEqual(GitConfigLevelT.gitConfigLevelApp.cValue(), GIT_CONFIG_LEVEL_APP)
        XCTAssertEqual(GitConfigLevelT.gitConfigHighestLevel.cValue(), GIT_CONFIG_HIGHEST_LEVEL)
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
                
                
                
                let configLockResult: GitErrorCode = gitConfigLock(
                    tx:     &transactionPointer,
                    cfg:    configPointer
                )
                
                XCTAssertOK(configLockResult)
                XCTAssertNotNil(transactionPointer)
            }
        }
    }
    
    
    
    func testGitConfigMap() throws
    {
        let configMap = GitConfigMap()
        
        XCTAssertEqual(configMap.type, .gitConfigMapFalse)
        XCTAssertNil(configMap.strMatch)
        XCTAssertEqual(configMap.mapValue, 0)
        
        configMap.withCValue
        {
            cConfigMap in
            
            XCTAssertEqual(GitConfigMapT(cValue: cConfigMap.pointee.type), .gitConfigMapFalse)
            XCTAssertNil(cConfigMap.pointee.str_match)
            XCTAssertEqual(cConfigMap.pointee.map_value, 0)
        }
    }
    
    
    
    func testGitConfigMappingOperations() throws
    {
        let customString    : String    = "custom-value_123!"
        let anotherString   : String    = "another-value"
        
        var configMapBoolFalse = GitConfigMap()
        
        configMapBoolFalse.type         = .gitConfigMapFalse
        configMapBoolFalse.strMatch     = nil
        configMapBoolFalse.mapValue     = 0
        
        var configMapBoolTrue = GitConfigMap()
        
        configMapBoolTrue.type          = .gitConfigMapTrue
        configMapBoolTrue.strMatch      = nil
        configMapBoolTrue.mapValue      = 1
        
        var configMapStringCustom = GitConfigMap()
        
        configMapStringCustom.type          = .gitConfigMapString
        configMapStringCustom.strMatch      = customString
        configMapStringCustom.mapValue      = 2
        
        var configMapStringAnother = GitConfigMap()
        
        configMapStringAnother.type         = .gitConfigMapString
        configMapStringAnother.strMatch     = anotherString
        configMapStringAnother.mapValue     = 3
        
        var configMapStringEmpty = GitConfigMap()
        
        configMapStringEmpty.type           = .gitConfigMapString
        configMapStringEmpty.strMatch       = ""
        configMapStringEmpty.mapValue       = 4
        
        /// Interweave the `nil` `strMatch` properties to test the indexing of
        /// ``withArrayOfGitConfigMaps(_:)``.
        let configMaps: [GitConfigMap] =
        [
            configMapStringEmpty,
            configMapBoolFalse,
            configMapStringCustom,
            configMapBoolTrue,
            configMapStringAnother
        ]
        
        
        
        try Repository.withRepository
        {
            repository in
            
            try withConfigOnDisk(in: repository)
            {
                configPointer in
                
                /// Test boolean `false` mapping.
                let configSetBoolFalseResult: GitErrorCode = gitConfigSetBool(
                    cfg:    configPointer,
                    name:   "map.boolfalse",
                    value:  false
                )
                
                XCTAssertOK(configSetBoolFalseResult)
                
                
                
                var mappedValue: Int32 = -1
                
                let configGetBoolFalseResult: GitErrorCode = gitConfigGetMapped(
                    out:    &mappedValue,
                    cfg:    configPointer,
                    name:   "map.boolfalse",
                    maps:   configMaps,
                    mapN:   configMaps.count
                )
                
                XCTAssertOK(configGetBoolFalseResult)
                XCTAssertEqual(mappedValue, Int32(configMapBoolFalse.mapValue))
                
                
                
                
                /// Test boolean `true` mapping.
                let configSetBoolTrueResult: GitErrorCode = gitConfigSetBool(
                    cfg:    configPointer,
                    name:   "map.booltrue",
                    value:  true
                )
                
                XCTAssertOK(configSetBoolTrueResult)
                
                
                
                mappedValue = -1
                
                let configGetBoolTrueResult: GitErrorCode = gitConfigGetMapped(
                    out:    &mappedValue,
                    cfg:    configPointer,
                    name:   "map.booltrue",
                    maps:   configMaps,
                    mapN:   configMaps.count
                )
                
                XCTAssertOK(configGetBoolTrueResult)
                XCTAssertEqual(mappedValue, Int32(configMapBoolTrue.mapValue))
                
                
                
                /// Test string mapping with `customString`.
                let configSetCustomStringResult: GitErrorCode
                    = gitConfigSetString(
                        cfg:    configPointer,
                        name:   "map.stringcustom",
                        value:  customString
                    )
                
                XCTAssertOK(configSetCustomStringResult)
                
                
                
                mappedValue = -1
                
                let configGetCustomStringResult: GitErrorCode
                    = gitConfigGetMapped(
                        out:    &mappedValue,
                        cfg:    configPointer,
                        name:   "map.stringcustom",
                        maps:   configMaps,
                        mapN:   configMaps.count
                    )
                
                XCTAssertOK(configGetCustomStringResult)
                XCTAssertEqual(mappedValue, Int32(configMapStringCustom.mapValue))
                
                
                
                /// Test string mapping with `anotherString`.
                let configSetAnotherStringResult: GitErrorCode
                    = gitConfigSetString(
                        cfg:    configPointer,
                        name:   "map.stringanother",
                        value:  anotherString
                    )
                
                XCTAssertOK(configSetAnotherStringResult)
                
                
                
                mappedValue = -1
                
                let configGetAnotherStringResult: GitErrorCode
                    = gitConfigGetMapped(
                        out:    &mappedValue,
                        cfg:    configPointer,
                        name:   "map.stringanother",
                        maps:   configMaps,
                        mapN:   configMaps.count
                    )
                
                XCTAssertOK(configGetAnotherStringResult)
                XCTAssertEqual(mappedValue, Int32(configMapStringAnother.mapValue))
                
                
                
                /// Test string lookup with `"false"`.
                var lookupValue: Int32 = -1
                
                let configLookupFalseStringResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   configMaps,
                        mapN:   configMaps.count,
                        value:  "false"
                    )
                
                XCTAssertOK(configLookupFalseStringResult)
                XCTAssertEqual(lookupValue, Int32(configMapBoolFalse.mapValue))

                
                
                /// Test string lookup with `"true"`.
                lookupValue = -1
                
                let configLookupTrueStringResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   configMaps,
                        mapN:   configMaps.count,
                        value:  "true"
                    )
                
                XCTAssertOK(configLookupTrueStringResult)
                XCTAssertEqual(lookupValue, Int32(configMapBoolTrue.mapValue))
                
                
                
                /// Test string lookup with `customString`.
                lookupValue = -1
                
                let configLookupCustomStringResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   configMaps,
                        mapN:   configMaps.count,
                        value:  customString
                    )
                
                XCTAssertOK(configLookupCustomStringResult)
                XCTAssertEqual(lookupValue, Int32(configMapStringCustom.mapValue))
                
                
                
                /// Test string lookup with `anotherString`.
                lookupValue = -1
                
                let configLookupAnotherStringResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   configMaps,
                        mapN:   configMaps.count,
                        value:  anotherString
                    )
                
                XCTAssertOK(configLookupAnotherStringResult)
                XCTAssertEqual(lookupValue, Int32(configMapStringAnother.mapValue))
                
                
                
                /// Test with an empty array.
                lookupValue = -1
                
                let configLookupEmptyResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   [],
                        mapN:   0,
                        value:  "empty"
                    )
                
                XCTAssertNotOK(configLookupEmptyResult)
                
                
                
                /// Test with all `nil` values. This hits the fast path of
                /// ``withArrayOfGitConfigMaps(_:)``, where there is no buffer
                /// allocation.
                lookupValue = -1
                
                let configLookupAllNilResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   [configMapBoolFalse, configMapBoolTrue],
                        mapN:   2,
                        value:  "false"
                    )
                
                XCTAssertOK(configLookupAllNilResult)
                XCTAssertEqual(lookupValue, Int32(configMapBoolFalse.mapValue))
                
                
                
                /// Test with a single string.
                lookupValue = -1
                
                let configLookupSingleStringResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   [configMapStringCustom],
                        mapN:   1,
                        value:  customString
                    )
                
                XCTAssertOK(configLookupSingleStringResult)
                XCTAssertEqual(lookupValue, Int32(configMapStringCustom.mapValue))
                
                
                
                /// Test with an empty string.
                lookupValue = -1
                
                let configLookupEmptyStringResult: GitErrorCode
                    = gitConfigLookupMapValue(
                        out:    &lookupValue,
                        maps:   [configMapStringEmpty],
                        mapN:   1,
                        value:  ""
                    )
                
                XCTAssertOK(configLookupEmptyStringResult)
                XCTAssertEqual(lookupValue, Int32(configMapStringEmpty.mapValue))
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
        
        XCTAssertEqual(GitConfigMapT.gitConfigMapFalse.cValue(), GIT_CONFIGMAP_FALSE)
        XCTAssertEqual(GitConfigMapT.gitConfigMapTrue.cValue(), GIT_CONFIGMAP_TRUE)
        XCTAssertEqual(GitConfigMapT.gitConfigMapInt32.cValue(), GIT_CONFIGMAP_INT32)
        XCTAssertEqual(GitConfigMapT.gitConfigMapString.cValue(), GIT_CONFIGMAP_STRING)
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
                    var configSetMultivarResult: GitErrorCode
                        = gitConfigSetMultivar(
                            cfg:        configPointer,
                            name:       multivarName,
                            regExp:     "",
                            value:      "value\(index)"
                        )
                    
                    XCTAssertOK(configSetMultivarResult)
                    
                    
                    
                    let configDeleteMultivarResult: GitErrorCode
                        = gitConfigDeleteMultivar(
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
                    
                    let configGetMultivarForEachResult: GitErrorCode
                        = gitConfigGetMultivarForEach(
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
                
                
                
                var configIterator: UnsafeMutablePointer<git_config_iterator>?
                    = nil
                
                defer
                {
                    gitConfigIteratorFree(iter: configIterator)
                }
                
                
                
                let configMultivarIteratorNewResult: GitErrorCode
                    = gitConfigMultivarIteratorNew(
                        out:        &configIterator,
                        cfg:        configPointer,
                        name:       multivarName,
                        regExp:     nil
                    )
                
                XCTAssertOK(configMultivarIteratorNewResult)
                
                guard let configIterator: UnsafeMutablePointer<git_config_iterator>
                        = configIterator
                else
                {
                    XCTFail("The configuration iterator was nil.")
                    return
                }
                
                
                
                var valueCount  : Int               = 0
                var configEntry : GitConfigEntry    = GitConfigEntry()
                
                while true
                {
                    let configNextResult: GitErrorCode = gitConfigNext(
                        entry:  &configEntry,
                        iter:   configIterator
                    )
                    
                    if configNextResult == .gitIterOver
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
            gitConfigFree(cfg: configPointer)
        }
        
        
        
        let configNewResult: GitErrorCode = gitConfigNew(out: &configPointer)
        
        XCTAssertOK(configNewResult)
        XCTAssertNotNil(configPointer)
    }
    
    
    
    func testGitConfigOpenDefault() throws
    {
        var configPointer: OpaquePointer? = nil
        
        defer
        {
            gitConfigFree(cfg: configPointer)
        }
        
        
        
        let configOpenDefaultResult: GitErrorCode
            = gitConfigOpenDefault(out: &configPointer)
        
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
                    gitConfigFree(cfg: newConfigPointer)
                }
                
                
                
                let configNewResult: GitErrorCode
                    = gitConfigNew(out: &newConfigPointer)
                
                XCTAssertOK(configNewResult)
                
                guard let newConfigPointer: OpaquePointer = newConfigPointer
                else
                {
                    XCTFail("The new configuration pointer was nil.")
                    return
                }
                
                
                
                let configAddFileOnDiskResult: GitErrorCode
                    = gitConfigAddFileOnDisk(
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
        
        let configParseTrueResult: GitErrorCode = gitConfigParseBool(
            out:    &boolResult,
            value:  "yes"
        )
        
        XCTAssertOK(configParseTrueResult)
        XCTAssertTrue(boolResult)
        
        
        
        let configParseFalseResult: GitErrorCode = gitConfigParseBool(
            out:    &boolResult,
            value:  "no"
        )
        
        XCTAssertOK(configParseFalseResult)
        XCTAssertFalse(boolResult)
        
        
        
        var int32Result: Int32 = 0
        
        let configParseInt32Result: GitErrorCode = gitConfigParseInt32(
            out:    &int32Result,
            value:  "123"
        )
        
        XCTAssertOK(configParseInt32Result)
        XCTAssertEqual(int32Result, 123)
        
        
        
        let configParseInt32SuffixResult: GitErrorCode = gitConfigParseInt32(
            out:    &int32Result,
            value:  "1k"
        )
        
        XCTAssertOK(configParseInt32SuffixResult)
        XCTAssertEqual(int32Result, 1024)
        
        
        
        var int64Result: Int64 = 0
        
        let configParseInt64Result: GitErrorCode = gitConfigParseInt64(
            out:    &int64Result,
            value:  "123"
        )
        
        XCTAssertOK(configParseInt64Result)
        XCTAssertEqual(int64Result, 123)
        
        
        
        let configParseInt64SuffixResult: GitErrorCode = gitConfigParseInt64(
            out:    &int64Result,
            value:  "1k"
        )
        
        XCTAssertOK(configParseInt64SuffixResult)
        XCTAssertEqual(int64Result, 1024)
        
        
        
        var pathBuffer = GitBuf()
        
        defer
        {
            XCTAssertOK(gitBufDispose(buffer: &pathBuffer))
        }
        
        
        
        let configParsePathResult: GitErrorCode = gitConfigParsePath(
            out:    &pathBuffer,
            value:  "~/test"
        )
        
        XCTAssertOK(configParsePathResult)
        
        guard let pathBufferPointer: UnsafeMutablePointer<CChar>
                = pathBuffer.ptr
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
        
        /// The path should be expanded. The exact value depends on the
        /// environment.
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
                
                var configSetStringResult: GitErrorCode = gitConfigSetString(
                    cfg:    configPointer,
                    name:   stringName,
                    value:  stringExpectedValue
                )
                
                XCTAssertOK(configSetStringResult)
                
                
                
                let configDeleteEntryResult: GitErrorCode
                    = gitConfigDeleteEntry(
                        cfg:    configPointer,
                        name:   stringName
                    )
                
                XCTAssertOK(configDeleteEntryResult)
                
                
                
                var configEntry = GitConfigEntry()
                
                var configGetEntryResult: GitErrorCode = gitConfigGetEntry(
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
                    gitConfigEntryFree(entry: cConfigEntry)
                }
                
                let cConfigGetEntryResult: Int32 = git_config_get_entry(
                    &cConfigEntry,
                    configPointer,
                    stringName
                )
                
                XCTAssertOK(GitErrorCode(rawValue: cConfigGetEntryResult))
                XCTAssertNotNil(cConfigEntry)
                
                
                
                var stringBuffer: GitBuf = GitBuf()
                
                defer
                {
                    XCTAssertOK(gitBufDispose(buffer: &stringBuffer))
                }
                
                
                
                let configGetStringBufResult: GitErrorCode
                    = gitConfigGetStringBuf(
                        out:    &stringBuffer,
                        cfg:    configPointer,
                        name:   stringName
                    )
                
                XCTAssertOK(configGetStringBufResult)
                
                guard let stringBufferPointer: UnsafeMutablePointer<CChar>
                        = stringBuffer.ptr
                else
                {
                    XCTFail("The string buffer pointer was nil.")
                    return
                }
                
                guard let stringBufferContent
                        = String(optionalCString: stringBufferPointer)
                else
                {
                    XCTFail("The string buffer content was nil.")
                    return
                }
                
                XCTAssertEqual(stringBufferContent, stringExpectedValue)
                
                
                
                let int32ExpectedValue  : Int32     = 123
                let int32Name           : String    = "test.int32"
                
                let configSetInt32Result: GitErrorCode = gitConfigSetInt32(
                    cfg:    configPointer,
                    name:   int32Name,
                    value:  int32ExpectedValue
                )
                
                XCTAssertOK(configSetInt32Result)
                
                
                
                var int32Value: Int32 = 0
                
                let configGetInt32Result: GitErrorCode = gitConfigGetInt32(
                    out:    &int32Value,
                    cfg:    configPointer,
                    name:   int32Name
                )
                
                XCTAssertOK(configGetInt32Result)
                XCTAssertEqual(int32Value, int32ExpectedValue)
                
                
                
                let int64ExpectedValue  : Int64     = 1234567891234567890
                let int64Name           : String    = "test.int64"
                
                let configSetInt64Result: GitErrorCode = gitConfigSetInt64(
                    cfg:    configPointer,
                    name:   int64Name,
                    value:  int64ExpectedValue
                )
                
                XCTAssertOK(configSetInt64Result)
                
                
                
                var int64Value: Int64 = 0
                
                let configGetInt64Result: GitErrorCode = gitConfigGetInt64(
                    out:    &int64Value,
                    cfg:    configPointer,
                    name:   int64Name
                )
                
                XCTAssertOK(configGetInt64Result)
                XCTAssertEqual(int64Value, int64ExpectedValue)
                
                
                
                let boolExpectedValue   : Bool      = true
                let boolName            : String    = "test.bool"
                
                let configSetBoolResult: GitErrorCode = gitConfigSetBool(
                    cfg:    configPointer,
                    name:   boolName,
                    value:  boolExpectedValue
                )
                
                XCTAssertOK(configSetBoolResult)
                
                
                
                var boolValue: Bool = false
                
                let configGetBoolResult: GitErrorCode = gitConfigGetBool(
                    out:    &boolValue,
                    cfg:    configPointer,
                    name:   boolName
                )
                
                XCTAssertOK(configGetBoolResult)
                XCTAssertEqual(boolValue, boolExpectedValue)
                
                
                
                let pathExpectedValue   : String    = "~/Documents"
                let pathName            : String    = "test.path"
                
                let configSetPathResult: GitErrorCode = gitConfigSetString(
                    cfg:    configPointer,
                    name:   pathName,
                    value:  pathExpectedValue
                )
                
                XCTAssertOK(configSetPathResult)
                
                
                
                var pathBuffer = GitBuf()
                
                defer
                {
                    XCTAssertOK(gitBufDispose(buffer: &pathBuffer))
                }
                
                
                
                let configGetPathResult: GitErrorCode = gitConfigGetPath(
                    out:    &pathBuffer,
                    cfg:    configPointer,
                    name:   pathName
                )
                
                XCTAssertOK(configGetPathResult)
                
                guard let pathBufferPointer: UnsafeMutablePointer<CChar>
                        = pathBuffer.ptr
                else
                {
                    XCTFail("The path buffer pointer was nil.")
                    return
                }
                
                guard let pathBufferContent
                        = String(optionalCString: pathBufferPointer)
                else
                {
                    XCTFail("The path buffer content was nil.")
                    return
                }
                
                /// The path should be expanded. The exact value depends on
                /// the environment.
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
                    gitConfigFree(cfg: snapshotPointer)
                }
                
                
                
                let stringExpectedValue : String    = "hello world"
                let stringName          : String    = "test.string"
                
                let configSetStringResult: GitErrorCode = gitConfigSetString(
                    cfg:    configPointer,
                    name:   stringName,
                    value:  stringExpectedValue
                )
                
                XCTAssertOK(configSetStringResult)
                
                
                
                let configSnapshotResult: GitErrorCode = gitConfigSnapshot(
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
                
                let invalidConfigGetStringResult: GitErrorCode
                    = gitConfigGetString(
                        out:    &stringValue,
                        cfg:    configPointer,
                        name:   stringName
                    )
                
                /// This should fail since it attempts to get the string value
                /// from a live configuration object.
                XCTAssertNotOK(invalidConfigGetStringResult)
                
                
                
                stringValue = nil
                
                let configGetStringResult: GitErrorCode = gitConfigGetString(
                    out:    &stringValue,
                    cfg:    snapshotPointer,
                    name:   stringName
                )
                
                XCTAssertOK(configGetStringResult)
                XCTAssertNotNil(stringValue)
                XCTAssertEqual(stringValue, stringExpectedValue)
                
                
                
                let configSetWriteOrderResult: GitErrorCode
                    = gitConfigSetWriteOrder(
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
            return GitErrorCode.gitOK.rawValue
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
        
        return GitErrorCode.gitOK.rawValue
    }
    
    
    
    /// Calls the closure with a pointer to an on-disk configuraiton object.
    /// - Parameters:
    ///   - repository: The repository in which to create the configuration
    ///   object.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    /// - Throws: An error if the configuration creation failed.
    private func withConfigOnDisk<T>(
        in  repository  : Repository,
        _   body        : (OpaquePointer) -> T
    ) throws -> T
    {
        var configPointer: OpaquePointer? = nil
        
        defer
        {
            gitConfigFree(cfg: configPointer)
        }
        
        
        
        let configOpenOnDiskResult: GitErrorCode = gitConfigOpenOnDisk(
            out:    &configPointer,
            path:   repository.configPath
        )
        
        XCTAssertOK(configOpenOnDiskResult)
        
        guard let configPointer: OpaquePointer = configPointer
        else
        {
            XCTFail("The configuration pointer was nil.")
            
            throw NSError.makeError(
                code:       Int(GitErrorCode.gitEUser.rawValue),
                message:    "The configuration pointer was nil."
            )
        }
        
        return body(configPointer)
    }
}
