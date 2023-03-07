return {{ -- File broswer that behaves like a buffer
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup({
			keymaps = {
				["<C-y>"] = "actions.copy_entry_path",
			},
		})
	end,
}}
