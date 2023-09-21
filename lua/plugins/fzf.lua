return {
	{ -- fzf vim plugin
		"junegunn/fzf.vim",

		config = function()
			local os_info = require("frank.os-info")

			-- fzf config
			vim.fn.setenv("FZF_DEFAULT_COMMAND", "fd --type f --color=always")
			vim.fn.setenv(
				"FZF_DEFAULT_OPTS",
				"--ansi --layout reverse --preview 'bat --color=always --style=header,grid --line-range :300 {}' --bind 'tab:down,btab:up'"
			)
			vim.g.fzf_layout = {
				up = "~90%",
				window = {
					width = 0.9,
					height = 0.9,
					yoffset = 0.5,
					xoffset = 0.5,
					border = "rounded",
				},
			}
			-- for xome reason fzf_colors isnt working on my windows PC, so I need to do this
			if os_info:is_windows() then
				-- these options will need to be re-generated when colorscheme is changed
				-- on a machione where fzf_colors works do: `:echo fzf#wrap().options`
				vim.fn.setenv(
					"FZF_DEFAULT_OPTS",
					os.getenv("FZF_DEFAULT_OPTS")
					.. " "
					.. "--color=bg+:#2a2b3c,bg:#1e1e2e,spinner:#74c7ec,hl:#585b70 "
					.. "--color=fg:#cdd6f4,pointer:#cba6f7,info:#f5c2e7,header:#585b70 "
					.. "--color=marker:#cba6f7,fg+:#cdd6f4,prompt:#cba6f7,hl+:#cba6f7"
				)
			elseif os_info:is_mac() or os_info:is_linux() then
				vim.g.fzf_colors = {
					["fg"] = { "fg", "Normal" },
					["bg"] = { "bg", "Normal" },
					["hl"] = { "fg", "Comment" },
					["fg+"] = { "fg", "CursorLine", "CursorColumn", "Normal" },
					["bg+"] = { "bg", "CursorLine", "CursorColumn" },
					["hl+"] = { "fg", "Statement" },
					["info"] = { "fg", "PreProc" },
					["border"] = { "fg", "Normal" },
					["prompt"] = { "fg", "Conditional" },
					["pointer"] = { "fg", "Exception" },
					["marker"] = { "fg", "Keyword" },
					["spinner"] = { "fg", "Label" },
					["header"] = { "fg", "Comment" },
				}
			end
		end,
	},

	{ -- install the actual fzf binary
		"junegunn/fzf",
		build = "./install --bin",
	},
}
