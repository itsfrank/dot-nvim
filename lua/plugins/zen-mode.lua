return {
    "folke/zen-mode.nvim",
    config = function()
        require("zen-mode").setup({
            window = {
                backdrop = 0.9,
                width = 0.70,
            },
            plugins = {
                twilight = {
                    enabled = false,
                },
            },
        })
    end,
}
