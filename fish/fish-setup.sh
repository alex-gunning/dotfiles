#!/bin/sh

echo "Setting up fish shell ..."

if ! [ -x "$(command -v fish)" ]; then
  yes | brew install fish
  echo "Successfully installed Fish shell"
else
  echo "Fish is already installed"
fi
chsh -s $(which fish)
