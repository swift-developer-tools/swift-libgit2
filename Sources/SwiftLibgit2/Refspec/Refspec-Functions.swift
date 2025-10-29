//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Parses the given refspec string.
/// - Parameters:
///   - refspec: The pointer in which to store the refspec. The underlying
///   type must be `git_refspec`.
///   - input: The refspec string to parse.
///   - isFetch: Whether the given refspec string is for a fetch operation.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_refspec_parse()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_parse.html)
public func gitRefspecParse(
    refspec : UnsafeMutablePointer<OpaquePointer?>,
    input   : String,
    isFetch : Bool
) -> GitErrorCode
{
    return withCConversion
    {
        return git_refspec_parse(
            refspec,
            input,
            isFetch.int32Value
        )
    }
}



/// Frees the memory allocated for the given `git_refspec` instance.
/// - Parameter refspec: The refspec to free. The underlying type must be
/// `git_refspec`.
///
/// ## C Equivalent
///
/// [`git_refspec_free()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_free.html)
public func gitRefspecFree(
    refspec: OpaquePointer?
)
{
    guard let refspec: OpaquePointer = refspec
    else
    {
        return
    }
    
    git_refspec_free(refspec)
}



/// Gets the source specifier of the given refspec.
/// - Parameter refspec: The refspec for which to get the source specifier.
/// The underlying type must be `git_refspec`.
/// - Returns: The source specifier of the given refspec.
///
/// ## C Equivalent
///
/// [`git_refspec_src()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_src.html)
public func gitRefspecSrc(
    refspec: OpaquePointer
) -> String?
{
    let sourceSpecifier: UnsafePointer<CChar>? = git_refspec_src(refspec)
    
    return String(optionalCString: sourceSpecifier)
}



/// Gets the destination specifier of the given refspec.
/// - Parameter refspec: The refspec for which to get the destination
/// specifier. The underlying type must be `git_refspec`.
/// - Returns: The destination specifier of the given refspec.
///
/// ## C Equivalent
///
/// [`git_refspec_dst()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_dst.html)
public func gitRefspecDst(
    refspec: OpaquePointer
) -> String?
{
    let destinationSpecifier: UnsafePointer<CChar>? = git_refspec_dst(refspec)
    
    return String(optionalCString: destinationSpecifier)
}



/// Gets the original string of the given refspec.
/// - Parameter refspec: The refspec for which to get the original string.
/// The underlying type must be `git_refspec`.
/// - Returns: The original string of the given refspec.
///
/// ## C Equivalent
///
/// [`git_refspec_string()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_string.html)
public func gitRefspecString(
    refspec: OpaquePointer
) -> String?
{
    let originalString: UnsafePointer<CChar>? = git_refspec_string(refspec)
    
    return String(optionalCString: originalString)
}



/// Checks whether the force update setting of the given refspec has been set.
/// - Parameter refspec: The refspec to check. The underlying type must be
/// `git_refspec`.
/// - Returns: Whether the force update setting of the given refspec has been
/// set.
///
/// ## C Equivalent
///
/// [`git_refspec_force()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_force.html)
public func gitRefspecForce(
    refspec: OpaquePointer
) -> Bool
{
    let isForceUpdateSet: Int32 = git_refspec_force(refspec)
    
    return Bool(isForceUpdateSet)
}



/// Gets the direction of the given refspec.
/// - Parameter refspec: The refspec for which to get the direction. The
/// underlying type must be `git_refspec`.
/// - Returns: The direction of the given refspec.
///
/// ## C Equivalent
///
/// [`git_refspec_direction()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_direction.html)
public func gitRefspecDirection(
    refspec: OpaquePointer
) -> GitDirection?
{
    let direction: git_direction = git_refspec_direction(refspec)
    
    return GitDirection(cValue: direction)
}



/// Checks whether the source descriptor of the given refspec matches a
/// negative reference.
/// - Parameters:
///   - refspec: The refspec to check. The underlying type must be
///   `git_refspec`.
///   - refName: The name of the reference to check.
/// - Returns: Whether the source descriptor of the given refspec matches a
/// negative reference.
///
/// ## C Equivalent
///
/// [`git_refspec_src_matches_negative()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_src_matches_negative.html)
public func gitRefspecSrcMatchesNegative(
    refspec : OpaquePointer,
    refName : String
) -> Bool
{
    let sourceMatchesNegative: Int32 = git_refspec_src_matches_negative(
        refspec,
        refName
    )
    
    return Bool(sourceMatchesNegative)
}



/// Checks whether the source descriptor of the given refspec matches the given
/// reference.
/// - Parameters:
///   - refspec: The refspec to check. The underlying type must be
///   `git_refspec`.
///   - refName: The name of the reference to check.
/// - Returns: Whether the source descriptor of the given refspec matches the
/// given reference.
///
/// ## C Equivalent
///
/// [`git_refspec_src_matches()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_src_matches.html)
public func gitRefspecSrcMatches(
    refspec : OpaquePointer,
    refName : String
) -> Bool
{
    let sourceMatches: Int32 = git_refspec_src_matches(
        refspec,
        refName
    )
    
    return Bool(sourceMatches)
}



/// Checks whether the destination descriptor of the given refspec matches the
/// given reference.
/// - Parameters:
///   - refspec: The refspec to check. The underlying type must be
///   `git_refspec`.
///   - refName: The name of the reference to check.
/// - Returns: Whether the source descriptor of the given refspec matches the
/// given reference.
///
/// ## C Equivalent
///
/// [`git_refspec_dst_matches()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_dst_matches.html)
public func gitRefspecDstMatches(
    refspec : OpaquePointer,
    refName : String
) -> Bool
{
    let destinationMatches: Int32 = git_refspec_dst_matches(
        refspec,
        refName
    )
    
    return Bool(destinationMatches)
}



/// Transforms the specified reference to its target, following the rules of
/// the given refspec.
/// - Parameters:
///   - out: The `String` instance in which to store the target name.
///   - spec: The refspec to use. The underlying type must be `git_refspec`.
///   - name: The name of the reference to transform.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_refspec_transform()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_transform.html)
public func gitRefspecTransform(
    out     : inout String?,
    spec    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_refspec_transform(
                cOut,
                spec,
                name
            )
        }
    }
}



/// Transforms the specified reference to its source reference, following the
/// rules of the given refspec.
/// - Parameters:
///   - out: The `String` instance in which to store the target name.
///   - spec: The refspec to transform. The underlying type must be
///   `git_refspec`.
///   - name: The name of the reference to transform.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_refspec_rtransform()`](https://libgit2.org/docs/reference/main/refspec/git_refspec_rtransform.html)
public func gitRefspecRTransform(
    out     : inout String?,
    spec    : OpaquePointer,
    name    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try out.withOptionalMutatingGitBuf
        {
            cOut in
            
            return git_refspec_rtransform(
                cOut,
                spec,
                name
            )
        }
    }
}
