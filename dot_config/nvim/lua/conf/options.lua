local options = {
	-- 🎨 UI & Display
	termguicolors = true, -- Enable 24-bit RGB colors
	guifont = "Terminess Nerd Font:h12",
	cmdheight = 2, -- Space for command line
	conceallevel = 0, -- Show `` in markdown files
	pumheight = 10, -- Popup menu height
	showmode = false, -- We don't need to see things like -- INSERT -- anymore
	showcmd = true, -- Show pending commands
	showtabline = 0, -- Always show tabs
	winbar = "", -- Disable winbar
	signcolumn = "yes", -- Always show the sign column (prevents text shifting)
	cursorline = true, -- Highlight the current line
	wrap = false, -- Display long lines as just one line

	-- 🔢 Numbers & Scrolling
	number = true, -- Show line numbers
	relativenumber = true, -- Relative line numbers
	numberwidth = 4, -- Set number column width
	scrolloff = 4, -- Lines of context to keep above/below cursor
	sidescrolloff = 4, -- Columns of context to keep left/right

	-- 🔍 Search
	hlsearch = true, -- Highlight all matches on previous search pattern
	incsearch = true, -- Show search matches as you type
	ignorecase = true, -- Ignore case in search patterns
	smartcase = true, -- Override ignorecase if search contains capitals

	-- 📏 Indentation & Tabs
	expandtab = true, -- Convert tabs to spaces
	shiftwidth = 4, -- The number of spaces inserted for each indentation
	tabstop = 4, -- Insert 4 spaces for a tab
	smartindent = true, -- Make indenting smarter again

	-- 💾 Backups & Files
	backup = false, -- Creates a backup file
	writebackup = false, -- If a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
	swapfile = false, -- Creates a swapfile
	undofile = true, -- Enable persistent undo (undo after closing file)
	fileencoding = "utf-8", -- The encoding written to a file
	ro = false, -- Not strictly necessary, but sets readonly to false

	-- ⚙️ General Behavior
	clipboard = "unnamedplus", -- Allows neovim to access the system clipboard
	completeopt = { "menuone", "noselect" }, -- Mostly just for cmp
	mouse = "a", -- Allow the mouse to be used in neovim
	splitbelow = true, -- Force all horizontal splits to go below current window
	splitright = true, -- Force all vertical splits to go to the right of current window
	timeoutlen = 1000, -- Time to wait for a mapped sequence to complete (in milliseconds)
	updatetime = 300,
}

for k, v in pairs(options) do
	vim.opt[k] = v
end

-- Create an autocommand group for file-specific settings
vim.api.nvim_create_augroup("FileTypeSpecific", { clear = true })

-- Set shiftwidth and tabstop to 2 for HTML, CSS, JavaScript, and Lua files
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "html", "css", "javascript", "lua", "json" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
	end,
	group = "FileTypeSpecific",
})

vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

vim.opt.shortmess:append("c")

vim.api.nvim_create_autocmd("TextYankPost", {
	pattern = "*",
	callback = function()
		vim.hl.on_yank({ higroup = "IncSearch", timeout = 250 })
	end,
	group = vim.api.nvim_create_augroup("highlight_yank", {}),
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"typst",
		"tex",
		"html",
		"markdown",
		"text",
		"gitcommit",
		"rst",
		"asciidoc",
	},
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
	end,
	group = "FileTypeSpecific",
})

vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("save_notification", { clear = true }),
	pattern = "*",
	callback = function()
		vim.notify("File saved!", vim.log.levels.INFO, { title = "Neovim" })
	end,
})

vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.lsp.log.set_level(vim.log.levels.ERROR)
