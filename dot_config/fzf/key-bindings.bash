# Custom fzf keybindings (applied after eval "$(fzf --bash)")

# Unbind Ctrl-T (file picker) and Ctrl-R (history)
bind -r '\C-t'
bind -r '\C-r'

# Bind Ctrl-F for file picker
bind -x '"\C-f": "fzf-file-widget"'

# Bind Ctrl-H for history search
bind -x '"\C-h": "fzf-history-widget"'

# Customize history search options
export FZF_CTRL_H_OPTS="--reverse --height 40%"

