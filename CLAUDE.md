# Dotfiles CLAUDE.md

Personal macOS dotfiles, deployed as symlinks into `$HOME` by GNU Stow.

## Workflow and conventions

- Make meaningful, small commits. The only interaction with the remote is `git push`. NEVER raise a PR.
- Commit messages are `<package>: <lowercase summary>` (e.g. `nvim: spellfile`, `alacritty: claude shift-enter support`). For changes that don't belong to a package, use `core`.
- Commits are GPG-signed (`commit.gpgSign=true`). If signing fails, run `~/bin/reset-gpg`.

## Usage

```sh
make                        # restow all packages (idempotent; run after adding ANY file)
make packages=zsh           # restow one package
make delete packages=zsh    # remove a package's symlinks
make adopt packages=zsh     # pull existing $HOME files into the package (destructive to repo files)
make eject packages=zsh     # inverse of adopt: symlinks become real files, repo copy removed
make eject paths=zsh/dot-config/zsh/dot-aliasrc   # eject one file, leaving the rest of the package linked
make eject paths="zsh/dot-config/zsh/dot-aliasrc git/dot-config/git/ignore"   # several; quotes required
make adopt packages=zsh dry=1   # dry=1 works on any target: print the plan, change nothing
```

`make` only creates links for files that exist at run time, so a new file in an already-stowed package is invisible until you rerun it.

## Bringing an existing `$HOME` file under management

`stow --adopt` only resolves *conflicts* — it acts on a target file when the package already has an entry at that path, and ignores anything else in the target directory. So the way to adopt is to create an empty placeholder in the package first, then let adopt overwrite it with the real file's contents:

```sh
touch neovim/dot-config/nvim/lazy-lock.json   # placeholder at the mirrored path
make adopt packages=neovim                    # overwrites it with ~/.config/nvim/lazy-lock.json, then symlinks
git diff                                      # confirm what actually came in
```

Adopt always overwrites repo files with whatever is in `$HOME`, so scope it to one package and dry-run first (`dry=1`). With an empty placeholder there is nothing to lose; adopting a package with real content in it can silently clobber committed config.

### Adopting a file written by another program

Stow's model assumes the target is a symlink that stays a symlink. Before adopting anything an application rewrites (lock files, state, generated config), check *how* it writes:

- **Writes through the symlink** — opens the path and truncates. The link survives. Safe to adopt.
- **Replaces the path** — writes a temp file then `rename()`s it over the target, the usual "atomic save". This *deletes the symlink* and leaves a real file in `$HOME`. The repo copy silently stops being the live one, and the next `make` reports a conflict.

Find the write call in the program's source before adopting, then verify empirically: trigger a real write, and confirm with `test -L` that the target is still a symlink and that the repo copy changed. Editors and anything advertising crash-safe or atomic saves are the usual offenders.

Separately from safety, weigh whether the churn is *meaningful*: a lock file changes only on an explicit update and each diff is a real event worth committing, whereas a file the program rewrites on its own schedule (e.g. `.claude.json`) just adds noise.

## Taking a package back out

`make eject` runs `eject.sh`, the inverse of adopt: a `$HOME` symlink becomes the real file, and the repo's copy is deleted. Take a whole package with `packages=<pkg>`, or individual files with `paths=<pkg>/<file>` (repo-relative, as the path appears here). Both accept several space-separated values, quoted — unquoted, make reads the second one as a target and stops. The script sits at the repo root because every top-level *directory* is a stow package — a `tools/` dir would itself get stowed into `$HOME`.

What not to break if you rewrite it:

- It only acts on links that resolve back into this repo, so stow-ignored files (`.gitignore`) are left alone rather than moved out.
- It handles tree folding: when a package owns a whole target directory, stow links the *directory* rather than its files (`~/bin` → `scripts/bin`), so eject unstows first, then rebuilds the real directory.
- Ejecting one file therefore unstows the whole package, moves that file out, and restows the rest — the file has no symlink of its own to remove when the package is folded. That restow happens *only* in single-file mode; doing it after a whole-package eject would link files stow had deliberately skipped.
- It refuses the `packages = */` default, which would otherwise empty the repo into `$HOME`.
- The `dot-` → `.` translation is `sed 's|/dot-|/.|g'` on a slash-prefixed path. Not an alternation like `\(^\|/\)` — that's a GNU extension, and BSD sed silently fails to match it, which makes every target look unmanaged.

