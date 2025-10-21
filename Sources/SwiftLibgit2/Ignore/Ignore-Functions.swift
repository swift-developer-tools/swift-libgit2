//===----------------------------------------------------------------------===//
//
// This source file is part of the swift-libgit2 open source project.
//
// Copyright (c) Margins Technologies LLC.
// Licensed under the Apache License, Version 2.0.
//
//===----------------------------------------------------------------------===//

import CLibgit2



/// Adds internal ignore rules in the given repository.
/// - Parameters:
///   - repo: The repository to which to add the ignore rules. The underlying
///   type must be `git_repository`.
///   - rules: The text of rules to add, with each rule terminated by a
///   newline character.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The `excludesfile` rules are generally read from `.gitignore` files in the
/// repository tree or from a shared system file only if a `core.excludesfile`
/// configuration value is set.
///
/// This function may be used to add rules to a set of per-repository internal
/// ignore rules maintained by libgit2. These rules can be configured in memory
/// and will not persist across sessions.
///
/// ## C Equivalent
///
/// [`git_ignore_add_rule()`](https://libgit2.org/docs/reference/main/ignore/git_ignore_add_rule.html)
public func gitIgnoreAddRule(
    repo    : OpaquePointer,
    rules   : String
) -> GitErrorCode
{
    return withCConversion
    {
        return git_ignore_add_rule(
            repo,
            rules
        )
    }
}



/// Resets the internal ignore list.
/// - Parameter repo: The repository from which to remove explicitly-added
/// rules. The underlying type must be `git_repository`.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The default internal ignore list includes the current directory ("."),
/// the parent directory (".."), and `.git`.
///
/// ## C Equivalent
///
/// [`git_ignore_clear_internal_rules()`](https://libgit2.org/docs/reference/main/ignore/git_ignore_clear_internal_rules.html)
public func gitIgnoreClearInternalRules(
    repo: OpaquePointer
) -> GitErrorCode
{
    return withCConversion
    {
        return git_ignore_clear_internal_rules(repo)
    }
}



/// Checks whether the given path is (or would be) ignored.
/// - Parameters:
///   - ignored: The `Bool` instance in which to store whether the given
///   path is (or would be) ignored.
///   - repo: The repository containing the path. The underlying type must be
///   `git_repository`.
///   - path: The path to the file to check, relative to the working directory.
/// - Returns: A ``GitErrorCode`` instance.
///
/// ## Discussion
///
/// The value stored in `ignored` indicates whether the given path would be
/// ignored regardless of whether the file is already committed or in the index.
///
/// This is similar to `git check-ignore --no-index`.
///
/// ## C Equivalent
///
/// [`git_ignore_path_is_ignored()`](https://libgit2.org/docs/reference/main/ignore/git_ignore_path_is_ignored.html)
public func gitIgnorePathIsIgnored(
    ignored : inout Bool,
    repo    : OpaquePointer,
    path    : String
) -> GitErrorCode
{
    return withCConversion
    {
        return ignored.withMutatingBool
        {
            cIgnored in
            
            return git_ignore_path_is_ignored(
                cIgnored,
                repo,
                path
            )
        }
    }
}
