return {
    "mbbill/undotree",
    config = function()
        vim.keymap.set("n", "<leader>ut", ":UndotreeToggle<cr>", { desc = "toggle [U]ndo[T]ree", silent = true })
    end,
}
