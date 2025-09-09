//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
// Parts of this file are adapted from the Swift.org open source project.
//
// Copyright (c) 2014 - 2016 Apple Inc. and the Swift project authors.
// Licensed under the Apache License, Version 2.0, with Runtime Library
// Exception.
//
// See https://swift.org/LICENSE.txt for license information.
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors.
//
//===----------------------------------------------------------------------===//

/// The ``scan(seq:intial:combine:)`` and ``withArrayOfCStrings(args:body:)``
/// functions below are adapted from the Swift.org open source project. Original source code:
/// https://github.com/swiftlang/swift/blob/c3b7709a7c4789f1ad7249d357f69509fb8be731/stdlib/private/SwiftPrivate/SwiftPrivate.swift



/// Computes the prefix sums of a sequence by cumulatively applying a binary operation to each element
/// of the sequence.
///
/// - Parameters:
///   - seq: The sequence to process.
///   - initial: The initial value to start the accumulation.
///   - combine: A binary operation that combines the running result with each element.
/// - Returns: An array containing the cumulative results of applying `combine`.
///
/// ## Discussion
///
/// For example, `scan([1, 2, 3, 4], 0, +)` returns `[1, 3, 6, 10]`.
internal func scan<S: Sequence, U>(
    _   seq     : S,
    _   initial : U,
    _   combine : (U, S.Iterator.Element) -> U
) -> [U]
{
    var result: [U] = []
    
    result.reserveCapacity(seq.underestimatedCount)
    
    
    
    var runningResult: U = initial
    
    for element in seq
    {
        runningResult = combine(runningResult, element)
        result.append(runningResult)
    }
    
    
    
    return result
}



/// Calls the given closure with an array of C strings created from an array of Swift strings.
/// - Parameters:
///   - args: The array of Swift strings.
///   - body: The closure to call.
/// - Returns: The return value of the closure.
internal func withArrayOfCStrings<R>(
  _     args    : [String],
  _     body    : ([UnsafeMutablePointer<CChar>?]) -> R
) -> R
{
    guard !args.isEmpty
    else
    {
        return body([nil])
    }
    
    
    
    let argsCounts      : [Int]     = Array(args.map { $0.utf8.count + 1 })
    let argsOffsets     : [Int]     = [0] + scan(argsCounts, 0, +)
    let argsBufferSize  : Int       = argsOffsets.last ?? 0
    
    
    
    var argsBuffer: [UInt8] = []
    argsBuffer.reserveCapacity(argsBufferSize)
    
    for arg in args
    {
        argsBuffer.append(contentsOf: arg.utf8)
        argsBuffer.append(0)
    }
    
    
    
    return argsBuffer.withUnsafeMutableBufferPointer
    {
        argsBuffer in
        
        guard let baseAddress: UnsafeMutablePointer<UInt8> = argsBuffer.baseAddress
        else
        {
            return body([nil])
        }
        
        
        
        let pointer = UnsafeMutableRawPointer(baseAddress)
            .bindMemory(to: CChar.self, capacity: argsBuffer.count)
        
        var cStrings: [UnsafeMutablePointer<CChar>?] = argsOffsets.map { pointer + $0 }
        
        cStrings[cStrings.count - 1] = nil
        
        
        
        return body(cStrings)
    }
}



/// Calls the given closure with an array of immutable C strings created from an array of Swift strings.
///
/// - Parameters:
///   - args: The array of Swift strings.
///   - body: The closure to call.
/// - Returns: The return value of the closure.
///
/// ## Discussion
///
/// Use this function over ``withArrayOfCStrings(args:body:)`` when working with C functions
/// that expect `const char **` parameters.
internal func withArrayOfImmutableCStrings<T>(
    _   args    : [String],
    _   body    : (UnsafeMutablePointer<UnsafePointer<CChar>?>) -> T
) -> T
{
    return withArrayOfCStrings(args)
    {
        cStrings in
        
        let immutableCStrings: [UnsafePointer<CChar>?] = cStrings.map { $0.map { UnsafePointer<CChar>($0) } }
        
        
        
        return immutableCStrings.withUnsafeBufferPointer
        {
            buffer in
            
            guard let baseAddress: UnsafePointer<UnsafePointer<CChar>?> = buffer.baseAddress
            else
            {
                var nilPointer: UnsafePointer<CChar>? = nil
                
                return withUnsafePointer(to: &nilPointer)
                {
                    unsafeNilPointer in
                    
                    return body(
                        UnsafeMutablePointer<UnsafePointer<CChar>?>(
                            mutating: unsafeNilPointer
                        )
                    )
                }
            }
            
            
            
            /// Get a mutable pointer to the array of immutable pointers.
            let pointer = UnsafeMutablePointer<UnsafePointer<CChar>?>(mutating: baseAddress)
            
            return body(pointer)
        }
    }
}
