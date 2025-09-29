vim.lsp.config("*", {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

vim.lsp.enable("astro")
vim.lsp.enable("clangd")
vim.lsp.enable("denols")
vim.lsp.enable("gopls")
vim.lsp.enable("jsonls")
vim.lsp.enable("lua_ls")
vim.lsp.enable("pyright")
vim.lsp.enable("rust_analyzer")
vim.lsp.enable("ts_ls")
vim.lsp.enable("typos_lsp")
