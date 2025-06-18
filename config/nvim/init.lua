if table.unpack == nil then table.unpack = unpack end

vim.scriptencoding = "utf-8"
vim.wo.number = true

require("keymaps")
require("lazynvim")
require("autocmd")
require("command")
require("options")
require("clipboard-wsl")

require("onedark").load()
