return {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    -- install jsregexp (don't need it for now).
    -- build = "make install_jsregexp",

    config = function()
        local ls = require("luasnip")

        vim.keymap.set({ "i", "s" }, "<C-E>", function()
            if ls.choice_active() then
                ls.change_choice(1)
            end
        end, { silent = true, desc = "luasnip change choice" })

        require("frank.snippets").load()
    end,
}
