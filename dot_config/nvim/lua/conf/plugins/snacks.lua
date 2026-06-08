return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	---@type snacks.Config
	opts = {
		bigfile = { enabled = true },
		explorer = { enabled = true },
		image = {
			enabled = true,
			math = {
				enabled = false,
			},
		},
		indent = { enabled = true },
		notifier = {
			enabled = true,
			timeout = 3000,
		},
		picker = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = true },
		terminal = { enabled = true },
		styles = {
			wo = { wrap = true },
			terminal = {
				position = "right",
				width = 0.5,
				border = "single",
			},
			lazygit = {
				position = "float",
				relative = "editor",
				width = 0.9,
				height = 0.9,
			},
		},
	},
	keys = {
		{
			"<leader>e",
			function()
				Snacks.explorer()
			end,
			desc = "File Explorer",
		},
		{
			"<leader>ns",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notification History",
		},
	},
}
