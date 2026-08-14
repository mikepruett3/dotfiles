# Custom mcfly keybindings (applied after eval "$(mcfly init bash)")

# Unbind Ctrl-R and rebind to Alt-R for mcfly history search
bind -r '\C-r'
bind -x '"\M-r": "mcfly-history-search"'
