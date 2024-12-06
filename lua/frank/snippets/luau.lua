local m = {}

function m.load()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    local snip_fun = s("fun", {
        t("function "),
        i(0),
        t("()"),
        t({ "", "end" }),
    })
    ls.add_snippets("luau", {
        snip_fun,
    })
end

return m
