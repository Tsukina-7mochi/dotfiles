return {
    "neovim/nvim-lspconfig",
    event = "BufEnter",
    config = function()
        require("neodev").setup {}

        local lspconfig = require("lspconfig")
        local util = require("lspconfig/util")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = function(client)
        end

        lspconfig.denols.setup {}

        lspconfig.gopls.setup {}

        lspconfig.lua_ls.setup {}

        lspconfig.pyright.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern(".venv"),
            cmd = { "bash", "-c", "source .venv/bin/activate && .venv/bin/pyright-langserver --stdio" },
        }

        lspconfig.rust_analyzer.setup {}

        lspconfig.typos_lsp.setup {
            cmd = { "/home/ts7m/programs/typos-lsp" },
        }
    end
}
