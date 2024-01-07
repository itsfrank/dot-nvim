---@type LazySpec
return {
    "itsfrank/cd-stack.nvim",
    -- dir = "~/frk/nvim-plugins/cd-stack.nvim",
    config = function()
        local cd_stack = require("cd-stack")

        vim.keymap.set("n", "<leader>cdd", ":CdstackPush<cr>", { silent = true, desc = "[C][D]stack push" })
        vim.keymap.set("n", "<leader>cdp", ":CdstackPop<cr>", { silent = true, desc = "[C][D]stack [P]op" })
        vim.keymap.set("n", "<leader>cds", ":CdstackSwitch<cr>", { silent = true, desc = "[C][D]stack [S]witch" })
    end,
}
