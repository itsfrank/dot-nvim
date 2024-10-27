-- quickfix keymaps
local del_qf_item = function()
    local items = vim.fn.getqflist()
    local line = vim.fn.line(".")
    table.remove(items, line)
    vim.fn.setqflist(items, "r")
    vim.api.nvim_win_set_cursor(0, { line, 0 })
end

vim.keymap.set("n", "dd", del_qf_item, { buffer = true, desc = "Remove line under cursor from quickfix" })
vim.keymap.set(
    "n",
    "df",
    "0:Cfilter! <c-r><c-f><cr>",
    { buffer = true, desc = "Remove all items from files of line under cursor from quickfix" }
)
