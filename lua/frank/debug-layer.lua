local libmodal = require("libmodal")

local function fire_layer_change()
	vim.api.nvim_exec_autocmds("User", {
		pattern = "DebugLayerChanged",
	})
end

local m = {}
m.layer = libmodal.layer.new({})

-- this needs to be a function because libmodal clears all keybinds when a layer is exited
local function set_keybinds()
	m.layer:map("n", "<esc>", function()
		m.layer:exit()
		fire_layer_change()
	end, { desc = "Exit the debug keymap layer" })

	m.layer:map("n", "de", ":LaunchDebugger<cr>", { desc = "Debug Executeable - select exe with telescope" })

	local dap = require("dap")
	m.layer:map("n", "i", dap.step_into, { desc = "Debug: Step [I]nto" })
	m.layer:map("n", "o", dap.step_over, { desc = "Debug: Step [O]ver" })
	m.layer:map("n", "u", dap.step_out, { desc = "Debug: Step O[U]t" })
	m.layer:map("n", "b", dap.toggle_breakpoint, { desc = "Debug: Toggle [B]reakpoint" })
	-- layer:map("n", "B", dap.step_out, { desc = "Debug: Toggle Conditional [B]reakpoint" })
end

function m.init()
	vim.keymap.set("n", "<leader>db", function()
		set_keybinds()
		m.layer:enter()
		fire_layer_change()
	end, { desc = "Enter the [D]e[B]ug layer" })
end

return m
