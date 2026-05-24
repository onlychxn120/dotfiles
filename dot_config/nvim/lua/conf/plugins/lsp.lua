return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/nvim-cmp",
		"hrsh7th/cmp-path",
		"hrsh7th/cmp-buffer",
	},

	config = function()
		vim.api.nvim_create_user_command("LspRestart", function()
			vim.cmd("LspStop")
			vim.cmd("LspRestart")
			print("LSP Restarted")
		end, {})
		vim.api.nvim_create_autocmd("LspAttach", {
			desc = "LSP actions",
			callback = function(event)
				local opts = { buffer = event.buf }
				vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
				vim.keymap.set("n", "<leader>k", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
				vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
				vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
				vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
				vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
				vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
				vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
				vim.keymap.set("n", "<F2>", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
				vim.keymap.set("n", "<F4>", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
				vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", { buffer = event.buf, desc = "Restart LSP" })
			end,
		})
		vim.diagnostic.config({
			virtual_text = false,
			signs = {
				text = {
					[vim.diagnostic.severity.ERROR] = " ",
					[vim.diagnostic.severity.WARN] = " ",
					[vim.diagnostic.severity.INFO] = " ",
					[vim.diagnostic.severity.HINT] = "󰠠 ",
				},
			},
			underline = true,
			update_in_insert = true,
			severity_sort = true,
			float = {
				border = "rounded",
				source = "if_many",
			},
		})
		vim.api.nvim_create_autocmd("ColorScheme", {
			callback = function()
				vim.cmd([[
          highlight DiagnosticVirtualTextError guibg=NONE guifg=#FF6C6B
          highlight DiagnosticVirtualTextWarn  guibg=NONE guifg=#ECBE7B
          highlight DiagnosticVirtualTextInfo  guibg=NONE guifg=#51AFEF
          highlight DiagnosticVirtualTextHint  guibg=NONE guifg=#A9A1E1
          highlight DiagnosticUnderlineError gui=undercurl guibg=NONE
          highlight DiagnosticUnderlineWarn  gui=underdashed guibg=NONE
          highlight DiagnosticUnderlineInfo  gui=underdotted guibg=NONE
          highlight DiagnosticUnderlineHint  gui=NONE guibg=NONE
          highlight NormalFloat guibg=NONE
          highlight FloatBorder guibg=NONE guifg=#888888
          highlight FloatTitle guibg=NONE
          highlight FloatFooter guibg=NONE
          highlight DiagnosticFloatingError guibg=NONE guifg=#FF6C6B
          highlight DiagnosticFloatingWarn  guibg=NONE guifg=#ECBE7B
          highlight DiagnosticFloatingInfo  guibg=NONE guifg=#51AFEF
          highlight DiagnosticFloatingHint  guibg=NONE guifg=#A9A1E1
        ]])
			end,
		})

		-- Mason setup
		require("mason").setup({
			ensure_installed = {},
		})

		local capabilities = require("cmp_nvim_lsp").default_capabilities()
		-- Mason-lspconfig setup
		require("mason-lspconfig").setup({
			handlers = {
				function(server_name)
					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
					})
				end,
				rust_analyzer = function()
					require("lspconfig").rust_analyzer.setup({
						capabilities = capabilities,
						settings = {
							["rust-analyzer"] = {
								cargo = {
									allFeatures = true,
									loadOutDirsFromCheck = true,
									buildScripts = {
										enable = true,
									},
								},
								checkOnSave = {
									allFeatures = true,
									command = "clippy",
									extraArgs = { "--no-deps" },
								},
								procMacro = {
									enable = true,
								},
							},
						},
					})
				end,
				tinymist = function()
					require("lspconfig").tinymist.setup({
						capabilities = capabilities,
						settings = {
							formatterMode = "disable",
							exportPdf = "never",
						},
					})
				end,
				clangd = function()
					require("lspconfig").clangd.setup({
						capabilities = capabilities,
						cmd = {
							"clangd",
							"--offset-encoding=utf-16",
						},
					})
				end,
				lua_ls = function()
					require("lspconfig").lua_ls.setup({
						capabilities = capabilities,
						on_attach = function(client)
							client.server_capabilities.documentFormattingProvider = false
							client.server_capabilities.documentRangeFormattingProvider = false
						end,
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								telemetry = { enable = false },
							},
						},
					})
				end,
				basedpyright = function()
					require("lspconfig").basedpyright.setup({
						capabilities = capabilities,
						settings = {
							basedpyright = {
								analysis = {
									autoSearchPaths = true,
									useLibraryCodeForTypes = true,
									diagnosticMode = "workspace",
									typeCheckingMode = "standard",
								},
							},
						},
					})
				end,
				ruff = function()
					require("lspconfig").ruff.setup({
						capabilities = capabilities,
						on_attach = function(client)
							client.server_capabilities.hoverProvider = false
							client.server_capabilities.documentFormattingProvider = false
						end,
						init_options = {
							settings = {
								lint = {
									enable = true,
								},
							},
						},
					})
				end,
				tailwindcss = function()
					require("lspconfig").tailwindcss.setup({
						capabilities = capabilities,
						filetypes = {
							"html",
							"css",
							"javascript",
							"javascriptreact",
							"typescript",
							"typescriptreact",
							"astro",
						},
						-- Optional but recommended: Only start if a tailwind config file is found
						root_dir = require("lspconfig").util.root_pattern(
							"tailwind.config.js",
							"tailwind.config.cjs",
							"tailwind.config.mjs",
							"tailwind.config.ts",
							"postcss.config.js"
						),
					})
				end,
			},
		})

		local cmp = require("cmp")

		--   פּ ﯟ   some other good icons
		local kind_icons = {
			Text = "",
			Method = "m",
			Function = "",
			Constructor = "",
			Field = "",
			Variable = "",
			Class = "",
			Interface = "",
			Module = "",
			Property = "",
			Unit = "",
			Value = "",
			Enum = "",
			Keyword = "",
			Snippet = "",
			Color = "",
			File = "",
			Reference = "",
			Folder = "",
			EnumMember = "",
			Constant = "",
			Struct = "",
			Event = "",
			Operator = "",
			TypeParameter = "",
		}
		-- find more here: https://www.nerdfonts.com/cheat-sheet

		cmp.setup({
			snippet = {
				expand = function(args)
					vim.snippet.expand(args.body)
				end,
			},
			sources = cmp.config.sources({
				{ name = "neorg" },
				{ name = "nvim_lsp" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),

			mapping = {
				["<C-k>"] = cmp.mapping.select_prev_item(),
				["<C-j>"] = cmp.mapping.select_next_item(),
				["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
				["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
				["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
				---@diagnostic disable-next-line: assign-type-mismatch
				["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
				["<C-e>"] = cmp.mapping({
					i = cmp.mapping.abort(),
					c = cmp.mapping.close(),
				}),
				-- Accept currently selected item. If none selected, `select` first item.
				-- Set `select` to `false` to only confirm explicitly selected items.
				["<CR>"] = cmp.mapping.confirm({ select = false }),
				["<Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_next_item()
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
				["<S-Tab>"] = cmp.mapping(function(fallback)
					if cmp.visible() then
						cmp.select_prev_item()
					else
						fallback()
					end
				end, {
					"i",
					"s",
				}),
			},

			formatting = {
				fields = { "kind", "abbr", "menu" },
				format = function(entry, vim_item)
					-- Kind icons
					vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
					-- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
					vim_item.menu = ({
						nvim_lsp = "[LSP]",
						--nvim_lsp_signature_help = "[LSP-Signature]",
						buffer = "[Buffer]",
						path = "[Path]",
						neorg = "[Neorg]",
					})[entry.source.name]
					return require("nvim-highlight-colors").format(entry, vim_item)
				end,
			},
		})
		vim.cmd("doautocmd ColorScheme")
	end,
}
