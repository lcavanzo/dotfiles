return {
	{
		"mfussenegger/nvim-dap",
		recommended = true,
		event = "VeryLazy",
		desc = "Debugging support. Requires language specific adapters to be configured. (see lang extras)",

		dependencies = {
			"rcarriga/nvim-dap-ui",
			"mfussenegger/nvim-dap-python",

			-- virtual text for the debugger
			{
				"theHamsta/nvim-dap-virtual-text",
				opts = {},
			},
		},
		config = function()
			require("dap").adapters.python = {
				type = "executable",
				command = "python3",
				args = { "-m", "debugpy.adapter" },
			}
			require("dap").configurations.python = {
				{
					type = "python",
					request = "launch",
					name = "Launch file",
					program = "${file}",
					pythonPath = function()
						return "/usr/bin/python3"
					end,
				},
				{
					type = "python",
					request = "launch",
					name = "Launch file with arguments",
					program = "${file}",
					args = function()
						local args_string = vim.fn.input("Arguments: ")
						return vim.split(args_string, " +")
					end,
					console = "integratedTerminal",
					pythonPath = function()
						return "/usr/bin/python3"
					end,
				},
			}
		end,

          -- stylua: ignore
        keys = {
            -- DAP keymaps

            -- Breakpoints
            { "<leader>d", "", desc = "+debug", mode = {"n", "v"} },
            { "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, desc = "Breakpoint Condition" },
            { "<leader>dd", function() require("dap").set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end, desc = "Breakpoint with Message"},
            { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint" },
            { "<leader>dD", function() require("dap").clear_breakpoint() end, desc = "Clear all Breakpoints" },

            -- Navigation
            { "<leader>do", function() require("dap").step_out() end, desc = "Step Out" },
            { "<leader>dO", function() require("dap").step_over() end, desc = "Step Over" },
            { "<leader>di", function() require("dap").step_into() end, desc = "Step Into" },
            { "<leader>dj", function() require("dap").down() end, desc = "Down" },
            { "<leader>dk", function() require("dap").up() end, desc = "Up" },
            { "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Run to Cursor" },
            { "<leader>dg", function() require("dap").goto_() end, desc = "Go to Line (No Execute)" },

            -- Stop & Start
            { "<leader>da", function() require("dap").continue({ before = get_args }) end, desc = "Run with Args" },
            { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
            { "<leader>dt", function() require("dap").terminate() end, desc = "Terminate" },

            -- Other
            { "<leader>dl", function() require("dap").run_last() end, desc = "Run Last" },
            { "<leader>dp", function() require("dap").pause() end, desc = "Pause" },
            -- { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL" },
            { "<leader>ds", function() require("dap").session() end, desc = "Session" },
            { "<leader>dw", function() require("dap.ui.widgets").hover() end, desc = "Widgets" },
        },
	},
	{
		"rcarriga/nvim-dap-ui",
		event = "VeryLazy",
		dependencies = { "nvim-neotest/nvim-nio" },
              -- stylua: ignore
              keys = {
                { "<leader>du", function() require("dapui").toggle({ }) end, desc = "Dap UI" },
                { "<leader>de", function() require("dapui").eval() end, desc = "Eval", mode = {"n", "v"} },
              },
		opts = {},
		config = function(_, opts)
			local dap = require("dap")
			local dapui = require("dapui")
			dapui.setup(opts)

			dap.listeners.after.event_initialized["dapui_config"] = function()
				dapui.open({})
			end
			dap.listeners.before.event_terminated["dapui_config"] = function()
				dapui.close({})
			end
			dap.listeners.before.event_exited["dapui_config"] = function()
				dapui.close({})
			end

			vim.fn.sign_define(
				"DapBreakpoint",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "󰀩", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapBreakpointRejected",
				{ text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" }
			)
			vim.fn.sign_define(
				"DapLogPoint",
				{ text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" }
			)
			vim.fn.sign_define(
				"DapStopped",
				{ text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" }
			)
		end,
	},
}
