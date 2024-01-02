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

            vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "error", linehl = "", numhl = "" })
            vim.fn.sign_define(
                "DapBreakpointCondition",
                { text = "●", texthl = "character", linehl = "", numhl = "" }
            )
            vim.fn.sign_define("DapLogPoint", { text = "●", texthl = "class", linehl = "", numhl = "" })
            vim.fn.sign_define("DapBreakpointRejected", { text = "●", texthl = "type", linehl = "", numhl = "" })

            local dap_utils = require("frank.debug.utils")

            -- cpp stuff
            local dap_cpp = require("frank.debug.dap-cpp")
            dap.adapters.lldb = dap_cpp.lldb_adapter

            vim.api.nvim_create_user_command("LaunchDebuggerCppExe", function()
                dap_utils.telescope_debug_launch({}, function(selected, args)
                    return dap_cpp.new_cpp_debug_config(selected, args)
                end)
            end, { desc = "Select a cpp exe with telescope and launch it with a debugger addached" })

            -- lua stuff
            local dap_lua = require("frank.debug.dap-lua")
            dap.adapters["local-lua"] = dap_lua.local_lua_adapter

            vim.api.nvim_create_user_command("LaunchDebuggerLuaLs", function()
                require("dap").run(dap_lua.make_luals_debug_config({ "test.lua" }))
            end, {})
        end,
    },
}
