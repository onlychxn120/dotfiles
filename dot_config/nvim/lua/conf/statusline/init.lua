-- lua/custom_statusline/init.lua
local C = require("conf.statusline.components")

-- Initialize highlight groups
vim.api.nvim_create_autocmd("ColorScheme", { callback = C.setup_highlights })
C.setup_highlights()

local sep = " · "

-- Status line string builder
_G.ActiveStatusLine = function()
	local left = {}
	local right = {}

	-- === LEFT SIDE ===
	table.insert(left, C.get_mode())

	local git = C.get_git()
	if git ~= "" then
		table.insert(left, git)
	end

	local diag = C.get_diagnostics()
	if diag ~= "" then
		table.insert(left, diag)
	end

	table.insert(left, "%<" .. C.get_filename())

	local crumbs = C.get_breadcrumbs()
	if crumbs ~= "" then
		table.insert(left, " " .. crumbs)
	end

	-- === RIGHT SIDE ===
	local macro = C.get_macro_recording()
	if macro ~= "" then
		table.insert(right, macro)
	end

	local lazy = C.get_lazy_updates()
	if lazy ~= "" then
		table.insert(right, lazy)
	end

	local wordcount = C.get_wordcount()
	if wordcount ~= "" then
		table.insert(right, wordcount)
	end

	local size = C.get_filesize()
	if size ~= "" then
		table.insert(right, size)
	end

	local enc = C.get_encoding()
	if enc ~= "" then
		table.insert(right, enc)
	end

	local ft = C.get_filetype()
	if ft ~= "" then
		table.insert(right, ft)
	end

	local lsp = C.get_lsp()
	if lsp ~= "" then
		table.insert(right, lsp)
	end

	table.insert(right, "%p%%")
	table.insert(right, "%l:%c")

	-- === ASSEMBLY ===
	local left_str = table.concat(left, sep)
	local right_str = table.concat(right, sep)

	return string.format(" %s %%= %s ", left_str, right_str)
end

-- Set options
vim.opt.laststatus = 3
vim.opt.statusline = "%!v:lua.ActiveStatusLine()"

vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
	callback = function()
		vim.cmd("redrawstatus")
	end,
})