## Layout rules

Each top-level directory is one stow package, and its contents mirror the path under `$HOME` exactly:

- `zsh/dot-zshenv` → `~/.zshenv`
- `git/dot-config/git/config` → `~/.config/git/config`
- `scripts/bin/reset-gpg` → `~/bin/reset-gpg` (on `PATH` via `.zshenv`)
- `gnupg/Library/gnupg/gpg-agent.conf` → `~/Library/gnupg/gpg-agent.conf`

`dot-` is stow's `--dotfiles` prefix for leading dots; it keeps files unhidden in the repo. Use it for every dotfile — a literal `.name` also stows, but inconsistently with the rest of the repo. `home/dot-stow-global-ignore` → `~/.stow-global-ignore` is what excludes `README.md`, `.git`, `.gitignore`, `.DS_Store` from every package, so per-package READMEs are safe to keep.

Most config is XDG-based, and `~/.zshenv` defines the XDG roots first (note the macOS-specific values: `XDG_DATA_HOME=$HOME/Library/`, `XDG_STATE_HOME=$HOME/Library/State`). New tool config belongs in `<pkg>/dot-config/<tool>/`, wired up with the tool's env var (`ASDF_CONFIG_FILE`, `GNUPGHOME`, `ZDOTDIR`, …) in `zsh/dot-config/zsh/dot-zshrc` if the tool doesn't find it automatically.

## Package notes

- **zsh** — `.zshenv` sets XDG paths and `ZDOTDIR`, so everything else lives in `dot-config/zsh/`: `.zshrc` (env + init), `.antigenrc` (plugins via antigen/oh-my-zsh, powerlevel10k theme), `.aliasrc`, `.p10k.zsh` (generated by `p10k configure` — don't hand-edit).
- **neovim** — LazyVim. `lua/config/extras.lua` selects LazyVim extras, `lua/plugins/*.lua` overrides them (one file per concern; `disable.lua` turns plugins off). `lazy-lock.json` is tracked, which is what pins the plugin set (the spec itself uses `version = false`, i.e. always latest commit). lazy.nvim rewrites it in place, so the stow symlink survives; commit the change after any `:Lazy update`, and use `:Lazy restore` to roll back to a committed state. `lazyvim.json` is deliberately *not* tracked: `extras` in it is empty (extras are declared in `lua/config/extras.lua`) and the rest is LazyVim's own state — a NEWS.md read marker and schema-version fields — so tracking it only produces churn that reflects no config change. Format Lua with stylua (`stylua.toml`: 2 spaces, 120 cols). The spellfile lives at `neovim/Library/nvim/site/spell/en.utf-8.add` → `~/Library/nvim/site/spell/` (i.e. `stdpath('data')/site`, *not* the config dir — nvim's `zg` picks the data dir); `zg` appends through the symlink and regenerates the `.add.spl` next to it in place, so both stay linked and both are tracked.
- **claude** — `dot-claude/CLAUDE.md` is the global instruction file symlinked to `~/.claude/CLAUDE.md`, so editing it here changes Claude Code's behaviour everywhere. Plugins are declared, not vendored: `enabledPlugins` in `settings.json` is the tracked part, while the plugin bodies stay a local cache in `~/.claude/plugins`. Skills have no such declaration, so third-party ones are vendored under `dot-claude/skills/<name>/` with the upstream repo and commit recorded in the commit message — refresh by re-downloading over the tree and reading `git diff`. `~/.claude/skills` is a *folded* symlink to `dot-claude/skills/` (the directory itself is the link), so any skill written by skill-creator or by hand lands straight in this repo as untracked files.
- **home** — `brew.sh` is a documentation-style install script, intended to keep track of useful packages I've installed.
