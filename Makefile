stow_cmd = stow --verbose --dotfiles --target=$(HOME)
packages = */

# dry=1 turns any target into a plan: stow simulates, eject.sh prints instead
# of moving. --verbose alone is enough to show the plan; a second -v only adds
# stow's own internal chatter.
dry_flag = $(if $(dry),-n)

all:
	$(stow_cmd) $(dry_flag) --restow $(packages)

delete:
	$(stow_cmd) $(dry_flag) --delete $(packages)

adopt:
	$(stow_cmd) $(dry_flag) --adopt $(packages)

# unlike the others, this refuses the `*/` default: ejecting every package by
# accident would empty the repo into $HOME
eject:
	@[ "$(packages)" != "*/" ] || { echo "eject needs explicit packages, e.g. make eject packages=zsh" >&2; exit 2; }
	@DRY="$(dry)" ./eject.sh $(packages)
