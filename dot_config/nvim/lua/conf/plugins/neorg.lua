return {
	"nvim-neorg/neorg",
	version = "*",
	ft = "norg",
	cmd = "Neorg",
	dependencies = {
		"benlubas/neorg-interim-ls",
		"nvim-neorg/tree-sitter-norg",
		"nvim-neorg/tree-sitter-norg-meta",
	},
	config = function()
		require("neorg").setup({
			load = {
				["core.defaults"] = {},
				["core.itero"] = {},
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
				["core.ui.calendar"] = {},
				["core.summary"] = {},
				["core.export"] = {},
				["core.export.markdown"] = {
					config = {
						extension = "all",
					},
				},
				["external.interim-ls"] = {
					config = {
						completion_provider = {
							enable = true,
							documentation = true,
						},
					},
				},
				["core.completion"] = {
					config = {
						engine = { module_name = "external.lsp-completion" },
					},
				},
			},
		})
		local fzf = require("fzf-lua")

		vim.keymap.set("n", "<leader>nn", function()
			fzf.files({ cwd = "~/Documents/neorg_notes" })
		end, { desc = "Neorg: Find Files" })

		vim.keymap.set("n", "<leader>ng", function()
			fzf.live_grep({ cwd = "~/Documents/neorg_notes" })
		end, { desc = "Neorg: Grep Notes" })

		vim.keymap.set("n", "<leader>nt", function()
			fzf.grep({
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
