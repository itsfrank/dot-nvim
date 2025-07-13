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

        -- cpp stuff
        local dap_cpp = require("frank.debug.dap-cpp")
        dap.adapters.lldb = dap_cpp.lldb_adapter

        -- lua stuff
        local dap_lua = require("frank.debug.dap-lua")
        dap.adapters["local-lua"] = dap_lua.local_lua_adapter

        -- set up my debug commands
        local dap_utils = require("frank.debug.utils")

        dap_utils.register_debug_kind("cpp", dap_cpp.new_cpp_debug_config)
        dap_utils.make_commands() -- add :LaunchDebug and :LaunchDebugLast

        vim.keymap.set("n", "<leader>dui", require("dapui").toggle, { desc = "Debug: [D]ap [U][I] toggle" })
    end,
}
