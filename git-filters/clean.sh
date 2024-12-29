#!/usr/bin/env bash

if [[ -z "$DOTFILES_ENCRYPTION_KEY" ]]; then
    echo "WARNING! Must provide DOTFILES_ENCRYPTION_KEY in environment. File will not be encrypted." 1>&2
    exit 1
fi

echo "Encrypting $1" 1>&2

openssl enc -aes-256-cbc -pass pass:$DOTFILES_ENCRYPTION_KEY -pbkdf2 -iter 310000 -md sha256 -salt | base64
