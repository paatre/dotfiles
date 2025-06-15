-- Provides the gruvbox colorscheme for Neovim.

return {
	"ellisonleao/gruvbox.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		require("gruvbox").setup({
			dim_inactive = false,
			transparent_mode = true,
		})
		vim.cmd.colorscheme("gruvbox")
	end,
}
