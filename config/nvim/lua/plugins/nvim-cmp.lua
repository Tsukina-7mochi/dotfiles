local has_words_before_cursor = function()
    local row, col = unpack(vim.api.nvim_win_get_cursor(0))
    local row_str = vim.api.nvim_buf_get_lines(0, row - 1, row, true)[1]

    if row_str == nil then return false end
    return row_str:sub(1, col):match("^%s*$") == nil
end

return {
    "hrsh7th/nvim-cmp",
    lazy = false,
    dependencies = {
        "neovim/nvim-lspconfig",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "mattn/emmet-vim",
        "dcampos/cmp-emmet-vim",
    },
    config = function()
        local cmp = require("cmp")
        local map = cmp.mapping

        cmp.setup {
            enabled = true,
            sources = cmp.config.sources({
                { name = "copilot",  group_index = 2 },
                { name = "nvim_lsp" },
                { name = "buffer" },
                { name = "path" },
                { name = 'emmet_vim' },
                { name = "lazydev" },
            }),
            mapping = map.preset.insert {
                ["<C-Space>"] = map.complete(),
                ["<CR>"] = map.confirm { select = false },
                ["<C-k>"] = cmp.mapping(function()
                    vim.lsp.buf.signature_help()
                end, { "i", "s" }),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif has_words_before_cursor() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            },
        }

        -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline({ "/", "?" }, {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {
                { name = "buffer" }
            }
        })

        -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(":", {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = "path" }
            }, {
                { name = "cmdline" }
            }),
            matching = { disallow_symbol_nonprefix_matching = false }
        })
    end
}
