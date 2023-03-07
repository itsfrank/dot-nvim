return {
	{ -- Easier terminal window management
		"akinsho/toggleterm.nvim",
		config = function()
			require("toggleterm").setup({
				size = 40,
			})
		end,
	},
}
