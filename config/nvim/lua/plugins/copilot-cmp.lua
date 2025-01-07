return {
    "zbirenbaum/copilot-cmp",
    dependencies = {
        "zbirenbaum/copilot.lua",
    },
    lazy = false,
    config = function()
        require("copilot_cmp").setup()
    end,
}
