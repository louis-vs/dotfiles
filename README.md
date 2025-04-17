# dotfiles

This repo contains my personal dotfiles collection, written for macOS.

## Usage

Clone the repo (e.g. into `~/dotfiles`), then run `make` to install symlinks to your `$HOME` directory. To remove symlinks, run `make delete`.

By default, commands affect all packages. Specify the `packages` variable to run `stow` on particular packages, e.g. `make delete packages=zsh`.

**NB make sure to run `make` whenever you add a new file or package to ensure that it's picked up.**

You can prefix files that start with a dot with `dot-` instead so they aren't treated by your system as hidden files.

If you have files that are already in your dotfiles that you want to absorb into a new package you can run `make adopt`.
