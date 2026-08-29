# dotfiles

Personal dotfiles for **macOS** and **Arch Linux (Omarchy)**, managed with [chezmoi](https://www.chezmoi.io/).

Everything is built from templates that switch on the OS, so the same repo drives both platforms: Linux-only bits (Omarchy zsh functions, `omarchy` tab-completion) and macOS-only bits (Aerospace) are deployed only where they belong.

## Repository layout

| Path | Target | Notes |
|---|---|---|
| `dot_zshrc.tmpl` | `~/.zshrc` | Interactive zsh: plugins, completions, powerlevel10k |
| `dot_zprofile` | `~/.zprofile` | Login-shell hook |
| `dot_zshenv` | `~/.zshenv` | Sources `~/.local/share/zsh/envs.zsh` for every shell |
| `dot_local/share/zsh/envs.zsh.tmpl` | `~/.local/share/zsh/envs.zsh` | Env vars, editor, PATH, OS-specific setup |
| `dot_local/share/zsh/aliases.zsh.tmpl` | `~/.local/share/zsh/aliases.zsh` | Aliases (OS-aware) |
| `dot_local/share/zsh/init.zsh.tmpl` | `~/.local/share/zsh/init.zsh` | History options & general init |
| `dot_local/share/zsh/shell.zsh` | `~/.local/share/zsh/shell.zsh` | Keybindings, options |
| `dot_local/share/zsh/functions.zsh` | `~/.local/share/zsh/functions.zsh` | Linux only: sources `fns/*` |
| `dot_local/share/zsh/fns/*` | `~/.local/share/zsh/fns/*` | Linux only: helper commands (`tdl`, `hdl`, `rsw`, SSH/tmux helpers, …) |
| `dot_local/share/zsh/completions/_omarchy` | `~/.local/share/zsh/completions/_omarchy` | Linux only: `omarchy` tab-completion |
| `dot_local/share/zsh/env-bootstrap` | `~/.local/share/zsh/env-bootstrap` | Linux only: Omarchy PATH bootstrap |
| `dot_gitignore_global` | `~/.gitignore_global` | Global git ignores |
| `dot_config/git/config` | `~/.config/git/config` | Git aliases, diff settings, signing. **Contains personal identity — override after applying** (see below) |
| `dot_config/nvim/**` | `~/.config/nvim/**` | Neovim (lazy.nvim) config |
| `dot_config/tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | tmux config |
| `dot_config/yazi/yazi.toml` | `~/.config/yazi/yazi.toml` | yazi file manager |
| `dot_config/btop/btop.conf.tmpl` | `~/.config/btop/btop.conf` | btop monitor |
| `dot_config/ghostty/config.tmpl` | `~/.config/ghostty/config` | Ghostty terminal |
| `dot_aerospace.toml` | `~/.aerospace.toml` | **macOS only** (kept in the repo but ignored on Linux) |
| `.chezmoi.toml.tmpl` | `~/.config/chezmoi/chezmoi.toml` | Sources `~/.config/dotfiles`; defines `is_mac` / `is_linux` template data |

## Prerequisites

- **Linux (Omarchy/Arch):** `git`, `zsh`, `fzf`, and any tools you want aliases for (`eza`, `bat`, `yazi`, `tmux`, `btop`, `ghostty`). Omarchy is needed only if you want the `omarchy` completion/functions to do anything.
- **macOS:** [Homebrew](https://brew.sh/), `zsh`, `fzf`, `zsh-completions` (`brew install fzf zsh-completions`), and [Aerospace](https://github.com/nikitabobko/AeroSpace) if you use the tiling-WM config.
- [chezmoi](https://www.chezmoi.io/install/) on both.

## Installation

Install chezmoi first (pick one):

```bash
sh -c "$(curl -fsLS get.chezmoi.io)"   # official installer
# or: sudo pacman -S chezmoi            # Arch
# or: brew install chezmoi              # macOS
```

### 1. Clone to the expected path

The config template pins the source directory to `~/.config/dotfiles`, so clone **exactly there**:

```bash
git clone <this-repo-url> ~/.config/dotfiles
```

### 2. Initialize

```bash
chezmoi init --source "$HOME/.config/dotfiles"
```

This creates `~/.config/chezmoi/chezmoi.toml` (from `.chezmoi.toml.tmpl`) with the source directory and OS flags.

### 3. Review what will change

```bash
chezmoi diff          # full diff of every file that would change
chezmoi apply -n      # dry run: list actions without touching anything
```

Existing untracked files are not overwritten by default; pass `--force` if you're sure.

### 4. Apply

```bash
chezmoi apply
```

### 5. Make zsh your default shell

```bash
chsh -s "$(command -v zsh)"
```

Log out and back in (or open a new terminal) to confirm.

### 6. Install zsh plugins and powerlevel10k

The `.zshrc` sources plugins from `~/.local/share/zsh/` — they are **not** part of this repo, so clone them once:

```bash
mkdir -p "$HOME/.local/share/zsh/plugins"
git clone --depth 1 https://github.com/romkatv/zsh-defer          "$HOME/.local/share/zsh/plugins/zsh-defer"
git clone --depth 1 https://github.com/Aloxaf/fzf-tab             "$HOME/.local/share/zsh/plugins/fzf-tab"
git clone --depth 1 https://github.com/zsh-users/zsh-autosuggestions "$HOME/.local/share/zsh/plugins/zsh-autosuggestions"
git clone --depth 1 https://github.com/zdharma-continuum/fast-syntax-highlighting "$HOME/.local/share/zsh/plugins/fast-syntax-highlighting"
git clone --depth 1 https://github.com/romkatv/powerlevel10k      "$HOME/.local/share/zsh/powerlevel10k"
```

### 7. (Optional) Configure powerlevel10k

```bash
p10k configure
```

writes `~/.p10k.zsh`, which `.zshrc` sources automatically.

## After installing

**Fix git identity.** `~/.config/git/config` deploys with the author's identity (name, email, SSH signing key). Override with your own:

```bash
git config --global user.name  "Your Name"
git config --global user.email "you@example.com"
git config --global user.signingkey ~/.ssh/id_ed25519   # or remove the [commit]/[gpg] sections to disable signing
```

**Edit behaviors** live in `~/.local/share/zsh/aliases.zsh`, `shell.zsh`, and `fns/*` (Linux). To pull changes from this repo again, re-run `chezmoi apply`.

## Daily chezmoi workflow

```bash
chezmoi status              # what differs locally vs. the repo
chezmoi diff                # preview changes
chezmoi apply               # sync local files with the repo
chezmoi re-add              # capture manual edits in $HOME back into the repo
chezmoi edit ~/.zshrc       # edit a managed file (then apply)
chezmoi cd                  # jump into ~/.config/dotfiles
```

## Platform notes

- **Linux (Omarchy):** Omarchy-specific zsh functions, `env-bootstrap`, and the `omarchy` tab-completion are deployed; `~/.aerospace.toml` is never written.
- **macOS:** Aerospace config is deployed; Omarchy bits are skipped, Homebrew completions paths are added to `fpath`, and FZF keybindings come from `$(brew --prefix)/opt/fzf`.
- The `omarchy` completion is generated from the commands in `$PATH` (all `omarchy-*` binaries). If your Omarchy layout changes, the completion reflects it automatically on the next shell start.

## Troubleshooting

- **Completion not picking up:** start a fresh shell, or force a reindex with `rm ~/.zcompdump*`.
- **Old values after editing configs:** `exec zsh` or open a new terminal; `~/.p10k.zsh` is only sourced if present.
- **`chezmoi apply` refuses to overwrite:** your files pre-date chezmoi. Back them up first, then use `chezmoi apply --force`.

## See also

- [Neovim config README](.config/nvim/README.md)
- [chezmoi documentation](https://www.chezmoi.io/ref/)