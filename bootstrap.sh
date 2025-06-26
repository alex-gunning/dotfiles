#!/bin/sh

echo "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `bootstrap.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    echo "Sudo credentials updated."
else
    >&2 echo "Failed to obtain sudo credentials."
fi


if ! [ -x "$(command -v xcode-select)" ]; then
  yes | sudo xcode-select --install
  echo "xcode-select installed"
else
  echo "xcode-select has already been installed. Skipping."
fi

if ! [ -x "$(command -v brew)" ]; then
  yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Homebrew installed"
else
  echo "Homebrew has already been installed. Skipping."
fi

if ! [ -x "$(command -v maccy)" ]; then
  yes | brew install maccy
  echo "Maccy installed"
else
  echo "Maccy has already been installed. Skipping."
fi

if ! [ -x "$(command -v ghostty)" ]; then
  yes | brew install --cask ghostty
  echo "Ghostty installed"
else
  echo "Ghostty has already been installed. Skipping."
fi

if ! [ -x "$(command -v jq)" ]; then
  yes | brew install jq
  echo "jq installed"
else
  echo "jq has already been installed. Skipping."
fi

if ! [ -x "$(command -v vim)" ]; then
  yes | brew install vim
  echo "Vim installed"
else
  echo "Vim has already been installed. Skipping."
fi

if ! [ -x "$(command -v starship)" ]; then
  yes | brew install starship
  echo "Starship installed"
else
  echo "Starship has already been installed. Skipping."
fi

if ! [ -x "$(command -v git)" ]; then
  yes | brew install git
  echo "Git installed"
else
  echo "Git has already been installed. Skipping."
fi
