local lldb_adapter = {
	type = "executable",
	command = "/opt/homebrew/opt/llvm/bin/lldb-vscode", -- adjust as needed, must be absolute path
	name = "lldb",
}

local function str_split(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t = {}
	for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
		table.insert(t, str)
	end
	return t
end

local new_cpp_debug_config = function(exe_path, args)
	args = args and args or {}
	return {
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = exe_path and exe_path or function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = args,
	}
end

local telescope_debug_launch = function()
	local dap = require("dap")
	local actions_state = require("telescope.actions.state")
	local actions = require("telescope.actions")

	local exec_dap = function(prompt_bufnr, args)
		local selected_entry = actions_state.get_selected_entry()
		local cpp_config = new_cpp_debug_config(selected_entry.cwd .. "/" .. selected_entry[1], args)
		actions.close(prompt_bufnr)
		dap.run(cpp_config)
	end

	local get_args_exec = function(prompt_bufnr)
		vim.ui.input({
			prompt = "Executable args",
		}, function(input)
			if input == nil then
				return
			end

			if input == "" then
				exec_dap(prompt_bufnr)
			else
				local args = str_split(input)
				exec_dap(prompt_bufnr, args)
			end
		end)
	end

	require("telescope.builtin").find_files({
		find_command = { "fd", "-HI", "-t", "x" },
		attach_mappings = function(_, map)
			map("n", "<cr>", get_args_exec)
			map("i", "<cr>", get_args_exec)
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
			require("nvim-dap-virtual-text").setup({})

			dap.adapters.lldb = lldb_adapter
			dap.configurations.cpp = { new_cpp_debug_config() }

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "error", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "●", texthl = "character", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "class", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "type", linehl = "", numhl = "" })
			vim.api.nvim_create_user_command("LaunchDebugger", telescope_debug_launch, {})
		end,
	},
}
