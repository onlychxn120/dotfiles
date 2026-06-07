vim.g.mapleader = " "
vim.g.maplocalleader = ","

local options = {
	autowrite = true,
	backup = false, -- creates a backup file
	clipboard = vim.env.SSH_CONNECTION and "" or "unnamedplus", -- Allows neovim to access the system clipboard
	conceallevel = 2, -- Hide * markup for bold and italic, but not markers with subsitutions
	completeopt = { "menu", "menuone", "noselect" }, -- Mostly just for cmp
	cmdheight = 2, -- Space for command line
	cursorline = true, -- Highlight the current line
	expandtab = true, -- Convert tabs to spaces
	fillchars = {
		foldopen = "",
		foldclose = "",
		fold = " ",
		foldsep = " ",
		diff = "╱",
		eob = " ",
	},
	foldlevel = 99,
	foldmethod = "indent",
	foldtext = "",
	fileencoding = "utf-8", -- The encoding written to a file
	hlsearch = true, -- Highlight all matches on previous search pattern
	formatoptions = "jcroqlnt", -- tcqj
	grepformat = "%f:%l:%c:%m",
	grepprg = "rg --vimgrep",
	ignorecase = true, -- ignore case in search patterns
	incsearch = true, -- show search matches as you type
	mouse = "a", -- Allow the mouse to be used in neovim
	numberwidth = 4, -- Set number column width
	number = true, -- show line numbers
	pumblend = 10,
	pumheight = 10, -- popup menu height
	ro = false, -- not strictly necessary, but sets readonly to false
	relativenumber = true, -- relative line numbers
	showmode = false, -- we don't need to see things like -- insert -- anymore
	showcmd = true, -- show pending commands
	showtabline = 0, -- always show tabs
	scrolloff = 4, -- lines of context to keep above/below cursor
	sidescrolloff = 4, -- columns of context to keep left/right
	splitbelow = true, -- force all horizontal splits to go below current window
	splitright = true, -- force all vertical splits to go to the right of current window
	signcolumn = "yes", -- always show the sign column (prevents text shifting)
	shiftwidth = 4, -- the number of spaces inserted for each indentation
	swapfile = false, -- creates a swapfile
	smartindent = true, -- make indenting smarter again
	smartcase = true, -- override ignorecase if search contains capitals
	timeoutlen = 1000, -- time to wait for a mapped sequence to complete (in milliseconds)
	termguicolors = true, -- Enable 24-bit RGB colors
	tabstop = 4, -- insert 4 spaces for a tab
	undofile = true, -- enable persistent undo (undo after closing file)
	undolevels = 10000,
	updatetime = 200,
	winbar = "", -- disable winbar
	wrap = false, -- display long lines as just one line
	writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

vim.opt.shortmess:append({ W = true, I = true, c = true, C = true })

vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.lsp.log.set_level(vim.log.levels.ERROR)
vim.g.deprecated_warnings = false

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0

-- Detect chezmoi template files
vim.filetype.add({
	extension = {
		tmpl = "gotmpl",
	},
	pattern = {
		[".*/%.config/dotfiles/.*%.tmpl"] = "gotmpl",
	},
})
