return {
    "stevearc/conform.nvim",
    config = function()
        local conform = require("conform")
        conform.setup({})

        conform.formatters_by_ft = {
            javascript = { { "prettierd", "prettier" } },
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

        vim.api.nvim_create_user_command("Format", function()
            conform.format({ lsp_fallback = true })
        end, { desc = "Format the current buffer" })
    end,
}
