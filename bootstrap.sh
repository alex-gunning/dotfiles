#!/bin/sh
set -eu

printSuccess() {
  printf "\xE2\x9C\x93 $1\n"
}

printNeutral() {
  printf "\xE2\x80\xA2 $1\n"
}

printNeutral "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `bootstrap.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    printSuccess "Sudo credentials updated."
else
    >&2 echo "Failed to obtain sudo credentials."
fi


if ! [ -x "$(command -v xcode-select)" ]; then
  yes | sudo xcode-select --install
  printSuccess "xcode-select installed"
else
  printNeutral "xcode-select has already been installed. Skipping."
fi

if ! [ -x "$(command -v brew)" ]; then
  yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  printSuccess "Homebrew installed"
else
  printNeutral "Homebrew has already been installed. Skipping."
fi

if ! [ -x "$(command -v git)" ]; then
  yes | brew install git
  printSuccess "Git installed"
else
  printNeutral "Git has already been installed. Skipping."
fi

if ! [ -x "$(command -v maccy)" ]; then
  yes | brew install maccy
  printSuccess "Maccy installed"
else
  printNeutral "Maccy has already been installed. Skipping."
fi

if ! [ -x "$(command -v ghostty)" ]; then
  yes | brew install --cask ghostty
  printSuccess "Ghostty installed"
else
  printNeutral "Ghostty has already been installed. Skipping."
fi

if ! [ -x "$(command -v fish)" ]; then
  yes | brew install fish
  mkdir -p $HOME/.config/fish
  printSuccess "Fish shell installed"
else
  printNeutral "Fish shell has already been installed. Skipping."
fi

if ! [ -x "$(command -v jq)" ]; then
  yes | brew install jq
  printSuccess "jq installed"
else
  printNeutral "jq has already been installed. Skipping."
fi

if ! [ -x "$(command -v tfenv)" ]; then
  yes | brew install tfenv
  printSuccess "tfenv installed"
else
  printNeutral "tfenv has already been installed. Skipping."
fi

if ! [ -x "$(command -v nvm)" ]; then
  yes | brew install nvm
  printSuccess "nvm installed"
else
  printNeutral "nvm has already been installed. Skipping."
fi

if ! [ -x "$(command -v fzf)" ]; then
  yes | brew install fzf
  mkdir -p $HOME/.config/fish/functions
  fzf --fish > $HOME/.config/fish/functions/fzf_key_bindings.fish
  printSuccess "fzf installed and fish configured with completions."
else
  printNeutral "fzf has already been installed. Skipping."
fi

if ! [ -x "$(command -v vim)" ]; then
  yes | brew install vim
  printSuccess "Vim installed"
else
  printNeutral "Vim has already been installed. Skipping."
fi

if ! [ -x "$(command -v starship)" ]; then
  yes | brew install starship
  printSuccess "Starship installed"
else
  printNeutral "Starship has already been installed. Skipping."
fi

if ! [ -d "$(pwd)/../emacs" ]; then
  git clone https://github.com/emacs-mirror/emacs.git "$(pwd)/../emacs" --depth=1
  printSuccess "Emacs cloned. Compiling Emacs".

  pushd $(pwd)/../emacs
  ./autogen.sh
  ./configure \
        --with-mac \
        --enable-locallisppath=/usr/local/share/emacs/site-lisp:/opt/homebrew/share/emacs/site-lisp \
        --enable-mac-self-contained \
        --with-modules \
        --with-xwidgets \
        --with-tree-sitter \
        --without-lcms2 \
        --without-webp \
        --with-native-compilation \
        --with-mailutils

  printSuccess "Emacs compiled."
  popd
else
  printNeutral "Emacs sources exist. Skipping."
fi

#-----------------------
# Install openJDK
#-----------------------

#-----------------------
# Install jdtls
#-----------------------

#-----------------------
# Install mvn
#-----------------------

echo "\nPerforming necessary Symlinks..."

if [ -h "$HOME/localbin/emacs" ]; then
  printNeutral "Emacs symlink exists. Skipping."
else
  mkdir -p "$HOME/localbin"
  ln -s $(pwd)/../emacs/src/emacs "$HOME/localbin/emacs"
  printSuccess "Emacs symlink created."
fi

if [ -h "$HOME/.config/fish/config.fish" ]; then
  printNeutral "Fish config symlink exists. Skipping."
else
  mkdir -p "$HOME/.config/fish"
  ln -s $(pwd)/fish/config.fish "$HOME/.config/fish/config.fish"
  printSuccess "Fish config symlink created."
fi

if [ -h "$HOME/.config/starship.toml" ]; then
  printNeutral "Starship symlink exists. Skipping."
else
  ln -s $(pwd)/starship/starship.toml "$HOME/.config/starship.toml"
  printSuccess "Starship symlink created."
fi

#-----------------
# Symlink Vim
#-----------------

#-----------------
# Symlink Intellij
#-----------------

#-----------------
# Symlink Brave
#-----------------


echo "\nApplying necessary configurations..."

# nvm
# java
# tfenv
