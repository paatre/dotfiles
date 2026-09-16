-- Displays coverage information in the gutter of Neovim.
-- Also provides commands to view and manage coverage data in a pop-up window.
-- Note: this plugin does not run tests.
--
-- The report file is per language and found by the plugin's own defaults:
-- coverage.out for Go, .coverage for Python, coverage/lcov.info for JS/TS.
-- Python shells out to `coverage json`, so that has to be on PATH -- in a
-- project with a virtualenv, start Neovim with it activated.

return {
	"andythigpen/nvim-coverage",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = {
		"Coverage",
		"CoverageClear",
		"CoverageHide",
		"CoverageLoad",
		"CoverageLoadLcov",
		"CoverageShow",
		"CoverageSummary",
		"CoverageToggle",
	},
	keys = {
		{
			"<leader>tc",
			function()
				if require("coverage.signs").is_enabled() then
					require("coverage").hide()
				else
					-- :CoverageToggle only flips sign visibility and does nothing
					-- until a report has been loaded, so load on the way in. It
					-- re-reads the report each time, which keeps signs current.
					require("coverage").load(true)
				end
			end,
			desc = "[T]oggle [C]overage",
		},
	},
	main = "coverage",
	opts = {
		auto_reload = true,
	},
}
