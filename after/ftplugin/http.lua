vim.opt.splitright = true

local kulala = require("kulala")

vim.keymap.set("n", "<leader>hr", kulala.run, { desc = "[H]ttp [R]un" })

