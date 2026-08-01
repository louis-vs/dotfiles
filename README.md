# dotfiles

This repo contains my personal dotfiles collection, written for macOS.

## Usage

Clone the repo (e.g. into `~/dotfiles`), then run `make` to install symlinks to your `$HOME` directory. To remove symlinks, run `make delete`.

By default, commands affect all packages. Specify the `packages` variable to run `stow` on particular packages, e.g. `make delete packages=zsh`.

Add `dry=1` to any command to print what it would do without touching anything, e.g. `make adopt packages=zsh dry=1`.

**NB make sure to run `make` whenever you add a new file or package to ensure that it's picked up.**

You can prefix files that start with a dot with `dot-` instead so they aren't treated by your system as hidden files.

You can use `make adopt` to pull files into stow packages. Careful with this – you probably want to specify specific packages when you do this, and to check with `dry=1` first.

`make eject packages=<pkg>` is the opposite of adopt: it turns that package's symlinks back into real files in `$HOME` and drops the repo's copy, so you can stop managing something without losing it. It only touches links that point into this repo, and it requires you to name the packages.

To add a new package, first create the files you want to include into a new folder, or move files that already exist here. Then run `make packages=<new package name>` to create symlinks.

Some programs (e.g. GnuPG) might require you to fiddle with permissions after you clone the repo and run stow.
