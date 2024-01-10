# XDG mac equivalents based on https://github.com/adrg/xdg and https://github.com/folder/xdg
export XDG_CONFIG_HOME="$HOME/.config"
#export XDG_CONFIG_HOME="$HOME/Library/Preferences"
export XDG_STATE_HOME="$HOME/Library/Application Support"
export XDG_DATA_HOME="$HOME/Library/Application Support"
export XDG_CACHE_HOME="$HOME/Library/Caches"
export XDG_RUNTIME_DIR="$HOME/Library/Application Support"
export XDG_DATA_DIRS="/Library/Application Support"
export XDG_CONFIG_DIRS="/Library/Application Support:/Library/Preferences"

# path
export PATH="/opt/homebrew/opt/python@3.11/libexec/bin:$PATH"
export PATH="/Applications/Postgres.app/Contents/Versions/latest/bin:$PATH"

# zsh
export ZDOTDIR="$XDG_CONFIG_HOME/zsh"
