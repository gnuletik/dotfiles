#!/bin/bash

# Configuration script for :
# - vim / neovim
# - st (suckless terminal)
# - tmux

# Prerequiries:
# - Install neovim / vim with true colors
# - Install tmux
# - Install zsh

ln -s dotfiles/.shellrc $HOME/.shellrc
ln -s dotfiles/.inputrc $HOME/.inputrc
ln -s dotfiles/.tmux.conf $HOME/.tmux.conf
ln -s dotfiles/.vimrc $HOME/.vimrc
echo '. $HOME/.shellrc' >> $HOME/.zshrc

function config_neovim {
  # Neovim symbolic link config file
  mkdir -p $HOME/.config/nvim
  ln -s ../../.vimrc $HOME/.config/nvim/init.vim
  # Vim-plug for Neovim
  curl -fLo $HOME/.local/share/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  cat << EOF >> $HOME/.shellrc
  ## ZSH
  vim() {
    tput smkx # Fix delete key in neovim for the time being. See https://github.com/neovim/neovim/issues/3211
    command nvim \$@
  }
EOF
}

function config_vim {
  # Vim-plug for Vim
  curl -fLo $HOME/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
}

function install_ohmyzsh {
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

while true; do
  read -p "Do you use neovim? (Answer no if you use vim)" yn
  case $yn in
    [Yy]* ) config_neovim; break;;
    [Nn]* ) config_vim;;
    * ) echo "Please answer yes or no.";;
  esac
done

while true; do
  read -p "Do you wish to install oh-my-zsh?" yn
  case $yn in
    [Yy]* ) install_ohmyzsh; break;;
    [Nn]* ) break;;
    * ) echo "Please answer yes or no.";;
  esac
done
