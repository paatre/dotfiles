-- nvim-dap is a Debug Adapter Protocol client: breakpoints, stepping and
-- variable inspection. Each language needs its own adapter, installed by Mason.
--
-- mason-nvim-dap's `handlers = {}` sets up the adapters it knows about, which
-- covers debugpy and delve. Its only JavaScript adapter is the deprecated
-- node2, so pwa-node (vscode-js-debug) is wired up by hand below.

return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
	},
	keys = {
		{
			"<F5>",
			function()
				require("dap").continue()
			end,
			desc = "Debug: Start/Continue",
		},
		{
			"<F1>",
			function()
				require("dap").step_into()
			end,
			desc = "Debug: Step Into",
		},
		{
			"<F2>",
			function()
				require("dap").step_over()
			end,
			desc = "Debug: Step Over",
		},
		{
			"<F3>",
			function()
				require("dap").step_out()
			end,
			desc = "Debug: Step Out",
		},
		{
			"<F7>",
			function()
				require("dapui").toggle()
			end,
			desc = "Debug: Toggle UI",
		},
		{
			"<leader>b",
			function()
				require("dap").toggle_breakpoint()
			end,
			desc = "Debug: Toggle [B]reakpoint",
		},
		{
			"<leader>B",
			function()
				require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
			end,
			desc = "Debug: Conditional [B]reakpoint",
		},
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Names here are nvim-dap adapter names, which mason-nvim-dap maps to
		-- package names: js -> js-debug-adapter, python -> debugpy.
		require("mason-nvim-dap").setup({
			ensure_installed = { "js", "python", "delve" },
			handlers = {},
		})

		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "js-debug-adapter",
				args = { "${port}" },
			},
		}

		for _, ft in ipairs({ "javascript", "javascriptreact", "typescript", "typescriptreact" }) do
			dap.configurations[ft] = {
				{
					type = "pwa-node",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
				{
					type = "pwa-node",
					request = "attach",
					name = "Attach to process",
					processId = require("dap.utils").pick_process,
					cwd = "${workspaceFolder}",
					sourceMaps = true,
				},
			}
		end

		dapui.setup()

		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close
	end,
}
