return {
    {
        "folke/flash.nvim",
        config = function()
            local flash = require("flash")
            local flash_setup_opts = {
                modes = {
                    char = {
                        enabled = false,
                    },
                    search = {
                        enabled = false,
                    },
                },
            }
            flash.setup(flash_setup_opts)

            vim.keymap.set({ "n", "x", "o" }, "<c-s>", function()
                require("flash").jump()
            end, { desc = "Flash" })

            vim.keymap.set({ "c" }, "<c-S>", function()
                require("flash").toggle()
            end, { desc = "Toggle Flash Search" })

            -- fix the highlights for rose-pine colorscheme
            vim.api.nvim_create_autocmd("ColorScheme", {
                pattern = "*",
                callback = function()
                    if vim.g.colors_name == "rose-pine" then
                        local rose_pine_palette = require("rose-pine.palette")
                        local label_hl = {
                            fg = rose_pine_palette.base,
                            bg = rose_pine_palette.foam,
                        }
                        vim.api.nvim_set_hl(0, "FlashRosePineLabel", label_hl)
                        flash_setup_opts.highlight = {
                            groups = {
                                label = "FlashRosePineLabel",
                            },
                        }
                        flash.setup(flash_setup_opts)
                        flash_setup_opts.highlight = nil
                    end
                end,
            })
        end,
    },
}
