vim.api.nvim_create_user_command("DisableFormatOnSave", function(args)
    if args.bang then
        vim.b.disable_autoformat = true
    else
        vim.g.disable_autoformat = true
    end
end, {
    desc = "Disable format on save",
    bang = true
})

vim.api.nvim_create_user_command("EnableFormatOnSave", function(args)
    if args.bang then
        vim.b.disable_autoformat = false
    else
        vim.g.disable_autoformat = false
    end
end, {
    desc = "Enable format on save",
    bang = true
})

vim.api.nvim_create_user_command("Format", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format document" })

---@param name string
---@param bufnr integer
---@return boolean
local is_formatter_available = function(name, bufnr)
    return require("conform").get_formatter_info(name, bufnr).available
end

---@param bufnr integer
---@return string[]
local js_ts_formatter = function(bufnr)
    if is_formatter_available("biome", bufnr) then
        return { "biome" }
    elseif is_formatter_available("deno", bufnr) then
        return { "deno" }
    end

    return { "eslint", "prettier", lsp_format = "fallback" }
end

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
        require("conform").setup {
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                return { timeout_ms = 1000, lsp_fallback = true }
            end,
            formatters_by_ft = {
                python = { "venv.isort", "venv.black" },
                javascript = js_ts_formatter,
                javascriptreact = js_ts_formatter,
                ["javascript.jsx"] = js_ts_formatter,
                json = js_ts_formatter,
                jsonc = js_ts_formatter,
                typescript = js_ts_formatter,
                typescriptreact = js_ts_formatter,
                ["typescript.jsx"] = js_ts_formatter,
                typespec = { "tsp" },
            },
            formatters = {
                ["venv.isort"] = {
                    command = "bash",
                    args = { "-c", "source .venv/bin/activate && .venv/bin/isort -" },
                    cwd = require("conform.util").root_file({ ".venv" }),
                    require_cwd = true,
                },
                ["venv.black"] = {
                    command = "bash",
                    args = { "-c", "source .venv/bin/activate && .venv/bin/black -" },
                    cwd = require("conform.util").root_file({ ".venv" }),
                    require_cwd = true,
                },
                ["tsp"] = {
                    command = require("conform.util").from_node_modules("tsp"),
                    stdin = false,
                    args = { "format", "$FILENAME" },
                    cwd = require("conform.util").root_file({ "tspconfig.yaml" }),
                },
            },
        }
    end
}
