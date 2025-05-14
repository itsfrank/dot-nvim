return {
    "MagicDuck/grug-far.nvim",
    config = function()
        require("grug-far").setup({
            startInInsertMode = false,
            transient = true,
            prefills = {
                flags = "--ignore-case",
            },
            normalModeSearch = true,
            openTargetWindow = {
                preferredLocation = "prev",
            },
        })

        vim.keymap.set({ "n", "v" }, "<leader>sp", function()
            require("grug-far").toggle_instance({ instanceName = "grug main" })
        end, { desc = "Toggle [S]earch [P]project - global find/replace" })
    end,
}
