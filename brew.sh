# installs EVERYTHING you need for a fully-fledged macos setup
# (untested!)
# (make sure you install homebrew itself first!)

# casks
brew tap homebrew/cask-fonts

# wine-crossover
brew tap gcenx/wine

# contains openssl@1.0, needed to install certain (old) versions of ruby
brew tap rbenv/tap

brew install alacritty
# disable font smoothing (i.e. enable anti-aliasing?) to make font appear thinner
defaults write -g AppleFontSmoothing -int 0

# move to trash (bin) as a safe alternative to rm
brew install trash

# plugin manager for zsh and oh-my-zsh
brew install antigen
# some default completions for zsh
brew install zsh-completions

# ruby version manager
brew install rbenv
# from rbenv/tap
brew install openssl@1.0

# python version manager
brew install virtualenv
# system python (is this needed?)
brew install python@3.11

# Node.js version manager
brew install nvm
# system node (is this needed?)
brew install node

# javascript package manager (better than npm)
brew install yarn

# why do we have zip but not unzip? 
brew install unzip

# wine!
brew install wine-crossover # (cask)
brew install winetricks
#brew install cabextract@1.9.1
brew install cabextract

# interact with the internet
brew install wget

# JDK
brew install openjdk

# GNU Pretty Good Privacy
# provies ssh-agent and so on
brew install gnupg

# NeoVim text editor
brew install neovim

# open source .NET framework
brew install mono

# formatter for C family languages
brew install clang-format
brew install lua
brew install libevent

# CMAKE
brew install cmake
brew install universal-ctags

# 7-zip implementation
brew install p7zip

# fuzzy finder
brew install fzf

# grep but better
brew install ripgrep

# terminal multiplexer
brew install tmux
# plugin manager for tmux
brew install tpm

# nice git TUI
brew install lazygit

# cat but better
brew install bat
# bat but prettier
brew install glow


# language servers
brew install lua-language-server


# ocr enginge
brew install tesseract
brew install tesseract-lang

##############################################
# CASKS
##############################################
brew install alacritty
brew install font-fira-code-nerd-font
brew install homebrew/cask/wireshark
brew install homebrew/cask/syncthing
brew install obsidian

# macos tweaks
brew install middleclick
brew install linearmouse
brew install notunes


##############################################
# pip modules
##############################################
pip install --upgrade pip
pip install ocrmypdf


brew cleanup
