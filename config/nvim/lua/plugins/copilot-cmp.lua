return {
    "zbirenbaum/copilot-cmp",
    dependencies = {
        "zbirenbaum/copilot.lua",
    },
    cmd = "Copilot",
    config = function()
        require("copilot_cmp").setup()
    end,
}
