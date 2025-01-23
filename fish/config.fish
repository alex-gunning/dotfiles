# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
set -xU HOMEBREW_GITHUB_API_TOKEN fd3386fa123d177e80fc4ae997466e253be65b3d
set -xU BUNDLE_GITHUB__COM "374aed7422d448672fc3eac79befc66c2010e268:x-oauth-basic"
set -xU REACT_EDITOR code
alias cat="bat"
alias diff="diff-so-fancy"
# Set JAVA_HOME to Java 11
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home/
set -gx PATH $HOME/bin $PATH
# set -x JAVA_HOME (/usr/libexec/java_home)
test -d $JAVA_HOME ; and set -gx PATH $JAVA_HOME/bin $PATH

set -x ANDROID_HOME $HOME/Library/Android/sdk
set -x ANDROID_SDK_ROOT $HOME/Library/Android/sdk
set -gx PATH $HOME/Library/Android/sdk/tools $PATH
set -gx PATH $HOME/Library/Android/sdk/emulator $PATH
set -gx PATH /opt/local/bin $PATH
set -gx PATH /usr/local/spark/bin $PATH
set -gx PATH //opt/homebrew/bin $PATH
set -gx PATH $HOME/.cargo/bin $PATH
set -gx PATH $HOME/snowsql-1.3.2-darwin_x86_64/ $PATH
set -gx PATH /.emacs.d/emacs/bin $PATH
set -gx PATH $HOME/.config/emacs/bin $PATH
set -gx PATH $HOME/bin $PATH
set -gx FZF_DEFAULT_COMMAND rg --files --follow --hidden

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gitl="git log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias sw="git checkout"
alias p="git pull -r"
alias timestamp="date -r"
alias minictl="minikube kubectl --"
# alias docker="podman"
# alias docker-compose="podman-compose"
[ -f /usr/local/share/autojump/autojump.fish ]; and source /usr/local/share/autojump/autojump.fish
alias ctags=(brew --prefix)/bin/ctags
alias console-ops-container="kubectl get pods | grep -i console-ops | awk '{print $1}'"
function console-ops-container-exec
   set consoleContainer (kubectl get pods | grep -i console-ops | awk '{print $1}')
   kubectl exec -it $consoleContainer -- bash
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

function gitp --argument-names 'remote-name'
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
set -g fish_user_paths "/usr/local/opt/mysql-client/bin" $fish_user_paths

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

#Startup Commands for each shell instance
