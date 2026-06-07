return {
	"ibhagwan/fzf-lua",
	cmd = "FzfLua",
	keys = {
		{
			"<leader>ff",
			"<cmd>FzfLua files<cr>",
			desc = "Find Files",
		},
		{
			"<leader>bf",
			"<cmd>FzfLua buffers<cr>",
			desc = "Buffers",
		},
		{
			"<leader>bg",
			"<cmd>FzfLua lines<cr>",
			desc = "Grep Open Buffers",
		},
		{
			"<leader>fg",
			"<cmd>FzfLua live_grep<cr>",
			desc = "Grep Project",
		},
	},
	config = function()
		require("fzf-lua").setup({
			file_icon_provider = "mini",
			winopts = {
				border = "rounded",
				preview = {
					border = "border",
					wrap = "wrap",
				},
			},
		})
	end,
}
