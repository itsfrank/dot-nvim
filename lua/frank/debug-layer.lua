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

	m.layer:map("n", "<leader>de", ":LaunchDebugger<cr>", { desc = "Debug Executeable - select exe with telescope" })
	m.layer:map("n", "<leader>dui", require("dapui").toggle, { desc = "Debug: [D]ap [U][I] toggle" })

	local dap = require("dap")
	m.layer:map("n", "I", dap.step_into, { desc = "Debug: Step [I]nto" })
	m.layer:map("n", "O", dap.step_over, { desc = "Debug: Step [O]ver" })
	m.layer:map("n", "U", dap.step_out, { desc = "Debug: Step O[U]t" })
	m.layer:map("n", "C", dap.continue, { desc = "Debug: [C]ontinue" })

	m.layer:map("n", "<leader>b", dap.toggle_breakpoint, { desc = "Debug: Toggle [B]reakpoint" })
	-- layer:map("n", "<leader>B", dap.step_out, { desc = "Debug: Toggle Conditional [B]reakpoint" })
end

function m.init()
	set_keybinds()
	vim.keymap.set("n", "<leader>db", function()
		m.layer:enter()
		fire_layer_change()
	end, { desc = "Enter the [D]e[B]ug layer" })
end

return m
