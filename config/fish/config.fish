set -x EDITOR vim
set -x VISUAL vim
set -x BROWSER /usr/bin/chromium

if type -q exa
  alias ls "exa"
end

if type -q jenv
  set PATH $HOME/.jenv/bin $PATH
  status --is-interactive; and source (jenv init -|psub)
end

set -gx VOLTA_HOME $HOME/.volta
set -gx PATH $VOLTA_HOME/bin $PATH

set -gx PATH $PATH $HOME/.krew/bin
set -x KUBECONFIG $HOME/.kubeconfigs/config

[ -e $HOME/.env ]; and source $HOME/.env

starship init fish | source
