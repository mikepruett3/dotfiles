#!/usr/bin/env bash

# Cancel upgrade if git is unavailable on the system
if ! [ -x "$(command -v git)" ]; then
    echo "Missing git!"
    exit 1
fi

# Check if $HOME/.dotfiles exists, then export $DOTFILES
if [ -d $HOME/.dotfiles ]; then
    export $DOTFILES = $HOME/.dotfiles
fi

# Check if $HOME/dotfiles exists, then export $DOTFILES
if [ -d $HOME/dotfiles ]; then
    export $DOTFILES = $HOME/dotfiles
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

# Function to Link files
function Link_Files () {
    # Check to see if the Link Exists already
if [ ! -h "$1" ]; then
    rm -f "$1"
    ln -s "$2" "$1"
fi
}

Link_Files "$DOTFILES/.Xresources" "$HOME/"

