return {
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			},
		},
	},
	{
		"neovim/nvim-lspconfig",
		dependencies = { "folke/lazydev.nvim" },
		config = function()
			require("lspconfig").lua_ls.setup({})
		end,
	},
}
