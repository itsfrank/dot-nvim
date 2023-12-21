return {
	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
	},
	{
		-- fancy colors meow!
		"catppuccin/nvim",
		as = "catppuccin",
		priority = 1000,
	},
	{
		"nyoom-engineering/oxocarbon.nvim",
		as = "oxocarbon",
		priority = 1000,
	},
	{
		"ribru17/bamboo.nvim",
		priority = 1000,
		config = function()
			require("bamboo").setup({})
		end,
	},
}
