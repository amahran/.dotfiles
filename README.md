# dotfiles (Omarchy)

My configs and setup scripts for an [Omarchy](https://omarchy.org) machine.
This replaces the old Ansible playbook: Omarchy now provides the base system
(Hyprland, bar, terminal, Docker, firewall, fonts, ...), and this repo only
adds what's personal on top.

| Path | What it is |
|---|---|
| `bootstrap.sh` | One-command setup: a list of tasks (install, configure, clone repos) |
| `encrypt.sh` | Re-encrypts `secrets/` from the live files after you change or rotate keys |
| `stow.sh` | Links the configs into `~` with GNU Stow, backing up whatever is in the way |
| `zsh/ git/ tmux/ kitty/ zathura/ mbake/ bin/ nvim/` | Stow packages for portable configs |
| `hypr/` | Hyprland overrides (`bindings/monitors/input/looknfeel/autostart.lua`) |
| `omarchy/` | Omarchy hook that reports config changes after `omarchy update` |
| `claude-desktop/` | Launch flags for Claude Desktop: points it at GNOME Keyring, which Electron can't detect under Hyprland |

`vim/` (a plain vim config) is kept for machines without nvim but is **not**
stowed. The old i3/X-era configs are in git history.

---

## 1. Before you start

- Omarchy is installed and you went through the first-boot wizard.
- Windows still boots: pick it once from the Limine menu. If it's missing, run
  `sudo limine-scan` and follow the prompts.
- Wi-Fi is connected.
- You know the passphrases for the files in `secrets/` (see *Secrets* below).

Secure Boot stays **off** — Omarchy requires that.

## 2. Get this repo

Open a terminal (`Super + Return`) and run:

```bash
git clone --recurse-submodules -b omarchy https://github.com/amahran/.dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

HTTPS is used on purpose: the SSH keys don't exist yet. The `ssh_keys`
task switches the push URL to SSH later.

## 3. Run the bootstrap

```bash
./bootstrap.sh
```

It asks for your sudo password and the `secrets/` passphrases, then runs every task
in the `TASKS` list at the top of `bootstrap.sh`, in order:

- **Install tools and apps** — `tools_base`, `tools_dev`, `tools_desktop`,
  `tools_virt`, `tools_nordvpn`, `tools_smartcard` (these three also enable
  their services and groups).
- **Configure** — `ssh_keys` (decrypts `secrets/ssh.tar.age` into
  `~/.ssh`), `oh_my_zsh` (see 4.9), `dotfiles` (nvim submodule + `stow.sh`, which
  moves Omarchy's versions of the same files to `~/.dotfiles-backup/<timestamp>/`;
  preview with `./stow.sh --check`), `omarchy` (everything done through
  Omarchy's own commands: Chrome, kitty, VS Code, sudoless Docker). Existing
  SSH files are never overwritten.
- **Clone repos** — `repos_personal`.
- **Work** — `work` clones the private repo set in `WORK_REPO` to
  `~/work/setup` and runs its own `bootstrap.sh`. Everything for the current
  job (tools, secrets, VPN, services, configs, repos) lives there, not in this
  public repo. It can add shell config as `~/.oh-my-zsh/custom/*.zsh` (oh-my-zsh
  loads those automatically) and the git
  identity as `~/.gitconfig-work` (used for repos under `~/work/`).

Run single tasks by name, e.g. `./bootstrap.sh dotfiles` or
`./bootstrap.sh work`.

To change what runs, edit `TASKS`: comment out a task to skip it, or write a
new function and add it. When you change jobs, point `WORK_REPO` at the new
job's private repo (or leave it empty).

Then **log out and back in** (`Super + Escape` → Log out) so the new groups,
the zsh login shell and the Hyprland bindings are all picked up.

## 4. Manual steps after the bootstrap

### 4.1 Check the basics
```bash
ssh -T git@github.com          # GitHub accepts your key
git -C ~/.dotfiles remote -v   # push URL is git@github.com:...
ls -l ~/.oh-my-zsh/custom/personal.zsh ~/.config/nvim ~/.config/hypr/bindings.lua   # all symlinks into ~/.dotfiles
```

### 4.2 Neovim
Start `nvim` once. `vim.pack` installs the plugins, then Mason installs the
LSP servers and formatters (clangd, pyright, lua_ls, neocmake, dockerls,
black, shfmt, cmakelang, mbake). Wait until Mason is done, restart nvim, and
run `:checkhealth`.

### 4.3 tmux
Start `tmux`. TPM clones itself on first start; press `Ctrl+a` then `I` to
install the plugins. Your prefix is still `Ctrl+a` (Omarchy's default config
used `Ctrl+Space`; yours replaced it).

### 4.4 Hyprland
Omarchy's `Super` bindings stay (`Super + F1` lists them).
`hypr/.config/hypr/bindings.lua` adds the i3 habits on top:

- `Super + h/j/k/l` focus and `Super + Shift + h/j/k/l` swap windows; the
  arrow keys keep working.
- `Super + Backspace` opens a terminal, `Super + D` the app launcher,
  `Alt + Shift + C` resets the Insta360 Link 2C to a static frame.

Omarchy keys these replace moved to:

| Omarchy action | Was | Now |
|---|---|---|
| Toggle window split | `Super + J` | `Super + Alt + J` |
| Keybindings | `Super + K` | `Super + F1` |
| Toggle workspace layout | `Super + L` | `Super + Alt + L` |
| Toggle window transparency | `Super + Backspace` | `Super + Alt + Backspace` |

Lock stays on Omarchy's `Super + Ctrl + L`. `autostart.lua` opens Chrome on
workspace 1, kitty on 3 and the Claude web app on 4 at login.

**Monitors:** dock the laptop, run `hyprctl monitors`, and check that the
external screen is named `DP-4`, `DP-5` or `DP-6` as in
`hypr/.config/hypr/monitors.lua`. Adjust the name or scale there if not.
Changes apply on save.

### 4.5 Chrome
Open Chrome and sign in.

Don't set a DNS provider under Omarchy's *Setup → Network → DNS* if you use
a VPN with its own DNS: that writes a global override that also replaces the
VPN's DNS servers.

### 4.6 NordVPN
```bash
nordvpn login
```

### 4.7 Smartcard readers
`pcscd` is enabled. Plug in the reader and check it with `pcsc_scan`
(package `pcsc-tools`). Install AusweisApp if you need the German eID.

### 4.8 Optional
- **Docker without sudo:** Omarchy deliberately keeps you out of the `docker`
  group (it's equivalent to root). The `omarchy` task opts in anyway
  (*Setup → Security → Sudoless Docker*); it needs a reboot. Undo it with
  `omarchy-remove-security-sudoless-docker`.
- **VS Code:** installed by the `omarchy` task through `omarchy-install-editor-vscode`
  (Omarchy theme, libsecret keyring, self-update off).
- **SSH server:** off by default. *Setup → Security → SSHD* turns it on, opens
  the firewall, and disables password logins once a key is authorized.
- **Firmware:** *Update → Firmware* in the Omarchy menu.

### 4.9 zsh
The `oh_my_zsh` task runs the oh-my-zsh installer, which writes its default
`~/.zshrc` (not tracked here), then sets the plugins line to
`plugins=(git zsh-autosuggestions fzf zoxide)` and makes zsh your shell.
Your own aliases, functions and key bindings are in
`zsh/.oh-my-zsh/custom/personal.zsh`, which oh-my-zsh loads automatically.
Update oh-my-zsh with `omz update`.

## 5. Living with it

- **Updates:** always `omarchy update` (or the update icon in the bar), never
  `pacman -Syu` / `yay -Syu`.
- **After an update:** the hook in `omarchy/` prints and notifies if the update
  changed a managed config. Omarchy writes *through* the stow symlinks, so
  the change shows up in this repo: review it with `git -C ~/.dotfiles diff`
  and keep it or `git checkout` it.
- **Don't run** `omarchy refresh <x>`, *Update → Config* or
  `omarchy reinstall configs` for configs you manage here. They overwrite
  them (with a `.bak` copy).
- **Add a package:** add it to the right `tools_*` function in `bootstrap.sh`
  and run that task, e.g. `./bootstrap.sh tools_dev`.
- **Add a config:** put it in a stow package folder (mirroring its path under
  `~`), add the package to `DEFAULT_PACKAGES` in `stow.sh` if it's new, run
  `./bootstrap.sh dotfiles`.
- **Never edit** `/usr/share/omarchy`. It belongs to the Omarchy package and is
  replaced on update.

## Secrets

Your SSH keys are kept in `secrets/`, encrypted with
[age](https://age-encryption.org) using a passphrase. The repo is public, so
use a long, random passphrase. `.gitignore` only lets `*.age` files in
`secrets/` be committed.

Create or update the archive (e.g. after rotating a key) with:

```bash
./encrypt.sh
```

It packs the files listed in `SSH_FILES` at the top of `encrypt.sh`
(`~/.ssh/config`, `github`, `github.pub`) into `secrets/ssh.tar.age`. Commit
the new file afterwards.

`./bootstrap.sh ssh_keys` decrypts it again (asking for the passphrase); if
the file is missing, the task is skipped. Work secrets belong in the private
work repo.

The old ansible-vault copies are still public, in github.com/amahran/ansible
and in this repo's history (`git/.gitconfig-work`), so rotate those SSH keys.
