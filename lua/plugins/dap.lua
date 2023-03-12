local lldb_adapter = {
	type = "executable",
	command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
	name = "lldb",
}

local new_cpp_debug_config = function(exe_path)
	return {
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = exe_path and exe_path or function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	}
end

local telescope_debug_launch = function()
	local dap = require("dap")
	local actions_state = require("telescope.actions.state")
	local actions = require("telescope.actions")

	local exec_dap = function(prompt_bufnr)
		local selected_entry = actions_state.get_selected_entry()
		local cpp_config = new_cpp_debug_config(selected_entry.cwd .. "/" .. selected_entry[1])
		actions.close(prompt_bufnr)
		dap.run(cpp_config)
	end
	require("telescope.builtin").find_files({
		find_command = { "fd", "-HI", "-t", "x" },
		attach_mappings = function(_, map)
			map("n", "<cr>", exec_dap)
			map("i", "<cr>", exec_dap)
			return true
		end,
	})
end

return {
	{
		"mfussenegger/nvim-dap",
		dependencies = {
			"nvim-telescope/telescope-dap.nvim",
			"theHamsta/nvim-dap-virtual-text",
			"rcarriga/nvim-dap-ui",
			"rcarriga/cmp-dap",
		},
		config = function()
			local dap = require("dap")
			require("dapui").setup()
			require("nvim-dap-virtual-text").setup()

			dap.adapters.lldb = lldb_adapter
			dap.configurations.cpp = { new_cpp_debug_config() }

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "error", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "character", linehl = "", numhl = "" })
			vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "class", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "type", linehl = "", numhl = "" })
			vim.api.nvim_create_user_command("LaunchDebugger", telescope_debug_launch, {})
		end,
	},
}
