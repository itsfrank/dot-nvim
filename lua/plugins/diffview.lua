return {
	{ -- better git diffview
		"sindrets/diffview.nvim",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			vim.keymap.set("n", "<leader>dvo", ":DiffviewOpen<cr>", { silent = true, desc = "[D]iff [V]iew [O]pen" })
			vim.keymap.set("n", "<leader>dvc", ":DiffviewClose<cr>", { silent = true, desc = "[D]iff [V]iew [C]lose" })
		end,
	},
}
