return {
	"gaoDean/autolist.nvim",
	ft = { "markdown", "text" },
	config = function()
		require("autolist").setup()

		-- Automatically add list items on Enter in insert mode
		vim.keymap.set("i", "<S-CR>", "<CR><cmd>AutolistNewBullet<cr>")

		-- Automatically add list items with 'o' and 'O' in normal mode
		vim.keymap.set("n", "o", "o<cmd>AutolistNewBullet<cr>")
		vim.keymap.set("n", "O", "O<cmd>AutolistNewBulletBefore<cr>")

		-- Recalculate numbered lists when you indent/dedent or delete
		vim.keymap.set("n", ">>", ">><cmd>AutolistRecalculate<cr>")
		vim.keymap.set("n", "<<", "<<<cmd>AutolistRecalculate<cr>")
		vim.keymap.set("n", "dd", "dd<cmd>AutolistRecalculate<cr>")
		vim.keymap.set("v", "d", "d<cmd>AutolistRecalculate<cr>")

		-- Optional: Toggle checkboxes with <CR> in normal mode
		vim.keymap.set("n", "<CR>", "<cmd>AutolistToggleCheckbox<cr><CR>")
	end,
}
