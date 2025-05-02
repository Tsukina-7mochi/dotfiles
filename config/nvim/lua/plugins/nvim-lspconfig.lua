return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "b0o/schemastore.nvim",
    },
    event = "BufEnter",
    config = function()
        local lspconfig = require("lspconfig")
        local util = require("lspconfig/util")
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        lspconfig.astro.setup {}

        lspconfig.denols.setup {
            root_dir = util.root_pattern("deno.json"),
        }

        lspconfig.gopls.setup {}

        lspconfig.jsonls.setup {
            capabilities = capabilities,
            settings = {
                json = {
                    schemas = require('schemastore').json.schemas(),
                    validate = { enable = true },
                },
            },
        }

        lspconfig.lua_ls.setup {}

        lspconfig.pyright.setup {
            capabilities = capabilities,
            root_dir = util.root_pattern(".venv"),
            cmd = { "bash", "-c", "source .venv/bin/activate && .venv/bin/pyright-langserver --stdio" },
        }

        lspconfig.rust_analyzer.setup {
            settings = {
                ["rust-analyzer"] = {
                    checkOnSave = {
                        command = "clippy",
                    },
                },
            },
        }

        lspconfig.ts_ls.setup {
            root_dir = util.root_pattern("tsconfig.json", "jsconfig.json", "package.json"),
            single_file_support = false,
        }

        lspconfig.typos_lsp.setup {
            cmd = { vim.fn.expand("$HOME/.local/share/typos-lsp/target/release/typos-lsp") },
        }
    end
}
