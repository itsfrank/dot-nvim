return {
	{
		"folke/zen-mode.nvim",
		config = function()
			require("zen-mode").setup({
				window = {
					backdrop = 1, -- shade the backdrop of the Zen window. Set to 1 to keep the same as Normal
					width = 160, -- width of the Zen windowl
				},
			})
		end,
	},
}
