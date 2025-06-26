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


echo "\nInstalling cli software..."

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


if ! [ -x "$(command -v fzf)" ]; then
  yes | brew install fzf
  mkdir -p $HOME/.config/fish/functions
  fzf --fish > $HOME/.config/fish/functions/fzf_key_bindings.fish
  printSuccess "fzf installed and fish configured with completions."
else
  printNeutral "fzf has already been installed. Skipping."
fi

if ! [ -x "$(command -v fd)" ]; then
  yes | brew install fd
  printSuccess "fd installed"
else
  printNeutral "fd has already been installed. Skipping."
fi

if ! [ -x "$(command -v rg)" ]; then
  yes | brew install ripgrep
  printSuccess "Ripgrep installed"
else
  printNeutral "Ripgrep has already been installed. Skipping."
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

if ! [ -x "$(command -v vd)" ]; then
  yes | brew install saulpw/vd/visidata
  printSuccess "Visidata installed"
else
  printNeutral "Visidata has already been installed. Skipping."
fi

if ! [ -x "$(command -v java)" ]; then
  yes | brew install openjdk
  printSuccess "OpenJDK installed"
else
  printNeutral "OpenJDK has already been installed. Skipping."
fi
if ! [ -x "$(command -v jdtls)" ]; then
  yes | brew install jdjtls
  printSuccess "jdtls installed"
else
  printNeutral "jdtls has already been installed. Skipping."
fi

if ! [ -x "$(command -v mvn)" ]; then
  yes | brew install mvn
  printSuccess "Maven installed"
else
  printNeutral "Maven has already been installed. Skipping."
fi

echo "\nInstalling/updating app-based software..."

yes | brew install --cask rectangle 2>/dev/null
printSuccess "Rectangle installed"

yes | brew install --cask shottr 2>/dev/null
printSuccess "Shottr installed"

yes | brew install nvm 2>/dev/null
printSuccess "Nvm installed"

yes | brew install maccy 2>/dev/null
printSuccess "Maccy installed"

yes | brew install 1password 2>/dev/null
printSuccess "1Password installed"

yes | brew install --cask brave-browser 2>/dev/null
printSuccess "Brave browser installed"

printNeutral "Xnip will need to be installed through the app store."

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
  printNeutral "starship symlink exists. skipping."
else
  ln -s $(pwd)/starship/starship.toml "$HOME/.config/starship.toml"
  printSuccess "Starship symlink created."
fi

if [ -h "$HOME/.config/ghostty/config" ]; then
  printNeutral "Ghostty symlink exists. skipping."
else
  mkdir -p "$HOME/.config/ghostty"
  ln -s $(pwd)/ghostty/config "$HOME/.config/ghostty/config"
  printSuccess "Ghostty symlink created."
fi

if [ -h "$HOME/.vimrc" ]; then
  printNeutral "Vimrc symlink exists. skipping."
else
  ln -s $(pwd)/vim/.vimrc "$HOME/.vimrc"
  printSuccess "Vimrc symlink created."
fi

#-----------------
# Symlink Intellij
#-----------------

#-----------------
# Symlink Brave
#-----------------

echo "\nApplying necessary configurations..."

mvn \
        org.apache.maven.plugins:maven-dependency-plugin:2.10:get \
        -Dartifact=com.microsoft.java:com.microsoft.java.debug.plugin:0.53.1 1> /dev/null
printSuccess "Java debug plugin saved to .m2 cache."

NODE_APPROPRIATE_VERSION="v18.14.2"

printNeutral "Please run 'nvm install $NODE_APPROPRIATE_VERSION && nvm alias default $NODE_APPROPRIATE_VERSION' to set the global NodeJS version."
# nvm install --lts 1> /dev/null
# nvm install $NODE_APPROPRIATE_VERSION 1> /dev/null
# nvm alias default $NODE_APPROPRIATE_VERSION 1> /dev/null
# printSuccess "Set default nodejs version to $NODE_APPROPRIATE_VERSION and installed latest LTS in Fish"

# java
# tfenv
