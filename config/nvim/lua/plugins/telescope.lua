local function open_find_files()
    require("telescope.builtin").find_files()
end

local function open_live_grep()
    require("telescope.builtin").live_grep()
end

local function open_buffers()
    require("telescope.builtin").buffers()
end

local function open_help_tags()
    require("telescope.builtin").help_tags()
end

return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        keys = {
            { "<leader>ff", open_find_files, desc = "Telescope find files" },
            { "<leader>fg", open_live_grep,  desc = "Telescope live grep" },
            { "<leader>fb", open_buffers,    desc = "Telescope buffers" },
            { "<leader>fh", open_help_tags,  desc = "Telescope help" },
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
