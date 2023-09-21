return {
	{
		"akinsho/git-conflict.nvim",
		version = "*",
		config = function()
			require("git-conflict").setup()

			-- mappings in conflicted files:
			-- 		co — choose ours
			-- 		ct — choose theirs
			-- 		cb — choose both
			-- 		c0 — choose none
			-- 		]x — move to previous conflict
			-- 		[x — move to next conflict
		end,
	},
}
