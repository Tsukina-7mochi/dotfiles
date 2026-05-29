---@type vim.lsp.Config
return {
    root_markers = { "package.json" },
    workspace_required = true,
    init_options = {
        tsserver = {
            -- Explicitly specify path for projects that node_modules are placed
            -- not in root directory, such as pnpm workspace
            path = vim.fs.joinpath(vim.fs.root(0, { "node_modules" }), "node_modules", "typescript", "lib"),
        },
    },
}
