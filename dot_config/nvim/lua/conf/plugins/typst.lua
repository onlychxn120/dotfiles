return {
	"chomosuke/typst-preview.nvim",
	lazy = false,
	version = "1.*",
	opts = {
		debug = false,
		open_cmd = nil,
		port = 0,
		host = "127.0.0.1",
		invert_colors = "auto",
		follow_cursor = true,
		dependencies_bin = {
			["tinymist"] = "tinymist",
		},
		extra_args = nil,
		get_root = function(path_of_main_file)
			local root = os.getenv("TYPST_ROOT")
			if root then
				return root
			end

			local main_dir = vim.fs.dirname(vim.fn.fnamemodify(path_of_main_file, ":p"))
			local found = vim.fs.find({ "typst.toml", ".git" }, { path = main_dir, upward = true })
			if #found > 0 then
				return vim.fs.dirname(found[1])
			end

			return main_dir
		end,

		get_main_file = function(path_of_buffer)
			return path_of_buffer
		end,
	},
	keys = {
		{ "<leader>tp", "<cmd>TypstPreviewToggle<cr>", desc = "Toggle Typst Preview" },
	},
}
