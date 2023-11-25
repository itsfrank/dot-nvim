return {
	{
		-- Add indentation guides even on blank lines
		"lukas-reineke/indent-blankline.nvim",
		config = function()
			require("ibl").setup({
				indent = {
					char = "┊",
				},
				scope = {
					char = "┊",
					highlight = "IblWhitespace" ,
					show_start = false,
				},
			})
		end,
	},
}
