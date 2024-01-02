vim.g.tmux_navigator_no_mappings = 1

return {
    "christoomey/vim-tmux-navigator",
    config = function()
        vim.keymap.set("n", "<M-h>", ":<C-U>TmuxNavigateLeft<cr>", { silent = true })
        vim.keymap.set("n", "<M-j>", ":<C-U>TmuxNavigateDown<cr>", { silent = true })
        vim.keymap.set("n", "<M-k>", ":<C-U>TmuxNavigateUp<cr>", { silent = true })
        vim.keymap.set("n", "<M-l>", ":<C-U>TmuxNavigateRight<cr>", { silent = true })
    end,
}
