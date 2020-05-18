#!/usr/local/bin/fish

echo "Installing Git..."
if type -q git
  echo "Already installed Git"
else
  brew install git
end


