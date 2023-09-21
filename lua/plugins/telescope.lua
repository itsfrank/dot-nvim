return {
	{
		-- Fuzzy Finder (files, lsp, etc)
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
		config = function()
			local telescope = require("telescope")
			telescope.load_extension("dap")
			telescope.load_extension("workspaces")
			telescope.load_extension("aerial")
			telescope.load_extension("git_worktree")
			telescope.load_extension("harpoon")

			telescope.setup({
				defaults = {
					path_display = { "smart" },
					mappings = {
						i = {
							["<C-j>"] = "move_selection_next",
							["<C-k>"] = "move_selection_previous",
							["<tab>"] = "move_selection_previous",
							["<S-tab>"] = "move_selection_next",
							["<C-h>"] = "which_key",
						},
						n = {
							["<C-h>"] = "which_key",
						},
					},
					pickers = {
						find_files = {
							find_command = {
								"fd",
								"--type",
								"file",
								"--type",
								"symlink",
								"--hidden",
								"--exclude",
								".git",
								-- put your other patterns here
							},
						},
					},
				},
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case", -- or "ignore_case" or "respect_case"
						-- the default case_mode is "smart_case"
					},
				},
			})
		end,
	},
}
