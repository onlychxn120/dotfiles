# dotfiles

Personal dotfiles for macOS and Arch Linux, managed with [chezmoi](https://www.chezmoi.io/).

## Setup

Use this repo as the chezmoi source directory (instead of the default `~/.local/share/chezmoi`):

```bash
chezmoi init --source ~/.config/dotfiles
```

## Basic chezmoi commands

```bash
chezmoi apply        # apply config to your home directory
chezmoi status       # show pending changes
chezmoi diff         # preview what will change
chezmoi re-add       # update source after manual edits in $HOME
```

## What is included

- Zsh config (`dot_zshrc`, `dot_zprofile`, `dot_zshenv`)
- Neovim config (`dot_config/nvim`)
- Git ignore defaults (`dot_gitignore_global`)
