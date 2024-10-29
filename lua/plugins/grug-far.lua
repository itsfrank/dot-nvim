return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({})
        vim.keymap.set({ "n", "v" }, "<leader>sp", function()
            require("grug-far").toggle_instance({
                instanceName = "grug-far main",
                startInInsertMode = false,
                transient = true,
            })
        end, { desc = "Toggle [S]earch [P]project - global find/replace" })
    end,
}
