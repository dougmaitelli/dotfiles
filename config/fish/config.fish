set -x EDITOR vim
set -x VISUAL vim
set -x BROWSER /usr/bin/chromium

if [ -e /opt/homebrew ]
  fish_add_path /opt/homebrew/bin
end

if type -q lsd
  alias ls "lsd"
end

alias git-prune "git fetch -p ; git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 (git branch -vv | grep origin | psub) | awk '{print \$1}' | xargs git branch -D"

if type -q jenv
  fish_add_path $HOME/.jenv/bin
  status --is-interactive; and source (jenv init -|psub)
end

if [ -e $HOME/.volta ]
  set -gx VOLTA_HOME $HOME/.volta
  fish_add_path $VOLTA_HOME/bin
end

if type -q npm
  fish_add_path (npm bin)
end

if [ -e $HOME/.kubeconfigs ]
  fish_add_path $HOME/.krew/bin
  set -x KUBECONFIG $HOME/.kubeconfigs/config
end

[ -e $HOME/.env ]; and source $HOME/.env

zoxide init fish | source

starship init fish | source
