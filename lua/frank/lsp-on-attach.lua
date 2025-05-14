-- function to set up lsp behavior when something providing LSP features attaches to a buffer (lspconfig)
return function(client, bufnr)
    -- lets us more easily define mappings specific
    -- for LSP related items. It sets the mode, buffer and description for us each time.
    print("ON ATTACH RUN")
    local keymap_set = function(mode, keys, func, desc)
        if desc then
            desc = "LSP: " .. desc
        end
        vim.keymap.set(mode, keys, func, { silent = true, buffer = bufnr, desc = desc })
    end

    -- better lsp rename
    vim.keymap.set("n", "<leader>rn", function()
        return ":IncRename " .. vim.fn.expand("<cword>")
    end, { expr = true })

    keymap_set({ "n", "v" }, "<leader>ca", require("fastaction").code_action, "[C]ode [A]ction")

    keymap_set("n", "gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    keymap_set("n", "gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    keymap_set("n", "gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    keymap_set("n", "<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    -- keymap_set("n", "gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences - with fuzzy finder")
    -- keymap_set("n", "<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
    -- keymap_set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
    local snacks = require("snacks")
    keymap_set("n", "gr", snacks.picker.lsp_references, "[G]oto [R]eferences - with fuzzy finder")
    keymap_set("n", "<leader>ds", snacks.picker.lsp_symbols, "[D]ocument [S]ymbols")
    keymap_set("n", "<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    keymap_set("n", "K", vim.lsp.buf.hover, "Hover Documentation")
    keymap_set({ "i", "n" }, "<C-k>", vim.lsp.buf.signature_help, "Function signature Documentation")

    if client.name == "clangd" then
        -- hop between matching source and header files
        keymap_set("n", "<leader>ch", ":ClangdSwitchSourceHeader<cr>", "[C]langd switch source [H]eader")
    end

    -- Adds command `:FormatModifications`
    local lsp_format_modifications = require("lsp-format-modifications")
    lsp_format_modifications.attach(client, bufnr, { format_on_save = false })
end
