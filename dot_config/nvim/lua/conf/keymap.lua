local map = vim.keymap.set

map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "<Down>", "v:count == 0 ? 'gj' : 'j'", { desc = "Down", expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })
map({ "n", "x" }, "<Up>", "v:count == 0 ? 'gk' : 'k'", { desc = "Up", expr = true, silent = true })

-- Move to window using <ctrl> hjkl keys
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Scroll up and down
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })

-- buffers
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", function()
	Snacks.bufdelete()
end, { desc = "Delete Buffer" })
map("n", "<leader>bo", function()
	Snacks.bufdelete.other()
end, { desc = "Delete Other Buffers" })
map("n", "<leader>bi", function()
	Snacks.bufdelete.invisible()
end, { desc = "Delete Invisible Buffers" })
map("n", "<leader>bD", "<cmd>:bd<cr>", { desc = "Delete Buffer and Window" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward].'zv'", { expr = true, desc = "Next Search Result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next Search Result" })
map("n", "N", "'nN'[v:searchforward].'zv'", { expr = true, desc = "Prev Search Result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev Search Result" })

-- save
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })

-- quit
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })

-- clear hl
map("n", "<leader>h", "<cmd>noh<CR>", { desc = "Clear search highlights" })

-- toggle diagnostics
map("n", "<leader>d", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })

map({ "n", "v" }, "j", "gj", { desc = "Move down visual line" })
map({ "n", "v" }, "k", "gk", { desc = "Move up visual line" })

map("n", "Q", "<nop>")

-- generate TOC md
map("n", "<leader>tc", function()
	local file = vim.fn.expand("%")
	vim.cmd("silent !markdown-toc -i " .. file)
	vim.cmd("edit!")
	print("Table of Contents updated")
end, { desc = "Generate/Update Markdown TOC" })

-- lazygit
if vim.fn.executable("lazygit") == 1 then
	map("n", "<leader>gg", function()
		Snacks.lazygit()
	end, { desc = "Lazygit (cwd)" })
end

map("i", "<C-j>", "<ESC>", { desc = "Exit insert mode" })

map("v", "<A-j>", ":m .+1<CR>==", { desc = "Move text down" })
map("v", "<A-k>", ":m .-2<CR>==", { desc = "Move text up" })
map("v", "p", '"_dP', { desc = "Paste without overwriting register" })

map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move block down" })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move block up" })
map("x", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move block down" })
map("x", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move block up" })
map("x", "p", '"_dP', { desc = "Paste without overwriting register" })

-- commenting
map("n", "gco", "o<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Below" })
map("n", "gcO", "O<esc>Vcx<esc><cmd>normal gcc<cr>fxa<bs>", { desc = "Add Comment Above" })

-- lazy
map("n", "<leader>ll", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- better indenting
map("x", "<", "<gv")
map("x", ">", ">gv")

-- goto window in terminal mode
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })

-- toggle terminal
map({ "n", "t" }, "<C-t>", function()
	Snacks.terminal()
end, { desc = "Terminal (cwd)" })
