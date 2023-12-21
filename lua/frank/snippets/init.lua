local m = {}

function m.load()
	require("frank.snippets.rust").load()
	require("frank.snippets.ocaml").load()
end

return m
