return {
	{ -- github goodies
		"tpope/vim-rhubarb",
		config = function()
			vim.g.github_enterprise_urls = { "https://github.rbx.com" }
		end,
	},
}
