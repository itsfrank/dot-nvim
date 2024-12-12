-- lazy.nvim
return {
    "folke/snacks.nvim",
    config = function()
        local snacks = require("snacks")
        snacks.setup({
            terminal = {
                -- your terminal configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            },
        })

        vim.keymap.set({ "n", "t" }, "<m-q>", function()
            print("hi")
            snacks.terminal.toggle()
        end)
    end,
}
