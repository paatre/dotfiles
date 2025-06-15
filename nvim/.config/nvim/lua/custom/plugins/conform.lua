-- Conform is a Neovim plugin that provides a unified interface for formatting code using various formatters. It allows you to configure formatters for different file types and provides options for formatting on save, as well as manual formatting commands.

return {
	"stevearc/conform.nvim",
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
		format_on_save = function(bufnr)
			local disable_filetypes = { c = true, cpp = true, javascript = true }
			return {
				timeout_ms = 500,
				lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
			}
		end,
		formatters_by_ft = {
			lua = { "stylua" },
		},
	},
}
