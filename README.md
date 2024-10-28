# dotfiles

This repo contains my personal dotfiles collection.

## Usage

Clone the repo into `~/dotfiles`, then run `make` to install symlinks. To remove symlinks, run `make delete`.

By default, commands affect all packages. Specify the `packages` variable to run `stow` on particular packages, e.g. `make delete packages=zsh`.
