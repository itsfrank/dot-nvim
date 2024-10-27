return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({})
        vim.keymap.set(
            { "n", "v" },
            "<leader>sp",
            require("grug-far").open,
            { desc = "Toggle [S]earch [P]project - global find/replace" }
        )
    end,
}
