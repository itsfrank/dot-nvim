return {
    "JellyApple102/flote.nvim",
    config = function()
        require("flote").setup({})

        vim.keymap.set("n", "<leader>no", ":Flote<cr>", { desc = "[NO]tes - flote.nvim, project notes" })
    end,
}
