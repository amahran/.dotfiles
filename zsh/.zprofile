if [[ ":$PATH:" != *":/var/lib/flatpak/exports/bin:"* ]]; then
    export PATH="/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin:$PATH"
fi
export PYENV_ROOT="$HOME/.pyenv"
if [[ ":$PATH:" != *":$PYENV_ROOT/bin:"* ]]; then
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
fi

