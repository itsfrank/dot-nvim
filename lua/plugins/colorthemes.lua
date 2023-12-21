return {
	{
		-- fancy colors meow!
		"catppuccin/nvim",
		lazy = false,
		as = "catppuccin",
		priority = 1000,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		lazy = false,
		as = "oxocarbon",
		priority = 1000,
	},
	{
		"ribru17/bamboo.nvim",
		lazy = false,
		priority = 1000,
		config = function()
			require("bamboo").setup({})
		end,
	},
}
