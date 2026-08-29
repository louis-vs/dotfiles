stow_cmd = stow --verbose --dotfiles --dir=stow --target=$(HOME)
packages = */

# dry=1 turns any target into a plan: stow simulates, eject.sh prints instead
# of moving. --verbose alone is enough to show the plan; a second -v only adds
# stow's own internal chatter.
dry_flag = $(if $(dry),-n)

# `*/` is expanded by the shell in this directory, so glob inside stow/ and
# strip the prefix back off — stow names packages relative to --dir.
pkg_args = $(if $(filter */,$(packages)),$(patsubst stow/%,%,$(wildcard stow/*/)),$(packages))

all:
	$(stow_cmd) $(dry_flag) --restow $(pkg_args)

delete:
	$(stow_cmd) $(dry_flag) --delete $(pkg_args)

adopt:
	$(stow_cmd) $(dry_flag) --adopt $(pkg_args)

# takes packages= or paths= (one file, relative to stow/). Unlike the others it
# refuses the `*/` default: ejecting every package would empty the repo.
eject:
	@[ -n "$(paths)" ] || [ "$(packages)" != "*/" ] || { echo "eject needs packages=<pkg> or paths=<pkg/file>" >&2; exit 2; }
	@[ -z "$(paths)" ] || [ "$(packages)" = "*/" ] || { echo "eject takes packages= or paths=, not both" >&2; exit 2; }
	@DRY="$(dry)" ./eject.sh $(if $(paths),$(paths),$(packages))
