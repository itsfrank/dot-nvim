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

        -- dont make tab suck when using snippets
        vim.api.nvim_create_autocmd("ModeChanged", {
            pattern = "*",
            callback = function()
                if
                    ((vim.v.event.old_mode == "s" and vim.v.event.new_mode == "n") or vim.v.event.old_mode == "i")
                    and require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
                    and not require("luasnip").session.jump_active
                then
                    require("luasnip").unlink_current()
                end
            end,
        })
    end,
}
