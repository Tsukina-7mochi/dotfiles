return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        event = "VimEnter",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")
            local builtin = require("telescope.builtin")

            vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
            vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
            vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

            telescope.setup {
                defaults = {
                    mappings = {
                        i = {
                            ["<S-Enter>"] = actions.file_tab,
                            ["<Esc>"] = actions.close,
                        },
                        n = {
                            ["<S-Enter>"] = actions.file_tab,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        hidden = true,
                        find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
                    },
                }
            }
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = {
            "nvim-telescope/telescope.nvim",
        },
        event = "VimEnter",
        config = function()
            require("telescope").load_extension("ui-select")
        end,
    }
}
