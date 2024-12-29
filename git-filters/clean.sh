#!/usr/bin/env bash

echo "Cleaning for upload" 1>&2

openssl enc -aes-256-cbc -pass pass:alex -pbkdf2 -iter 310000 -md sha256 -salt
