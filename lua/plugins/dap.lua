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

---@param make_config fun(selected:string, args:string[]|nil):any
local telescope_debug_launch = function(make_config)
	local dap = require("dap")
	local actions_state = require("telescope.actions.state")
	local actions = require("telescope.actions")

	local exec_dap = function(prompt_bufnr, args)
		local selected_entry = actions_state.get_selected_entry()
		local config = make_config(selected_entry.cwd .. "/" .. selected_entry[1], args)
		actions.close(prompt_bufnr)
		dap.run(config)
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

local local_lua_adapter = {
	type = "executable",
	command = "node",
	args = {
		"/Users/fobrien/tools/local-lua-debugger-vscode/extension/debugAdapter.js",
	},
	enrich_config = function(config, on_config)
		if not config["extensionPath"] then
			local c = vim.deepcopy(config)
			-- 💀 If this is missing or wrong you'll see
			-- "module 'lldebugger' not found" errors in the dap-repl when trying to launch a debug session
			c.extensionPath = "/Users/fobrien/tools/local-lua-debugger-vscode/"
			on_config(c)
		else
			on_config(config)
		end
	end,
}

local make_luals_debug_config = function(args)
	local config = {
		name = "Debug LuaLS test",
		type = "local-lua",
		request = "launch",
		program = {
			command = "/Users/fobrien/frk/lua-language-server/bin/lua-language-server",
		},
		args = args,
		cwd = "${workspaceFolder}",
	}
	return config
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

			dap.adapters["local-lua"] = local_lua_adapter
			dap.adapters.lldb = lldb_adapter
			dap.configurations.cpp = { new_cpp_debug_config() }

			vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "error", linehl = "", numhl = "" })
			vim.fn.sign_define(
				"DapBreakpointCondition",
				{ text = "●", texthl = "character", linehl = "", numhl = "" }
			)
			vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "class", linehl = "", numhl = "" })
			vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "type", linehl = "", numhl = "" })
			vim.api.nvim_create_user_command("LaunchDebugger", function()
				telescope_debug_launch(function(selected, args)
					return new_cpp_debug_config(selected, args)
				end)
			end, {})
			vim.api.nvim_create_user_command("LaunchDebuggerLuaLs", function()
				require("dap").run(make_luals_debug_config({ "test.lua" }))
			end, {})
		end,
	},
}
