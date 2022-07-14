set -x EDITOR vim
set -x VISUAL vim
set -x BROWSER /usr/bin/chromium

if type -q exa
  alias ls "exa"
end

alias git-prune "git fetch -p ; git branch -r | awk '{print \$1}' | egrep -v -f /dev/fd/0 (git branch -vv | grep origin | psub) | awk '{print \$1}' | xargs git branch -D"

if type -q jenv
  set PATH $HOME/.jenv/bin $PATH
  status --is-interactive; and source (jenv init -|psub)
end

if [ -e $HOME/.volta ]
  set -gx VOLTA_HOME $HOME/.volta
  set -gx PATH $VOLTA_HOME/bin $PATH
end

if [ -e $HOME/.kubeconfigs ]
  set -gx PATH $PATH $HOME/.krew/bin
  set -x KUBECONFIG $HOME/.kubeconfigs/config
end

[ -e $HOME/.env ]; and source $HOME/.env

starship init fish | source
