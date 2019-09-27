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

# Function to Link Files
#function Link_Files () {
#    # Check to see if the symlink exists already
#    if [ ! -h "$1" ]; then
#        rm -f "$1"
#        ln -s "$2" "$1"
#    fi
#}

# Function to Link Directories
#function Link_Dirs () {
#    # Check to see if the Symlink exists already
#    if [ -d "$1" ]; then
#        rm -rf "$1"
#    fi
#
#    # Check to see if the symlink exists already
#    if [ ! -h "$1" ]; then
#        rm -f "$1"
#        ln -s "$2" "$1"
#    fi
#}

# Create Symlinks for all my dotfiles!
#Link_Files "$HOME/.Xresources" "$DOTFILES/.Xresources"
#Link_Files "$HOME/.xinitrc" "$DOTFILES/.xinitrc"
#Link_Files "$HOME/.inputrc" "$DOTFILES/.inputrc"
#Link_Files "$HOME/.gitconfig" "$DOTFILES/.gitconfig"
#Link_Files "$HOME/.config/compton.conf" "$DOTFILES/compton.conf"
#Link_Dirs "$HOME/.config/i3" "$DOTFILES/i3"
#Link_Dirs "$HOME/.config/i3blocks" "$DOTFILES/i3blocks"
#Link_Dirs "$HOME/.weechat" "$DOTFILES/.weechat"
#Link_Dirs "$HOME/Icons" "$DOTFILES/Icons"
#Link_Dirs "$HOME/Wallpapers" "$DOTFILES/Wallpapers"
#Link_Dirs "$HOME/.config/dunst" "$DOTFILES/dunst"
#Link_Dirs "$HOME/.config/Xresources" "$DOTFILES/Xresources"
#Link_Dirs "$HOME/.config/urxvt" "$DOTFILES/urxvt"

# Use stow to create symlinks for the dotfiles
echo $DOTFILES
stow --restow --dir $DOTFILES i3