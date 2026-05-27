return {
	"nvim-neorg/neorg",
	version = "*",
	ft = "norg",
	cmd = "Neorg",
	dependencies = {
		"nvim-neorg/tree-sitter-norg",
		"nvim-neorg/tree-sitter-norg-meta",
	},
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.concealer"] = {
					config = {
						icon_preset = "varied",
					},
				},
				["core.dirman"] = {
					config = {
						workspaces = {
							main = "~/Documents/neorg_notes",
						},
						default_workspace = "main",
					},
				},
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
					},
				},
				["core.ui.calendar"] = {},
				["core.summary"] = {},
				["core.export"] = {},
				["core.export.markdown"] = {
					config = {
						extension = "all",
					},
				},
			},
		})
		local snacks = require("snacks")
		vim.keymap.set("n", "<leader>nn", function()
			snacks.picker.files({ cwd = "~/Documents/neorg_notes" })
		end, { desc = "Neorg: Find Files" })

		vim.keymap.set("n", "<leader>ng", function()
			snacks.picker.grep({ cwd = "~/Documents/neorg_notes" })
		end, { desc = "Neorg: Grep Notes" })

		vim.keymap.set("n", "<leader>nt", function()
			snacks.picker.grep({
				cwd = "~/Documents/neorg_notes",
				search = "TODO|FIXME|\\( \\)|\\(/\\)|\\(-\\)",
			})
		end, { desc = "Neorg: Find Actionable Tasks" })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = "norg",
			callback = function()
				vim.opt_local.conceallevel = 3
				vim.opt_local.wrap = true
				vim.opt_local.linebreak = true
			end,
		})
	end,
}
