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

# takes packages= or paths= (one file, repo-relative). Unlike the others it
# refuses the `*/` default: ejecting every package would empty the repo.
eject:
	@[ -n "$(paths)" ] || [ "$(packages)" != "*/" ] || { echo "eject needs packages=<pkg> or paths=<pkg/file>" >&2; exit 2; }
	@[ -z "$(paths)" ] || [ "$(packages)" = "*/" ] || { echo "eject takes packages= or paths=, not both" >&2; exit 2; }
	@DRY="$(dry)" ./eject.sh $(if $(paths),$(paths),$(packages))
