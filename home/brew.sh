# installs EVERYTHING you need for a fully-fledged macos setup
# (make sure you install homebrew itself first!)

# wine-crossover
brew tap gcenx/wine

# disable font smoothing (i.e. enable anti-aliasing?) to make font appear thinner
defaults write -g AppleFontSmoothing -int 0

# move to trash (bin) as a safe alternative to rm
brew install trash

# plugin manager for zsh and oh-my-zsh
brew install antigen
# some default completions for zsh
brew install zsh-completions

# tool version management
brew install asdf

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

# GNU sed (different from BSD sed)
brew install gnu-sed

# GNU CoreUtils (provides g-prefixed tools)
brew install coreutils

# NeoVim text editor
brew install neovim

# open source .NET framework
brew install mono

# formatter for C family languages
brew install clang-format

# lua dev
brew install lua
brew install luarocks

# CMAKE
brew install cmake
brew install universal-ctags

# 7-zip implementation
brew install p7zip

# fuzzy finder
brew install fzf

# grep but better
brew install ripgrep

# find but better
brew install fd

# nice git TUI
brew install lazygit

# cat but better
brew install bat
# bat but prettier
brew install glow


# language servers
brew install lua-language-server


# ocr engine
brew install tesseract
brew install tesseract-lang

# fuck
brew install thefuck

# stow (for dotfiles)
brew install stow

# work
brew tap hashicorp/tap
brew install hashicorp/tap/terraform
brew install awscli
brew install azure-cli

##############################################
# CASKS
##############################################
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font

brew install alacritty
brew install homebrew/cask/wireshark
brew install homebrew/cask/syncthing

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
