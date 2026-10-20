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
function markdown
    clear
    tdx $argv
    clear
end
# Set JAVA_HOME
#
# Exec JAVA_HOME=(/usr/libexec/java_home)
#
set -gx JAVA_HOME "/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home/"
set -gx CPPFLAGS "-I//opt/homebrew/opt/openjdk/include"
set -gx CFLAGS "-I$(brew --prefix libmps)/include"
set -gx LDFLAGS "-L$(brew --prefix libmps)/lib"
set -gx PATH //opt/homebrew/opt/openjdk/bin $PATH
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
#set -gx PATH $HOME/snowsql-1.3.2-darwin_x86_64/ $PATH
set -gx PATH $HOME/.emacs.d/bin $PATH
set -gx PATH $HOME/.config/emacs/bin $PATH
set -gx PATH $HOME/localbin $PATH
set -gx PATH $HOME/bin $PATH
set -gx PATH $HOME/.duckdb/cli/latest $PATH
# fish_add_path (npm get prefix -g)
# set -gx PATH $HOME/.nvm/versions/node/v18.14.2/bin/node $PATH # Only here to sync to Emacs with "doom sync"
set -g fish_user_paths "/usr/local/opt/mysql-client/bin" $fish_user_paths

# Terragrunt >= 0.58 defaults to OpenTofu when both are installed; force Terraform.
set -gx TG_TF_PATH terraform

# aws-vault (ByteNess fork): store secrets in the macOS "aws-vault" keychain
# and require Touch ID (biometrics) on every credential access (exec/login/list/remove).
set -gx AWS_VAULT_BACKEND keychain
set -gx AWS_VAULT_BIOMETRICS true

set -gx FZF_DEFAULT_COMMAND rg --files --follow --hidden
alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias gitl="git log --graph --pretty=format:'%Cred%h%Creset %C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
alias gitlfilehistory="git log --oneline --follow --"
alias sw="git checkout"
alias p="git pull -r"
alias timestamp="date -r"
alias minictl="minikube kubectl --"
alias ls="eza"
alias cd="z"
alias csv="vd"
alias 1password="op"
alias coffeecrab="caffeinate -d -- tarts crab"
alias coffeematrix="caffeinate -d -- tarts matrix"
# Print the newest *non-expired* AWS SSO access token from the CLI cache.
# The SSO token is org-wide: one `aws sso login` against any sso-session works
# for every account/role you are entitled to. Fails loudly if nothing is valid.
function awstokencurrent --description 'Print the newest non-expired AWS SSO access token'
    set -l now (date -u +%Y-%m-%dT%H:%M:%SZ)
    set -l token (jq -rs --arg now "$now" '
        [ .[]
          | select(.accessToken != null)
          | select((.expiresAt // "") | endswith("Z"))
          | select(.expiresAt > $now)
        ]
        | max_by(.expiresAt)
        | .accessToken // empty
    ' ~/.aws/sso/cache/*.json 2>/dev/null)
    if test -z "$token"
        echo "awstokencurrent: no valid SSO token; run 'aws sso login --sso-session prod-3' first" >&2
        return 1
    end
    echo $token
end

# Get temporary role credentials (JSON) for an org account via SSO.
# Usage: awsrole <account-id> <role-name>
function awsrole --description 'Get temp role credentials for an org account via SSO'
    if test (count $argv) -lt 2
        echo "usage: awsrole <account-id> <role-name>" >&2
        return 1
    end
    aws sso get-role-credentials \
        --account-id $argv[1] \
        --role-name $argv[2] \
        --access-token (awstokencurrent) \
        --region eu-west-1
end

# Log in to the SSO org (only if needed) and assume an account role by exporting
# its temporary credentials into the *current* shell. In fish a function runs in
# the calling shell, so `set -gx` here mutates your interactive session directly
# (no eval/source of `export ...` lines needed). Clear them again with `rm_aws_env`.
# Usage: awsassume <account-id> <role-name> [sso-session]
function awsassume --description 'SSO login if needed, then assume an account role into this shell'
    if test (count $argv) -lt 2
        echo "usage: awsassume <account-id> <role-name> [sso-session]" >&2
        return 1
    end
    set -l account $argv[1]
    set -l role $argv[2]
    set -l session $argv[3]
    test -z "$session"; and set session prod-3

    # Ensure a valid org-wide SSO token exists; log in only if not.
    if not awstokencurrent >/dev/null 2>&1
        aws sso login --sso-session $session; or return 1
    end

    set -l json (awsrole $account $role)
    or return 1
    set -l akid (echo $json | jq -r '.roleCredentials.accessKeyId')
    set -l skey (echo $json | jq -r '.roleCredentials.secretAccessKey')
    set -l stok (echo $json | jq -r '.roleCredentials.sessionToken')
    if test -z "$akid" -o "$akid" = null
        echo "awsassume: could not get credentials for $role @ $account" >&2
        return 1
    end
    set -gx AWS_ACCESS_KEY_ID $akid
    set -gx AWS_SECRET_ACCESS_KEY $skey
    set -gx AWS_SESSION_TOKEN $stok

    set -l expms (echo $json | jq -r '.roleCredentials.expiration')
    set -l human ""
    if test -n "$expms" -a "$expms" != null
        set human (date -r (math -s0 "$expms/1000") "+%Y-%m-%d %H:%M:%S %Z" 2>/dev/null)
    end
    echo "Assumed $role @ $account (expires $human)"
end

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
fundle plugin 'brgmnn/fish-docker-compose'
fundle init

#Startup Commands
fzf --fish | source
if type -q wally-cli
    wally-cli completion fish | source
end
zoxide init fish | source

hidutil property --set '{"UserKeyMapping":[{"HIDKeyboardModifierMappingSrc":0x700000064,"HIDKeyboardModifierMappingDst":0x700000035}]}' &> /dev/null

export FZF_DEFAULT_OPTS='--color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#262626
    --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
    --color=prompt:#87ff00,spinner:#af5fff,pointer:#5fd7ff,header:#87afaf
    --color=border:#262626,label:#aeaeae,query:#d9d9d9
    --preview-window="border-rounded" --prompt=">" --marker=">"
    --separator="-" --scrollbar="│"'
