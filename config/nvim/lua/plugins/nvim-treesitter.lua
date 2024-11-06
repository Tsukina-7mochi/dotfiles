return {
    "nvim-treesitter/nvim-treesitter",
    event = "VimEnter",
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "c", "lua", "vim", "vimdoc", "query" },
            sync_install = false,
            highlight = { enable = true },
            indent = { enable = true },
        })
    end
};
