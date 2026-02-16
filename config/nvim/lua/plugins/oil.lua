return {
    "stevearc/oil.nvim",
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    lazy = false,
    config = function ()
        require("oil").setup()
    end,
}
