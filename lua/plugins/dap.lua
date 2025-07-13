return {
    "mfussenegger/nvim-dap",
    dependencies = {
        "theHamsta/nvim-dap-virtual-text",
        "rcarriga/nvim-dap-ui",
        "nvim-neotest/nvim-nio",
    },
    config = function()
        local dap = require("dap")
        require("dapui").setup()
        require("nvim-dap-virtual-text").setup({})

        vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "error", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointCondition", { text = "●", texthl = "@character", linehl = "", numhl = "" })
        vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "@type", linehl = "", numhl = "" })
        vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "@function", linehl = "", numhl = "" })

        local dap_utils = require("frank.debug.utils")

        -- cpp stuff
        local dap_cpp = require("frank.debug.dap-cpp")
        dap.adapters.lldb = dap_cpp.lldb_adapter

        -- TODO: re-enable when debug utils rework is done
        -- vim.api.nvim_create_user_command("LaunchDebugCppExe", function()
        --     dap_utils.telescope_debug_launch({}, function(selected, args)
        --         return dap_cpp.new_cpp_debug_config(selected, args)
        --     end)
        -- end, { desc = "Select a cpp exe with telescope and launch it with a debugger addached" })
        --
        -- vim.api.nvim_create_user_command("LaunchDebugCppExeArgs", function(opts)
        --     dap_utils.telescope_debug_launch({}, function(selected, args)
        --         return dap_cpp.new_cpp_debug_config(selected, args)
        --     end, { args = opts.args })
        -- end, { nargs = "?", desc = "Select a cpp exe with telescope and launch it with a debugger addached" })

        -- lua stuff
        local dap_lua = require("frank.debug.dap-lua")
        dap.adapters["local-lua"] = dap_lua.local_lua_adapter

        vim.api.nvim_create_user_command("LaunchDebugLuaLs", function()
            require("dap").run(dap_lua.make_luals_debug_config({ "test.lua" }))
        end, {})

        vim.api.nvim_create_user_command("LaunchDebugLast", function()
            dap_utils.debug_last()
        end, { desc = "Restart the last debug session" })

        vim.keymap.set("n", "<leader>dui", require("dapui").toggle, { desc = "Debug: [D]ap [U][I] toggle" })
    end,
}
