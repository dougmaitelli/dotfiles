#!/bin/bash

# Setting up dotfiles
echo "Setting up dotfiles"
git clone https://github.com/dougmaitelli/dotfiles.git $HOME/.dotfiles
cd $HOME/.dotfiles
./install
