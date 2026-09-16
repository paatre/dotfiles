-- neotest discovers and runs tests, marking results in the sign column and
-- collecting them in a summary panel. Each language needs its own adapter.
--
-- Tests can be run under nvim-dap with `strategy = "dap"`, which is what
-- <leader>Td does. dap is not listed as a dependency: lazy.nvim loads it when
-- neotest's dap strategy requires it.

return {
	"nvim-neotest/neotest",
	dependencies = {
		"nvim-neotest/nvim-nio",
		"nvim-lua/plenary.nvim",
		"antoinemadec/FixCursorHold.nvim",
		"nvim-treesitter/nvim-treesitter",
		"marilari88/neotest-vitest",
		"nvim-neotest/neotest-python",
		{ "fredrikaverpil/neotest-golang", version = "*" },
		-- neotest-golang's dap_mode defaults to "dap-go", which expects this to
		-- supply delve's configuration. Without it, debugging a Go test is a no-op.
		"leoluz/nvim-dap-go",
	},
	keys = {
		{
			"<leader>Tt",
			function()
				require("neotest").run.run()
			end,
			desc = "[T]est nearest",
		},
		{
			"<leader>Tf",
			function()
				require("neotest").run.run(vim.fn.expand("%"))
			end,
			desc = "[T]est [F]ile",
		},
		{
			"<leader>Td",
			function()
				require("neotest").run.run({ strategy = "dap" })
			end,
			desc = "[T]est nearest under [D]ebugger",
		},
		{
			"<leader>Ts",
			function()
				require("neotest").summary.toggle()
			end,
			desc = "[T]est [S]ummary",
		},
		{
			"<leader>To",
			function()
				require("neotest").output.open({ enter = true })
			end,
			desc = "[T]est [O]utput",
		},
		{
			"<leader>TS",
			function()
				require("neotest").run.stop()
			end,
			desc = "[T]est [S]top",
		},
	},
	config = function()
		require("neotest").setup({
			adapters = {
				require("neotest-vitest"),
				require("neotest-python")({
					-- Stepping into the standard library is rarely what you want,
					-- but stopping short of your own dependencies usually isn't either.
					dap = { justMyCode = false },
				}),
				require("neotest-golang"),
			},
		})
	end,
}
