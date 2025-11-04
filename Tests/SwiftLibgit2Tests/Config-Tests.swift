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
@testable import SwiftLibgit2TestUtilities



/// Tests for Config bindings.
///
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
            
            let configBackendFromStringResult: GitErrorCode
                = gitConfigBackendFromString(
                    out:    &configBackend,
                    cfg:    configBackendContent,
                    len:    configBackendContent.count,
                    opts:   nil
                )
            
            XCTAssertOK(configBackendFromStringResult)
            
            guard let configBackend
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
    
    
    
    func testGitConfigFindGlobal() throws
    {
        var path: String? = nil
        
        _ = gitConfigFindGlobal(out: &path)
    }
    
    
    
    func testGitConfigFindProgramData() throws
    {
        var path: String? = nil
        
        _ = gitConfigFindProgramData(out: &path)
    }
    
    
    
    func testGitConfigFindSystem() throws
    {
        var path: String? = nil
        
        _ = gitConfigFindSystem(out: &path)
    }
    
    
    
    func testGitConfigFindXDG() throws
    {
        var path: String? = nil
        
        _ = gitConfigFindXDG(out: &path)
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
        try Repository.withConfig
        {
            _, configPointer in
            
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
            
            guard let configIterator
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
            
            
            
            let configIteratorGlobNewResult: GitErrorCode
                = gitConfigIteratorGlobNew(
                    out:        &configGlobIterator,
                    cfg:        configPointer,
                    regExp:     "test.*"
                )
            
            XCTAssertOK(configIteratorGlobNewResult)
            
            guard let configGlobIterator
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
                let parentConfigPointer
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
        
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_LEVEL_PROGRAMDATA), .gitConfigLevelProgramData)
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_LEVEL_SYSTEM), .gitConfigLevelSystem)
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_LEVEL_XDG), .gitConfigLevelXDG)
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_LEVEL_GLOBAL), .gitConfigLevelGlobal)
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_LEVEL_LOCAL), .gitConfigLevelLocal)
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_LEVEL_WORKTREE), .gitConfigLevelWorktree)
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_LEVEL_APP), .gitConfigLevelApp)
        XCTAssertEqual(GitConfigLevelT(cValue: GIT_CONFIG_HIGHEST_LEVEL), .gitConfigHighestLevel)
    }
    
    
    
    func testGitConfigLock() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
            var transactionPointer: OpaquePointer? = nil
            
            defer
            {
                gitTransactionFree(tx: transactionPointer)
            }
            
            
            
            let configLockResult: GitErrorCode = gitConfigLock(
                tx:     &transactionPointer,
                cfg:    configPointer
            )
            
            XCTAssertOK(configLockResult)
            XCTAssertNotNil(transactionPointer)
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
        
        
        
        try Repository.withConfig
        {
            _, configPointer in
            
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
        
        XCTAssertEqual(GitConfigMapT(cValue: GIT_CONFIGMAP_FALSE), .gitConfigMapFalse)
        XCTAssertEqual(GitConfigMapT(cValue: GIT_CONFIGMAP_TRUE), .gitConfigMapTrue)
        XCTAssertEqual(GitConfigMapT(cValue: GIT_CONFIGMAP_INT32), .gitConfigMapInt32)
        XCTAssertEqual(GitConfigMapT(cValue: GIT_CONFIGMAP_STRING), .gitConfigMapString)
    }
    
    
    
    func testGitConfigMultivarOperations() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
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
            
            guard let configIterator
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
        try Repository.withConfig
        {
            repository, configPointer in
            
            var newConfigPointer: OpaquePointer? = nil
            
            defer
            {
                gitConfigFree(cfg: newConfigPointer)
            }
            
            
            
            let configNewResult: GitErrorCode
                = gitConfigNew(out: &newConfigPointer)
            
            XCTAssertOK(configNewResult)
            
            guard let newConfigPointer
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
    
    
    
    func testGitConfigParseBool() throws
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
    }
    
    
    
    func testGitConfigParseInt32() throws
    {
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
    }
    
    
    
    func testGitConfigParseInt64() throws
    {
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
    }
    
    
    
    func testGitConfigParsePath() throws
    {
        var path                : String?   = nil
        let pathExtension       : String    = "/test"
        let pathExpectedValue   : String    = "~" + pathExtension
        
        let configParsePathResult: GitErrorCode = gitConfigParsePath(
            out:    &path,
            value:  pathExpectedValue
        )
        
        XCTAssertOK(configParsePathResult)
        
        /// The path should be expanded. The exact value depends on the
        /// environment.
        XCTAssertNotNil(path)
        XCTAssertNotEqual(path, pathExpectedValue)
        XCTAssertTrue(path?.hasSuffix(pathExtension) ?? false)
    }
    
    
    
    func testGitConfigSetAndGetBool() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
            let name    : String    = "test.bool"
            let value   : Bool      = true
            
            let configSetBoolResult: GitErrorCode = gitConfigSetBool(
                cfg:    configPointer,
                name:   name,
                value:  value
            )
            
            XCTAssertOK(configSetBoolResult)
            
            
            
            var retrievedValue: Bool = false
            
            let configGetBoolResult: GitErrorCode = gitConfigGetBool(
                out:    &retrievedValue,
                cfg:    configPointer,
                name:   name
            )
            
            XCTAssertOK(configGetBoolResult)
            XCTAssertEqual(retrievedValue, value)
        }
    }
    
    
    
    func testGitConfigSetAndGetInt32() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
            let name    : String    = "test.int32"
            let value   : Int32     = 123

            let configSetInt32Result: GitErrorCode = gitConfigSetInt32(
                cfg:    configPointer,
                name:   name,
                value:  value
            )
            
            XCTAssertOK(configSetInt32Result)
            
            
            
            var retrievedValue: Int32 = 0
            
            let configGetInt32Result: GitErrorCode = gitConfigGetInt32(
                out:    &retrievedValue,
                cfg:    configPointer,
                name:   name
            )
            
            XCTAssertOK(configGetInt32Result)
            XCTAssertEqual(retrievedValue, value)
        }
    }
    
    
    
    func testGitConfigSetAndGetInt64() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
            let name    : String    = "test.int64"
            let value   : Int64     = 1234567891234567890
            
            let configSetInt64Result: GitErrorCode = gitConfigSetInt64(
                cfg:    configPointer,
                name:   name,
                value:  value
            )
            
            XCTAssertOK(configSetInt64Result)
            
            
            
            var retirevedValue: Int64 = 0
            
            let configGetInt64Result: GitErrorCode = gitConfigGetInt64(
                out:    &retirevedValue,
                cfg:    configPointer,
                name:   name
            )
            
            XCTAssertOK(configGetInt64Result)
            XCTAssertEqual(retirevedValue, value)
        }
    }
    
    
    
    func testGitConfigSetAndGetPath() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
            let pathExtension   : String    = "/Documents"
            let name            : String    = "test.path"
            let value           : String    = "~" + pathExtension
            
            let configSetPathResult: GitErrorCode = gitConfigSetString(
                cfg:    configPointer,
                name:   name,
                value:  value
            )
            
            XCTAssertOK(configSetPathResult)
            
            
            
            var retrievedValue: String? = nil
            
            let configGetPathResult: GitErrorCode = gitConfigGetPath(
                out:    &retrievedValue,
                cfg:    configPointer,
                name:   name
            )
            
            XCTAssertOK(configGetPathResult)
            
            /// The path should be expanded. The exact value depends on
            /// the environment.
            XCTAssertNotNil(retrievedValue)
            XCTAssertNotEqual(retrievedValue, value)
            XCTAssertTrue(retrievedValue?.hasSuffix(pathExtension) ?? false)
        }
    }
    
    
    
    func testGitConfigSetAndGetString() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
            let name    : String    = "test.string"
            let value   : String    = "hello world"
            
            var configSetStringResult: GitErrorCode = gitConfigSetString(
                cfg:    configPointer,
                name:   name,
                value:  value
            )
            
            XCTAssertOK(configSetStringResult)
            
            
            
            let configDeleteEntryResult: GitErrorCode = gitConfigDeleteEntry(
                cfg:    configPointer,
                name:   name
            )
            
            XCTAssertOK(configDeleteEntryResult)
            
            
            
            var configEntry = GitConfigEntry()
            
            var configGetEntryResult: GitErrorCode = gitConfigGetEntry(
                out:    &configEntry,
                cfg:    configPointer,
                name:   name
            )
            
            /// The entry was deleted.
            XCTAssertNotOK(configGetEntryResult)
            
            
            
            configSetStringResult = gitConfigSetString(
                cfg:    configPointer,
                name:   name,
                value:  value
            )
            
            XCTAssertOK(configSetStringResult)
            
            
            
            configGetEntryResult = gitConfigGetEntry(
                out:    &configEntry,
                cfg:    configPointer,
                name:   name
            )
            
            XCTAssertOK(configGetEntryResult)
            XCTAssertNotNil(configEntry.name)
            XCTAssertNotNil(configEntry.value)
            XCTAssertNotNil(configEntry.backendType)
            XCTAssertNotNil(configEntry.originPath)
            XCTAssertEqual(configEntry.name, name)
            XCTAssertEqual(configEntry.value, value)
            XCTAssertEqual(configEntry.level, .gitConfigLevelLocal)
            
            
            
            var retrievedValue: String? = nil
            
            let configGetStringBufResult: GitErrorCode = gitConfigGetStringBuf(
                out:    &retrievedValue,
                cfg:    configPointer,
                name:   name
            )
            
            XCTAssertOK(configGetStringBufResult)
            XCTAssertNotNil(retrievedValue)
            XCTAssertEqual(retrievedValue, value)
        }
    }
    
    
    
    func testGitConfigSnapshotAndWriteOrder() throws
    {
        try Repository.withConfig
        {
            _, configPointer in
            
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
            
            guard let snapshotPointer
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



// MARK: - Extensions

private extension ConfigTests
{
    struct CallbackData
    {
        var count   : Int       = 0
        var values  : [String]  = []
    }
    
    
    
    static let configForEachCB: GitConfigForEachCB =
    {
        entry, payload in
        
        if entry == nil
        {
            return 1
        }
        
        guard
            let payload,
            let name    = String(optionalCString: entry?.pointee.name),
            let value   = String(optionalCString: entry?.pointee.value)
        else
        {
            XCTFail("All or some callback parameters were nil.")
            return GitErrorCode.gitUnknown(-123).rawValue
        }
        
        let payloadPointer: UnsafeMutablePointer<CallbackData>
            = payload.assumingMemoryBound(to: CallbackData.self)
        
        payloadPointer.pointee.count += 1
        payloadPointer.pointee.values.append("\(name)=\(value)")
        
        return GitErrorCode.gitOK.rawValue
    }
}
