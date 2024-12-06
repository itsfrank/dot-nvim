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

    m.layer:map("n", "<leader>de", ":LaunchDebugCppExe<cr>", { desc = "Debug Executeable - select exe with telescope" })
    m.layer:map("n", "<leader>dl", ":LaunchDebugLast<cr>", { desc = "Debug Last - re-run last debug session" })

    local dap = require("dap")
    local brkp = require("breakingpoint")
    m.layer:map("n", "I", dap.step_into, { desc = "Debug: Step [I]nto" })
    m.layer:map("n", "O", dap.step_over, { desc = "Debug: Step [O]ver" })
    m.layer:map("n", "U", dap.step_out, { desc = "Debug: Step O[U]t" })
    m.layer:map("n", "C", dap.continue, { desc = "Debug: [C]ontinue" })

    m.layer:map("n", "<leader>b", dap.toggle_breakpoint, { desc = "debug: toggle [b]reakpoint" })
    m.layer:map("n", "<leader>B", brkp.create_or_edit_cndpoint, { desc = "debug: toggle conditional [B]reakpoint" })
    m.layer:map("n", "<leader>L", brkp.create_or_edit_logppoint, { desc = "debug: toggle [L]ogpoint" })

    -- widgets
    local dap_widgets = require("dap.ui.widgets")
    m.layer:map("n", "<leader>dh", function()
        local buffer_utils = require("frank.utils.buffer")
        local info = dap_widgets.hover()
        buffer_utils.make_temp_buf(info.buf)
    end, { desc = "[d]ap [h]over" })
    m.layer:map("n", "<leader>dp", dap_widgets.preview, { desc = "[d]ap [p]review" })
end

function m.init()
    set_keybinds()
    vim.keymap.set("n", "<leader>db", function()
        m.layer:enter()
        fire_layer_change()
    end, { desc = "Enter the [D]e[B]ug layer" })
end

return m
