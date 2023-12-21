return {
	{ -- code outline and navigation
		"stevearc/aerial.nvim",
		config = function()
			require("aerial").setup({ -- optionally use on_attach to set keymaps when aerial has attached to a buffer
				on_attach = function(bufnr)
					-- toggle the aerial pane
					vim.keymap.set(
						"n",
						"<leader>ar",
						"<cmd>AerialToggle!<CR>",
						{ silent = true, desc = "Toggle [A]e[R]ial - file symbol tree" }
					)

					-- search with telescope
					vim.keymap.set(
						"n",
						"<leader>sa",
						require("telescope").extensions.aerial.aerial,
						{ desc = "Search [S]earch [A]erial" }
					)

					-- Jump forwards/backwards with '{' and '}'
					vim.keymap.set("n", "{", "<cmd>AerialPrev<CR>", { buffer = bufnr })
					vim.keymap.set("n", "}", "<cmd>AerialNext<CR>", { buffer = bufnr })
				end,
			})
		end,
	},
}
