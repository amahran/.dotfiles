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

# Make ~/.local/{scripts,bin} available to the X session (i3, xss-lock, etc.).
# Must be exported before `exec startx` below, since that exec replaces this
# shell and .zshrc (which sources ~/.zsh_profile) is never reached.
if [[ ":$PATH:" != *":$HOME/.local/scripts:"* ]]; then
    export PATH="$PATH:$HOME/.local/scripts"
fi
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
    export PATH="$PATH:$HOME/.local/bin"
fi

if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then exec startx; fi
