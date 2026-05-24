# Neovim Configuration

A modern Neovim setup built with `lazy.nvim`, focused on fast startup, sensible defaults, and a clean coding workflow.

This config includes:
- LSP (via `nvim-lspconfig` + Mason-managed tools)
- Formatting on save (`conform.nvim`)
- UI, file explorer, and pickers (`snacks.nvim`)
- UI enhancements (`noice.nvim`)
- Completion (`nvim-cmp`)
- Notes and org-mode (`neorg`)
- Document writing support (`typst`)
- Tree-sitter highlighting and parsing (`tree-sitter-manager.nvim`)

---

## Requirements

### Core
- **Neovim 0.12 nightly or newer**
- `git` (2.19+ recommended)
- `curl`
- `tar`
- C compiler (`clang` or `gcc`) for parser builds

### Recommended
- [Nerd Font](https://www.nerdfonts.com/) for icons
- `tree-sitter-cli` (recommended for parser tooling)

### Optional language toolchains
Depending on what you code in:
- `npm` and `node` (for many JS/TS-based language servers)
- `python` and `pip` (for Python tooling)
- `cargo` (for Rust)

---

## Installation

```bash
# 1) Backup existing config (optional but recommended)
mv ~/.config/nvim ~/.config/nvim.bak

# 2) Clone this config
git clone git@github.com:onlychxn120/nvim.git ~/.config/nvim

# 3) Start Neovim
nvim
```

On first launch, `lazy.nvim` installs plugins automatically.

---

## First Run Checklist

Run these commands inside Neovim after installation:

```vim
:Lazy
:checkhealth
:Mason
:TSManager
```

What they do:
- `:Lazy` confirms plugin install state
- `:checkhealth` checks runtime and tooling issues
- `:Mason` opens Mason UI for language tooling
- `:TSManager` opens Tree-sitter Manager UI to handle parser installations

---

## Theme

This configuration uses the `Tokyonight` colorscheme (specifically the `night` style) as its default theme.

---

## LSP Setup (Mason)

This config is pre-wired for these servers and tools:

- `lua_ls` (Lua)
- `basedpyright` (Python)
- `ruff` (Python)
- `clangd` (C/C++)
- `tailwindcss` (Web)
- `rust_analyzer` (Rust)
- `tinymist` (Typst)

Install them with Mason:

```vim
:MasonInstall lua_ls basedpyright ruff clangd tailwindcss-language-server rust-analyzer tinymist
```

Check installed tools and active clients:

```vim
:Mason
:LspInfo
```

---

## Formatting

Formatting is handled by `conform.nvim` and runs on save.

Manual format:
- `<leader>mp`

Configured formatters include:
- Typst: `typstyle`
- Rust: `rustfmt` (with LSP fallback)
- C/C++: `clang-format`
- Go: `goimports`, `gofmt`
- Lua: `stylua`
- Python: `ruff_format`, `ruff_fix`
- JS/TS/CSS/HTML/JSON/YAML/Markdown/Astro: `prettierd`

---

## Useful Keymaps

Leader key: `Space`

**General**
- `<C-h/j/k/l>`: Move between windows
- `<leader>w`: Save file
- `<leader>q`: Quit
- `<leader>h`: Clear search highlight
- `<leader>d`: Toggle diagnostics
- `<leader>mp`: Format file
- `<leader>tc`: Generate/Update Markdown TOC

**Snacks & Pickers**
- `<leader>e`: File Explorer
- `<leader><space>`: Smart Find Files
- `<leader>ff`: Find Files
- `<leader>bf`: List Buffers
- `<leader>bg`: Grep Open Buffers
- `<leader>bd`: Delete Buffer
- `<leader>ns`: Notification History
- `<C-t>`: Toggle Terminal
- `<leader>gg`: Open Lazygit
- `<leader>z`: Toggle Zen Mode

**LSP**
- `K`: Hover documentation
- `gd`: Go to definition
- `gD`: Go to declaration
- `gi`: Go to implementation
- `go`: Go to type definition
- `gr`: References
- `gs`: Signature help
- `<F2>`: Rename
- `<F4>`: Code action

---

## Project Structure

```text
.
├── init.lua
├── lazy-lock.json
└── lua/conf/
    ├── init.lua
    ├── options.lua
    ├── keymap.lua
    ├── lazy_init.lua
    ├── statusline.lua
    ├── typewriter.lua
    └── plugins/
        ├── lsp.lua
        ├── conform.lua
        ├── tsmanager.lua
        ├── snacks.lua
        ├── neorg.lua
        ├── themes.lua
        └── ...
```

Main flow:
- `init.lua` loads `lua/conf/init.lua`
- `lua/conf/init.lua` loads options, keymaps, and lazy bootstrap
- `lua/conf/plugins/*.lua` contains plugin specs and configuration

---

## Troubleshooting

### LSP not attaching
- Run `:LspInfo`
- Run `:checkhealth vim.lsp`
- Ensure the server is installed in `:Mason`

### Tree-sitter parser errors
- Open `:TSManager` to install or update parsers.
- Confirm `curl`, `tar`, and a C compiler are available.

### Missing icons
- Install and enable a Nerd Font in your terminal.

### Plugin install issues
- Open `:Lazy` and check failed plugins.
- Re-run `:checkhealth` for missing dependencies.

---

## Notes

- Plugin versions are pinned in `lazy-lock.json`
- Plugin configs live in `lua/conf/plugins/`
- This config targets Neovim nightly-era APIs (`0.12+`)
