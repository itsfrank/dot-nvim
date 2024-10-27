vim.keymap.set(
    "n",
    "<leader>fta",
    ':echo "ope you tried to format the whole file!"<cr>',
    { buffer = true, silent = true, desc = "[F]orma[T] [A]ll - disabled in cpp :)" }
)
