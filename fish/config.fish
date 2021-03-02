alias aur-search="yay -Slq | fzf -m --preview 'yay -Si {1}'| xargs -ro yay -S"
alias remove-package="yay -Qeq | fzf -m --preview 'yay -Qi {1}' | xargs -ro yay -Rs"
alias cat="bat"
#set -x brew ./linuxbrew
set -gx PATH ~/.linuxbrew/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/path $PATH
set -gx PATH /usr/lib/jvm/java-11-openjdk $PATH
set -gx PATH $HOME/.local/bin $PATH
set -gx PATH $HOME/.emacs.d/bin $PATH
set -gx JAVA_HOME /usr/lib/jvm/java-11-openjdk 
#xmodmap ~/.Xmodmap
starship init fish | source
alias calc="insect"
alias sysinfo="neofetch"
alias p="git pull -r"
alias gitl="git log --pretty --oneline"
