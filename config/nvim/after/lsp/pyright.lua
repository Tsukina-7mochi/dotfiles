---@type vim.lsp.Config
return {
    root_markers = { ".venv" },
    cmd = { "bash", "-c", "source .venv/bin/activate && .venv/bin/pyright-langserver --stdio" },
}
