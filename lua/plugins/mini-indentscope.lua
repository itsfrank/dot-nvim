return {
	{ -- highlight indent markers
		"echasnovski/mini.indentscope",
		config = function()
			require("mini.indentscope").setup({
				draw = {
					delay = 20,
					animation = require("mini.indentscope").gen_animation.linear({ duration = 5 }),
				},
				options = {
					try_as_border = true,
				},
			})
		end,
	},
}
