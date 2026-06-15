if table.unpack == nil then
    table.unpack = unpack
end

vim.scriptencoding = "utf-8"
vim.wo.number = true

require("options")
require("keymaps")

require("lazynvim")

require("clipboard-wsl")
require("colorscheme")
require("filetype")
require("indentation")
require("lsp")
require("treesitter")
