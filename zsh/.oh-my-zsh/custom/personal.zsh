# Personal zsh settings. oh-my-zsh loads every *.zsh in its custom/ folder.

path+=(~/.local/scripts)   # tmux-sessionizer, tmux-cht.sh, ... (from bin/)

alias cd=z
alias cdi=zi

# yazi: `y` opens yazi and cds into the directory you quit in
y() {
  local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
  yazi "$@" --cwd-file="$tmp"
  cwd="$(<"$tmp")"
  [[ -n $cwd && $cwd != $PWD ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}

# Open a TODO file in nvim
todo() {
  local file=$(find ~/work/todo ~/personal/todo -type f 2>/dev/null | fzf)
  [[ -n $file ]] && nvim "$file"
}

bindkey -s '^f' 'tmux-sessionizer\n'   # Ctrl+F
bindkey -s '\ee' 'todo\n'              # Alt+E
