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
            local win, created = snacks.terminal.get()
            if win then
                win.opts.height = 20
            end
            if not created then
                snacks.terminal.toggle()
            end
        end)

        vim.keymap.set({ "n", "t" }, "<m-Q>", function()
            local win, created = snacks.terminal.get(nil, { win = { height = 0 } })
            if win then
                win.opts.height = 0
            end
            if not created then
                snacks.terminal.toggle(nil, { win = { height = 0 } })
            end
        end)
    end,
}
