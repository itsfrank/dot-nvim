return {
    "JellyApple102/flote.nvim",
    config = function()
        require("flote").setup({})

        vim.keymap.set("n", "<leader>no", ":Flote<cr>", { desc = "[no]tes - flote.nvim, project notes" })
        vim.keymap.set("n", "<leader>NO", ":Flote global<cr>", { desc = "[NO]tes global - flote.nvim, project notes" })
    end,
}
