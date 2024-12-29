#/usr/bin/env bash

if [[ -z "$DOTFILES_ENCRYPTION_KEY" ]]; then
    echo "WARNING!: Must provide DOTFILES_ENCRYPTION_KEY in environment. File will not be decrypted!" 1>&2
    exit 1
fi

echo "Decrypting $1" 1>&2
base64 --decode | openssl enc -d --aes-256-cbc -pbkdf2 -iter 310000 -md sha256 -salt -pass pass:$DOTFILES_ENCRYPTION_KEY
