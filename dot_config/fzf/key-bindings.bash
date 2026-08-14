# Custom fzf keybindings

# Source system fzf keybindings first
[ -f /usr/share/doc/fzf/examples/key-bindings.bash ] && source /usr/share/doc/fzf/examples/key-bindings.bash

# Unbind Ctrl-T (file picker) and Ctrl-R (history)
bind -r '\C-t'
bind -r '\C-r'

# Bind Ctrl-F for file picker
bind -x '"\C-f": "fzf-file-widget"'

# Bind Ctrl-H for history search
bind -x '"\C-h": "fzf-history-widget"'

# Customize history search options
export FZF_CTRL_H_OPTS="--reverse --height 40%"

