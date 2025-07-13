return {
    "gbprod/yanky.nvim",
    dependencies = {
        "folke/snacks.nvim",
    },
    config = function()
        require("yanky").setup()
        vim.keymap.set("n", "<leader>yh", Snacks.picker.yanky, { desc = "[Y]ank [H]istory" })
    end,
}
