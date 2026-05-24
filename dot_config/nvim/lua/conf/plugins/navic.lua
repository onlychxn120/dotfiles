return {
	"SmiteshP/nvim-navic",
	dependencies = {
		"neovim/nvim-lspconfig",
	},
	opts = {
		icons = {
			File = "󰈙 ",
			Module = " ",
			Namespace = "󰌗 ",
			Package = " ",
			Class = "󰌗 ",
			Method = "󰆧 ",
			Property = " ",
			Field = " ",
			Constructor = " ",
			Enum = "󰕘",
			Interface = "󰕘",
			Function = "󰊕 ",
			Variable = "󰆧 ",
			Constant = "󰏿 ",
			String = "󰀬 ",
			Number = "󰎠 ",
			Boolean = "◩ ",
			Array = "󰅪 ",
			Object = "󰅩 ",
			Key = "󰌋 ",
			Null = "󰟢 ",
			EnumMember = " ",
			Struct = "󰌗 ",
			Event = " ",
			Operator = "󰆕 ",
			TypeParameter = "󰊄 ",
		},
		lsp = {
			auto_attach = true,
			preference = nil,
		},
		highlight = true,
		separator = "  ",
		depth_limit = 5,
		depth_limit_indicator = "..",
		safe_output = true,
		lazy_update_context = false,
		click = false,
		format_text = function(text)
			return text
		end,
	},
	config = function(_, opts)
		-- Ensure highlight groups blend nicely with your existing theme
		vim.api.nvim_set_hl(0, "NavicSeparator", { link = "Comment" })
		require("nvim-navic").setup(opts)
	end,
}
