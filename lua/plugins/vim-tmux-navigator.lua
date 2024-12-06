vim.g.tmux_navigator_no_mappings = 1

return {
    {
        "christoomey/vim-tmux-navigator",
        enabled = false,
        config = function()
            vim.keymap.set("n", "<M-h>", ":<C-U>TmuxNavigateLeft<cr>", { silent = true })
            vim.keymap.set("n", "<M-j>", ":<C-U>TmuxNavigateDown<cr>", { silent = true })
            vim.keymap.set("n", "<M-k>", ":<C-U>TmuxNavigateUp<cr>", { silent = true })
            vim.keymap.set("n", "<M-l>", ":<C-U>TmuxNavigateRight<cr>", { silent = true })
        end,
    },
    {
        "numToStr/Navigator.nvim",
        config = function()
            require("Navigator").setup()
            vim.keymap.set({ "n", "t" }, "<A-h>", "<CMD>NavigatorLeft<CR>")
            vim.keymap.set({ "n", "t" }, "<A-l>", "<CMD>NavigatorRight<CR>")
            vim.keymap.set({ "n", "t" }, "<A-k>", "<CMD>NavigatorUp<CR>")
            vim.keymap.set({ "n", "t" }, "<A-j>", "<CMD>NavigatorDown<CR>")
        end,
    },
}
