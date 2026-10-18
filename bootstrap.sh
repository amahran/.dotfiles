#!/usr/bin/env bash
# Set up a fresh Omarchy install.
#
#   ./bootstrap.sh              run every task in TASKS, in order
#   ./bootstrap.sh <task>...    run only these tasks, e.g. ./bootstrap.sh dotfiles
#
# Each task is a function below. To stop using one, comment it out in TASKS.
# To add one, write a function and list it. Every task is safe to re-run.

set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

TASKS=(
  # --- Install tools and apps ---
  base
  dev
  desktop
  virt

  # --- Configure ---
  ssh_keys          # first, so the repos below can be cloned over SSH
  zsh_setup         # before dotfiles, which links into ~/.oh-my-zsh/custom
  dotfiles
  default_apps
  laptop
  # dns             # encrypted DNS via systemd-resolved

  # --- Clone repos ---
  repos_personal

  # --- Work tools and configs ---
  work
)

# Work tools and configs. It's cloned to ~/work/setup and its bootstrap.sh is run.
WORK_REPO="git@github.com:amahran/work-b.git"

# ---------------------------------------------------------------- helpers

bold() { printf '\n\033[1m==> %s\033[0m\n' "$*"; }
die() { printf '\033[31m%s\033[0m\n' "$*" >&2; exit 1; }

# Install packages from the repos or the AUR (skips what's installed).
pkgs() { yay -S --needed --noconfirm "$@"; }

# clone <git url> <path under ~>
clone() {
  if [[ -d $HOME/$2/.git ]]; then
    echo "  exists  ~/$2"
  else
    git clone --recurse-submodules "$1" "$HOME/$2"
  fi
}

# ---------------------------------------------------------------- install

base() {
  bold "Base tools and fonts"
  pkgs stow age tree man-pages 7zip \
    otf-monaspace-nerdfonts

  # yazi and its support tools
  pkgs yazi chafa
}

dev() {
  bold "Development (Neovim toolchain, LSP prerequisites, debugger)"
  pkgs cmake ninja gdb srecord
}

desktop() {
  bold "Desktop apps"
  pkgs zathura zathura-pdf-mupdf zoom \
    v4l-utils # v4l-utils: for link2c-static-frame.sh (Insta360 Link 2C)

  # nordvpn
  pkgs nordvpn-bin
  sudo systemctl enable --now nordvpnd.service
  sudo usermod -aG nordvpn "$USER"

  # Smartcard readers (German eAT / Croatian eOI)
  pkgs pcsclite ccid
  sudo systemctl enable --now pcscd.socket
}

virt() {
  bold "Virtual machines"
  pkgs libvirt qemu-full virt-manager virt-viewer dnsmasq edk2-ovmf dmidecode
  sudo systemctl enable --now libvirtd.service
  sudo usermod -aG libvirt "$USER"
}

# ---------------------------------------------------------------- configure

ssh_keys() {
  bold "SSH keys"
  # secrets/ssh.tar.age holds .ssh/ (see README, Secrets). Existing files are kept.
  local f="$DOTFILES/secrets/ssh.tar.age"
  if [[ -f $f ]]; then
    install -d -m 700 "$HOME/.ssh"
    age -d "$f" | tar -C "$HOME" -x --skip-old-files
  else
    echo "  skipped: secrets/ssh.tar.age not found"
  fi

  # Push over SSH from now on (cloning stays on HTTPS).
  git -C "$DOTFILES" remote set-url --push origin git@github.com:amahran/.dotfiles.git
  git -C "$DOTFILES/nvim/.config/nvim" remote set-url --push origin git@github.com:amahran/nvim.git 2>/dev/null || true
}

dotfiles() {
  bold "Dotfiles"
  git -C "$DOTFILES" submodule update --init --recursive
  "$DOTFILES/stow.sh" # the list of stowed folders is in stow.sh

  # Omarchy's LazyVim plugins (seeded from /etc/skel); the nvim config above
  # uses vim.pack, so nothing reads them.
  rm -rf "$HOME/.local/share/nvim/lazy" "$HOME/.local/state/nvim/lazy"
}

zsh_setup() {
  bold "zsh + oh-my-zsh"
  pkgs zsh
  if [[ ! -f $HOME/.oh-my-zsh/oh-my-zsh.sh ]]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi
  sed -i 's/^plugins=(.*)/plugins=(git zsh-autosuggestions fzf zoxide)/' "$HOME/.zshrc"

  if [[ $(getent passwd "$USER" | cut -d: -f7) == /usr/bin/zsh ]]; then
    echo "  already zsh"
  else
    chsh -s /usr/bin/zsh
  fi
}

default_apps() {
  bold "Default apps"
  # Chrome
  pacman -Qq google-chrome &>/dev/null || omarchy-install-browser chrome
  omarchy-default-browser chrome
  # kitty as the terminal. After `dotfiles`, so the stowed kitty.conf is kept.
  omarchy-install-terminal kitty
}

laptop() {
  bold "Laptop hardware (Dell Precision 5490)"
  pkgs fwupd libcamera gst-plugin-libcamera pipewire-libcamera # IPU6 webcam, see README 4.9
}

dns() {
  bold "Encrypted DNS (systemd-resolved)"
  sudo install -Dm644 "$DOTFILES/system/resolved.conf.d/10-dns-over-tls.conf" \
    /etc/systemd/resolved.conf.d/10-dns-over-tls.conf
  sudo systemctl restart systemd-resolved
}

# ---------------------------------------------------------------- repos

repos_personal() {
  bold "Personal repos"
  mkdir -p "$HOME/personal"
  # clone git@github.com:amahran/<repo>.git personal/<repo>
}

# ---------------------------------------------------------------- work

work() {
  bold "Work setup"
  if [[ -z $WORK_REPO ]]; then
    echo "  skipped: WORK_REPO is not set in bootstrap.sh"
    return
  fi
  clone "$WORK_REPO" work/setup
  "$HOME/work/setup/bootstrap.sh"
}

# ----------------------------------------------------------------

((EUID != 0)) || die "Run as your normal user, not root."
command -v omarchy-pkg-add >/dev/null || die "Omarchy not found. Install Omarchy first and run this from its terminal."

(($#)) || set -- "${TASKS[@]}"
for task in "$@"; do
  declare -F "$task" >/dev/null || die "Unknown task: $task"
  "$task"
done

bold "Done: $*"
echo "Log out and back in so group changes and the new configs take effect."
