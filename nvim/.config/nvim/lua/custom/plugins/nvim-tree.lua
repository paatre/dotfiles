-- Nvim-tree is a file explorer for Neovim that provides a tree view of your files and directories.

return {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	config = function()
		require("nvim-tree").setup({})
	end,
}
