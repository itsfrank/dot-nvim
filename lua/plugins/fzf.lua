return {
	{
		-- install the actual fzf binary
		"junegunn/fzf",
		build = function()
			vim.fn["fzf#install"]()
		end,
	},
	{
		"linrongbin16/fzfx.nvim",
		dependencies = { "junegunn/fzf", "nvim-tree/nvim-web-devicons" },
		config = function()
			require("fzfx").setup({
				fzf_opts = {
					"--ansi",
					"--preview-window=hidden",
					"--info=inline",
					"--layout=reverse",
					"--border=rounded",
					"--height=100%",
					"--bind=ctrl-e:toggle",
					"--bind=ctrl-a:toggle-all",
					"--bind=alt-p:toggle-preview",
					"--bind=ctrl-f:preview-half-page-down",
					"--bind=ctrl-b:preview-half-page-up",
					"--bind 'tab:down,btab:up'",
					"--preview ''",
				},
				popup = {
					win_opts = {
						height = 0.9,
						width = 0.9,
					},
				},
			})

			vim.keymap.set("n", "<leader>sf", ":FzfxFiles<cr>", { silent = true, desc = "[S]earch [F]iles" })
			vim.keymap.set("n", "<leader>sg", ":FzfxLiveGrep<cr>", { silent = true, desc = "[S]earch by [G]rep" })
		end,
	},
}
