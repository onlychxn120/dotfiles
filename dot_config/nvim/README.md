# Neovim Configuration

Personal Neovim config built with `lazy.nvim`, centered on a lightweight UI, LSP workflow, and writing support (Markdown/Neorg/Typst).

## Highlights

- Plugin management with `lazy.nvim`
- LSP via `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig.nvim`
- Completion via `blink.cmp` + `LuaSnip` + `lazydev.nvim`
- Formatting with `conform.nvim` (format on save)
- Linting with `nvim-lint` (Markdown via `markdownlint`)
- File explorer, picker, terminal, notifications, and lazygit integration via `snacks.nvim`
- Extra UX: `noice.nvim`, custom global statusline, `gitsigns.nvim`, `nvim-navic`
- Writing stack: `neorg`, `render-markdown.nvim`, `autolist.nvim`, Typst preview
- Tree-sitter parsing via `tree-sitter-manager.nvim`

---

## Requirements

### Core
- Neovim nightly/newer APIs (config currently uses features around `0.12+`)
- `git`
- `curl` and `tar`
- C compiler (`clang` or `gcc`) for native/parser builds
- `ripgrep` (`rg`) for grep integrations (`grepprg = "rg --vimgrep"`)

### Recommended
- [Nerd Font](https://www.nerdfonts.com/) for icons
- `tree-sitter-cli`
- `lazygit` (enables `<leader>gg`)
- `markdown-toc` CLI (used by `<leader>tc`)

### Optional tooling (per language/workflow)
- LSP servers via Mason (example set below)
- Formatters: `stylua`, `clang-format`, `goimports`, `gofmt`, `prettierd`, `typstyle`, `ruff`
- Typst: `tinymist`
- Live server plugin global install uses `pnpm install -g live-server`

---

## Installation

```bash
# optional backup
mv ~/.config/nvim ~/.config/nvim.bak

# clone
git clone git@github.com:onlychxn120/nvim.git ~/.config/nvim

# launch
nvim
```

On first launch, `lazy.nvim` installs plugins automatically.

---

## First Run

Run these inside Neovim:

```vim
:Lazy
:checkhealth
:Mason
:TSManager
```

Useful optional setup:

```vim
:MasonInstall lua_ls basedpyright ruff clangd tailwindcss-language-server rust-analyzer tinymist
```

Notes:
- Mason auto-installs no servers by default (`ensure_installed = {}`), so install what you need.
- Tree-sitter Manager is configured with a broad parser list but `auto_install = false`.

---

## Theme

Default colorscheme is `tokyonight` (`night` style) with transparent background.

---

## LSP

Configured LSP handlers include:

- `lua_ls`
- `basedpyright`
- `ruff`
- `clangd`
- `tailwindcss`
- `rust_analyzer`
- `tinymist`

LSP keymaps (on attach):

- `K`: Hover
- `<leader>k`: Diagnostics float
- `gd`, `gD`, `gi`, `go`, `gr`, `gs`
- `<F2>`: Rename
- `<F4>`: Code Action
- `<leader>lr`: Restart LSP

---

## Formatting and Linting

Formatting is managed by `conform.nvim` with format-on-save enabled.

Manual format:
- `<leader>mp`

Configured formatters:
- Typst: `typstyle`
- Rust: `rustfmt` (LSP fallback)
- C/C++: `clang-format`
- Go: `goimports`, `gofmt`
- Lua: `stylua`
- Python: `ruff_format`, `ruff_fix`
- JS/TS/CSS/HTML/JSON/YAML/Markdown/Astro: `prettierd`

Linting:
- Markdown via `markdownlint` (`MD013` disabled)

---

## Keymaps (Common)

Leader key: `Space`

General:
- `<C-h/j/k/l>`: Move between windows
- `<C-s>`: Save
- `<leader>q`: Quit
- `<leader>h`: Clear search highlights
- `<leader>d`: Toggle diagnostics
- `<leader>tc`: Update Markdown TOC
- `<C-t>`: Toggle Snacks terminal
- `jj` (insert): Exit insert mode

Buffers:
- `<S-h>/<S-l>`: Prev/next buffer
- `<leader>bd`: Delete buffer
- `<leader>bo`: Delete other buffers
- `<leader>bi`: Delete invisible buffers
- `<leader>bD`: Delete buffer and window

Pickers / explorer:
- `<leader>e`: Explorer (Snacks)
- `<leader>ff`: Find files (`fzf-lua`)
- `<leader>fg`: Live grep project (`fzf-lua`)
- `<leader>bf`: Buffers (`fzf-lua`)
- `<leader>bg`: Grep open buffers (`fzf-lua` lines)
- `<leader>ns`: Notification history

Git / tools:
- `<leader>gg`: Lazygit (if installed)
- `<leader>l`: Open Lazy
- `<leader>fn`: New file

Notes / Typst / Live server:
- `<leader>nn`: Neorg files
- `<leader>ng`: Neorg grep
- `<leader>nt`: Neorg actionable tasks
- `<leader>tp`: Toggle Typst preview
- `<leader>ls` / `<leader>lx`: Start/stop live server

---

## Project Structure

```text
.
|- init.lua
`- lua/conf/
   |- init.lua
   |- options.lua
   |- keymap.lua
   |- autocmds.lua
   |- lazy_init.lua
   |- statusline/
   |  |- init.lua
   |  `- components.lua
   `- plugins/
      |- lsp.lua
      |- conform.lua
      |- nvimlint.lua
      |- snacks.lua
      |- noice.lua
      |- tsmanager.lua
      |- neorg.lua
      |- typst.lua
      |- fzflua.lua
      |- gitsigns.lua
      |- navic.lua
      |- themes.lua
      `- ...
```

Load flow:
- `init.lua` -> `lua/conf/init.lua`
- `lua/conf/init.lua` loads autocmds, options, keymaps, lazy bootstrap, and statusline
- `lua/conf/plugins/*.lua` contains plugin specs/config

---

## Troubleshooting

LSP issues:
- `:LspInfo`
- `:checkhealth vim.lsp`
- Confirm server install in `:Mason`

Parser issues:
- Open `:TSManager` and install/update parsers
- Verify `curl`, `tar`, compiler availability

Missing icons:
- Use a Nerd Font in terminal

Plugin problems:
- Check `:Lazy`
- Re-run `:checkhealth`

---

## Notes

- Main config lives in `lua/conf/`
- Some plugin defaults (especially Snacks) provide additional mappings/behavior beyond explicit keymaps listed here
