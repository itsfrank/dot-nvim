-- [[ Franks keymaps ]]
-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- basic maps
vim.keymap.set("n", "<leader>cs", ':let @/ = ""<cr>', { desc = "[C]lear [S]earch" })
vim.keymap.set("n", "<leader>ls", "^", { desc = "[L]ine [S]tart" })
vim.keymap.set("n", "<leader>le", "g_", { desc = "[L]ine [E]nd" })
vim.keymap.set("v", "<leader>ls", "^", { desc = "[L]ine [S]tart" })
vim.keymap.set("v", "<leader>le", "g_", { desc = "[L]ine [E]nd" })

-- formatting
vim.keymap.set("n", "<leader>fta", ":Format<cr>", { desc = "[F]orma[T] [A]ll - formats enire buffer" })
vim.keymap.set(
    "n",
    "<leader>ftm",
    ":FormatModifications<cr>",
    { desc = "[F]orma[T] [M]odifications - formats modifications in this buffer" }
)

-- better window movement
vim.keymap.set("n", "<M-h>", "<C-w>h", { desc = "Window left" })
vim.keymap.set("n", "<M-j>", "<C-w>j", { desc = "Window down" })
vim.keymap.set("n", "<M-k>", "<C-w>k", { desc = "Window up" })
vim.keymap.set("n", "<M-l>", "<C-w>l", { desc = "Window right" })

-- better window resize
vim.keymap.set("n", "<M-=>", ':exe "resize " . (winheight(0) * 3/2)<CR>')
vim.keymap.set("n", "<M-->", ':exe "resize " . (winheight(0) * 2/3)<CR>')
vim.keymap.set("n", "<M-+>", ':exe "vertical resize " . (winwidth(0) * 3/2)<CR>')
vim.keymap.set("n", "<M-_>", ':exe "vertical resize " . (winwidth(0) * 2/3)<CR>')

-- system clipboard keymaps
vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank to system cpliboar" })
vim.keymap.set("n", "<leader>Y", '"+yg_', { desc = "Yank to system cpliboar" })
vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank to system cpliboar" })
vim.keymap.set("n", "<leader>yy", '"+yy', { desc = "Yank to system cpliboar" })
vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("n", "<leader>P", '"+P', { desc = "Paste from system clipboard" })
vim.keymap.set("v", "<leader>p", '"+p', { desc = "Paste from system clipboard" })
vim.keymap.set("v", "<leader>P", '"+P', { desc = "Paste from system clipboard" })
vim.keymap.set("t", "<c-p>", "<c-\\><c-n>pi", { desc = "Paste in terminal mode" })

-- [[ Plugin Keymaps ]]
-- Git DiffView Keymaps
vim.keymap.set("n", "<leader>dvo", ":DiffviewOpen<cr>", { desc = "[D]iff [V]iew [O]pen" })
vim.keymap.set("n", "<leader>dvc", ":DiffviewClose<cr>", { desc = "[D]iff [V]iew [C]lose" })

-- Table mode keymap
vim.keymap.set("v", "<leader>f<Bslash>", ":EasyAlign*<Bar><cr>", { desc = "[F]ormat Table (split at '|' [\\])" })
vim.keymap.set("n", "<leader>f<Bslash>", "vip:EasyAlign*<Bar><cr>g;", { desc = "[F]ormat Table (split at '|' [\\])" })

-- spectre keymaps
vim.keymap.set("n", "<leader>sp", function()
    local spectre = require("spectre")
    local spectre_state = require("spectre.state")

    local is_open = false
    if spectre_state.bufnr ~= nil then
        local wins = vim.fn.win_findbuf(spectre_state.bufnr)
        if next(wins) ~= nil then
            is_open = true
        end
    end

    if is_open then
        spectre.close()
    else
        spectre.open()
    end
end, { desc = "Toggle [S][P]ectre search" })

-- Leap mappings
vim.keymap.set({ "n", "x", "o" }, "<leader>ss", "<Plug>(leap-forward-to)", { desc = "Leap [S]earch forward to" })
vim.keymap.set({ "n", "x", "o" }, "<leader>SS", "<Plug>(leap-backward-to)", { desc = "Leap [S]earch backwards to" })
vim.keymap.set(
    { "n", "x", "o" },
    "<leader>gs",
    "<Plug>(leap-from-window)",
    { desc = "Leap [S]earch all windowsbackwards to" }
)
vim.keymap.set({ "x", "o" }, "<leader>xx", "<Plug>(leap-forward-till)", { desc = "Leap [S]earch forward till" })
vim.keymap.set({ "x", "o" }, "<leader>XX", "<Plug>(leap-backward-till)", { desc = "Leap [S]earch backwards till" })

-- Aerial keymaps
vim.keymap.set("n", "<leader>ar", "<cmd>AerialToggle!<CR>", { desc = "Toggle [A]e[R]ial" })

-- telescope/fzf mappings
vim.keymap.set("n", "<leader>?", require("telescope.builtin").oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", require("telescope.builtin").buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
        winblend = 10,
        previewer = false,
        layout_config = { width = 0.8 },
    }))
end, { desc = "[/] Fuzzily search in current buffer]" })

-- using fzf to find files instead of telescope
-- vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files, { desc = "[S]earch [F]iles" })
vim.keymap.set("n", "<leader>sf", ":Files<cr>", { desc = "[S]earch [F]iles" })
-- vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sg", ":Rg<cr>", { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", require("telescope.builtin").grep_string, { desc = "[S]earch current [W]ord" })
vim.keymap.set("n", "<leader>sd", require("telescope.builtin").diagnostics, { desc = "[S]earch [D]iagnostics" })
vim.keymap.set("n", "<leader>km", require("telescope.builtin").keymaps, { desc = "[K]ey [M]aps" })

-- oil mappings
vim.keymap.set("n", "<leader>-", require("oil").open, { desc = "Oil.nvim: Open parent directory [-]" })

-- workspaces/telescope workspace search
require("telescope").load_extension("workspaces")
vim.keymap.set(
    "n",
    "<leader>wk",
    require("telescope").extensions.workspaces.workspaces,
    { desc = "Search [W]or[K] spaces" }
)

-- aerial/telescope mappings
require("telescope").load_extension("aerial")
vim.keymap.set("n", "<leader>sa", require("telescope").extensions.aerial.aerial, { desc = "Search [S]earch [A]erial" })

-- Toggleterm mappings
vim.keymap.set("n", "<leader>``", ":ToggleTerm<cr>", { desc = "Toggle terminal view" })
vim.keymap.set("n", "<leader>`v", ":ToggleTerm direction=vertical <cr>", { desc = "Toggle [H]orizontal terminal view" })
vim.keymap.set("n", "<leader>`h", ":ToggleTerm direction=horizontal <cr>", { desc = "Toggle [V]ertical terminal view" })
vim.keymap.set("n", "<leader>`f", ":ToggleTerm direction=float <cr>", { desc = "Toggle [F]loat terminal view" })

vim.keymap.set("t", "<C-space>", "<C-\\><C-n>")
vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]])
vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]])
vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]])
vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]])

-- Diagnostic keymaps
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist)
