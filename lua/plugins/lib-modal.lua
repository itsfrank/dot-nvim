return {
    {
        "Iron-E/nvim-libmodal",
        dependencies = {
            "mfussenegger/nvim-dap",
            "rcarriga/nvim-dap-ui",
        },
        config = function()
            require("frank.debug.debug-layer").init()
        end,
    },
}
