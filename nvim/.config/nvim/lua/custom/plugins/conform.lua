-- Conform is a Neovim plugin that provides a unified interface for formatting code using various formatters. It allows you to configure formatters for different file types and provides options for formatting on save, as well as manual formatting commands.

return {
	"stevearc/conform.nvim",
	-- format_on_save is registered by conform's setup(), so the plugin has to be
	-- loaded before a write rather than on first use of the keymap below.
	event = { "BufWritePre" },
	cmd = { "ConformInfo" },
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "",
			desc = "[F]ormat buffer",
		},
	},
	opts = {
		format_on_save = {
			timeout_ms = 3000,
			lsp_format = "fallback",
		},
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
			javascript = { "prettierd" },
			javascriptreact = { "prettierd" },
			typescript = { "prettierd" },
			typescriptreact = { "prettierd" },
			json = { "prettierd" },
			jsonc = { "prettierd" },
			css = { "prettierd" },
			scss = { "prettierd" },
			html = { "prettierd" },
			htmldjango = { "djlint" },
			go = { "goimports", "gofumpt" },
		},
		formatters = {
			-- djlint defaults to its html profile, which does not know Django's
			-- block tags; htmldjango is the only filetype mapped to it here.
			djlint = {
				prepend_args = { "--profile=django" },
			},
		},
	},
}
