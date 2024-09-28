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

return {
    "stevearc/conform.nvim",
    event = { "BufWritePre" },
    cmd = { "ConformInfo" },
    config = function()
        require("conform").setup {
            format_on_save = function(bufnr)
                if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then return end
                return { timeout_ms = 500, lsp_fallback = true }
            end,
            formatters_by_ft = {
                python = { { "venv.isort", "isort" }, { "venv.black", "black" } },
                typescript = { { "deno", "biome", "eslint", "prettier" } },
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
                ["deno"] = {
                    command = "deno",
                    stdin = false,
                    args = { "fmt", "$FILENAME" },
                    cwd = require("conform.util").root_file({ "deno.json", "deno.jsonc" }),
                    require_cwd = true,
                },
                ["biome"] = {
                    command = "npx @biomejs/biome",
                    stdin = false,
                    args = { "check", "--write" },
                    cwd = require("conform.util").root_file({ "biome.json" }),
                    require_cwd = true,
                },
            },
        }
    end
}
