alias aur-search="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"
alias remove-package="yay -Qeq | fzf -m --preview 'yay -Qi {1}' | xargs -ro yay -Rs"
alias cat="bat"
#set -x brew ./linuxbrew
set -gx PATH ~/.linuxbrew/bin $PATH
#xmodmap ~/.Xmodmap
starship init fish | source
alias calc="insect"
alias sysinfo="neofetch"
alias p="git pull -r"
