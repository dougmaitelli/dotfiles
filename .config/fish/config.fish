set -x EDITOR vim
set -x VISUAL vim
set -x BROWSER /usr/bin/chromium

alias config "/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME"

if type -q exa
  alias ls "exa"
end

if type -q jenv
  set PATH $HOME/.jenv/bin $PATH
  status --is-interactive; and source (jenv init -|psub)
end

set -x NPM_PACKAGES $HOME/.npm-packages
set -x PATH $NPM_PACKAGES/bin $PATH
set -x MANPATH $NPM_PACKAGES/share/man (manpath)

[ -e $HOME/.env ]; and source $HOME/.env

starship init fish | source
