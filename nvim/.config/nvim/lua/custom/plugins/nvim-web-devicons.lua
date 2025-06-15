-- Provides Nerd Font icons for Neovim plugins such as nvim-tree.

return {
	"nvim-tree/nvim-web-devicons",
	lazy = false,
	opts = {
		override = {
			[".gitconfig-base"] = {
				icon = "",
				color = "#F14E32",
				name = "GitConfig",
			},
			[".gitconfig-haltu"] = {
				icon = "",
				color = "#F14E32",
				name = "GitConfig",
			},
			[".gitconfig-paatre"] = {
				icon = "",
				color = "#F14E32",
				name = "GitConfig",
			},
		},
	},
}
