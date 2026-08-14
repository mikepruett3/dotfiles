# Custom mcfly keybindings (applied after eval "$(mcfly init bash)")

# Unbind Ctrl-R
bind -r '\C-r'

# Create wrapper for mcfly history search and bind to Ctrl-K
mcfly-search() {
  mcfly search
}
bind -x '"\C-k": "mcfly-search"'
