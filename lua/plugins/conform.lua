return {
    "stevearc/conform.nvim",
    dependencies = {
        "lewis6991/gitsigns.nvim", -- for format modifications
        "williamboman/mason.nvim",
        "LittleEndianRoot/mason-conform",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function()
        -- inverse of conform's formatters_by_ft
        local formatters = {
            prettier = { ft = { "javascript" } },
            fixjson = { ft = { "json" } },
            stylua = { ft = { "lua", "luau" } },
            markdownlint = { ft = { "markdown" } },
            black = { ft = { "python" } },
            rustfmt = { ft = { "rust" } },
            shfmt = { ft = { "sh" } },
            yamlfmt = { ft = { "yaml" } },
            ocamlformat = { ft = { "ocaml" }, auto_install = false },
            nixfmt = { ft = { "nix" }, auto_install = false },
        }

        local formatters_by_ft = {}
        local formatters_to_install = {}
        for fm, v in pairs(formatters) do
            if v.auto_install ~= false then
                table.insert(formatters_to_install, fm)
            end
            for _, ft in ipairs(v.ft) do
                if formatters_by_ft[ft] == nil then
                    formatters_by_ft[ft] = {}
                end
                table.insert(formatters_by_ft[ft], fm)
            end
        end

        local conform = require("conform")
        conform.setup({})
        conform.formatters_by_ft = formatters_by_ft
        require("mason-tool-installer").setup({ ensure_installed = formatters_to_install })

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
