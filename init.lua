local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- important! set leaderkey before loading plugins
vim.g.mapleader = " "
vim.g.maplocalleader = ","

-- Keymap for better default experience
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- stop auto adding comments on mewline around a comment
vim.cmd("autocmd BufEnter * set formatoptions-=cro")
vim.cmd("autocmd BufEnter * setlocal formatoptions-=cro")

require("lazy").setup("plugins", {
    change_detection = {
        enabled = false, -- dont reload config on change
    },
})

require("frank.options")
require("frank.keymaps")
require("frank.commands")
require("frank.filetype")
