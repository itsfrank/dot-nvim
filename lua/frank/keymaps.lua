-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- clear the highlighting of search results
vim.keymap.set("n", "<leader>cs", ':let @/ = ""<cr>', { silent = true, desc = "[C]lear [S]earch" })

-- convenient jump to start/end of line (you should still learn '0' and '$' as they have their own uses)
vim.keymap.set({ "n", "v" }, "<leader>hh", "^", { desc = "Line Start - [H] to move left" })
vim.keymap.set({ "n", "v" }, "<leader>ll", "g_", { desc = "Line End - [L] to move right" })

-- new lines without entering insert mode
vim.keymap.set({ "n" }, "<M-o>", "o<esc>", { desc = "New line below" })
vim.keymap.set({ "n" }, "<M-O>", "O<esc>", { desc = "New line above" })

-- formatting
vim.keymap.set("n", "<leader>fta", ":Format<cr>", { silent = true, desc = "[F]orma[T] [A]ll - formats entire buffer" })
vim.keymap.set(
    "n",
    "<leader>ftm",
    ":FormatModifications<cr>",
    { silent = true, desc = "[F]orma[T] [M]odifications - formats modifications in this buffer" }
)

-- system clipboard keymaps
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system cpliboard" })
vim.keymap.set({ "n", "v" }, "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set({ "n", "v" }, "<leader>P", '"+P', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+yg_', { desc = "Yank to system cpliboard" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Yank to system cpliboar" })

-- convenience, use c-space to leave terminal mode
vim.keymap.set("t", "<C-space>", "<C-\\><C-n>")

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set({ "i", "n" }, "<C-l>", vim.diagnostic.open_float, { desc = "[L]ine diagnostics in float" })

-- window stuff
-- better window movement (set by vim-tmux-navigator now)
-- vim.keymap.set("n", "<M-h>", "<C-w>h", { desc = "Window left" })
-- vim.keymap.set("n", "<M-j>", "<C-w>j", { desc = "Window down" })
-- vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Window up" })
-- vim.keymap.set("n", "<M-l>", "<C-w>l", { desc = "Window right" })

-- better window resize
local function scale_current_win_height_fn(scale)
    return function()
        local height = vim.api.nvim_win_get_height(0)
        local new_height = math.floor(height * scale)
        if scale > 1 and height < 2 then
            new_height = 2
        end
        vim.api.nvim_win_set_height(0, new_height)
    end
end
local function scale_current_win_width_fn(scale)
    return function()
        local width = vim.api.nvim_win_get_width(0)
        local new_width = math.floor(width * scale)
        if scale > 1 and width < 2 then
            new_width = 2
        end
        vim.api.nvim_win_set_width(0, new_width)
    end
end
-- scale window by 1/3 of it's current size
vim.keymap.set("n", "<M-=>", scale_current_win_width_fn(3 / 2), { desc = "Horizontally grow window by 1/3" })
vim.keymap.set("n", "<M-->", scale_current_win_width_fn(2 / 3), { desc = "Horizontally shrink window by 1/3" })
vim.keymap.set("n", "<M-+>", scale_current_win_height_fn(3 / 2), { desc = "Vertically grow window by 1/3" })
vim.keymap.set("n", "<M-_>", scale_current_win_height_fn(2 / 3), { desc = "Vertically shrink window by 1/3" })

-- plugin testing keymaps
vim.keymap.set(
    "n",
    "<leader>rt",
    "<Plug>PlenaryTestFile",
    { desc = "[R]un [T]ests - runs plenary tests in current file" }
)

-- lua run utility
-- if curent file contains a function called _nvim_runme it will get called
vim.keymap.set(
    "n",
    "<leader>lr",
    ":so<cr>:lua _nvim_runme()<cr>",
    { desc = "[L]ua [R]un - source & run function _nvim_runme" }
)
