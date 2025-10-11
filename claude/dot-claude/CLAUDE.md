# Global CLAUDE.md

## Important instructions

- Use Task tool for multi-step searches and complex investigations
- Read multiple related files in parallel when analyzing codebase
- Use TodoWrite tool proactively for task management and user visibility
- Prefer editing existing files over creating new ones

## Git and GitHub

IMPORTANT: All commits should be GPG signed. However, pinentry *will break your prompt*. Before you run a git command, check that this script has output `gpg-connect-agent 'keyinfo --list' /bye | grep ' 1 '`. If there is not output, ASK THE USER TO RUN THE `reset-gpg` script.

NEVER use `--no-verify` when using `git commit`.
