return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		"williamboman/mason-lspconfig.nvim",
		"brenoprata10/nvim-highlight-colors",
		{
			"saghen/blink.cmp",
			version = "1.*",
		},
	},

	config = function()
		vim.api.nvim_create_user_command("LspRestart", function()
			vim.cmd("LspStop")
			vim.cmd("LspStart")
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

		require("mason").setup()

		local capabilities = require("blink.cmp").get_lsp_capabilities()

		require("mason-lspconfig").setup({
			ensure_installed = {},
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
								diagnostics = {
									globals = { "vim" },
								},
								workspace = {
									library = vim.api.nvim_get_runtime_file("", true),
									checkThirdParty = false,
								},
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

		require("nvim-highlight-colors").setup({})

		local kind_icons = {
			Text = "󰉿 ",
			Method = "󰆧 ",
			Function = "󰊕 ",
			Constructor = " ",
			Field = "󰜢 ",
			Variable = "󰀫 ",
			Class = "󰠱 ",
			Interface = " ",
			Module = " ",
			Property = "󰜢 ",
			Unit = "󰑭 ",
			Value = "󰎚 ",
			Enum = "󰏗 ",
			Keyword = "󰌋 ",
			Snippet = " ",
			Color = "󰏘 ",
			File = "󰈙 ",
			Reference = "󰈇 ",
			Folder = "󰉋 ",
			EnumMember = "󰏗 ",
			Constant = "󰏿 ",
			Struct = "󰙅 ",
			Event = "󱐋 ",
			Operator = "󰆕 ",
			TypeParameter = "󰏘 ",
		}

		require("blink.cmp").setup({
			keymap = {
				["<C-k>"] = { "show", "show_documentation", "hide_documentation" },
				["<C-e>"] = { "hide" },
				["<CR>"] = { "accept", "fallback" },
				["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
				["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
				-- ["<C-j>"] = { "select_next", "fallback" },
				-- ["<C-k>"] = { "select_prev", "fallback" },
				["<C-b>"] = { "scroll_documentation_up", "fallback" },
				["<C-f>"] = { "scroll_documentation_down", "fallback" },
			},

			appearance = {
				use_nvim_cmp_as_default = false,
				nerd_font_variant = "normal",
				kind_icons = kind_icons,
			},

			sources = {
				default = { "lazydev", "lsp", "path", "snippets", "buffer" },

				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						score_offset = 100,
					},
				},
			},

			completion = {
				menu = {
					draw = {
						columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
						components = {
							source_name = {
								text = function(ctx)
									local names = {
										lsp = "[LSP]",
										buffer = "[Buffer]",
										path = "[Path]",
										snippets = "[Snippet]",
										neorg = "[Neorg]",
									}
									return names[ctx.source_id] or "[" .. ctx.source_name .. "]"
								end,
							},
							kind_icon = {
								text = function(ctx)
									local icon = ctx.kind_icon
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr and color_item.abbr ~= "" then
											icon = color_item.abbr
										end
									end
									return icon .. ctx.icon_gap
								end,
								highlight = function(ctx)
									local highlight = "BlinkCmpKind" .. ctx.kind
									if ctx.item.source_name == "LSP" then
										local color_item = require("nvim-highlight-colors").format(
											ctx.item.documentation,
											{ kind = ctx.kind }
										)
										if color_item and color_item.abbr_hl_group then
											highlight = color_item.abbr_hl_group
										end
									end
									return highlight
								end,
							},
						},
					},
				},
			},

			signature = { enabled = true },
		})

		vim.cmd("doautocmd ColorScheme")
	end,
}
