-- blink.cmp is the completion engine: it collects candidates from sources
-- (LSP, snippets, paths), ranks them and draws the menu. It replaces nvim-cmp
-- together with cmp-nvim-lsp, cmp-path and cmp_luasnip.
--
-- Snippets expand through Neovim's built-in vim.snippet, with friendly-snippets
-- supplying the bodies, so there is no separate snippet engine. LuaSnip is
-- supported if its extras -- choice nodes, dynamic nodes, Lua-authored snippets
-- -- are ever wanted back.
--
-- Not lazy-loaded: lsp.lua asks blink for the capabilities it advertises to
-- language servers, which has to happen before any server starts.

return {
	"saghen/blink.cmp",
	-- A release tag makes blink download a prebuilt fuzzy matcher rather than
	-- building it with cargo.
	version = "1.*",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	opts = {
		keymap = {
			-- The default preset already matches what nvim-cmp was bound to:
			-- <C-space> opens the menu, <C-y> accepts, <C-n>/<C-p> move through
			-- the list and <C-b>/<C-f> scroll the documentation window.
			preset = "default",
			-- Snippet jumps keep their old keys, alongside the preset's
			-- <Tab>/<S-Tab>.
			["<C-l>"] = { "snippet_forward", "fallback" },
			["<C-h>"] = { "snippet_backward", "fallback" },
		},
		sources = {
			default = { "lsp", "snippets", "path" },
		},
		completion = {
			-- blink hides the documentation until asked; nvim-cmp showed it
			-- while moving through the list.
			documentation = { auto_show = true },
		},
		appearance = {
			nerd_font_variant = "mono",
		},
	},
	opts_extend = { "sources.default" },
}
