local os_info = require("frank.utils.os-info")

vim.o.exrc = true

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- highlight line cursor is on
vim.o.cursorline = true
-- Enable mouse mode
vim.o.mouse = "a"

-- Enable break indent
vim.o.breakindent = true

-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = "yes"

-- Set colorscheme
vim.o.termguicolors = true
vim.opt.background = "dark"

vim.cmd.colorscheme("rose-pine")
-- vim.cmd.colorscheme("rose-pine-dawn")
-- vim.cmd.colorscheme("cyberdream")
-- vim.cmd.colorscheme("catppuccin")
-- vim.cmd.colorscheme("catppuccin-latte")
-- vim.cmd.colorscheme("oxocarbon")

-- override cursor line nr so its the same color as other colors, otherwise with cursorline its distracting
local line_nr_color = vim.api.nvim_get_hl_by_name("LineNr", true)
vim.api.nvim_set_hl(0, "CursorLineNr", { fg = line_nr_color.foreground })

-- from primeagen
vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
-- vim.opt.virtualedit = "all"

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writeany = true

if os_info:is_windows() then
    vim.opt.undodir = os.getenv("HOMEPATH") .. "/.vim/undodir"
elseif os_info:is_mac() or os_info:is_linux() then
    vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
end

vim.opt.undofile = true

vim.opt.incsearch = true

vim.opt.scrolloff = 8
vim.opt.isfname:append("@-@")

vim.diagnostic.config({ virtual_text = true })

-- dont log lsp stuff (set to "debug" when you want them)
vim.lsp.set_log_level("WARN")

-- Set completeopt to have a better completion experience
vim.o.completeopt = "menuone,noselect"

-- make it so the yanked text is always highlighted
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = "*",
})

-- add builtin plugins
vim.cmd("packadd cfilter")
