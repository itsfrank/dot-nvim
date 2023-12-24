local m = {}

function m.load()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    local snip_comment = s("cmt", {
        t("(* "),
        i(0),
        t({ " *)" }),
    })

    ls.add_snippets("ocaml", {
        snip_comment,
    })
end

return m
