# Custom fzf keybindings (applied after eval "$(fzf --bash)")

# Unbind Ctrl-T (file picker) and Ctrl-R (history)
bind -r '\C-t'
bind -r '\C-r'

# Bind Ctrl-F for file picker
bind -x '"\C-f": "fzf-file-widget"'

# Bind Ctrl-H for history search
fzf-history-search() {
  local cmd
  cmd=$( (history -p ''; history) | fzf --reverse --height 40% --tac -n2..,..,.. +m)
  eval "$cmd"
}
bind -x '"\C-h": "fzf-history-search"'

# Bind Ctrl-G for change directory
fzf-cd-search() {
  local dir
  dir=$(find ${1:-.} -maxdepth 3 -type d 2>/dev/null | fzf --preview 'ls -la {}' --reverse)
  [ -n "$dir" ] && cd "$dir"
}
bind -x '"\C-g": "fzf-cd-search"'

