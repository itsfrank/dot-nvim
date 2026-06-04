---@type LazySpec
return {
    "itsfrank/overseer-quick-tasks",
    dependencies = {
        "ThePrimeagen/harpoon",
        "stevearc/overseer.nvim",
    },
    config = function()
        local harpoon = require("harpoon")
        local oqt = require("oqt")
        harpoon:setup({
            oqt = oqt.harppon_list_config,
        })
        oqt.setup_keymaps()
    end,
}
