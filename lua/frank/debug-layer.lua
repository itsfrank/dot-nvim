local libmodal = require("libmodal")

local function fire_layer_change()
	vim.api.nvim_exec_autocmds("User", {
		pattern = "DebugLayerChanged",
	})
end

local m = {}
m.layer = nil

local function make_layer()
	local layer = libmodal.layer.new({})
	layer:map("n", "<esc>", function()
		layer:exit()
		layer = nil
		fire_layer_change()
	end, { desc = "Exit the debug keymap layer" })

	layer:map("n", "de", ":LaunchDebugger<cr>", { desc = "Debug Executeable - select exe with telescope" })

	local dap = require("dap")
	layer:map("n", "i", dap.step_into, { desc = "Debug: Step [I]nto" })
	layer:map("n", "o", dap.step_over, { desc = "Debug: Step [O]ver" })
	layer:map("n", "u", dap.step_out, { desc = "Debug: Step O[U]t" })
	layer:map("n", "b", dap.toggle_breakpoint, { desc = "Debug: Toggle [B]reakpoint" })
	-- layer:map("n", "B", dap.step_out, { desc = "Debug: Toggle Conditional [B]reakpoint" })

	return layer
end

function m.init()
	vim.keymap.set("n", "<leader>db", function()
		m.layer = make_layer()
		m.layer:enter()
		fire_layer_change()
	end, { desc = "Enter the [D]e[B]ug layer" })
end

return m
