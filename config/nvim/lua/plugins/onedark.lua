return {
  "navarasu/onedark.nvim",
  name = "onedark",
  priority = 1000,
  event = "VimEnter",
  config = function()
    require("onedark").setup({ style = "dark" })
    require("onedark").load()
  end
}
