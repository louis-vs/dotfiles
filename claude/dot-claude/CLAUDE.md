# Global CLAUDE.md

## Important instructions

- Keep files SMALL and FEW.
- Don't rely on quick fixes. Write clean code.
- Don't disable lint rules without express permission.

## Git and GitHub

Create regular, small, TESTED commits.

IMPORTANT: All commits should be GPG signed. Before you run a git command, RUN THIS SCRIPT `gpg-connect-agent 'keyinfo --list' /bye | grep ' 1 '`. If there is no output, ASK THE USER TO RUN THE `reset-gpg` script.

NEVER use `--no-verify` when using `git commit`.

## Tools

Use `fd` and `rg`, not `find` or `grep`.

Prefer python for scripts, unless bash is the right tool for the job. Use `uv run` to run python scripts. Define script dependencies in a `/// script` block.
