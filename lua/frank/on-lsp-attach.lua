-- function to set up lsp behavior when something providing LSP features attaches to a buffer (lspconfig)
return function(client, bufnr)
	-- lets us more easily define mappings specific
	-- for LSP related items. It sets the mode, buffer and description for us each time.
	local map = function(mode, keys, func, desc)
		if desc then
			desc = "LSP: " .. desc
		end
		vim.keymap.set(mode, keys, func, { silent = true, buffer = bufnr, desc = desc })
	end

	-- map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
	-- better lsp rename
	vim.keymap.set("n", "<leader>rn", function()
		return ":IncRename " .. vim.fn.expand("<cword>")
	end, { expr = true })

	map("n", "<leader>ca", ":CodeActionMenu<cr>", "[C]ode [A]ction")
	-- map("n", '<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

	map("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
	map("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
	map("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
	map("n", "gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
	map("n", "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
	-- map("n", "<leader>rn", vim.lsp.buf.rename, "[R]e[N]ame")
	map("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
	map("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

	-- See `:help K` for why this keymap
	map("n", "K", vim.lsp.buf.hover, "Hover Documentation")
	map({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")
	map({ "i", "n" }, "<C-l>", vim.diagnostic.open_float, "[L]ine diagnostics in float")

	-- Lesser used LSP functionality
	map("n", "<leader>wl", function()
		print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
	end, "[W]orkspace [L]ist Folders")

	-- clangd only
	map("n", "<leade>ch", ":ClangdSwitchSourceHeader<cr>", "[C]langd switch source [H]eader")

	-- Adds command `:FormatModifications`
	local lsp_format_modifications = require("lsp-format-modifications")
	lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
end
