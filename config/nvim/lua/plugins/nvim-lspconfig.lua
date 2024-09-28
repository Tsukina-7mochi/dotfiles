return {
    "neovim/nvim-lspconfig",
    event = "BufEnter",
    config = function()
        local lspconfig = require("lspconfig")
        local util = require("lspconfig/util")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local on_attach = function(client)
        end

        lspconfig.denols.setup {
            root_dir = util.root_pattern("deno.json"),
        }

        lspconfig.gopls.setup {}

        lspconfig.lua_ls.setup {}

        lspconfig.pyright.setup {
            on_attach = on_attach,
            capabilities = capabilities,
            root_dir = util.root_pattern(".venv"),
            cmd = { "bash", "-c", "source .venv/bin/activate && .venv/bin/pyright-langserver --stdio" },
        }

        lspconfig.rust_analyzer.setup {}

        lspconfig.ts_ls.setup {}

        lspconfig.typos_lsp.setup {
            cmd = { "/home/ts7m/programs/typos-lsp" },
        }
    end
}
