return {
	"stevearc/conform.nvim",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				typst = { "typstyle" },
				rust = { "rustfmt", lsp_format = "fallback" },
				c = { "clang-format" },
				cpp = { "clang-format" },
				go = { "goimports", "gofmt" },
				lua = { "stylua" },
				python = { "ruff_format", "ruff_fix" },
				javascript = { "biome" },
				typescript = { "biome" },
				javascriptreact = { "biome" },
				typescriptreact = { "biome" },
				json = { "biome" },
				css = { "biome" },
				html = { "biome" },
				yaml = { "prettierd" },
				markdown = { "prettierd" },
				astro = { "prettierd" },
			},
			formatters = {
				ruff_fix = {
					args = {
						"check",
						"--fix",
						"--force-exclude",
						"--exit-zero",
						"--no-cache",
						"--unfixable=F401,F841",
						"--stdin-filename",
						"$FILENAME",
						"-",
					},
				},
				["clang-format"] = {
					prepend_args = { "-style={BasedOnStyle: LLVM, IndentWidth: 4, TabWidth: 4}" },
				},
			},
			format_on_save = {
				lsp_format = "fallback",
				async = false,
				timeout_ms = 500,
			},
		})

		vim.keymap.set({ "n", "v" }, "<leader>mp", function()
			require("conform").format({
				lsp_format = "fallback",
				async = false,
				timeout_ms = 500,
			})
		end, { desc = "Format file or range (in visual mode)" })
	end,
}
