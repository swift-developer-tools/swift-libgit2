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

/// The ``scan(_:_:_:)`` and ``withArrayOfCStrings(_:)``
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



internal extension Array where Element == String
{
    /// Calls the given closure with an array of C string pointers created from an array of Swift strings.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the closure.
    func withArrayOfCStrings<T>(
      _ body: ([UnsafeMutablePointer<CChar>?]) -> T
    ) -> T
    {
        guard !self.isEmpty
        else
        {
            return body([nil])
        }
        
        
        
        /// Use `Swift.Array` instead of the unqualified `Array` because within the
        /// `extension Array where Element == String` context, the compiler resolves
        /// unqualified `Array(_:)` calls to `Array<String>.init(_:)` rather than the generic
        /// `Array<T>.init(_:)` initializer. This causes a type mismatch since the assigned type
        /// is `[Int]`, but the compiler expects `[String]`.
        ///
        /// The explicit `Swift.Array` wrapper is retained from the original Swift implementation for
        /// consistency, and may proivde benefits for type inference stability or future-proofing against
        /// changes in collection protocols.
        let argsCounts      : [Int]     = Swift.Array(self.map { $0.utf8.count + 1 })
        let argsOffsets     : [Int]     = [0] + scan(argsCounts, 0, +)
        let argsBufferSize  : Int       = argsOffsets.last ?? 0
        
        
        
        var argsBuffer: [UInt8] = []
        argsBuffer.reserveCapacity(argsBufferSize)
        
        for arg in self
        {
            argsBuffer.append(contentsOf: arg.utf8)
            argsBuffer.append(0)
        }
        
        
        
        return argsBuffer.withUnsafeMutableBufferPointer
        {
            argsBuffer in
            
            /// `baseAddress` should never be `nil` since the buffer will not be empty at this point.
            let pointer = UnsafeMutableRawPointer(argsBuffer.baseAddress!)
                .bindMemory(to: CChar.self, capacity: argsBuffer.count)
            
            var cStrings: [UnsafeMutablePointer<CChar>?] = argsOffsets.map { pointer + $0 }
            
            cStrings[cStrings.count - 1] = nil
            
            
            
            return body(cStrings)
        }
    }
    
    
    
    /// Calls the given closure with an array of immutable C string pointers created from an array of Swift strings.
    /// - Parameter body: The closure to call.
    /// - Returns: The return value of the closure.
    ///
    /// ## Discussion
    ///
    /// Use this function over ``withArrayOfCStrings(_:)`` when working with C APIs
    /// that expect `const char **` parameters.
    func withArrayOfImmutableCStrings<T>(
        _ body: (UnsafeMutablePointer<UnsafePointer<CChar>?>) -> T
    ) -> T
    {
        return self.withArrayOfCStrings
        {
            cStrings in
            
            let immutableCStrings: [UnsafePointer<CChar>?] = cStrings.map
            {
                $0.map { UnsafePointer<CChar>($0) }
            }
            
            
            
            return immutableCStrings.withUnsafeBufferPointer
            {
                buffer in
                
                /// `baseAddress` should never be `nil` since the buffer will not be empty at this point.
                let pointer = UnsafeMutablePointer<UnsafePointer<CChar>?>(
                    mutating: buffer.baseAddress!
                )
                
                return body(pointer)
            }
        }
    }
}
