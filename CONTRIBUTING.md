<div align="center">
    <h1 style="font-size: 2em; font-weight: bold">CONTRIBUTING</h1>
</div>

Thank you for considering contributing to this Bash-based project. Whether you're improving a script, fixing bugs, or enhancing packaging, your contributions are welcome. This document outlines how to propose changes effectively and consistently.

## Getting Started

Start by forking the repository and cloning your fork locally. Create a new branch named after your change:

```bash
git checkout -b fix/cleanup-logging
```

Before making changes, read the existing scripts to understand their style and behavior. Bash scripts should be POSIX-compliant where possible and avoid unnecessary dependencies.

## Coding Conventions

Please follow these conventions when writing or modifying Bash scripts:

- Use `#!/usr/bin/env bash` shebangs depending on portability needs.
- Prefer long-form options (create, delete, list, restore, help and version) for clarity.
- Quote all variable references ("$var") when appropriate to prevent word splitting and globbing.
- Always use set `-eo pipefail` to ensure the script exits on errors and failures in pipelines.
- Avoid comments on code that is self-explanatory; use comments to explain complex logic or decisions.
- Use shellcheck to lint your changes and avoid common issues.
- Full POSIX compliance is not required, but aim for compatibility with common Bash versions.

If your change impacts system behavior, describe how it was tested (e.g., in a VM, live system, chroot).

## Commit Messages

Commit messages should describe what changed and why, clearly and briefly and under 90 characters. Use the following format:

```markdown
<type>(<scope>): <subject>
```

Example:

```markdown
fix(logging): improve error handling in snapshot creation
```

## Debian Packaging Changes

Please avoid making changes to the Debian packaging files unless necessary. If you do need to modify them, ensure that:

- The changes are well-documented in the commit message.
- The packaging files are updated to reflect the changes made in the scripts.
- Test the packaging changes in a clean environment and with `lintian` to ensure compliance with Debian standards.

Any changes to the Debian packaging should be made in a separate commit with a clear message indicating the changes made.

For changelog entries, `dh_genchangelog` which is installed via `apt install genchangelog` can be used to generate the changelog automatically. It will use the commit messages to create a well-formatted changelog entry. This package is available on the [HowToNebie](https://repository.howtonebie.com/) repository.

## Pull Requests

Push your branch and open a pull request against the **testing** branch. In your description, explain the purpose of the change, what was tested, and reference any related issues. Make sure your branch is rebased or merged with the latest main before submission. If the PR includes both script and packaging changes, clarify each in the description.

## Code Review

After submitting your pull request, it will be reviewed by the maintainers. They may request changes or provide feedback. Please be responsive to comments and make necessary adjustments. Your contribution will be merged once it meets the project's standards and passes all tests.

All contributors well understand that the maintainers are volunteers and may take time to review contributions. Please be patient and respectful in your interactions. All contributors are expected to follow the [Code of Conduct](CODE_OF_CONDUCT.md). Be respectful and constructive in your communication.
