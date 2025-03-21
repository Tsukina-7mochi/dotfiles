return {
    {
        "Shatur/neovim-ayu",
        name = "ayu",
        event = "VimEnter",
        config = function()
            require("ayu").setup { color = "dark", mirage = true }
        end
    },

    {
        "catppuccin/nvim",
        name = "catppuccin",
        event = "VimEnter",
        config = function()
            require("catppuccin").setup {}
        end
    },

    {
        "ellisonleao/gruvbox.nvim",
        name = "gruvbox",
        event = "VimEnter",
        config = function()
            require("gruvbox").setup {
                bold = false,
            }
        end
    },

    {
        "talha-akram/noctis.nvim",
        name = "noctis",
        event = "VimEnter",
    },

    {
        "shaunsingh/nord.nvim",
        name = "nord",
        event = "VimEnter",
    },

    {
        "navarasu/onedark.nvim",
        name = "onedark",
        event = "VimEnter",
        config = function()
            require("onedark").setup({ style = "dark" })
        end,
    },

    {
        "shaunsingh/solarized.nvim",
        name = "solarized",
        event = "VimEnter",
    },
}
