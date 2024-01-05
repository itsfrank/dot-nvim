---@type LazySpec
return {
    "itsfrank/overseer-quick-tasks",
    -- dir = "~/frk/nvim-plugins/overseer-quick-tasks",
    dependencies = {
        "ThePrimeagen/harpoon",
        "stevearc/overseer.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        local oqt = require("oqt")
        -- harpoon supports being partialy configured, should not affect your main setup
        harpoon:setup({
            oqt = oqt.harppon_list_config,
        })
        oqt.setup_keymaps()
    end,
}
