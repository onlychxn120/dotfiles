return {
	{
		"folke/tokyonight.nvim",
		lazy = false,
		priority = 1200,
		opts = {
			style = "night",
			transparent = true,
		},
		config = function(_, opts)
			require("tokyonight").setup(opts)
			vim.cmd([[colorscheme tokyonight]])
		end,
	},
}
