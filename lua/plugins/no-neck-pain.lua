return {
	{
		"shortcuts/no-neck-pain.nvim",
		version = "*",
		config = function()
			require("no-neck-pain").setup({
				buffers = {
					wo = {
						fillchars = "eob: ",
					},
				},
			})
		end,
	},
}
