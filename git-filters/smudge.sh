#/usr/bin/env bash

echo "Smudging" 1>&2

openssl enc -d --aes-256-cbc -pbkdf2 -iter 310000 -md sha256 -salt -pass pass:alex
