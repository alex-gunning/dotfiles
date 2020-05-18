#!/bin/sh

echo "Prompting for sudo password..."
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    echo "Sudo credentials updated."
else
    >&2 echo "Failed to obtain sudo credentials."
fi
echo "Installing Homebrew..."

if ! [ -x "$(command -v brew)" ]; then
  yes | /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  echo "Homebrew installed"
else
  echo "Homebrew has already been installed"
fi

if ! [ -x "$(command -v jq)" ]; then
  yes | brew install jq
fi
