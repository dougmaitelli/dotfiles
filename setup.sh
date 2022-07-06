#!/bin/bash

# Install Fisher
echo "Installing Fisher"
curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish

# Install Fish Theme
echo "Installing Fish Theme"
fisher add oh-my-fish/theme-bobthefish

# Install Vim Plug
echo "Installing Vim Plug"
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Setting up dotfiles
echo "Setting up dotfiles"
git clone --bare https://github.com/dougmaitelli/dotfiles.git $HOME/.cfg
function config {
   /usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME $@
}
config checkout
if [ $? = 0 ]; then
  echo "Checked out config.";
  else
    echo "Backing up pre-existing dot files.";
    mkdir -p .config-backup
    config checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | xargs -I{} mv {} .config-backup/{}
    config checkout
fi;
config config status.showUntrackedFiles no
config update-index --assume-unchanged -z README.md setup.sh
