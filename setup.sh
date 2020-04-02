#!/usr/bin/env bash

# Cancel upgrade if git is unavailable on the system
if ! [ -x "$(command -v git)" ]; then
    echo "Missing git!"
    exit 1
fi

# Cancel upgrade if stow is unavailable on the system
if ! [ -x "$(command -v stow)" ]; then
    echo "Missing GNU stow!"
    exit 1
fi

# Check if $HOME/.dotfiles exists, then export $DOTFILES
if [ -d $HOME/.dotfiles ]; then
    export DOTFILES=$HOME/.dotfiles
fi

# Check if $HOME/dotfiles exists, then export $DOTFILES
if [ -d $HOME/dotfiles ]; then
    export DOTFILES=$HOME/dotfiles
fi

# Check for empty $DOTFILES vairable
if [ -z $DOTFILES ]; then
    echo -e "Unable to find the DOTFILES folder..."
    echo -e "Please ensure that repo has been cloned to either:"
    echo -e "\r"
    echo -e "$HOME/.dotfiles"
    echo -e "$HOME/dotfiles"
    echo -e "\r"
    exit 1
fi

# Use stow to create symlinks for the dotfiles
cd $DOTFILES
stow -v --restow bash

# restow urxvt config
if [ -x "$(command -v urxvt)" ]; then
    stow -v --restow urxvt
fi

# restow X-Windows configurations
if [ -x "$(command -v i3)" ]; then
    stow -v --restow Xresources
    stow -v --restow i3
    stow -v --restow i3blocks
fi

# restow compton config
if [ -x "$(command -v compton)" ]; then
    stow -v --restow compton
fi

# restow dunst config
if [ -x "$(command -v dunst)" ]; then
    stow -v --restow dunst
fi

# restow rofi config
if [ -x "$(command -v rofi)" ]; then
    stow -v --restow rofi
fi
