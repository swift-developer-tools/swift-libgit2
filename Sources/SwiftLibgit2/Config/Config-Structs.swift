//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// An entry in a configuration file.
///
/// ## C Equivalent
///
/// [`git_config_entry`](https://libgit2.org/docs/reference/main/config/git_config_entry.html)
public struct GitConfigEntry: GitStructInternalMutable, WithCConvertible
{
    /// The normalized name of the configuration entry.
    public private(set) var name            : String?           = nil
    
    /// The value of the configuration entry.
    public private(set) var value           : String?           = nil
    
    /// The type of backend in which the configuration entry exists (for example, `file`).
    public private(set) var backendType     : String?           = nil
    
    /// The path to the origin of the configuration entry.
    ///
    /// ## Discussion
    ///
    /// For configuration files, this represents the path to the file.
    public private(set) var originPath      : String?           = nil
    
    /// The depth of includes where the configuration entry was found.
    public private(set) var includeDepth    : UInt32            = 0
    
    /// The configuration level for the file in which the configuration entry was found.
    public private(set) var level           : GitConfigLevelT   = .gitConfigLevelLocal
    
    
    
    /// Creates a ``GitConfigEntry`` instance.
    public init() { }
    
    
    
    /// Creates a ``GitConfigEntry`` instance from a `git_config_entry` instance.
    /// - Parameter configEntry: The `git_config_entry` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``level`` defaults to ``GitConfigLevelT/gitConfigLevelLocal`` if an unexpected
    /// value is encountered, although this should never occur.
    internal init(
        cValue configEntry: git_config_entry
    )
    {
        self.name           = String(optionalCString: configEntry.name)
        self.value          = String(optionalCString: configEntry.value)
        self.backendType    = String(optionalCString: configEntry.backend_type)
        self.originPath     = String(optionalCString: configEntry.origin_path)
        self.includeDepth   = configEntry.include_depth
        self.level          = GitConfigLevelT(cValue: configEntry.level) ?? .gitConfigLevelLocal
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_config_entry` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_config_entry>) -> T
    ) -> T
    {
        var configEntry = git_config_entry()
        
        configEntry.include_depth   = includeDepth
        configEntry.level           = level.cValue()
        
        return name.withOptionalCString
        {
            cName in
            
            configEntry.name = cName
            
            return value.withOptionalCString
            {
                cValue in
                
                configEntry.value = cValue
                
                return backendType.withOptionalCString
                {
                    cBackendType in
                    
                    configEntry.backend_type = cBackendType
                    
                    return originPath.withOptionalCString
                    {
                        cOriginPath in
                        
                        configEntry.origin_path = cOriginPath
                        
                        return body(&configEntry)
                    }
                }
            }
        }
    }
}




/// A mapping from configuration variables to integer values.
///
/// ## Discussion
///
/// This defines how configuration values should be mapped to integer constants by specifying the
/// type of value ot match, an optional string to match against, and the integer value to map when
/// a match is found.
///
/// ## C Equivalent
///
/// [`git_configmap`](https://libgit2.org/docs/reference/main/config/git_configmap.html)
public struct GitConfigMap: GitStructMutable, WithCConvertible
{
    /// The type of configuration value to match.
    ///
    /// ## Discussion
    ///
    /// The default value is ``GitConfigMapT/gitConfigMapFalse``.
    public var type     : GitConfigMapT     = .gitConfigMapFalse
    
    /// The specific string to match against.
    ///
    /// ## Discussion
    ///
    /// The default value is `nil`.
    ///
    /// When ``type`` is ``GitConfigMapT/gitConfigMapString``, this specifies the exact
    /// string value to match using case-insensitive comparison. This is ignored for other types.
    public var strMatch : String?           = nil
    
    /// The integer value to return when a match is found.
    ///
    /// ## Discussion
    ///
    /// The default value is `0`.
    public var mapValue : Int               = 0
    
    
    
    /// Creates a ``GitConfigMap`` instance with the default configuration.
    ///
    /// ## Discussion
    ///
    /// See the individual property documentation for specific default values.
    public init() { }
    
    
    
    /// Creates a ``GitConfigMap`` instance from a `git_configmap` instance.
    /// - Parameter configMap: The `git_configmap` instance to use.
    ///
    /// ## Discussion
    ///
    /// ``certType`` defaults to ``GitCertT/gitCertNone`` if an unexpected
    /// value is encountered, although this should never occur.
    internal init(
        cValue configMap: git_configmap
    )
    {
        self.type       = GitConfigMapT(cValue: configMap.type) ?? .gitConfigMapFalse
        self.strMatch   = String(optionalCString: configMap.str_match)
        self.mapValue   = Int(configMap.map_value)
    }
    
    
    
    /// Calls the given closure with a pointer to a `git_configmap` instance.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the given closure.
    internal func withCValue<T>(
        _ body: (UnsafeMutablePointer<git_configmap>) -> T
    ) -> T
    {
        var configMap = git_configmap()
        
        configMap.type          = type.cValue()
        configMap.map_value     = Int32(mapValue)
        
        return strMatch.withOptionalCString
        {
            cStrMatch in
            
            configMap.str_match = cStrMatch
            
            return body(&configMap)
        }
    }
}



// MARK: - Extensions

internal extension Array where Element == GitConfigMap
{
    /// Calls the given closure with a  pointer to a `git_configmap` array, by recursively converting
    /// each ``GitConfigMap`` element of the receiver.
    /// - Parameters:
    ///   - recursionIndex: The current recursion index.
    ///   - accumulatedMaps: The accumulated `git_configmap` instances.
    ///   - body: The closure to call.
    /// - Returns: The return value of the given closure.
    ///
    /// ## Discussion
    ///
    /// The pointer will be `nil` if the array is empty or if memory allocation fails.
    ///
    /// Neither `recursionIndex` nor `accumulatedMaps` should be provided by the caller.
    func withCValues<T>(
        index           recursionIndex  : Int                                   = 0,
        accumulating    accumulatedMaps : [git_configmap]                       = [],
        _               body            : (UnsafePointer<git_configmap>?) -> T
    ) -> T
    {
        guard !self.isEmpty
        else
        {
            return body(nil)
        }
        
        guard recursionIndex < self.count
        else
        {
            return accumulatedMaps.withUnsafeBufferPointer
            {
                accumulatedMapsBufferPointer in
                
                /// The base address should not be `nil` at this point, since the array is not empty.
                /// No `guard` is necessary, since the alternative would be to call `body(nil)`.
                return body(accumulatedMapsBufferPointer.baseAddress)
            }
        }
        
        
        
        return self[recursionIndex].withCValue
        {
            configMap in
            
            var updatedConfigMaps: [git_configmap] = accumulatedMaps
            
            updatedConfigMaps.append(configMap.pointee)
            
            return self.withCValues(
                index:          recursionIndex + 1,
                accumulating:   updatedConfigMaps,
                body
            )
        }
    }
}
