return {
    "zaldih/themery.nvim",
    event = "VimEnter",
    config = function()
        require("themery").setup {
            themes = {
                { name = "Ayu",                  colorscheme = "ayu" },
                { name = "Catppuccin",           colorscheme = "catppuccin" },
                { name = "Catppuccin Frappe",    colorscheme = "catppuccin-frappe" },
                { name = "Catppuccin Latte",     colorscheme = "catppuccin-latte" },
                { name = "Catppuccin Mocha",     colorscheme = "catppuccin-mocha" },
                { name = "Catppuccin Macchiato", colorscheme = "catppuccin-macchiato" },
                { name = "One Dark",             colorscheme = "onedark" },
                { name = "Gruvbox",              colorscheme = "gruvbox" },
                { name = "Nord",                 colorscheme = "nord" },
                { name = "Vim",                  colorscheme = "vim" },
            },
        }
    end
}
