-- Displays coverage information in the gutter of Neovim.
-- Also provides commands to view and manage coverage data in a pop-up window.
-- Note: this plugin does not run tests.

return {
	"andythigpen/nvim-coverage",
	dependencies = "nvim-lua/plenary.nvim",
	config = function()
		require("coverage").setup({
			commands = true,
			lang = {
				python = {
					coverage_file = vim.fn.getcwd() .. "/.coverage",
					auto_reload = true,
					coverage_command = 'docker compose exec runserver sh -c "cd /home/bew/bew && /home/bew/.venv/bin/coverage json -o -"',
					only_open_buffers = false,
				},
			},
		})
	end,
}
