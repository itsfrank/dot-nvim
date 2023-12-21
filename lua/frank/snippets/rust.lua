local m = {}

function m.load()
	local ls = require("luasnip")
	local s = ls.snippet
	local t = ls.text_node
	local i = ls.insert_node

	local snip_test_module = s("tmod", {
		t({
			"#[cfg(test)]",
			"mod tests {",
			"\tuse super::*;",
			"",
			"\t",
		}),
		i(0),
		t({ "", "", "}" }),
	})

	local snip_test_case = s("tcase", {
		t("#[test]"),
		t({ "", "fn " }),
		i(1, "name"),
		t("_test() {"),
		t({ "", "\t" }),
		i(0),
		t({ "", "}" }),
	})

	ls.add_snippets("rust", {
		snip_test_module,
		snip_test_case,
	})
end

return m
