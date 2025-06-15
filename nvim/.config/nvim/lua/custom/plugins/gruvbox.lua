-- Provides the gruvbox colorscheme for Neovim.

return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000, -- Make sure to load this before all the other start plugins.
	config = function()
		require("gruvbox").setup({
			transparent_mode = true,
		})
		vim.cmd.colorscheme("gruvbox")
	end,
}
