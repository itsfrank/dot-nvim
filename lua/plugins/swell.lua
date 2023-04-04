return {
	{
		-- "itsFrank/nvim-swell",
		dir = "/Users/fobrien/frk/nvim-plugins/nvim-swell",
		config = function()
			vim.keymap.set("n", "<leader>z", "<Plug>(swell-toggle)")
		end,
	},
}
