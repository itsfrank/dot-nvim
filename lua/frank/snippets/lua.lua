local m = {}

function m.load()
    local ls = require("luasnip")
    local s = ls.snippet
    local t = ls.text_node
    local i = ls.insert_node

    local snip_ldoc_class = s("ldc", {
        t("---@class "),
        i(0),
    })
    local snip_ldoc_field = s("ldf", {
        t("---@field "),
        i(0),
    })
    local snip_ldoc_param = s("ldp", {
        t("---@param "),
        i(0),
    })

    ls.add_snippets("lua", {
        snip_ldoc_class,
        snip_ldoc_field,
        snip_ldoc_param,
    })
end

return m
