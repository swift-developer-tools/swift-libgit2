//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// A custom memory allocator.
///
/// All properties of the custom memory allocator must be set for it to work
/// correctly.
///
/// - Note: Use ``gitLibgit2OptSetAllocator(allocator:)`` to set the global
/// memory allocator.
///
/// - Note: This struct is provided for documentation purposes, but is not
/// used by other bindings. All binding use `git_allocator` instead.
///
/// ## C Equivalent
///
/// [`git_allocator`](https://libgit2.org/docs/reference/main/sys/alloc/git_allocator.html)
public struct GitAllocator: CStruct, Sendable
{
    /// Allocates memory for the given number of bytes.
    public let gMalloc  : GitAllocator.GMalloc?
    
    /// Deallocates the given object and reallocates memory for the given
    /// number of bytes.
    public let gRealloc : GitAllocator.GRealloc?
    
    /// Frees the memory allocated for the given object.
    public let gFree    : GitAllocator.GFree?
    
    
    
    /// Initializes a ``GitAllocator`` instance from the given `git_allocator`
    /// instance.
    /// - Parameter allocator: The `git_allocator` instance to use.
    internal init(
        cValue allocator: git_allocator
    )
    {
        self.gMalloc    = allocator.gmalloc
        self.gRealloc   = allocator.grealloc
        self.gFree      = allocator.gfree
    }
    
    
    
    /// The callback invoked to allocate memory for the given number of bytes.
    /// - Parameters:
    ///   - n: The number of bytes of memory to allocate.
    ///   - file: The source file for which memory allocation was requested.
    ///   - line: The line number for which memory allocation was requested.
    /// - Returns: A pointer to the allocated memory.
    public typealias GMalloc = @convention(c)
    (
        Int,
        UnsafePointer<CChar>?,
        Int32
    ) -> UnsafeMutableRawPointer?
    
    
    
    /// The callback invoked to deallocate the given object and reallocate
    /// memory for the given number of bytes.
    /// - Parameters:
    ///   - ptr: The object to deallocate and reallocate. Pass `nil` to
    ///   allocate a new object.
    ///   - size: The number of bytes of memory to reallocate.
    ///   - file: The source file for which memory allocation was requested.
    ///   - line: The line number for which memory allocation was requested.
    /// - Returns: A pointer to the allocated memory.
    public typealias GRealloc = @convention(c)
    (
        UnsafeMutableRawPointer?,
        Int,
        UnsafePointer<CChar>?,
        Int32
    ) -> UnsafeMutableRawPointer?
    
    
    
    /// The callback invoked to free the memory allocated for the given object.
    /// - Parameter ptr: The object to free.
    public typealias GFree = @convention(c)
    (
        UnsafeMutableRawPointer?
    ) -> Void
}
