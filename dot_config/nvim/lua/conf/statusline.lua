local has_devicons, devicons = pcall(require, "nvim-web-devicons")

local function setup_highlights()
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

vim.api.nvim_create_autocmd("ColorScheme", {
	callback = setup_highlights,
})
setup_highlights()

local sep = " · "

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

local function get_mode()
	local mode = vim.api.nvim_get_mode().mode
	local current = modes[mode] or { mode, "%#StlNormal#" }
	return string.format("%s %s %%#StatusLine#", current[2], current[1])
end

local function get_git()
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

local function get_diagnostics()
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

local function get_filename()
	local path = vim.fn.expand("%:~:.")
	if path == "" then
		return "[No Name]"
	end

	local modified = vim.bo.modified and " %#WarningMsg#%#StatusLine#" or ""
	local readonly = vim.bo.readonly and " " or ""

	return path .. modified .. readonly
end

local icon_cache = {}

vim.api.nvim_create_autocmd({ "BufDelete", "BufFilePost" }, {
	callback = function(args)
		icon_cache[args.buf] = nil
	end,
})

local function get_filetype()
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

local lsp_cache = {}

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

local function get_lsp()
	return lsp_cache[vim.api.nvim_get_current_buf()] or ""
end

local function get_encoding()
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

_G.ActiveStatusLine = function()
	local left = {}
	local right = {}

	table.insert(left, get_mode())

	local git = get_git()
	if git ~= "" then
		table.insert(left, git)
	end

	local diag = get_diagnostics()
	if diag ~= "" then
		table.insert(left, diag)
	end

	table.insert(left, "%<" .. get_filename())

	local enc = get_encoding()
	if enc ~= "" then
		table.insert(right, enc)
	end

	local ft = get_filetype()
	if ft ~= "" then
		table.insert(right, ft)
	end

	local lsp = get_lsp()
	if lsp ~= "" then
		table.insert(right, lsp)
	end

	table.insert(right, "%p%%")
	table.insert(right, "%l:%c")

	local left_str = table.concat(left, sep)
	local right_str = table.concat(right, sep)

	return string.format(" %s %%= %s ", left_str, right_str)
end

vim.opt.laststatus = 3
vim.opt.statusline = "%!v:lua.ActiveStatusLine()"
