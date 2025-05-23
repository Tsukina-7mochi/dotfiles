return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        keys = {
            { "<leader>ff", function() require("telescope.builtin").find_files() end,  desc = "Telescope find files" },
            { "<leader>fg", function() require("telescope.builtin").live_grep() end,   desc = "Telescope live grep" },
            { "<leader>fb", function() require("telescope.builtin").buffers() end,     desc = "Telescope buffers" },
            { "<leader>fh", function() require("telescope.builtin").help_tags() end,   desc = "Telescope help" },
            { "<leader>fc", function() require("telescope.builtin").colorscheme() end, desc = "Telescope colorscheme" },
            { "<leader>fs", function() require("telescope.builtin").git_status() end,  desc = "Telescope git status" },
        },
        event = "VimEnter",
        config = function()
            local telescope = require("telescope")
            local actions = require("telescope.actions")

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
                    colorscheme = {
                        enable_preview = true,
                    },
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
