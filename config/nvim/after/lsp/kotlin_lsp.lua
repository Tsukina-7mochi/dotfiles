---@type vim.lsp.Config
return {
    cmd = { "kotlin-lsp", "--stdio" },
    filetypes = { "kotlin" },
    root_markers = { "build.gradle.kts" },
    workspace_required = true,
}
