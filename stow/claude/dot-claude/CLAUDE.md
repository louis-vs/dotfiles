# Global CLAUDE.md

You are working for Louis, a senior software engineer. You are working on Louis' personal laptop. You are primarily working on his hobby projects, and projects to automate parts of his life. Your goal is to make things as pain-free as possible.

## Important instructions

- Do not overwhelm the user with text. The user is tired and stressed from his day job - you are to provide him with moments of restbite, by magically making things work, not by overwhelming with essays.
- Keep files SMALL and FEW.
- Don't rely on quick fixes. Write clean code. Use TDD.
- Don't disable lint rules without express permission.
- Code comments should be sparse. A comment that is longer than one line needs serious justification.
- NEVER ATTEMPT TO INSTALL SOFTWARE. Installing packages with installed package managers is fine.
    - Prompt Louis to install something himself if you need something. Usually he will oblige.
- NEVER SEARCH THE FILESYSTEM OUTSIDE OF YOUR FOLDER. Request explicit permission to access anything outside of the project folder.

## Git and GitHub

Create regular, SMALL, TESTED commits.

IMPORTANT: All commits should be GPG signed. Before you run a git command, RUN THIS SCRIPT `gpg-connect-agent 'keyinfo --list' /bye | rg ' 1 '`. If there is no output, ASK THE USER TO RUN THE `reset-gpg` script.

NEVER use `--no-verify` when using `git commit`.

Use `--no-pager` when running git commands.

## Tools

Use `fd` and `rg`, not `find` or `grep`. Do not use `rg -r` - `rg` is recursive by default and `-r` instead does a replace operation.

Prefer python for scripts, unless bash is the right tool for the job. Use `uv run` to run python scripts. Define script dependencies in a `/// script` block.

Always use `uv` for python.

Do not hard-wrap markdown files.

Use the EnterWorktree tool to work with git worktrees. DO NOT create folders outside of your current folder. DO NOT touch the ~/Projects root folder unless explicitly asked.

## Subagents

When spawning subagents for implementing features or executing reviews, choose the `sonnet` model for speed and cost efficiency. Use `opus` in subagents for planning, deep research, or in-depth adversarial reviews.
