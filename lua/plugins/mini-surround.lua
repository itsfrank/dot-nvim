return {
	{ -- suround stuff easily
		"echasnovski/mini.surround",
		config = function()
			require("mini.surround").setup({
				mappings = {
					add = "<leader>wa", -- Add surrounding in Normal and Visual modes
					delete = "<leader>wd", -- Delete surrounding
					find = "<leader>wf", -- Find surrounding (to the right)
					find_left = "<leader>wF", -- Find surrounding (to the left)
					highlight = "<leader>wh", -- Highlight surrounding
					replace = "<leader>wr", -- Replace surrounding
					update_n_lines = "<leader>wn", -- Update `n_lines`

					suffix_last = "l", -- Suffix to search with "prev" method
					suffix_next = "n", -- Suffix to search with "next" method
				},
			})
			vim.keymap.set("n", "<leader>ww", "viw<leader>wa", { desc = "[W]rap [W]ord" })
		end,
	},
}
