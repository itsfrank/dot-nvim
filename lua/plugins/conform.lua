return {
    "stevearc/conform.nvim",
    dependencies = {
        "lewis6991/gitsigns.nvim", -- for format modifications
    },
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
            sh = { "shfmt" },
            yaml = { "yamlfmt" },
        }

        conform.formatters["stylua"] = {
            prepend_args = { "--indent-type=Spaces" },
        }
        conform.formatters["shfmt"] = {
            prepend_args = { "--case-indent" },
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

        local function format_modifications()
            local hunks = require("gitsigns").get_hunks()
            local format = require("conform").format
            for i = #hunks, 1, -1 do
                local hunk = hunks[i]
                if hunk ~= nil and hunk.type ~= "delete" then
                    local start = hunk.added.start
                    local last = start + hunk.added.count
                    -- nvim_buf_get_lines uses zero-based indexing -> subtract from last
                    local last_hunk_line = vim.api.nvim_buf_get_lines(0, last - 2, last - 1, true)[1]
                    local range = { start = { start, 0 }, ["end"] = { last - 1, last_hunk_line:len() } }
                    format({ range = range })
                end
            end
        end

        vim.keymap.set(
            "n",
            "<leader>ftt",
            format_modifications,
            { silent = true, desc = "[F]orma[T] [M]odifications - formats modifications in this buffer" }
        )
    end,
}
