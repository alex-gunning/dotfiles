# dotfiles

## Cloning instructions
##### Only clone using the following so that encrypted files are decrypted.

1. Make sure `DOTFILES_ENCRYPTION_KEY` is available in the shell environment.
2. ```git clone --config filter.sensitive.clean="./git-filters/clean.sh %f" --config filter.sensitive.smudge="./git-filters/smudge.sh %f" git@github.com:alex-gunning/dotfiles.git```

