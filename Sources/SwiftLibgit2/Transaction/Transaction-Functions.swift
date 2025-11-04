//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Creates a new transaction from the given repository.
/// - Parameters:
///   - out: The pointer in which to store the transaction. The underlying type
///   must be `git_transaction`.
///   - repo: The repository to search. The underlying type must be
///   `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// This function does not lock anything, but sets up the transaction to know
/// from which repository to lock.
///
/// ## C Equivalent
///
/// [`git_transaction_new()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_new.html)
public func gitTransactionNew(
    out: UnsafeMutablePointer<OpaquePointer?>,
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transaction_new(
            out,
            repo
        )
    }
}


/// Locks the specified reference.
/// - Parameters:
///   - tx: The transaction to use. The underlying type must be
///   `git_transaction`.
///   - refName: The name of the reference to lock.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transaction_lock_ref()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_lock_ref.html)
public func gitTransactionLockRef(
    tx      : OpaquePointer,
    refName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transaction_lock_ref(
            tx,
            refName
        )
    }
}



/// Sets the target of the specified reference.
/// - Parameters:
///   - tx: The transaction to use. The underlying type must be
///   `git_transaction`.
///   - refName: The name of the reference to update. The reference must be
///   locked.
///   - target: The ID of the target to which to set the specified reference.
///   - sig: The signature to use in the reflog. Pass `nil` to use the identity
///   in the repository's configuration.
///   - msg: The reflog message to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transaction_set_target()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_set_target.html)
public func gitTransactionSetTarget(
    tx      : OpaquePointer,
    refName : String,
    target  : GitOID,
    sig     : GitSignature?,
    msg     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try target.withCValue
        {
            cTarget in
            
            return try sig.withOptionalCValue
            {
                cSig in
                
                return git_transaction_set_target(
                    tx,
                    refName,
                    cTarget,
                    cSig,
                    msg
                )
            }
        }
    }
}



/// Sets the symbolic target of the specified reference.
/// - Parameters:
///   - tx: The transaction to use. The underlying type must be
///   `git_transaction`.
///   - refName: The name of the reference to update. The reference must be
///   locked.
///   - target: The target to which to set the specified reference.
///   - sig: The signature to use in the reflog. Pass `nil` to use the identity
///   in the repository's configuration.
///   - msg: The reflog message to use.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transaction_set_symbolic_target()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_set_symbolic_target.html)
public func gitTransactionSetSymbolicTarget(
    tx      : OpaquePointer,
    refName : String,
    target  : String,
    sig     : GitSignature?,
    msg     : String
) -> GitErrorCode
{
    return withCConversion
    {
        return try sig.withOptionalCValue
        {
            cSig in
            
            return git_transaction_set_symbolic_target(
                tx,
                refName,
                target,
                cSig,
                msg
            )
        }
    }
}



/// Sets the reflog of the specified reference.
/// - Parameters:
///   - tx: The transaction to use. The underlying type must be
///   `git_transaction`.
///   - refName: The name of the reference to update.
///   - reflog: The reflog to write out.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// If this is combined with setting the target of the reference, then that
/// update will not be written to the reflog.
///
/// ## C Equivalent
///
/// [`git_transaction_set_reflog()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_set_reflog.html)
public func gitTransactionSetReflog(
    tx      : OpaquePointer,
    refName : String,
    reflog  : OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transaction_set_reflog(
            tx,
            refName,
            reflog
        )
    }
}



/// Removes the specified reference.
/// - Parameters:
///   - tx: The transaction to use. The underlying type must be
///   `git_transaction`.
///   - refName: The name of the reference to remove.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## C Equivalent
///
/// [`git_transaction_remove()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_remove.html)
public func gitTransactionRemove(
    tx      : OpaquePointer,
    refName : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transaction_remove(
            tx,
            refName
        )
    }
}



/// Commits the changes from the given transaction.
/// - Parameter tx: The transaction to commit. The underlying type must be
/// `git_transaction`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The updates will be made sequentially. The first failure with stop the
/// process.
///
/// ## C Equivalent
///
/// [`git_transaction_commit()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_commit.html)
public func gitTransactionCommit(
    tx: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_transaction_commit(tx)
    }
}



/// Frees the memory allocated for the given `git_transaction` instance.
/// - Parameter tx: The transaction to free. The underlying type must be
/// `git_transaction`.
///
/// ## C Equivalent
///
/// [`git_transaction_free()`](https://libgit2.org/docs/reference/main/transaction/git_transaction_free.html)
public func gitTransactionFree(
    tx: OpaquePointer?
)
{
    guard let tx
    else
    {
        return
    }
    
    git_transaction_free(tx)
}
