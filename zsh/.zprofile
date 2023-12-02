# tmux sessionizer shortcut
export PATH="$PATH:$HOME/.local/scripts"
bindkey -s ^f "tmux-sessionizer\n"
# Pyenv
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init --path)"
#eval "$(pyenv virtualenv-init -)"
