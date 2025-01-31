return {
    "rest-nvim/rest.nvim",
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            table.insert(opts.ensure_installed, "http")
        end,
    },
    config = function()
        vim.keymap.set("n", "<leader>hr", ":vert botright Rest run<cr>", { desc = "[H]ttp [R]un" })
    end,
}
