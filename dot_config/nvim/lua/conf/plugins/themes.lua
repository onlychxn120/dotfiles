return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1200,
		opts = {
			style = "night",
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
