local function enableCopilot()
    require("copilot.command").enable()
    print("Copilot enabled")
end

local function disableCopilot()
    require("copilot.command").disable()
    print("Copilot disabled")
end

return {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    keys = {
        { "<leader>ce", enableCopilot,  desc = "Enable Copilot" },
        { "<leader>cd", disableCopilot, desc = "Disable Copilot" },
    },
    config = function()
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = false },
        })
    end,
}
