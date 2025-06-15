-- nvim-cmp is code completion engine for Neovim that sources suggestions from various plugins (LSP, buffer, snippets, etc.).
-- The plugin provides:
-- - Displaying completion suggestions
-- - Managing different completion sources
-- - Keybindings for navigating and selecting suggestions
-- - Autocompletion capabilities

return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet engines
		{
			"L3MON4D3/LuaSnip",
			version = "v2.*",
			build = "make install_jsregexp",
			dependencies = {
				{
					"rafamadriz/friendly-snippets",
					config = function()
						require("luasnip.loaders.from_vscode").lazy_load()
					end,
				},
			},
		},
		-- Completion sources
		"saadparwaiz1/cmp_luasnip", -- Completion source for LuaSnip snippets
		"hrsh7th/cmp-nvim-lsp", -- Completion source for Neovim's built-in LSP client
		"hrsh7th/cmp-path", -- Completion source for file paths
	},
	config = function()
		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
		luasnip.config.setup({})

		cmp.setup({
			-- Delegates snippet expansion to LuaSnip
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			-- When and where to trigger completion
			completion = { completeopt = "menu,menuone,noinsert" },
			-- Keymaps for navigating and selecting completion items
			mapping = cmp.mapping.preset.insert({
				-- Select the [n]ext item
				["<C-n>"] = cmp.mapping.select_next_item(),
				-- Select the [p]revious item
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Scroll the documentation window [b]ack / [f]orward
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-y>"] = cmp.mapping.confirm({ select = true }),

				-- If you prefer more traditional completion keymaps,
				-- you can uncomment the following lines
				--['<CR>'] = cmp.mapping.confirm { select = true },
				--['<Tab>'] = cmp.mapping.select_next_item(),
				--['<S-Tab>'] = cmp.mapping.select_prev_item(),

				-- Manually trigger a completion from nvim-cmp.
				["<C-Space>"] = cmp.mapping.complete({}),

				-- Think of <c-l> as moving to the right of your snippet expansion.
				--  So if you have a snippet that's like:
				--  function $name($args)
				--    $body
				--  end
				--
				-- <c-l> will move you to the right of each of the expansion locations.
				-- <c-h> is similar, except moving you backwards.
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),

				-- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
				--    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
			}),
			-- Order and inclusion of the completion sources from nvim-cmp depedencies
			sources = {
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
			},
		})
	end,
}
