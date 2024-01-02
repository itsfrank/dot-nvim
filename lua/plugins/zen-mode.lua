return {
    "folke/zen-mode.nvim",
    config = function()
        require("zen-mode").setup({
            window = {
                backdrop = 1,
            },
            plugins = {
                twilight = {
                    enabled = false,
                },
            },
        })
    end,
}
