stow_cmd = stow --verbose --dotfiles --target=$(HOME)
packages = */

all:
	$(stow_cmd) --restow $(packages)

delete:
	$(stow_cmd) --delete $(packages)

adopt:
	$(stow_cmd) --adopt $(packages)

# unlike the others, this refuses the `*/` default: ejecting every package by
# accident would empty the repo into $HOME
eject:
	@[ "$(packages)" != "*/" ] || { echo "eject needs explicit packages, e.g. make eject packages=zsh" >&2; exit 2; }
	@DRY="$(dry)" ./eject.sh $(packages)
