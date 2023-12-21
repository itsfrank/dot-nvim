local function format_modifications()
	local lines = vim.fn.system("git diff --unified=0"):gmatch("[^\n\r]+")
	local ranges = {}
	for line in lines do
		if line:find("^@@") then
			local line_nums = line:match("%+.- ")
			if line_nums:find(",") then
				local _, _, first, second = line_nums:find("(%d+),(%d+)")
				table.insert(ranges, {
					start = { tonumber(first), 0 },
					["end"] = { tonumber(first) + tonumber(second), 0 },
				})
			else
				local first = tonumber(line_nums:match("%d+"))
				table.insert(ranges, {
					start = { first, 0 },
					["end"] = { first + 1, 0 },
				})
			end
		end
	end
	local conform = require("conform")
	for _, range in pairs(ranges) do
		conform.format({
			range = range,
			lsp_fallback = true,
		})
	end
end

return {
	"stevearc/conform.nvim",
	config = function()
		local conform = require("conform")
		conform.setup({
			formatters_by_ft = {
				ocaml = { "ocamlformat" },
				lua = { "stylua" },
				rustfmt = { "rust" },
				markdown = { "markdownlint" },
				python = { "isort", "black" },
				javascript = { { "prettierd", "prettier" } },
				sh = { "beautysh" },
				json = { "fixjson" },
				yaml = { "yamlfix" },
			},
		})

		vim.api.nvim_create_user_command("FormatDiff", function()
			format_modifications()
		end, { desc = "Format only modifications within file" })

		vim.api.nvim_create_user_command("Format", function()
			conform.format({ lsp_fallback = true })
		end, { desc = "Format only modifications within file" })
	end,
}
