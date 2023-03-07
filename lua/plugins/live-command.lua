return {
	{ -- improved search & replace (and other fun stuff)
		"smjonas/live-command.nvim",
		config = function()
			require("live-command").setup({
				commands = {
					S = { cmd = "Subvert" }, -- must be defined before we import vim-abolish
				},
			})
		end,
	},
}
