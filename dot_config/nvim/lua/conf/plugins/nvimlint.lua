return {
	"mfussenegger/nvim-lint",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		local lint = require("lint")

		lint.linters_by_ft = {
			markdown = { "markdownlint" },
			go = { "golangci-lint" },
			javascript = { "biomejs" },
			typescript = { "biomejs" },
			javascriptreact = { "biomejs" },
			typescriptreact = { "biomejs" },
			json = { "biomejs" },
			css = { "biomejs" },
			html = { "biomejs" },
		}

		local markdownlint = vim.deepcopy(require("lint.linters.markdownlint"))
		table.insert(markdownlint.args, "--disable")
		table.insert(markdownlint.args, "MD013")
		lint.linters.markdownlint = markdownlint

		vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost", "InsertLeave" }, {
			callback = function()
				lint.try_lint()
			end,
		})
	end,
}
