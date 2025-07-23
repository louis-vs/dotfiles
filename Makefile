stow_cmd = stow --verbose --dotfiles --target=$(HOME)
packages = */

all:
	$(stow_cmd) --restow $(packages)

delete:
	$(stow_cmd) --delete $(packages)

adopt:
	$(stow_cmd) --adopt $(packages)
