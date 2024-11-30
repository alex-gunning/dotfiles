#!/usr/local/bin/fish

echo "Installing Node..."

if type -q nvm
  echo "Already installed NodeJS" 
else
  omf install nvm
end

nvm install --lts

