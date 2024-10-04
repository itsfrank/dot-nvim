return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")
        conform.setup({})

        conform.formatters_by_ft = {
            javascript = { "prettierd", "prettier" },
            json = { "fixjson" },
            lua = { "stylua" },
            luau = { "stylua" },
            markdown = { "markdownlint" },
            ocaml = { "ocamlformat" },
            python = { "isort", "black" },
            rustfmt = { "rust" },
            sh = { "beautysh" },
            yaml = { "yamlfmt" },
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
