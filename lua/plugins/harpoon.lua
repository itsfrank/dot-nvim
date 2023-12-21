return {
	{
		"ThePrimeagen/harpoon",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local harpoon_ui = require("harpoon.ui")
			local harpoon_mark = require("harpoon.mark")
			vim.keymap.set("n", "<leader>hm", harpoon_mark.add_file, { desc = "[H]arpoon [M]ark" })
			vim.keymap.set("n", "<leader>hv", harpoon_ui.toggle_quick_menu, { desc = "[H]arpoon [V]iew quick menu" })
			vim.keymap.set(
				"n",
				"<leader>hs",
				":Telescope harpoon marks<cr>",
				{ silent = true, desc = "[H]arpoon [S]earch with telescope" }
			)

			-- set up numeric keymaps: <leader>h1-9 for jumping to marks
			for i = 1, 9 do
				vim.keymap.set("n", "<leader>h" .. tostring(i), function()
					harpoon_ui.nav_file(i)
				end, { desc = "[H]arpoon jump to mark #" .. tostring(i) })
			end
		end,
	},
}
