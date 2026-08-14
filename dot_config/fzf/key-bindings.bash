# Custom fzf keybindings (applied after eval "$(fzf --bash)")

# Unbind Ctrl-T (file picker) and Ctrl-R (history)
bind -r '\C-t'
bind -r '\C-r'

# Bind Ctrl-F for file picker
bind -x '"\C-f": "fzf-file-widget"'

# Create wrapper for history search and bind to Ctrl-H
fzf-history-search() {
  local cmd
  cmd=$( (history -p ''; history) | fzf --reverse --height 40% --tac -n2..,..,.. +m)
  eval "$cmd"
}
bind -x '"\C-h": "fzf-history-search"'

