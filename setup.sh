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

# Check if $HOME/.dotfiles or $HOME/dotfiles exists, then export $DOTFILES
if [[ $(grep -c "DOTFILES" ~/.bashrc) -eq 0 ]]; then
    DOTFILES_DIRS=(".dotfiles" "dotfiles")
    for DIR in "${DOTFILES_DIRS[@]}"; do
        if [ -d $HOME/$DIR/ ]; then
            export DOTFILES=$HOME/$DIR
        fi
    done
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
COMMANDS=("bash" "git" "starship" "i3" "urxvt" "compton" "dunst" "rofi" "weechat")
for COMMAND in "${COMMANDS[@]}"; do
    if [ -x "$(command -v $COMMAND)" ]; then
        #stow -v --restow $COMMAND
        stow --restow $COMMAND
    fi
done
