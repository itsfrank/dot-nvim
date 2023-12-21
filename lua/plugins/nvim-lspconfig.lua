return {
	{
		-- LSP Configuration & Plugins
		"neovim/nvim-lspconfig",
		dependencies = {
			-- Automatically install LSPs to stdpath for neovim
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			-- Useful status updates for LSP
			"j-hui/fidget.nvim",

			-- Additional lua configuration, makes nvim stuff amazing
			"folke/neodev.nvim",
		},
		config = function()
			local lsp = require("lspconfig")

			local mason_servers = {
				clangd = {},
				gopls = {},
				tsserver = {},
				pyright = {},
				lua_ls = {
					Lua = {
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
						diagnostics = {
							globals = {
								-- Busted
								"describe",
								"it",
								"before_each",
								"after_each",
								"teardown",
								"pending",
								"clear",
							},
						},
					},
				},
			}

			local manual_servers = {
				ocamllsp = {
					cmd = { "ocamllsp" },
					filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
					root_dir = lsp.util.root_pattern(
						"*.opam",
						"esy.json",
						"package.json",
						".git",
						"dune-project",
						"dune-workspace"
					),
					-- make_capabilities = function()
					-- 	print("making ocaml capabilities")
					-- 	local c = vim.lsp.protocol.make_client_capabilities()
					-- 	c.textDocument.completion.completionItem.snippetSupport = true
					-- 	c.textDocument.completion.completionItem.resolveSupport = {
					-- 		properties = {
					-- 			"documentation",
					-- 			"detail",
					-- 			"additionalTextEdits",
					-- 		},
					-- 	}
					-- 	return c
					-- end,
				},
			}

			require("neodev").setup({})

			-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
			local default_capabilities = vim.lsp.protocol.make_client_capabilities()
			default_capabilities = require("cmp_nvim_lsp").default_capabilities(default_capabilities)

			-- Setup mason so it can manage external tooling
			require("mason").setup()

			-- Ensure the servers above are installed
			local mason_lspconfig = require("mason-lspconfig")

			mason_lspconfig.setup({
				ensure_installed = vim.tbl_keys(mason_servers),
			})

			mason_lspconfig.setup_handlers({
				function(server_name)
					-- use fucntion or fallback to default
					local capabilities = default_capabilities
					if mason_servers[server_name] ~= nil and mason_servers[server_name].make_capabilities ~= nil then
						capabilities = mason_servers[server_name].make_capabilities()
						mason_servers[server_name].make_capabilities = nil
					end

					require("lspconfig")[server_name].setup({
						capabilities = capabilities,
						on_attach = require("frank.on-lsp-attach"),
						settings = mason_servers[server_name],
					})
				end,
			})

			for server_name, server_settings in pairs(manual_servers) do
				-- use fucntion or fallback to default
				local capabilities = default_capabilities
				if server_settings ~= nil and server_settings.make_capabilities ~= nil then
					capabilities = server_settings.make_capabilities()
					server_settings.make_capabilities = nil
				end

				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
					on_attach = require("frank.on-lsp-attach"),
					-- settings = server_settings,
				})
			end

			-- Turn on lsp status information
			require("fidget").setup()
		end,
	},
}
