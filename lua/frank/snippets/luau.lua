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
    local snip_req = s("req", {
        t('local _ = require("'),
        i(0),
        t('")'),
    })
    ls.add_snippets("luau", {
        snip_fun,
        snip_req,
    })
end

return m
