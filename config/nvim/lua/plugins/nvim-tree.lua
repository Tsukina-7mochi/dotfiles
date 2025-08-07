return {
    'nvim-tree/nvim-tree.lua',
    config = function()
        require("nvim-tree").setup {
            tab = {
                sync = {
                    open = true,
                    close = true,
                },
            },
            renderer = {
                add_trailing = true,
                group_empty = true,
                highlight_git = true,
                highlight_opened_files = "name",
                indent_width = 2,
                indent_markers = {
                    enable = true,
                    inline_arrows = false,
                },
                icons = {
                    git_placement = "signcolumn",
                    show = {
                        file = false,
                        folder = false,
                        folder_arrow = false,
                        modified = false,
                        hidden = false,
                        diagnostics = false,
                    },
                    glyphs = {
                        default = "",
                        symlink = "",
                        modified = "",
                        hidden = "",
                        folder = {
                            arrow_closed = "",
                            arrow_open = "",
                            default = "",
                            open = "",
                            empty = "",
                            empty_open = "",
                            symlink = "",
                            symlink_open = "",
                        },
                        git = {
                            unstaged = "-",
                            staged = "+",
                            unmerged = "!",
                            renamed = ">",
                            untracked = "?",
                            deleted = "✗",
                            ignored = "~",
                        },
                    }
                },
            },
        }
    end,
    cmd = { "NvimTreeOpen", "NvimTreeToggle" },
    keys = {
        { "<leader>tt", mode = { "n" }, ":NvimTreeToggle<Enter>",              desc = "Open file tree" },
        { "<leader>tc", mode = { "n" }, ":NvimTreeCollapseKeepBuffers<Enter>", desc = "Collapse tree" },
        { "<leader>tf", mode = { "n" }, ":NvimTreeFindFile<Enter>",            desc = "Find file tree" },
    },
}
