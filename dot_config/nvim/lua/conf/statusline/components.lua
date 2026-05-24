local M = {}
local has_devicons, devicons = pcall(require, "nvim-web-devicons")

-- HIGHLIGHTS & CACHES
M.setup_highlights = function()
	local get_hl = function(name)
		return vim.api.nvim_get_hl(0, { name = name })
	end
	local normal = get_hl("Normal")
	local bg = normal.bg or 0x1e1e2e

	vim.api.nvim_set_hl(0, "StlNormal", { fg = bg, bg = get_hl("Function").fg, bold = true })
	vim.api.nvim_set_hl(0, "StlInsert", { fg = bg, bg = get_hl("String").fg, bold = true })
	vim.api.nvim_set_hl(0, "StlVisual", { fg = bg, bg = get_hl("Keyword").fg, bold = true })
	vim.api.nvim_set_hl(0, "StlCommand", { fg = bg, bg = get_hl("WarningMsg").fg, bold = true })
	vim.api.nvim_set_hl(0, "StlReplace", { fg = bg, bg = get_hl("ErrorMsg").fg, bold = true })
	vim.api.nvim_set_hl(0, "StlGitAdd", { fg = get_hl("GitSignsAdd").fg or 0x98c379, bg = bg })
	vim.api.nvim_set_hl(0, "StlGitChange", { fg = get_hl("GitSignsChange").fg or 0xe5c07b, bg = bg })
	vim.api.nvim_set_hl(0, "StlGitDelete", { fg = get_hl("GitSignsDelete").fg or 0xe06c75, bg = bg })
end

local icon_cache = {}
local lsp_cache = {}

vim.api.nvim_create_autocmd({ "BufDelete", "BufFilePost" }, {
	callback = function(args)
		icon_cache[args.buf] = nil
	end,
})

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	callback = function(args)
		local clients = vim.lsp.get_clients({ bufnr = args.buf })
		if #clients > 0 then
			lsp_cache[args.buf] = " " .. clients[1].name
		else
			lsp_cache[args.buf] = nil
		end
	end,
})

vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		lsp_cache[args.buf] = nil
	end,
})

local has_lazy, lazy_status = pcall(require, "lazy.status")

local size_cache = {}
local wordcount_cache = {}

local cache_group = vim.api.nvim_create_augroup("StatuslineCache", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost" }, {
	group = cache_group,
	callback = function(args)
		local file = vim.api.nvim_buf_get_name(args.buf)
		if file == "" then
			return
		end
		local size = vim.fn.getfsize(file)
		if size > 0 then
			local suffixes = { "B", "KB", "MB", "GB" }
			local i = 1
			while size > 1024 do
				size = size / 1024
				i = i + 1
			end
			size_cache[args.buf] = string.format("%.1f%s", size, suffixes[i])
		else
			size_cache[args.buf] = nil
		end
	end,
})

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI", "BufEnter", "BufWritePost" }, {
	group = cache_group,
	callback = function(args)
		local ft = vim.bo[args.buf].filetype
		if ft == "markdown" or ft == "typst" or ft == "norg" or "tex" then
			wordcount_cache[args.buf] = string.format(" %d words", vim.fn.wordcount().words)
		else
			wordcount_cache[args.buf] = nil
		end
	end,
})

vim.api.nvim_create_autocmd("BufDelete", {
	group = cache_group,
	callback = function(args)
		size_cache[args.buf] = nil
		wordcount_cache[args.buf] = nil
	end,
})

-- Components

local modes = {
	n = { "NORMAL", "%#StlNormal#" },
	i = { "INSERT", "%#StlInsert#" },
	v = { "VISUAL", "%#StlVisual#" },
	V = { "V-LINE", "%#StlVisual#" },
	["\22"] = { "V-BLOCK", "%#StlVisual#" },
	c = { "COMMAND", "%#StlCommand#" },
	R = { "REPLACE", "%#StlReplace#" },
	t = { "TERMINAL", "%#StlCommand#" },
}

M.get_mode = function()
	local mode = vim.api.nvim_get_mode().mode
	local current = modes[mode] or { mode, "%#StlNormal#" }
	return string.format("%s %s %%#StatusLine#", current[2], current[1])
