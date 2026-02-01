return {
    "NeogitOrg/neogit",
    dependencies = {
        "nvim-lua/plenary.nvim", -- required
        "folke/snacks.nvim", -- optional
    },
    config = function()
        local neogit = require("neogit")
        neogit.setup({
            integrations = {
                diffview = false,
            },
            mappings = {
                popup = {
                    ["v"] = false, -- I like to be able to use visual mode
                },
            },
        })

        vim.keymap.set("n", "<leader>ng", ":Neogit<cr>", { desc = "[n]eo[g]it", silent = true })
    end,
}
