return {
	"neovim/nvim-lspconfig",
	dependencies = {
		-- Automatically install LSPs and related tools to stdpath for Neovim
		{ "williamboman/mason.nvim", config = true },
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",

		-- Useful status updates for LSP.
		{ "j-hui/fidget.nvim", opts = {} },

		-- Lua LSP for editing your Neovim config
		{ "folke/lazydev.nvim", ft = "lua" },
	},
	config = function()
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
			callback = function(event)
				local map = function(keys, func, desc)
					vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
				end

				map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

				map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

				map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

				map("<leader>D", require("telescope.builtin").lsp_type_definitions, "Type [D]efinition")

				map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")

				map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

				map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")

				map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")

				map("K", vim.lsp.buf.hover, "Hover Documentation")

				map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

				local client = vim.lsp.get_client_by_id(event.data.client_id)
				if client and client.server_capabilities.documentHighlightProvider then
					local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
					vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.document_highlight,
					})

					vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
						buffer = event.buf,
						group = highlight_augroup,
						callback = vim.lsp.buf.clear_references,
					})

					vim.api.nvim_create_autocmd("LspDetach", {
						group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
						callback = function(event2)
							vim.lsp.buf.clear_references()
							vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
						end,
					})
				end

				-- Displays inlay hints, such as parameter names, inline type information, etc. in the editor
				if client and client.server_capabilities.inlayHintProvider and vim.lsp.inlay_hint then
					map("<leader>th", function()
						vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
					end, "[T]oggle Inlay [H]ints")
				end
			end,
		})

		-- Neovim's LSP capabilities are extended by plugins like nvim-cmp and then broadcast to language servers
		local capabilities = vim.lsp.protocol.make_client_capabilities()
		capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

		-- Enable and automatically install the following language servers
		local servers = {
			lua_ls = {
				settings = {
					Lua = {
						completion = {
							callSnippet = "Replace",
						},
						diagnostics = {
							globals = { "vim" },
						},
					},
				},
			},
			gopls = {
				settings = {
					gopls = {
						-- Match the gofumpt formatting conform applies on save
						gofumpt = true,
						staticcheck = true,
						analyses = {
							nilness = true,
							unusedparams = true,
							unusedwrite = true,
						},
					},
				},
			},
			ts_ls = {},
			-- pyright does types, hover and completion; ruff does linting,
			-- formatting and imports. Each gives up what the other is better at.
			pyright = {
				settings = {
					pyright = {
						disableOrganizeImports = true,
					},
				},
			},
			ruff = {
				on_attach = function(client)
					client.server_capabilities.hoverProvider = false
				end,
			},
			html = {},
			-- Django templates: lspconfig defaults djlsp to html as well, but Neovim
			-- detects Django markup as htmldjango, so plain HTML is left to html.
			djlsp = {
				filetypes = {
					"htmldjango",
				},
			},
			cssls = {},
			-- Emmet is only wanted in markup, not in every filetype it offers
			emmet_ls = {
				filetypes = {
					"html",
					"htmldjango",
				},
			},
		}

		-- mason-lspconfig only installs and enables servers; per-server settings are
		-- registered natively, and merged over what nvim-lspconfig ships in `lsp/`.
		vim.lsp.config("*", { capabilities = capabilities })

		for name, config in pairs(servers) do
			vim.lsp.config(name, config)
		end

		require("mason").setup()

		require("mason-tool-installer").setup({
			ensure_installed = vim.list_extend(vim.tbl_keys(servers), {
				"stylua", -- Used to format Lua code
				"prettierd", -- Used to format JS/TS and JSON
				"djlint", -- Used to format Django templates
				"goimports", -- Used to fix up Go imports
				"gofumpt", -- Used to format Go
			}),
		})

		require("mason-lspconfig").setup({
			ensure_installed = vim.tbl_keys(servers),
		})
	end,
}
