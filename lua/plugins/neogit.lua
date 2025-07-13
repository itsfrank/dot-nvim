return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "folke/snacks.nvim", -- optional
    },
    config = function()
        local neogit = require("neogit")
        neogit.setup({})

        vim.keymap.set("n", "<leader>ng", ":Neogit<cr>", { desc = "[n]eo[g]it", silent = true })
    end,
}
