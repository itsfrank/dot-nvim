return {
    "stevearc/conform.nvim",
    dependencies = {
        "williamboman/mason.nvim",
        "LittleEndianRoot/mason-conform",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- inverse of conform's formatters_by_ft
        local formatters_by_ft = {
            lua = { "stylua" },
            luau = { "stylua" },
            json = { "fixjson" },
            markdown = { "prettier" },
            [ 'markdown.mdx'  ]= { "prettier" },
            python = { "black" },
            rust = { "rustfmt" },
            sh = { "shfmt" },
            yaml = { "yamlfmt" },
            ocaml = { "ocamlformat" },
            nix = { "nixfmt" },
            elixir = { "mix" },
            hcl = { "hcl" },
            javascript = { "biome-check" },
        }
        local conform = require("conform")
        conform.setup({})
        conform.formatters_by_ft = formatters_by_ft

        conform.formatters["shfmt"] = {
            prepend_args = { "--case-indent" },
        }
        conform.formatters["stylua"] = {
            prepend_args = { "--indent-type=Spaces" },
        }
        -- roblox has poor taste in whitespace
        if require("frank.rbx_utils").is_rbx_lua_project(vim.fn.getcwd()) then
            conform.formatters["stylua"] = { prepend_args = {} }
        end

        -- js is unreadable with 2-space indent
        require("conform").formatters.prettier = function(bufnr)
            return {
                prepend_args = { "--tab-width", tostring(vim.bo[bufnr].shiftwidth) },
            }
        end
        require("conform").formatters.prettierd = function(bufnr)
            return {
                prepend_args = { "--tab-width", tostring(vim.bo[bufnr].shiftwidth) },
            }
        end

        vim.api.nvim_create_user_command("Format", function()
            conform.format({ lsp_fallback = true })
        end, { desc = "Format the current buffer" })
    end,
}
