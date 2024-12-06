return {
    "itsfrank/breakingpoint.nvim",
    -- dir = "~/frk/breakingpoint-nvim",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    config = function()
        local brkp = require("breakingpoint")
        vim.keymap.set("n", "<leader>dB", brkp.create_or_edit_cndpoint, { desc = "[d]ebug: toggle conditional [B]reakpoint" })
        vim.keymap.set("n", "<leader>dL", brkp.create_or_edit_logppoint, { desc = "[d]ebug: toggle [L]ogpoint" })
    end,
}
