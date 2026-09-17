return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                current_line_blame = true,
                current_line_blame_opts = {
                    virt_text_pos = "eol",
                    delay = 300,
                },
            })

            vim.keymap.set("n", "<leader>bl", "<cmd>Gitsigns blame_line<cr>", { desc = "[B]lame [L]ine" })
            vim.keymap.set(
                "n",
                "<leader>bt",
                "<cmd>Gitsigns toggle_current_line_blame<cr>",
                { desc = "[B]lame [T]oggle" }
            )
        end,
    },
}