end

M.get_git = function()
	local dict = vim.b.gitsigns_status_dict
	if not dict then
		return ""
	end
	local branch = dict.head and (" " .. dict.head) or ""
	local diffs = {}
	if dict.added and dict.added > 0 then
		table.insert(diffs, "%#StlGitAdd#+" .. dict.added .. "%#StatusLine#")
	end
	if dict.changed and dict.changed > 0 then
		table.insert(diffs, "%#StlGitChange#~" .. dict.changed .. "%#StatusLine#")
	end
	if dict.removed and dict.removed > 0 then
		table.insert(diffs, "%#StlGitDelete#-" .. dict.removed .. "%#StatusLine#")
	end

	local diff_str = table.concat(diffs, " ")

	if branch == "" then
		return diff_str
	end
	if diff_str == "" then
		return branch
	end
	return branch .. sep .. diff_str
end

M.get_diagnostics = function()
	local counts = vim.diagnostic.count(0)
	if not counts or vim.tbl_isempty(counts) then
		return ""
	end

	local errors = counts[vim.diagnostic.severity.ERROR] or 0
	local warns = counts[vim.diagnostic.severity.WARN] or 0
	local info = counts[vim.diagnostic.severity.INFO] or 0
	local parts = {}
	if errors > 0 then
		table.insert(parts, "%#DiagnosticError# " .. errors .. "%#StatusLine#")
	end
	if warns > 0 then
		table.insert(parts, "%#DiagnosticWarn# " .. warns .. "%#StatusLine#")
	end
	if info > 0 then
		table.insert(parts, "%#DiagnosticInfo# " .. info .. "%#StatusLine#")
	end

	return table.concat(parts, " ")
end

M.get_filename = function()
	local path = vim.fn.expand("%:~:.")
	if path == "" then
		return "[No Name]"
	end

	local modified = vim.bo.modified and " %#WarningMsg#%#StatusLine#" or ""
	local readonly = vim.bo.readonly and " " or ""

	return path .. modified .. readonly
end

M.get_macro_recording = function()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end
	return "%#WarningMsg# Recording @" .. reg .. "%#StatusLine#"
end

M.get_breadcrumbs = function()
	local has_navic, navic = pcall(require, "nvim-navic")
	return (has_navic and navic.is_available()) and navic.get_location() or ""
end

M.get_lazy_updates = function()
	return (has_lazy and lazy_status.has_updates())
			and string.format("%%#WarningMsg#%s%%#StatusLine#", lazy_status.updates())
		or ""
end

M.get_wordcount = function()
	return wordcount_cache[vim.api.nvim_get_current_buf()] or ""
end

M.get_filesize = function()
	return size_cache[vim.api.nvim_get_current_buf()] or ""
end

M.get_encoding = function()
	local enc = vim.bo.fileencoding
	local fmt = vim.bo.fileformat

	local warnings = {}

	if enc ~= "" and enc ~= "utf-8" then
		table.insert(warnings, " " .. enc)
	end
	if fmt ~= "unix" then
		table.insert(warnings, " " .. fmt)
	end

	if #warnings == 0 then
		return ""
	end

	return "%#WarningMsg#" .. table.concat(warnings, " ") .. "%#StatusLine#"
end

M.get_filetype = function()
	local ft = vim.bo.filetype
	if ft == "" then
		return ""
	end

	if has_devicons then
		local buf = vim.api.nvim_get_current_buf()

		if icon_cache[buf] then
			return icon_cache[buf] .. ft
		end

		local path = vim.api.nvim_buf_get_name(0)
		local tail = path:match("[^/]+$") or path
		local ext = tail:match("%.([^.]+)$") or ""

		local icon, icon_hl = devicons.get_icon(tail, ext, { default = true })
		if icon then
			local cached_str = string.format("%%#%s#%s%%#StatusLine# ", icon_hl, icon)
			icon_cache[buf] = cached_str
			return cached_str .. ft
		end
	end
	return ft
end

M.get_lsp = function()
	return lsp_cache[vim.api.nvim_get_current_buf()] or ""
end

return M
