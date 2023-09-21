return {
	{
		"rcarriga/nvim-notify",
		config = function()
			require("notify").setup({
				top_down = false,
				stages = "static",
				render = "compact",
				row = 2,
			})
			vim.notify = require("notify")
		end,
	},
}
