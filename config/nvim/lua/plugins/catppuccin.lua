return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  event = "VimEnter",
  config = function()
    require("catppuccin").setup({})
  end
}
