# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.config/zsh/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export EDITOR="nvim"

# personal environment variables
export NVIM_CONFIG="$XDG_CONFIG_HOME/nvim"

# enable colors
autoload -U colors && colors

# vi mode
bindkey -v
export KEYTIMEOUT=1

# load homebrew environment
if [[ -e /opt/homebrew/bin/brew ]]; then
    export HOMEBREW_NO_ANALYTICS=1
    export HOMEBREW_NO_ENV_HINTS=1
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# use rbenv
if whence rbenv &>/dev/null; then
    export RBENV_ROOT="$HOME/Library/rbenv" # can't go in DATA_HOME because of space in folder name
    eval "$(rbenv init - zsh)"
fi

# ruby
#export RUBY_CONFIGURE_OPTS="--with-openssl-dir=$(brew --prefix openssl@1.0)" # see https://github.com/rbenv/homebrew-tap/pull/2
#export BUNDLE_USER_CONFIG="$XDG_CONFIG_HOME/bundle"
#export BUNDLE_USER_CACHE="$XDG_CACHE_HOME/bundle"
#export BUNDLE_USER_PLUGIN="$XDG_DATA_HOME/bundle"

# use z to easily cd to directories
export ZSHZ_DATA="$XDG_DATA_HOME/z"

# wget config (don't bloat home directory)
export WGETRC="$XDG_CONFIG_HOME/wget/wgetrc"

# set gpg to use the current TTY when asking for password
export GPG_TTY=$TTY
export GNUPGHOME="$XDG_DATA_HOME/gnupg"

# nvm and node
export NVM_DIR="$XDG_DATA_HOME/nvm"
export NVM_COMPLETION=true
export NVM_AUTO_USE=true
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"

[ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && \. "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm

# make local libs available to compiler and executer
export C_INCLUDE_PATH="/usr/local/include:$C_INCLUDE_PATH"
export LD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"
export DYLD_LIBRARY_PATH="/usr/local/lib:$LD_LIBRARY_PATH"

# history settings
export HISTFILE="$XDG_DATA_HOME/history"
HISTSIZE=10000
SAVEHIST=10000
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY

# don't store less history
export LESSHISTFILE="-"

# terminfo
export TERMINFO="$XDG_DATA_HOME/terminfo"
export TERMINFO_DIRS="$XDG_DATA_HOME/terminfo:/usr/share/terminfo"

# load autocompletions from homebrew if installed
if type brew &>/dev/null; then
    FPATH="$(brew --prefix)/share/zsh-completions:$(brew --prefix)/share/zsh/site-functions:$FPATH"
fi
autoload -Uz compinit
zstyle ':completion:*' menu select cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zmodload zsh/complist
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
_comp_options+=(globdots) # include hidden files

# use antigen to install zsh plugins (this also loads oh-my-zsh)
export ADOTDIR="$XDG_CACHE_HOME/antigen" # ideally this would be data but antigen doesn't support spaces in paths
if type brew &>/dev/null; then
    source "$(brew --prefix)/share/antigen/antigen.zsh"
    antigen init "$ZDOTDIR/.antigenrc"
fi

# To customize prompt, run `p10k configure` or edit ~/.config/zsh/.p10k.zsh.
[[ ! -f "$ZDOTDIR/.p10k.zsh" ]] || source "$ZDOTDIR/.p10k.zsh"

# fuzzyfinder
[ -f "$ZDOTDIR/.fzf.zsh" ] && source "$ZDOTDIR/.fzf.zsh"

# load aliases
[ -f "$ZDOTDIR/.aliasrc" ] && source "$ZDOTDIR/.aliasrc"

# fuck
eval $(thefuck --alias fuck)
