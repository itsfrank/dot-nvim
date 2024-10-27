return {
    "mfussenegger/nvim-lint",
    config = function()
        require("lint").linters_by_ft = {
            shell = { "bash" },
            sh = { "bash" },
            bash = { "bash" },
        }
        vim.api.nvim_create_autocmd({ "BufWritePost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })
    end,
}
