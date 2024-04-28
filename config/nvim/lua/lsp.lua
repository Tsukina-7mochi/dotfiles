local lspconfig = require("lspconfig")
local util = require("lspconfig/util")
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local on_attach = function(client)
    require("completion").on_attach(client)
    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')
    -- go to definition
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
end

-- rust_analyzer
lspconfig.rust_analyzer.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "rust" },
    root_dir = util.root_pattern("Cargo.toml"),
    settings = {
        ["rust_analyzer"] = {
            cargo = {
                allFeatures = true,
            },
        },
    },
}

-- pyright with virtualenv
lspconfig.pyright.setup {
    on_attach = on_attach,
    capabilities = capabilities,
    filetypes = { "python" },
    root_dir = util.root_pattern(".venv"),
    cmd = { "rye", "run", "pyright-langserver", "--stdio" },
}

