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
stow --restow bash

COMMANDS=("git" "urxvt")
# restow function
for DIR in "${COMMANDS[@]}"; do
    if [ -x "$(command -v $1)" ]; then
        stow -v --restow $1
    fi
done

# restow git config
#if [ -x "$(command -v git)" ]; then
#    stow --restow git
#fi

# restow urxvt config
#if [ -x "$(command -v urxvt)" ]; then
#    stow --restow urxvt
#fi

# restow X-Windows configurations
if [ -x "$(command -v i3)" ]; then
    stow --restow Xresources
    stow --restow i3
fi

# restow compton config
if [ -x "$(command -v compton)" ]; then
    stow --restow compton
fi

# restow dunst config
if [ -x "$(command -v dunst)" ]; then
    stow --restow dunst
fi

# restow rofi config
if [ -x "$(command -v rofi)" ]; then
    stow --restow rofi
fi

# restow weechat config
if [ -x "$(command -v weechat)" ]; then
    stow --restow weechat
fi

# restow starship config
if [ -x "$(command -v starship)" ]; then
    stow --restow starship
fi
