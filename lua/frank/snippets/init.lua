local m = {}

function m.load()
    require("frank.snippets.lua").load()
    require("frank.snippets.ocaml").load()
    require("frank.snippets.rust").load()
end

return m
