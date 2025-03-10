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
                { name = "Noctis",               colorscheme = "noctis" },
                { name = "Noctis Azureus",       colorscheme = "noctis_azureus" },
                { name = "Noctis Bordo",         colorscheme = "noctis_bordo" },
                { name = "Noctis Uva",           colorscheme = "noctis_uva" },
                { name = "Noctis Minimus",       colorscheme = "noctis_minimus" },
                { name = "Noctis Viola",         colorscheme = "noctis_viola" },
                { name = "Noctis Lux",           colorscheme = "noctis_lux" },
                { name = "Noctis Hibernus",      colorscheme = "noctis_hibernus" },
                { name = "Noctis Lilac",         colorscheme = "noctis_lilac" },
                { name = "Nord",                 colorscheme = "nord" },
                { name = "Vim",                  colorscheme = "vim" },
            },
        }
    end
}
