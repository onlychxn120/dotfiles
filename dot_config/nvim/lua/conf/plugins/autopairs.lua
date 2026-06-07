return {
	"altermo/ultimate-autopair.nvim",
	event = { "InsertEnter", "CmdlineEnter" },
	branch = "v0.6",
	opts = {
		fastwarp = {
			multi = true,
			{ map = "<C-e>", cmap = "<C-e>" },
			{ faster = true, map = "<C-f>", cmap = "<C-f>" },
		},
		tabout = {
			enable = true,
			map = "<C-l>",
			hopout = true,
		},
	},
}
