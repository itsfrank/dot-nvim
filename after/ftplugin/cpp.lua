vim.keymap.set(
    "n",
    "<leader>fta",
    ':echo "ope you tried to format the whole file!"<cr>',
    { buffer = true, silent = true, desc = "[F]orma[T] [A]ll - disabled in cpp :)" }
)

local c_incl_guards = require("frank.utils.c_incl_guards")
vim.api.nvim_create_user_command("MakeCInclGuards", function()
    c_incl_guards.put_guards()
end, { desc = "Create c-style include guards" })
