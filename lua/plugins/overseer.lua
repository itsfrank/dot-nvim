return {
    "stevearc/overseer.nvim",
    config = function()
        require("overseer").setup({
            task_list = {
                direction = "right",
            },
            templates = {
                "builtin",
                "game-engine",
            },
            default_template_prompt = "missing",
        })

        vim.keymap.set("n", "<leader>or", ":OverseerRun<cr>", { desc = "[O]verseer [R]un" })
        vim.keymap.set("n", "<leader>ot", ":OverseerToggle<cr>", { desc = "[O]verseer [T]oggle" })
    end,
}
