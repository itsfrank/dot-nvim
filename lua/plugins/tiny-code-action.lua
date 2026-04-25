return {
    "rachartier/tiny-code-action.nvim",
    dependencies = {
        "folke/snacks.nvim",
    },
    event = "LspAttach",
    config = function()
        require("tiny-code-action").setup({})
        vim.keymap.set({ "n", "x" }, "<leader>ca", function()
            require("tiny-code-action").code_action()
        end, { noremap = true, silent = true })
    end,
}
