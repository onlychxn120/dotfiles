local map = vim.keymap.set

vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Normal --
map({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })
map("n", "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
map("n", "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })
map("n", "<C-Up>", "<cmd>resize +1<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -1<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -1<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +1<CR>", { desc = "Increase window width" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quit" })
map("n", "<leader>h", "<cmd>noh<CR>", { desc = "Clear search highlights" })
map("n", "<leader>d", function()
	vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
-- map("n", "<leader>rn", function()
-- 	return ":IncRename " .. vim.fn.expand("<cword>")
-- end, { expr = true, desc = "Rename under cursor" })
map({ "n", "v" }, "j", "gj", { desc = "Move down visual line" })
map({ "n", "v" }, "k", "gk", { desc = "Move up visual line" })
map("n", "Q", "<nop>")
map("n", "<leader>tc", function()
	local file = vim.fn.expand("%")
	vim.cmd("silent !markdown-toc -i " .. file)
	vim.cmd("edit!")
	print("Table of Contents updated")
end, { desc = "Generate/Update Markdown TOC" })

-- Insert --
map("i", "<C-l>", "<Right>", { desc = "Jump out of pair" })
map("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Visual --
map("v", "<A-j>", ":m .+1<CR>==", { desc = "Move text down" })
map("v", "<A-k>", ":m .-2<CR>==", { desc = "Move text up" })
map("v", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Visual Block --
map("x", "J", ":move '>+1<CR>gv=gv", { desc = "Move block down" })
map("x", "K", ":move '<-2<CR>gv=gv", { desc = "Move block up" })
map("x", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move block down" })
map("x", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move block up" })
map("x", "p", '"_dP', { desc = "Paste without overwriting register" })

-- Terminal --
map("t", "<C-h>", "<C-\\><C-N><C-w>h", { desc = "Go to left window" })
map("t", "<C-j>", "<C-\\><C-N><C-w>j", { desc = "Go to lower window" })
map("t", "<C-k>", "<C-\\><C-N><C-w>k", { desc = "Go to upper window" })
map("t", "<C-l>", "<C-\\><C-N><C-w>l", { desc = "Go to right window" })
map("t", "<C-t>", function()
	require("snacks").terminal()
end, { desc = "Toggle terminal" })
