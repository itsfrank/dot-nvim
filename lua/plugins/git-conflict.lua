return {
    "akinsho/git-conflict.nvim",
    version = "1.1.1",
    config = function()
        require("git-conflict").setup({
            disable_diagnostics = false,
            default_mappings = {
                ours = "<leader>co",
                theirs = "<leader>ct",
                none = "<leader>c0",
                both = "<leader>cb",
                next = "]x",
                prev = "[x",
            },
        })

        -- for some reason conflicts arent detected automatically
        vim.api.nvim_create_autocmd("BufEnter", {
            callback = function()
                vim.cmd("GitConflictRefresh")
            end,
        })
    end,
}
