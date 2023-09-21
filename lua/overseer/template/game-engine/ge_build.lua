return {
	name = "ge build",
	builder = function(_)
		return {
			name = "ge build",
			cmd = "stask run ge-build",
			components = { "default", "unique" },
		}
	end,
}
