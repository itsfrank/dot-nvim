return {
	{
		"L3MON4D3/LuaSnip",
		version = "v2.*",
		-- install jsregexp (don't need it for now).
		-- build = "make install_jsregexp",

		config = function()
			local ls = require("luasnip")

			-- vim.keymap.set({ "i" }, "<Tab>", function()
			-- 	ls.expand()
			-- end, { silent = true, desc = "luasnip expand" })
			-- vim.keymap.set({ "i", "s" }, "<Tab>", function()
			-- 	ls.jump(1)
			-- end, { silent = true, desc = "luasnip jump forward" })
			-- vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
			-- 	ls.jump(-1)
			-- end, { silent = true, desc = "luasnip jump backward" })

			vim.keymap.set({ "i", "s" }, "<C-E>", function()
				if ls.choice_active() then
					ls.change_choice(1)
				end
			end, { silent = true, desc = "luasnip change choice" })

			local s = ls.snippet
			local t = ls.text_node
			local i = ls.insert_node
			ls.add_snippets("rust", {
				s("tmod", {
					t({
						"#[cfg(test)]",
						"mod tests {",
						"\tuse super::*;",
						"",
						"\t",
					}),
					i(0),
					t({ "", "", "}" }),
				}),
				s("tcase", {
					t("#[test]"),
					t({ "", "fn " }),
					i(1, "name"),
					t("_test() {"),
					t({ "", "\t" }),
					i(0),
					t({ "", "}" }),
				}),
			})
		end,
	},
}
