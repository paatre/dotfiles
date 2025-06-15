-- dashboard-nvim is a fancy start dashbord screen for Neovim when the editor is started without a specific file.

return {
	"nvimdev/dashboard-nvim",
	event = "VimEnter",
	config = function()
		require("dashboard").setup({
			theme = "hyper",
			config = {
				week_header = {
					enable = true,
				},
				disable_move = true,
				packages = { enable = false },
				shortcut = {},
			},
			shortcut_type = "number",
		})
	end,
}
