if [[ ":$PATH:" != *":/var/lib/flatpak/exports/bin:"* ]]; then
    export PATH="/var/lib/flatpak/exports/bin:$HOME/.local/share/flatpak/exports/bin:$PATH"
fi
# export PYENV_ROOT="$HOME/.pyenv"
# if [[ ":$PATH:" != *":$PYENV_ROOT/bin:"* ]]; then
#     export PATH="$PYENV_ROOT/bin:$PATH"
#     eval "$(pyenv init --path)"
# fi

function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

export TASKING_TRICORE_PATH=/opt/TriCore/ctc/bin
eval "$(zoxide init zsh)"
