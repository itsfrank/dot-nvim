return {
	{ -- Fancier statusline
		"nvim-lualine/lualine.nvim",
		config = function()
			require("lualine").setup({
				options = {
					icons_enabled = false,
					theme = "catppuccin",
					component_separators = "|",
					section_separators = "",
				},
				sections = {
					lualine_a = {
						{
							"filename",
							file_status = true, -- Displays file status (readonly status, modified status)
							newfile_status = true, -- Display new file status (new file means no write after created)
							path = 1,
							-- 0: Just the filename
							-- 1: Relative path
							-- 2: Absolute path
							-- 3: Absolute path, with tilde as the home directory
						},
					},
					lualine_x = { "aerial" },
				},
			})
		end,
	},
}
