# DISABLE_UNTRACKED_FILES_DIRTY="true"
# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
set -xU HOMEBREW_GITHUB_API_TOKEN xxxxxxx
set -xU BUNDLE_GITHUB__COM "xxxxx:x-oauth-basic"
set -xU REACT_EDITOR code
#alias cat="bat"
alias diff="diff-so-fancy"
alias emacs="emacs -nw"
# Set JAVA_HOME
#
# Exec JAVA_HOME=(/usr/libexec/java_home)
#
set -gx JAVA_HOME /opt/homebrew/Cellar/openjdk/24.0.1/libexec/openjdk.jdk/Contents/Home
set -gx CPPFLAGS "-I//opt/homebrew/opt/openjdk/include"
set -gx CFLAGS "-I$(brew --prefix libmps)/include"
set -gx LDFLAGS "-L$(brew --prefix libmps)/lib"
set -gx PATH //opt/homebrew/opt/openjdk/bin $PATH
set -gx PATH $HOME/bin $PATH
# set -x JAVA_HOME (/usr/libexec/java_home)
#test -d $JAVA_HOME ; and set -gx PATH $JAVA_HOME/bin $PATH
set -x ANDROID_HOME $HOME/Library/Android/sdk
set -x ANDROID_SDK_ROOT $HOME/Library/Android/sdk
set -gx PATH $HOME/Library/Android/sdk/tools $PATH
set -gx PATH $HOME/Library/Android/sdk/emulator $PATH
set -gx PATH /opt/local/bin $PATH
set -gx PATH /usr/local/spark/bin $PATH
set -gx PATH //opt/homebrew/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
#set -gx PATH $HOME/snowsql-1.3.2-darwin_x86_64/ $PATH
set -gx PATH $HOME/.emacs.d/bin $PATH
set -gx PATH $HOME/.config/emacs/bin $PATH
set -gx PATH $HOME/localbin $PATH
set -gx PATH $HOME/bin $PATH
set -gx PATH $HOME/.duckdb/cli/latest $PATH
set -gx PATH $HOME/.nvm/versions/node/v18.14.2/bin/node $PATH # Only here to sync to Emacs with "doom sync"
set -g fish_user_paths "/usr/local/opt/mysql-client/bin" $fish_user_paths

set -gx FZF_DEFAULT_COMMAND rg --files --follow --hidden
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gitl="git log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias sw="git checkout"
alias p="git pull -r"
alias timestamp="date -r"
alias minictl="minikube kubectl --"
alias ls="eza"
alias csv="vd"

# alias docker="podman"
# alias docker-compose="podman-compose"
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
alias ctags=(brew --prefix)/bin/ctags
alias console-ops-container="kubectl get pods | grep -i console-ops | awk '{print $1}'"
function console-ops-container-exec
   set consoleContainer (kubectl get pods | grep -i console-ops | awk '{print $1}')
   kubectl exec -it $consoleContainer -- bash
end 
function countdown --argument-names 'numSeconds'
    if not test -n "$numSeconds"
        echo "countdown: 'numSeconds' arg should be supplied"
    else
        set now (date +%s)
        set finish (math $now + $numSeconds)
        while test $now -le $finish;
            set currCountdown (math $finish - $now)
            printf "%s\r" "$(date -u -j -f %s $currCountdown +%T)"
            sleep 1
            set now (date +%s)
        end
        afplay /System/Library/Sounds/Funk.aiff
    end
end
function fd-with-preview --argument-names 'REGEX'
  fd "$REGEX" | fzf --preview 'fzf-preview.sh {}'
end
function weather --argument-names 'LOCATION'
    if not test -n "$LOCATION"
        echo "weather: 'LOCATION' arg should be supplied"
    else
        curl v2.wttr.in/$LOCATION
    end
end

function rm_aws_env
  set -e AWS_ACCESS_KEY_ID
  set -e AWS_DEFAULT_REGION
  set -e AWS_PROFILE
  set -e AWS_ROLE_ARN
  set -e AWS_SECRET_ACCESS_KEY
  set -e AWS_SESSION_TOKEN
end
alias podinfo="kubectl get pods --all-namespaces -o jsonpath=\"{..image}\" |\
              tr -s '[[:space:]]' '\n' |\
              sort |\
              uniq -c"
function gitp --argument-names 'remote_name'
    # Get current branch name
    set branch_name (git rev-parse --abbrev-ref HEAD)
    if count $argv > /dev/null
        echo "Pushing to specified remote"
        git push --set-upstream $remote_name $branch_name --no-verify
    else
        git push --set-upstream origin $branch_name --no-verify
    end
end
complete -c gitp -f -a "(git remote -v)"
abbr r source ~/.config/fish/config.fish
starship init fish | source
function revert --argument-names 'file_source'
  git checkout HEAD -- $file_source
end
#fish_add_path /usr/local/opt/mysql@5.6/bin
function create_new_space_move_window_follow_focus
  yabai -m space --create && \
                   set index (yabai -m query --displays --display | jq '.spaces[-1]') && \
                   yabai -m window --space "$index" && \
                  yabai -m space --focus "$index"
end
function create_new_space_follow_focus
  yabai -m space --create && \
                   set index (yabai -m query --displays --display | jq '.spaces[-1]') && \
                   yabai -m space --focus "$index"
end
#Fundle plugins
fundle plugin 'FabioAntunes/fish-nvm'
fundle plugin 'edc/bass'
fundle init

#Startup Commands
fzf --fish | source
if type -q wally-cli
    wally-cli completion fish | source
end
export FZF_DEFAULT_OPTS='--color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#262626
    --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
    --color=prompt:#87ff00,spinner:#af5fff,pointer:#5fd7ff,header:#87afaf
    --color=border:#262626,label:#aeaeae,query:#d9d9d9
    --preview-window="border-rounded" --prompt=">" --marker=">"
    --separator="-" --scrollbar="│"'
