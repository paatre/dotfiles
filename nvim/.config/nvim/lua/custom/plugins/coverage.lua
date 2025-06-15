-- Displays coverage information in the gutter of Neovim.
-- Also provides commands to view and manage coverage data in a pop-up window.
-- Note: this plugin does not run tests.

return {
	"andythigpen/nvim-coverage",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	config = function()
		require("coverage").setup({
			auto_reload = true,
		})
	end,
}
