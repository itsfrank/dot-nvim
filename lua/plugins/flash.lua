return {
	{
		"folke/flash.nvim",
		config = function()
			local flash = require("flash")
			flash.setup({
				modes = {
					char = {
						enabled = false,
					},
					search = {
						enabled = false,
					},
				},
			})

			vim.keymap.set({ "n", "x", "o" }, "<c-s>", function()
				require("flash").jump()
			end, { desc = "Flash" })

			vim.keymap.set({ "c" }, "<c-S>", function()
				require("flash").toggle()
			end, { desc = "Toggle Flash Search" })
		end,
	},
}
