return {
	-- Required fields
	name = "set stask state",
	builder = function(params)
		-- This must return an overseer.TaskDefinition
		local cmds = {}
		if params.spec ~= nil then
			table.insert(cmds, "stask set ge-spec " .. params.spec)
		end
		if params.target ~= nil then
			table.insert(cmds, "stask set ge-target " .. params.target)
		end
		if params.build_type ~= nil then
			table.insert(cmds, "stask set ge-build-type " .. params.build_type)
		end
		return {
			name = "stask state",
			cmd = table.concat(cmds, " && "),
			components = { "default", "unique" },
		}
	end,
	params = {
		spec = {
			type = "string",
			optional = true,
		},
		target = {
			type = "string",
			optional = true,
		},
		build_type = {
			type = "string",
			optional = true,
		},
	},
}
